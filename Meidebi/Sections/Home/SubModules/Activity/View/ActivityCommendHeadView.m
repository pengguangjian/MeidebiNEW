//
//  ActivityCommendHeadView.m
//  Meidebi
//
//  Created by fishmi on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ActivityCommendHeadView.h"
#import "ActivityConcernView.h"
#import <UIImageView+WebCache.h>
#import "PersonalInfoIndexViewController.h"
#import <YLGIFImage/YLGIFImage.h>
#import <YLGIFImage/YLImageView.h>
@interface ActivityCommendHeadView ()<UIWebViewDelegate,ActivityConcernViewDelegate>
@property (nonatomic ,strong) UIView *view;
@property (nonatomic ,strong) UIWebView *describeV;
@property (nonatomic ,strong) ActivityConcernView *concernV;
@property (nonatomic ,strong) UILabel *numLabel;
@property (nonatomic ,strong) YLImageView *imageV;
@property (nonatomic ,strong) UILabel *endLabel;
@property (nonatomic ,strong) UIView *backgroundV;
@property (nonatomic ,strong) UIImageView *commendImageV;
@property (nonatomic, strong) SDWebImageDownloader *downloader;
@property (nonatomic ,strong) UIView *lineV;
@property (nonatomic, strong) NSMutableArray *images;
@end
@implementation ActivityCommendHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubView];
    }
    return self;
}

- (void)setModel:(ActivityDetailModel *)model{
    _model = model;
    _downloader = [SDWebImageDownloader sharedDownloader];
   
    for (NSInteger i = 0; i<_images.count; i++) {
        if (i>model.images.count-1) {
            break;
        }else{
            YLImageView *imageView = (YLImageView *)_images[i];
            imageView.hidden = NO;
            [self loadImageWithImageView:imageView imageLink:model.images[i]];
        }
    }
    if (model.images.count > 0) {
        YLImageView *lastImageView = (YLImageView *)_images[model.images.count-1];
        [_describeV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastImageView.mas_bottom).offset(15);
        }];
    }else{
        [_describeV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_view.mas_top).offset(15);
        }];
    }

    [self setWeBView:_describeV WithStr:model.activityDescription];
    [_concernV.imageV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"punot.png"]];
    _concernV.nameLabel.text = [NSString nullToString:model.username];
    if ([model.commentcount isEqualToString:@"0"]) {
        _numLabel.hidden = YES;
        _commendImageV.hidden = YES;
        _lineV.hidden = YES;
    }else{
        _lineV.hidden = NO;
        _numLabel.hidden = NO;
        _commendImageV.hidden = NO;
        _numLabel.text = [NSString stringWithFormat:@"评论(%@)",model.commentcount];
    }
    
    _concernV.subLabel.text = [NSString stringWithFormat:@"爆料%@  |  原创%@",model.share_num,model.showdan_num];
    if ([@"1" isEqualToString:model.is_follow]) {
        _concernV.concernBtn.selected = YES;
        _concernV.concernBtn.userInteractionEnabled = NO;
    }else{
        _concernV.concernBtn.selected = NO;
        _concernV.concernBtn.userInteractionEnabled = YES;
    }
}

- (void)loadImageWithImageView:(YLImageView *)imageView imageLink:(NSString *)link{
    [_downloader downloadImageWithURL:[NSURL URLWithString:[NSString nullToString:link]]
                             options:0
                            progress:nil
                           completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                               imageView.image = [YLGIFImage imageWithData:data];
                               if (image) {
                                   CGFloat scale = image.size.height / image.size.width;
                                   if (isnan(scale)) {
                                   }else{
                                       [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                                           make.height.offset(kMainScreenW *scale);
                                       }];
                                       if (_callback) {
                                           [self calculateSubViewHeight];
                                           _callback(self.height);
                                       }
                                       if (_imageDownload) {
                                           _imageDownload(image);
                                       }
                                   }
                               }
                           }];
}

