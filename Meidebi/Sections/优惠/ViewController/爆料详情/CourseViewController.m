//
//  CourseViewController.m
//  Meidebi
//
//  Created by mdb-admin on 16/5/17.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "CourseViewController.h"
#import "GMDCircleLoader.h"
#import "UIImage+Extensions.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface CourseViewController ()
<
UIWebViewDelegate
>
@property (nonatomic, strong) UIWebView *courseWebView;
@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"海淘教程";
    [self setNavigation];
    [self setupSubview];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubview{
    
    _courseWebView = ({
        UIWebView *webview = [[UIWebView alloc] init];
        [self.view addSubview:webview];
        [webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_HR,_courselink]]]];
        webview.delegate = self;
        webview;
    });
    [GMDCircleLoader setOnView:_courseWebView withTitle:nil animated:YES];
}

-(void)setNavigation{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setImage:[UIImage imageNamed:@"fengxiang"] forState:UIControlStateNormal];
    [btnright setImage:[UIImage imageNamed:@"fengxiang_click"] forState:UIControlStateHighlighted];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright addTarget:self action:@selector(doShareAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)doShareAction{
    
    NSString *title = [NSString stringWithFormat:@"【没得比】%@海淘教程",_sitName];
    NSString *shareUrlStr = [NSString stringWithFormat:@"%@%@",URL_HR,_courselink];

    //1、创建分享参数（必要）
    UIImage *images=[[UIImage imageNamed:@"icon120"] imageByScalingProportionallyToMinimumSize:CGSizeMake(120.0, 120.0)];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[images];
    [shareParams SSDKSetupShareParamsByText:@"网购省钱没得比"
                                     images:imageArray
                                        url:[NSURL URLWithString:shareUrlStr]
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    //2、分享
    [ShareSDK showShareActionSheet:self.view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           break;
                       }
                       default:
                           break;
                   }
               }];
}

#pragma mark - MDBwebDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [GMDCircleLoader hideFromView:webView animated:YES];
//    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}




@end
