//
//  CommentWebView.m
//  Meidebi
//
//  Created by fishmi on 2017/6/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CommentWebView.h"
@interface CommentWebView ()<UIWebViewDelegate>

@end

@implementation CommentWebView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _view = view;
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico"]];
    [view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(16);
        make.top.equalTo(view).offset(15);
        make.size.mas_equalTo(CGSizeMake(13, 14));
    }];
    _imageV = imageV;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithHexString:@"#F77210"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageV.mas_centerY);
        make.left.equalTo(imageV.mas_right).offset(5);
        make.right.equalTo(view.mas_right).offset(-16);
        make.height.offset(14);
    }];
    _titleLabel = titleLabel;
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scrollView.scrollEnabled = NO;
    [view addSubview:webView];
    webView.delegate = self;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-5);
        make.left.equalTo(view).offset(5);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(view.mas_bottom).offset(-10);
        make.height.offset(100);
    }];
    _webView = webView;
}

#pragma mark - 设置webview
- (void)setWeBView: (UIWebView *)webView WithStr: (NSString *)str{
    NSString *content = [NSString nullToString:str];
    NSString * htmlcontent = content;
    [webView loadHTMLString:htmlcontent baseURL:nil];
}

#pragma mark - webviewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([self.delegate respondsToSelector:@selector(webViewDidPreseeUrlWithLink:)]) {
            [self.delegate webViewDidPreseeUrlWithLink:[NSString stringWithFormat:@"%@",request.URL]];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [_webView stringByEvaluatingJavaScriptFromString:
     @"var tagHead =document.documentElement.firstChild;"
     "var tagStyle = document.createElement(\"style\");"
     "tagStyle.setAttribute(\"type\", \"text/css\");"
     "tagStyle.appendChild(document.createTextNode(\"BODY{padding: 0pt 8pt}\"));"
     "var tagHeadAdd = tagHead.appendChild(tagStyle);"];
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no\"", webView.frame.size.width];
    [_webView stringByEvaluatingJavaScriptFromString:meta];
    NSString *height_str=[_webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    float height = [height_str floatValue];
    //再次设置WebView高度（点）
    [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(height);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    if (_callback) {
        _callback(height+40);
    }
    
    
}

@end
