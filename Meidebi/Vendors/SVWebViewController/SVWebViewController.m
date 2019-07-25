//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewControllerActivityChrome.h"
#import "SVWebViewControllerActivitySafari.h"
#import "SVWebViewController.h"

#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"

@interface SVWebViewController () <UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *actionBarButtonItem;

@property (nonatomic, strong) UIView *viewback;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *request;

@property (strong, nonatomic) YHWebViewProgress *progressProxy;

@property (nonatomic, assign) BOOL istiaozhuan;

@end


@implementation SVWebViewController

#pragma mark - Initialization

- (void)dealloc {
    
    @try {
        NSHTTPCookie *cookie;
        
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        for (cookie in [storage cookies])
            
        {
            
            [storage deleteCookie:cookie];
            
        }
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:self.request];
        
        [self.webView stopLoading];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.webView.delegate = nil;
        self.delegate = nil;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
}

- (instancetype)initWithAddress:(NSString *)urlString {
    
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest*)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)loadRequest:(NSURLRequest*)request {
    [self.webView loadRequest:request];
}

#pragma mark - View lifecycle

- (void)loadView {
    
    
    self.view = self.viewback;
    [self.view addSubview:self.webView];
//    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
//    
//    CGRect rect=[self.webView.scrollView convertRect: self.view.bounds toView:window];
//    NSLog(@"%lf",rect.origin.y);
//    if(rect.origin.y>kStatusBarHeight+kNavBarHeight)
//    {
//        [self.webView setFrame:[UIScreen mainScreen].bounds];
//    }
//    else
//    {
//
//    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateToolbarItems];
    
    _progressProxy = [[YHWebViewProgress alloc] init];
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 3)];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    
    self.progressProxy.progressView = progressView;
    self.webView.delegate = self.progressProxy;
    [self.webView.scrollView setDelegate:self];
    self.progressProxy.webViewProxy = self;
    // 添加到视图
    [self.view addSubview:progressView];
    [NSHTTPCookieStorage load];
    [self loadRequest:self.request];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.webView = nil;
    _backBarButtonItem = nil;
    _forwardBarButtonItem = nil;
    _refreshBarButtonItem = nil;
    _stopBarButtonItem = nil;
    _actionBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.");
    
    [super viewWillAppear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Getters
-(UIView *)viewback
{
    if(!_viewback)
    {
        _viewback = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_viewback setBackgroundColor:[UIColor whiteColor]];
    }
    return _viewback;
}
- (UIWebView*)webView {
    if(!_webView) {
//        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavBarHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-(kStatusBarHeight+kNavBarHeight+50))];
        
        
        
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/SVWebViewControllerBack"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(goBackTapped:)];
        _backBarButtonItem.width = 18.0f;
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/SVWebViewControllerNext"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(goForwardTapped:)];
        _forwardBarButtonItem.width = 18.0f;
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTapped:)];
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    if (!_stopBarButtonItem) {
        _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopTapped:)];
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    if (!_actionBarButtonItem) {
        _actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
    }
    return _actionBarButtonItem;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.self.webView.canGoForward;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGFloat toolbarWidth = 250.0f;
        fixedSpace.width = 35.0f;
        
        NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          refreshStopBarButtonItem,
                          fixedSpace,
                          self.backBarButtonItem,
                          fixedSpace,
                          self.forwardBarButtonItem,
                          fixedSpace,
                          self.actionBarButtonItem,
                          nil];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
        toolbar.items = items;
        toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.navigationItem.rightBarButtonItems = items.reverseObjectEnumerator.allObjects;
    }
    
    else {
        NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          self.backBarButtonItem,
                          flexibleSpace,
                          self.forwardBarButtonItem,
                          flexibleSpace,
                          refreshStopBarButtonItem,
                          flexibleSpace,
                          self.actionBarButtonItem,
                          fixedSpace,
                          nil];
        
        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.toolbarItems = items;
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
    
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSString *strtemp = webView.request.URL.absoluteString;
    
    NSLog(@"7777777%@",strtemp);///
    if([strtemp rangeOfString:@"amazon"].location != NSNotFound&& [strtemp rangeOfString:@"tag="].location != NSNotFound && _istiaozhuan == NO)
    {
        _istiaozhuan = YES;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            //设备系统为IOS 10.0或者以上的
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strtemp]] options:@{} completionHandler:nil];
        }else{
            //设备系统为IOS 10.0以下的
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strtemp]]];
        }
    }
    if ([strtemp rangeOfString:@"to="].location == NSNotFound && [strtemp rangeOfString:@"gome"].location != NSNotFound && _istiaozhuan == NO)

    {
        _istiaozhuan = YES;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strtemp]]];
    }
    
    if (self.navigationItem.title == nil) {
        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    [self updateToolbarItems];
    
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
    
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
//    NSString *strtemp = request.URL.absoluteString;
//    NSLog(@"88888888=%@",strtemp);
//
//    if ([strtemp rangeOfString:@"to="].location == NSNotFound && ([strtemp rangeOfString:@"item.gome"].location != NSNotFound ||[strtemp rangeOfString:@"higoitem.gome"].location != NSNotFound))
//    {
//        NSLog(@"%@",request.URL.path);
//        NSString *strpath = request.URL.path;
//        NSArray *arrtemp = [strpath componentsSeparatedByString:@"-"];
//        NSString *strpathtemp = @"";
//        if(arrtemp.count==2)
//        {
//            strpathtemp = [NSString stringWithFormat:@"/p-%@",arrtemp[1]];
//
//        }
//        
//        if(strpathtemp.length>0)
//        {
//            strtemp = [strtemp stringByReplacingOccurrencesOfString:strpath withString:strpathtemp];
//            if([strtemp rangeOfString:@"higoitem.gome"].location != NSNotFound)
//            {
//                strtemp = [strtemp stringByReplacingOccurrencesOfString:@"higoitem.gome" withString:@"item.m.gome"];
//            }
//            else
//            {
//                strtemp = [strtemp stringByReplacingOccurrencesOfString:@"item.gome" withString:@"item.m.gome"];
//            }
//            
//            
//            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strtemp]]];
//            return NO;
//        }
//        
//        
//        
//    }
    
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

#pragma mark - Target actions

- (void)goBackTapped:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (void)goForwardTapped:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (void)reloadTapped:(UIBarButtonItem *)sender {
    [self.webView reload];
}

- (void)stopTapped:(UIBarButtonItem *)sender {
    [self.webView stopLoading];
    [self updateToolbarItems];
}

- (void)actionButtonTapped:(id)sender {
    NSURL *url = self.webView.request.URL ? self.webView.request.URL : self.request.URL;
    if (url != nil) {
        NSArray *activities = @[[SVWebViewControllerActivitySafari new], [SVWebViewControllerActivityChrome new]];
        
        if ([[url absoluteString] hasPrefix:@"file:///"]) {
            UIDocumentInteractionController *dc = [UIDocumentInteractionController interactionControllerWithURL:url];
            [dc presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
        } else {
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:activities];
            
#ifdef __IPHONE_8_0
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 &&
                UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                UIPopoverPresentationController *ctrl = activityController.popoverPresentationController;
                ctrl.sourceView = self.view;
                ctrl.barButtonItem = sender;
            }
#endif
            
            [self presentViewController:activityController animated:YES completion:nil];
        }
    }
}

- (void)doneButtonTapped:(id)sùender {
    [self dismissViewControllerAnimated:NO completion:NULL];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if(scrollView.contentOffset.y>=scrollView.contentSize.height-scrollView.height-50)
//    {
//        [self.navigationController.toolbar setHidden:YES];
//    }
//    else
//    {
//        [self.navigationController.toolbar setHidden:NO];
//    }
    
    
}

@end
