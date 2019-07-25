//
//  LaunchAdView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/1/9.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "LaunchAdView.h"
#import <YYKit/NSString+YYAdd.h>

#import "DingYueYuXuanViewController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

#define mainHeight      [[UIScreen mainScreen] bounds].size.height
#define mainWidth       [[UIScreen mainScreen] bounds].size.width
#define kUserDefaults   [NSUserDefaults standardUserDefaults]

static CGFloat const bottomPadding = 140;
static NSString *const adImageName = @"adImageName";

@interface LaunchAdView ()<DingYueYuXuanViewControllerDelegate>
{
    BOOL isdianjiaguanggao;
}
@property (nonatomic, strong) UIWindow*carrierWindow;
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, strong) NSArray *arrallkeys;

@end

@implementation LaunchAdView

- (instancetype)initWithWindow:(UIWindow *)window{
    _carrierWindow = window;
    return [self initWithFrame:window.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, mainWidth, mainHeight);
        [self setupSubviews];
        [self getAllKeys];
        
    }
    return self;
}

- (void)setupSubviews{
    _adTime = 3;
    [_carrierWindow makeKeyAndVisible];
    
    UIView *launchView = [[NSBundle mainBundle] loadNibNamed:@"Launch Screen" owner:nil options:nil][0];
    launchView.frame = _carrierWindow.bounds;
    [self addSubview:launchView];

    _adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight-bottomPadding)];
    _adImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_adImageView];
    self.adImageView.userInteractionEnabled = YES;
    [self.adImageView setContentMode:UIViewContentModeScaleAspectFill];
//    [self.adImageView setImage:[UIImage imageNamed:@"ipx.png"]];
    [self.adImageView setClipsToBounds:YES];
//    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    opacityAnimation.duration = 0.8;
//    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
//    opacityAnimation.toValue = [NSNumber numberWithFloat:0.8];
//    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    [self.adImageView.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];

    
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipBtn.frame = CGRectMake(mainWidth - 70, 30, 60, 30);
    [self.skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.skipBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
    self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.skipBtn setTitle:[NSString stringWithFormat:@"%@s | 跳过",@(_adTime)] forState:UIControlStateNormal];
    [self.skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.skipBtn.layer.cornerRadius = 4.f;
    [self.adImageView addSubview:self.skipBtn];
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.skipBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.skipBtn.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.skipBtn.layer.mask = maskLayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self activiTap:self];
}

- (void)onTimer {
    if (_adTime == 0) {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        [self closeAdView];
    }else{
        [self.skipBtn setTitle:[NSString stringWithFormat:@"%@s | 跳过",@(_adTime--)] forState:UIControlStateNormal];
    }
}

#pragma mark - 点击广告
- (void)activiTap:(id)sender{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    isdianjiaguanggao = YES;
    [self closeAdView];
    if (_clickBlock) {
        _clickBlock(LaunchAdTouchTypeAD);
    }
}

- (void)skipBtnClick{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    [self closeAdView];
    if (_clickBlock) {
        _clickBlock(LaunchAdTouchTypeSkip);
    }
    
    
}

- (void)closeAdView{
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"tuijiandingyuefirst"] integerValue]!=1)
    {
        [self showtuijianc];
    }
    else
    {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        self.hidden = YES;
        [self removeFromSuperview];
    }
    
}

-(void)showtuijianc
{
    
    if(_arrallkeys.count>0&&isdianjiaguanggao==NO)
    {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        
        self.hidden = YES;
        [self removeFromSuperview];
        
        DingYueYuXuanViewController *dvc = [[DingYueYuXuanViewController alloc] init];
        dvc.arrallkey = _arrallkeys;
        [dvc setDelegate:self];
        
        [_vc presentViewController:dvc animated:YES completion:nil];
    }
    else
    {
        
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        self.hidden = YES;
        [self removeFromSuperview];
    }
    
}
-(void)dimisview
{
    self.hidden = YES;
    [self removeFromSuperview];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [_vc dismissViewControllerAnimated:YES completion:nil];
}



-(void)getAllKeys
{
    [HTTPManager sendGETRequestUrlToService:URL_GetPushconfigRecSubscribe withParametersDictionry:nil view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        
        NSArray *arrallkeys ;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"] intValue] == 1) {
                if ([[dicAll objectForKey:@"data"]isKindOfClass:[NSArray class]]) {
                    NSArray *arrkeys=[dicAll objectForKey:@"data"];
                    //                    [_subjectView bindHotKeys:arrkeys];
                    arrallkeys = arrkeys;
                }
            }
        }
        _arrallkeys = arrallkeys;
        
    }];
    
}






-(void)dealloc
{
    [_countDownTimer invalidate];
}

#pragma mark - 图片操作
/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  初始化广告页面
 */
- (void)obtainAdvertisingImage:(NSString *)imageUrl
{
    
    // TODO 请求广告接口
    // 获取图片名:43-130P5122Z60-50.jpg
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = [stringArr.lastObject md5String];
    
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
    }
    
}

+ (void)updateAdvertisingImage:(NSString *)imageUrl{
    [[[LaunchAdView alloc] init] obtainAdvertisingImage:imageUrl];
}

/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
        }
        
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}

#pragma mark - seters and getters
- (void)setImgUrl:(NSString *)imgUrl{
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSArray *stringArr = [imgUrl componentsSeparatedByString:@"/"];
    NSString *imageName = [stringArr.lastObject md5String];
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {// 图片存在
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        [_adImageView setHeight:_adImageView.width*image.size.height/image.size.width];
        _adImageView.image = image;
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        
        
        [[NSRunLoop mainRunLoop] addTimer:_countDownTimer forMode:NSRunLoopCommonModes];
        
        [_carrierWindow addSubview:self];
    }else{
        [self obtainAdvertisingImage:imgUrl];
    }
}
@end
