//
//  DaiGouGongLueViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouGongLueViewController.h"

#import "MDBwebVIew.h"

#import "MDB_UserDefault.h"

#import "HTTPManager.h"

@interface DaiGouGongLueViewController ()<UIWebViewDelegate>
{
    UIScrollView *scvback;
    UIWebView *webview;
}
@end

@implementation DaiGouGongLueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代购攻略";
    
    [self drawSubview];
    
    [self bindData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [webview.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

-(void)drawSubview
{
    scvback = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight)];
    [scvback setBackgroundColor:RGB(245,245,245)];
    [self.view addSubview:scvback];
    
    UIView *viewheader = [self drawHeader:CGRectMake(10, 10, scvback.width-20, scvback.width-20)];
    [scvback addSubview:viewheader];
    
    
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(10, viewheader.bottom+15, viewheader.width, 200)];
    [webview.layer setMasksToBounds:YES];
    [webview.layer setCornerRadius:10];
    [webview.scrollView setScrollEnabled:NO];
    [scvback addSubview:webview];
    [webview setDelegate:self];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"完成");
//        });
//    });
    [webview.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(UIView *)drawHeader:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:10];
    
    
    UIView *viewleft = [self drawImageAndText:CGRectMake(20, 20, 80, 80+30) andtext:@"①下单付款" andimage:@"daigougongluediyibu" andtextfont:14 andcolor:RGB(181,141,84) andimageProportion:1];
    [view addSubview:viewleft];
    
    
    UIView *viewright = [self drawImageAndText:CGRectMake(20, 20, 80, 80+30) andtext:@"②包裹签收" andimage:@"daigougongluedierbu" andtextfont:14 andcolor:RGB(181,141,84) andimageProportion:1];
    [viewright setRight:view.width-20];
    [view addSubview:viewright];
    
    
    
    UILabel *lbb = [[UILabel alloc] initWithFrame:CGRectMake(viewleft.right+10, viewleft.top, viewright.left-viewleft.right-20, viewleft.height*0.55)];
    [lbb setText:@"您只需两步"];
    [lbb setTextColor:RGB(181,141,84)];
    [lbb setTextAlignment:NSTextAlignmentCenter];
    
    if(BOUNDS_WIDTH>320)
    {
        [lbb setFont:[UIFont systemFontOfSize:16]];
    }
    else
    {
        [lbb setFont:[UIFont systemFontOfSize:14]];
    }
    [view addSubview:lbb];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(lbb.left, lbb.bottom, lbb.width, 1)];
    [viewline setBackgroundColor:RGB(181,141,84)];
    [view addSubview:viewline];
    
    
    ///
    UIView *viewother = [self drawother:CGRectMake(viewleft.left, viewleft.bottom+30, view.width-40, 100)];
    [view addSubview:viewother];
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 40)];
    [lbtitle setText:@"我们为您搞定"];
    [lbtitle setTextColor:RGB(181,141,84)];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setFont:[UIFont systemFontOfSize:16]];
    [lbtitle setCenter:CGPointMake(view.width/2.0, viewother.top)];
    [lbtitle setBackgroundColor:[UIColor whiteColor]];
    [lbtitle.layer setMasksToBounds:YES];
    [lbtitle.layer setCornerRadius:lbtitle.height/2.0];
    [lbtitle.layer setBorderColor:RGB(181,141,84).CGColor];
    [lbtitle.layer setBorderWidth:1];
    [view addSubview:lbtitle];
    
    [view setHeight:viewother.bottom+30];
    
    return view;
}

-(UIView *)drawother:(CGRect)rect
{
   UIView *view = [[UIView alloc] initWithFrame:rect];
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:10];
    [view.layer setBorderColor:RGB(181,141,84).CGColor];
    [view.layer setBorderWidth:1];
    [view setClipsToBounds:NO];
    
    NSArray *arrimage = [NSArray arrayWithObjects:@"daigouguanligwcl",@"daigouguanligwfh",@"daigouguanliglqg",@"daigouguanlignfh", nil];
    NSArray *arrtitle = [NSArray arrayWithObjects:@"官网处理",@"官网发货",@"国内清关",@"国内发货", nil];
    float fbottom = 0.0;
    for(int i = 0 ; i < arrtitle.count; i++)
    {
        UIView *viewitem = [self drawImageAndText:CGRectMake(view.width/4.0*i, 40, view.width/4.0, 30*kScale+50) andtext:arrtitle[i] andimage:arrimage[i] andtextfont:12 andcolor:RGB(51,51,51) andimageProportion:0.5];
        [view addSubview:viewitem];
        fbottom = viewitem.bottom ;
    }
    
    [view setHeight:fbottom+15];
    
    return view;
}

-(UIView *)drawImageAndText:(CGRect)rect andtext:(NSString *)strtext andimage:(NSString *)strimage andtextfont:(float)font andcolor:(UIColor *)color andimageProportion:(float)fpp
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.width*fpp, view.width*fpp)];
    [imgv setImage:[UIImage imageNamed:strimage]];
    [imgv setCenterX:view.width/2.0];
    [view addSubview:imgv];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, imgv.bottom, view.width, view.height-imgv.bottom)];
    [lb setText:strtext];
    [lb setTextColor:color];
    [lb setTextAlignment:NSTextAlignmentCenter];
    [lb setFont:[UIFont systemFontOfSize:font]];
    [view addSubview:lb];
    
    return view;
}

#pragma mark - MDBwebVIew
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentSize"])
    {
        CGSize fittingSize = [webview sizeThatFits:CGSizeZero];
        [webview setHeight:fittingSize.height];
        [scvback setContentSize:CGSizeMake(0, webview.height+webview.top+15)];
        
    }
    
}

-(void)bindData
{
    [HTTPManager sendGETRequestUrlToService:WenZheng_ALL_rol withParametersDictionry:@{@"key":@"strategy"} view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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


-(void)dealloc
{
    [webview removeFromSuperview];
    webview = nil;
    scvback = nil;
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
