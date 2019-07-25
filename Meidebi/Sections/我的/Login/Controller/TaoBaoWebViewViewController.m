//
//  TaoBaoWebViewViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/3.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "TaoBaoWebViewViewController.h"

#import "GMDCircleLoader.h"

@interface TaoBaoWebViewViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
    
}
@end

@implementation TaoBaoWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"淘宝登录";
    
    [self drawUi];
    
}

-(void)drawUi
{
    ////http://127.0.0.1:12345/error   24777727      2439a800fcad71b977bc7fd34126f78c
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight)];
    [webview setDelegate:self];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://a.meidebi.com/Customer-tbwebauthlogin"]]]];////[NSString stringWithFormat:@"%@Customer-tbwebauthlogin",URL_HR]   [NSString stringWithFormat:@"https://a.meidebi.com/Customer-tbwebauthlogin"]
    [self.view addSubview:webview];
    
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *strurl = request.URL.absoluteString;
    NSString *strbaseurl = request.URL.path;
    NSLog(@"%@\n%@",strurl,strbaseurl);
    if([strbaseurl isEqualToString:@"/Customer-tbwebauthcallback"])///Customer-tbwebauthcallback  Customer-tbWebLogin
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.deletate taobaoLoginBackUrl:strurl];
        });
        
        
        return NO;
    }
    [GMDCircleLoader hideFromView:self.view animated:NO];
    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSString *header = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",70.0f];
//
//    [webview stringByEvaluatingJavaScriptFromString:header];
    [GMDCircleLoader hideFromView:self.view animated:NO];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [GMDCircleLoader hideFromView:self.view animated:NO];
    
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
