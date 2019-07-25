//
//  ProductInfoWebMessageViewController.m
//  Meidebi
//  加载网页
//  Created by mdb-losaic on 2018/8/23.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "ProductInfoWebMessageViewController.h"

#import "MDB_UserDefault.h"

#import "GMDCircleLoader.h"



@interface ProductInfoWebMessageViewController ()<UIWebViewDelegate>
{
    
    UILabel *lbtitle;
    
    
}
@end

@implementation ProductInfoWebMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawSubview];
    
}

-(void)drawSubview
{
    
    UIView *viewtop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH, kStatusBarHeight)];
    [viewtop setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewtop];
    
    UIView *viewtitle = [[UIView alloc] initWithFrame:CGRectMake(0, viewtop.bottom, BOUNDS_WIDTH, kNavBarHeight)];
    [self.view addSubview:viewtitle];
    [viewtitle setBackgroundColor:[UIColor whiteColor]];
    
    lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH-60, viewtitle.height)];
    [viewtitle addSubview:lbtitle];
    [lbtitle setTextColor:RGB(50, 50, 50)];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setFont:[UIFont systemFontOfSize:14]];

    
    UIButton *btwanc = [[UIButton alloc] initWithFrame:CGRectMake(lbtitle.right, 0, viewtitle.width-lbtitle.right, viewtitle.height)];
    [viewtitle addSubview:btwanc];
    [btwanc setTitle:@"完成" forState:UIControlStateNormal];
    [btwanc setTitleColor:RGB(28, 135, 255) forState:UIControlStateNormal];
    [btwanc.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [btwanc addTarget:self action:@selector(wanchengAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, viewtitle.height-1, viewtitle.width, 1)];
    [viewline setBackgroundColor:RGB(238, 239, 240)];
    [viewtitle addSubview:viewline];
    
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, viewtitle.bottom, BOUNDS_WIDTH, BOUNDS_HEIGHT-viewtitle.bottom)];
    [self.view addSubview:webview];
    
    if(_strurl == nil)
    {
        _strurl = @"";
        [MDB_UserDefault showNotifyHUDwithtext:@"地址错误" inView:self.view];
        return;
    }
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_strurl]]];
    [webview setDelegate:self];
    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
    
}



-(void)wanchengAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - UIWebView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"99999=%@",request.URL.absoluteString);
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [GMDCircleLoader hideFromView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
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
