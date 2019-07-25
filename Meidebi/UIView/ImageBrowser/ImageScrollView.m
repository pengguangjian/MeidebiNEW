//
//  ImageScrollView.m
//  Meidebi
//
//  Created by mdb-admin on 16/6/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ImageScrollView.h"
#import <SDWebImage/SDWebImageManager.h>
#import "MDB_UserDefault.h"
#import "ImageZoomScrollView.h"
#import <Photos/Photos.h>

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度
#define kScreenBounds [UIScreen mainScreen].bounds               //主屏幕bounds

@interface ImageScrollView ()<UIScrollViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UILabel * countLabel;
@property (nonatomic, strong) UIButton *downLoadBtn;

@end

@implementation ImageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

+ (ImageScrollView *)showImageWithImageArr:(NSArray *)urlArr{
    
    ImageScrollView *imgSV = [[self alloc] initWithFrame:kScreenBounds];
    [[UIApplication sharedApplication].keyWindow addSubview:imgSV];
    imgSV.imgUrl = [urlArr lastObject];
    NSMutableArray * arr =[NSMutableArray array];
    for (int i =0; i <urlArr.count-1; i++) {
        [arr addObject:urlArr[i]];
    }
    imgSV.imgUrlArr = arr;
    
    return imgSV;
}

#pragma mark - private method
- (void)setupSubViews{
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.downLoadBtn];
    [self addSubview:self.countLabel];
}

- (void)downLoadImg{
    
    
    ////添加权限弹窗
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存图片需要访问您的相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"允许", nil];
        [alter show];
        
        
        return;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [MDB_UserDefault showNotifyHUDwithtext:@"无法读取相册" inView:[UIApplication sharedApplication].keyWindow];
    }
    UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
//    MBProgressHUD*  HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
//    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
//    
//    // Set the custom view mode to show any view.
//    HUD.mode = MBProgressHUDModeCustomView;
//    // Set an image view with a checkmark.
//    UIImage *image1 = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    HUD.customView = [[UIImageView alloc] initWithImage:image1];
//    // Looks a bit nicer if we make it square.
//    HUD.square = YES;
//    // Optional label text.
//    HUD.labelText = NSLocalizedString(@"已保存至相册", @"HUD done title");
//    [HUD show:YES];
//    [HUD hide:YES afterDelay:2];
    [MDB_UserDefault showNotifyHUDwithtext:@"已保存至相册" inView:[UIApplication sharedApplication].keyWindow];
}

//停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = (int)scrollView.contentOffset.x/kScreenWidth;
    _countLabel.text =[NSString stringWithFormat:@"%d/%lu",page+1,(unsigned long)_imgUrlArr.count];
    SDWebImageDownloader *manager = [[SDWebImageDownloader alloc] init];
    [manager downloadImageWithURL:[NSURL URLWithString:self.imgUrlArr[page]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        self.image = image;

    }];
}


#pragma mark - setter and getter
-(void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
}
- (void)setImgUrlArr:(NSArray *)imgUrlArr
{
    _imgUrlArr = imgUrlArr;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.scrollView];
    self.scrollView.contentSize =  CGSizeMake(kScreenWidth * imgUrlArr.count,  kScreenHeight - 40);
    for (int  i  = 0; i < imgUrlArr.count; i++) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        
        ImageZoomScrollView * imageScrollView = [[ImageZoomScrollView alloc] initWithFrame:frame];
        imageScrollView.imgUrl= imgUrlArr[i];
        imageScrollView.RemoveView = ^{
            [self removeFromSuperview];
            [self.scrollView removeFromSuperview];
        };
        [self.scrollView addSubview:imageScrollView];
    }
    if (_imgUrl) {
        NSUInteger  index =  [_imgUrlArr indexOfObject:_imgUrl];
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth* index, 0)];
        _countLabel.text =[NSString stringWithFormat:@"%lu/%lu",(unsigned long)index+1,(unsigned long)_imgUrlArr.count];
        SDWebImageDownloader *manager = [[SDWebImageDownloader alloc] init];
        [manager downloadImageWithURL:[NSURL URLWithString:_imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            self.image = image;
            
        }];
    }
    
    
    
}


- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate =self;
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 40);
    }
    return _scrollView;
}




- (UIButton *)downLoadBtn{
    if (_downLoadBtn == nil) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downLoadBtn addTarget:self action:@selector(downLoadImg) forControlEvents:UIControlEventTouchUpInside];
        [_downLoadBtn setImage:[UIImage imageNamed:@"News_Picture_Save"] forState:UIControlStateNormal];
        _downLoadBtn.frame = CGRectMake(kScreenWidth-50, kScreenHeight-40, 40, 40);
        [_downLoadBtn sizeToFit];
    }
    return _downLoadBtn;
}
-(UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kScreenHeight-40, 60, 30)];
        _countLabel . textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _countLabel;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        //无权限
        NSURL * url = [NSURL URLWithString: UIApplicationOpenSettingsURLString];
        
        if ( [[UIApplication sharedApplication] canOpenURL: url] ) {
            
            NSURL*url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}


@end
