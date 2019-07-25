//
//  ADHandleViewController.m
//  Meidebi
//  加载yem 
//  Created by mdb-admin on 2017/1/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ADHandleViewController.h"
#import "GMDCircleLoader.h"

@interface ADHandleViewController ()
<
UIWebViewDelegate
>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *adLink;

@end

@implementation ADHandleViewController

- (instancetype)initWithAdLink:(NSString *)adLink{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _adLink = adLink;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigation];
    [self setupSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        make.edges.equalTo(self.view);
    }];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    _webView = webView;
    
    if (_adLink) {
        if ([_adLink hasPrefix:@"www"]) {
            _adLink = [NSString stringWithFormat:@"http://%@",_adLink];
        }
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_adLink]]];
        [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [GMDCircleLoader hideFromView:self.view animated:YES];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [GMDCircleLoader hideFromView:self.view animated:YES];
}

@end
