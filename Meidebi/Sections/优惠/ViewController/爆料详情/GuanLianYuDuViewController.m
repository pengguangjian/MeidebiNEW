//
//  GuanLianYuDuViewController.m
//  Meidebi
//  关联阅读网页页面
//  Created by mdb-losaic on 2018/7/3.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "GuanLianYuDuViewController.h"
#import "MDB_UserDefault.h"

#import "GMDCircleLoader.h"

@interface GuanLianYuDuViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
    
}

@end

@implementation GuanLianYuDuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_strtitle != nil)
    {
        self.title=_strtitle;
    }
    
    
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight)];
    [webview setDelegate:self];
    [self.view addSubview:webview];
    if(_strurl==nil)
    {
        _strurl = @"";
        [MDB_UserDefault showNotifyHUDwithtext:@"地址错误" inView:self.view];
    }
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_strurl]]];
    
    
    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
    
}


#pragma mark - UIWebView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
//    NSString *javascript = [NSString stringWithFormat:@"var viewPortTag=document.createElement('meta');  \
//                            viewPortTag.id='viewport';  \
//                            viewPortTag.name = 'viewport';  \
//                            viewPortTag.content = 'width=%d; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;';  \
//                            document.getElementsByTagName('head')[0].appendChild(viewPortTag);" , (int)webview.bounds.size.width];
//
//    [webview stringByEvaluatingJavaScriptFromString:javascript];
    [GMDCircleLoader hideFromView:self.view animated:YES];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    [MDB_UserDefault showNotifyHUDwithtext:@"加载失败" inView:self.view];
    [GMDCircleLoader hideFromView:self.view animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
