//
//  RichTextTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RichTextTableViewCell.h"
#import <JavaScriptCore/JavaScriptCore.h>
@protocol WebViewExportDelegate <NSObject>

- (void)onClick:(NSInteger)index;
- (void)onload;
- (void)documentReadyStateComplete;

@end

@protocol CorrelationJSExport <JSExport>

- (void)onClick:(NSInteger)index;
- (void)onload;
- (void)documentReadyStateComplete;

@end

@interface CorrelationJSExport : NSObject<CorrelationJSExport>
@property (nonatomic, weak) id<WebViewExportDelegate> delegate;

@end

@implementation CorrelationJSExport

- (void)onClick:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(onClick:)]) {
            [self.delegate onClick:index];
        }
    });
}

- (void)onload {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(onload)]) {
            [self.delegate onload];
        }
    });
}

- (void)documentReadyStateComplete {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(documentReadyStateComplete)]) {
            [self.delegate documentReadyStateComplete];
        }
    });
}

@end


static CGFloat const kWebViewToLeftMargin  = 16;
//static CGFloat const kWebViewToBottomMargin = 19;

@interface RichTextTableViewCell ()
<
UIWebViewDelegate,
WebViewExportDelegate
>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, assign) BOOL webviewIsLoading;
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) CorrelationJSExport *jsExport;

@end

@implementation RichTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupSubviews{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(kWebViewToLeftMargin, 0, kMainScreenW-kWebViewToLeftMargin*2, 1)];
    [self.contentView addSubview:_webView];
    _webView.delegate = self;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.scrollEnabled = NO;
    _webView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    _jsExport = [CorrelationJSExport new];
    _jsExport.delegate = self;
}

- (void)openRichTextWithUrl:(NSString *)linkUrl{
    if ([[NSString nullToString:linkUrl] isEqualToString:@""]) return;
    _webView.frame = CGRectMake(kWebViewToLeftMargin, 0, kMainScreenW-kWebViewToLeftMargin*2, 1);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString nullToString:linkUrl]]]];
}

- (void)openRichTextWithLocalSource:(NSString *)source{
    if (!source) return;
    _webView.frame = CGRectMake(kWebViewToLeftMargin, 0, kMainScreenW-kWebViewToLeftMargin*2, 1);
    NSString *str_bigfont=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bigfont" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString *description_bigfont=[NSString stringWithFormat:@"<html>%@%@</html>",str_bigfont,source];
    [_webView loadHTMLString:description_bigfont baseURL:nil];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([self.delegate respondsToSelector:@selector(webViewDidPreseeUrlWithLink:)]) {
            [self.delegate webViewDidPreseeUrlWithLink:[NSString stringWithFormat:@"%@",request.URL]];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _jsContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _jsContext[@"NJContext"] = _jsExport;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    if (!webView.isLoading) {
        NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
        BOOL complete = [readyState isEqualToString:@"complete"];
        if (complete) {
            [self webViewDidFinishLoadCompletely];
        } else {
            NSString *jsString =
            @"window.onload = function() {"
            @"    NJContext.onload();"
            @"};"
            @"document.onreadystatechange = function () {"
            @"    if (document.readyState == \"complete\") {"
            @"        NJContext.documentReadyStateComplete();"
            @"    }"
            @"};";
            [_webView stringByEvaluatingJavaScriptFromString:jsString];
        }
    }
}

#pragma mark - WebViewExportDelegate
- (void)onClick:(NSInteger)index {
}
- (void)onload {
    [self webViewDidFinishLoadCompletely];
}
- (void)documentReadyStateComplete {
    [self webViewDidFinishLoadCompletely];
}
- (void)webViewDidFinishLoadCompletely {
    
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no\"", _webView.frame.size.width];
    [_webView stringByEvaluatingJavaScriptFromString:meta];

    //    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    CGRect webFrame = _webView.frame;
    CGSize fittingSize = [_webView sizeThatFits:CGSizeZero];
    self.cellHeight = fittingSize.height;
    webFrame.size.height = self.cellHeight;
    self.webView.frame = webFrame;
    if(_webViewLoadFinished){
        _webViewLoadFinished(self.cellHeight);
    }
    // 用通知发送加载完成后的高度
    [[NSNotificationCenter defaultCenter] postNotificationName:kWebviewDidFinishLoadNotification object:self userInfo:nil];

}


@end
