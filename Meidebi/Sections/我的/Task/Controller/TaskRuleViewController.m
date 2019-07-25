//
//  TaskRuleViewController.m
//  Meidebi
//
//  Created by mdb-admin on 16/8/22.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "TaskRuleViewController.h"
#import "GMDCircleLoader.h"
@interface TaskRuleViewController ()
<
UIWebViewDelegate
>
@end

@implementation TaskRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"规则";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigation];
    [self setupSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
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

- (void)setupSubViews{
    UIWebView *webView = [UIWebView new];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    webView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.bounces = NO;
    webView.delegate = self;
    
    NSString *urlLink = [NSString stringWithFormat:@"%@Content-taskrule.html",URL_HR];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlLink]]];
    
    [GMDCircleLoader setOnView:self.navigationController.view withTitle:nil animated:YES];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [GMDCircleLoader hideFromView:self.navigationController.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [GMDCircleLoader hideFromView:self.navigationController.view animated:YES];
}
@end
