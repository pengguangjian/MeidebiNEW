//
//  ShowActiveViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/3/23.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "ShowActiveViewController.h"
#import "MDB_UserDefault.h"
#import "GMDCircleLoader.h"
#import "SVModalWebViewController.h"
@interface ShowActiveViewController ()
<UIWebViewDelegate>
@end

@implementation ShowActiveViewController{
    UIWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView=[[UIWebView alloc]init];
    NSURLRequest *requst=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:requst];
    _webView.scalesPageToFit=YES;
    _webView.delegate=self;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view);
        }
    }];
    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
    [self setNavigation];
}
-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)doClickLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webViewDidPreseeUrlWithLink:(NSString *)link{
    SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:link];
    svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:svweb animated:NO completion:nil];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked && _external) {
        [self webViewDidPreseeUrlWithLink:[NSString stringWithFormat:@"%@",request.URL]];
         return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [GMDCircleLoader hideFromView:self.view animated:YES];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [GMDCircleLoader hideFromView:self.view animated:YES];
}
@end