- (void)setSubView{
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        
    }];
    _view = view;
    _images = [NSMutableArray array];
    YLImageView *lastImageView = nil;
    for (NSInteger i = 0; i<5; i++) {
        YLImageView *imageV = [[YLImageView alloc ] init];
        [view addSubview: imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.height.offset(100);
            if (lastImageView) {
                make.top.equalTo(lastImageView.mas_bottom).offset(10);
            }else{
                make.top.equalTo(view.mas_top);
            }
        }];
        imageV.image = [YLGIFImage imageNamed:@"punot.png"];
        lastImageView = imageV;
        imageV.hidden = YES;
        [_images addObject:imageV];
    }
   
    UIWebView *describeV = [[UIWebView alloc] init];
    describeV.delegate = self;
    describeV.tag = 100;
    describeV.scrollView.scrollEnabled = NO;
    [describeV sizeToFit];
    [view addSubview:describeV];
    [describeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.right.equalTo(view).offset(-15);
        make.top.equalTo(lastImageView.mas_bottom).offset(15);
        make.height.offset(150);
    }];
    [self setWeBView:describeV WithStr:nil];
    _describeV = describeV;
    
    ActivityConcernView *concernV = [[ActivityConcernView alloc] init];
    concernV.delegate = self;
    [view addSubview:concernV];
    [concernV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(describeV.mas_bottom).offset(17);
        make.height.equalTo(@79);
    }];
    _concernV = concernV;
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#DADADA"];
    [view addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(concernV.mas_bottom).offset(20);
        make.height.equalTo(@1);
    }];
    _lineV = lineV;
    
    UIImageView *commendImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commendImage"]];
    [view addSubview:commendImageV];
    [commendImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(16);
        make.top.equalTo(lineV.mas_bottom).offset(22);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    _commendImageV = commendImageV;
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = @"评论()";
    numLabel.font = [UIFont systemFontOfSize:14];
    numLabel.textColor = [UIColor colorWithHexString:@"#F77210"];
    [view addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commendImageV.mas_right).offset(4);
        make.centerY.equalTo(commendImageV.mas_centerY);
        make.right.equalTo(view).offset(-16);
    }];
    _numLabel = numLabel;
    
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(numLabel.mas_bottom).offset(10);
    }];
    
    [self layoutIfNeeded];
    view.height = numLabel.bottom;

}

- (void)calculateSubViewHeight{
    //
    [self layoutIfNeeded];
    
    self.height = _view.bottom;
}

#pragma mark - webviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([self.delegate respondsToSelector:@selector(webViewDidPreseeUrlWithLink:)]) {
            [self.delegate webViewDidPreseeUrlWithLink:[NSString stringWithFormat:@"%@",request.URL]];
        }
        return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    webView.height = clientheight;
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    //获取内容实际高度（像素）
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
//    height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
    if (frame.height == 0) height =0;
        [webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
        }];
        if (_callback) {
            [self calculateSubViewHeight];
            _callback(self.height);
        }
    
    
    
}

#pragma mark - ActivityConcernViewDelegate

- (void)detailSubjectViewDidCickAddFollowdidComplete:(void (^)(BOOL))didComplete{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickAddFollowWithUserid:didComplete:)]) {
        [self.delegate detailSubjectViewDidCickAddFollowWithUserid:_model.userid didComplete:^(BOOL state) {
            if (state) {
                didComplete(state);
            }
            
        }];
    }

}

- (void)imageViewClicked{
    PersonalInfoIndexViewController *personalInfoVc = [[PersonalInfoIndexViewController alloc] initWithUserID:_model.userid];
    if ([self.delegate respondsToSelector:@selector(imageViewClickedtoController:)]) {
        [self.delegate imageViewClickedtoController:personalInfoVc];
    }
}

#pragma mark - setWevView
- (void)setWeBView: (UIWebView *)webView WithStr: (NSString *)str{
    NSString *content = [NSString nullToString:str];
    UIFont *font = [UIFont systemFontOfSize:12];
    NSString *fontColor =@"666666";
    NSString *htmlString =[NSString stringWithFormat:@"<html> \n"
                           "<head> \n"
                           "<style type=\"text/css\"> \n"
                           "body {font-family: \"%@\"; color: #%@;}\n"
                           "a{ text-decoration: none} \n"
                           "img{max-width:%@;width:auto;}"
                           "</style> \n"
                           "</head> \n"
                           "<body>%@</body> \n"
                           "</html>", font.familyName,@"100%",fontColor,content];
    NSString * htmlcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", htmlString];
    [webView loadHTMLString:htmlcontent baseURL:nil];
}

@end
