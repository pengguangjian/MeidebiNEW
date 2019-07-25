//
//  MDBPGGWebViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/28.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MDBPGGWebViewController.h"
#import "GMDCircleLoader.h"
#import "MDB_UserDefault.h"

@interface MDBPGGWebViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
    
}


@end

@implementation MDBPGGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_strtitle!=nil)
    {
        self.title = _strtitle;
    }
    
    [self drawSubview];
    
}

-(void)drawSubview
{
    if(_strurl==nil)return;
    if ([_strurl.lowercaseString hasPrefix:@"http://"]||[_strurl.lowercaseString hasPrefix:@"https://"])
    {
        
    } else
    {
        _strurl = [NSString stringWithFormat:@"http://%@",_strurl];
    }
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight)];
    [webview setDelegate:self];
    [self.view addSubview:webview];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_strurl]]];
    });
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
    //    [GMDCircleLoader hideFromView:self.view animated:YES];
    
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
    //    [GMDCircleLoader hideFromView:self.view animated:YES];
    [GMDCircleLoader hideFromView:self.view animated:YES];
    [MDB_UserDefault showNotifyHUDwithtext:@"加载失败" inView:self.view];
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
