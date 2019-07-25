//
//  DaiGouGuiZheViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/23.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouGuiZheViewController.h"
#import "GMDCircleLoader.h"
#import "MDB_UserDefault.h"
#import "MDBwebVIew.h"
#import "HTTPManager.h"

@interface DaiGouGuiZheViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
    
}

@end

@implementation DaiGouGuiZheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_strtitle==nil)
    {
        _strtitle = @"";
    }
    self.title = _strtitle;
    
    [self drawSubview];
}

-(void)drawSubview
{
    
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight)];
    [webview setDelegate:self];
    [self.view addSubview:webview];
//    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
//    });
    [self bindData];

    
}

-(void)bindData
{
    if(_strurl==nil)
    {
        _strurl = @"";
    }
    
    [HTTPManager sendGETRequestUrlToService:_strurl withParametersDictionry:_dicpush view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        //        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dicdata = [dicAll objectForKey:@"data"];
                NSString *strcontent = [NSString nullToString:dicdata[@"content"]];
                [webview loadHTMLString:strcontent baseURL:nil];
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
        }
        
    }];
    
}


//-(void)viewDidAppear:(BOOL)animated
//{
//    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
//    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
//
//}

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
    
    NSString *javascript = [NSString stringWithFormat:@"var viewPortTag=document.createElement('meta');  \
                  viewPortTag.id='viewport';  \
                  viewPortTag.name = 'viewport';  \
                  viewPortTag.content = 'width=%d; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;';  \
                  document.getElementsByTagName('head')[0].appendChild(viewPortTag);" , (int)webview.bounds.size.width];
    
    [webview stringByEvaluatingJavaScriptFromString:javascript];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [GMDCircleLoader hideFromView:self.view animated:YES];
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
