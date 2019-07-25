//
//  RecommendActivityViewCollectionHeadView.m
//  Meidebi
//
//  Created by fishmi on 2017/5/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RecommendActivityViewCollectionHeadView.h"
#import "ImagePlayerView.h"
#import "MDB_UserDefault.h"
@interface RecommendActivityViewCollectionHeadView ()<UIWebViewDelegate>
@property (nonatomic ,strong) UIView *view;
@property (nonatomic ,strong) UIButton *latestBtn;
@property (nonatomic ,strong) UIButton *hotestBtn;
@property (nonatomic ,strong) UIView *lineV;
@property (nonatomic ,strong) UIView *listV;
@property (nonatomic ,strong) UIView *imageV;
@property (nonatomic ,strong) UIWebView *detailV;
@property (nonatomic ,strong) UIView *timeV;
@property (nonatomic ,strong) UILabel *timeLab;
@property (nonatomic ,strong) UIButton *listBtn;
@property (nonatomic ,strong) UILabel *listLabel;
@property (nonatomic ,strong) UILabel *otherLabel;
@property (nonatomic, strong) UIImageView *activityStateBgImageView;
@end

@implementation RecommendActivityViewCollectionHeadView

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    _reFrame = self.frame;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSubView];
    }
    return self;
}

- (void)setModel:(RecommendActivityHeadViewModel *)model{
    _model = model;
    _subImageV.hidden = NO;
    if (![model.timeout isEqualToString:@"0"]) {
        _activityStateBgImageView.image = [UIImage imageNamed:@"avtivity_end"];
    }else{
        NSInteger currentTime = (NSInteger)[[NSDate date] timeIntervalSince1970];
        NSInteger endTime = [NSString nullToString:model.endtime].integerValue;
        NSInteger starTime = [NSString nullToString:model.starttime].integerValue;
         if (currentTime < starTime) {
            _activityStateBgImageView.image = [UIImage imageNamed:@"avtivity_no_star"];
         }else if (currentTime<=endTime && currentTime >= starTime) {
             _activityStateBgImageView.image = [UIImage imageNamed:@"avtivity_ing"];
         }else{
            _activityStateBgImageView.image = nil;
        }
    }

    [[MDB_UserDefault defaultInstance] setViewWithImage:_subImageV url:[NSString nullToString:model.image]];
    NSString *startTime = [self timeToStr:model.starttime];
    NSString *endTime = [self timeToStr:model.endtime];
    if (![startTime isEqualToString:@""]) {
        _timeV.hidden = NO;
        _timeLab.text = [NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];
    }
    [self setWeBView:_detailV WithStr:model.content];
}

- (void)showHidenSideView{
    _latestBtn.hidden = NO;
    _hotestBtn.hidden = NO;
    _lineV.hidden = NO;
}

- (void)setSubView{
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
    }];
    _view = view;
    
    [self setUpImageView];
    
    UIWebView *detailV = [[UIWebView alloc] init];
    detailV.delegate = self;
    detailV.tag = 101;
    detailV.scrollView.bounces = NO;
    detailV.scrollView.showsHorizontalScrollIndicator = NO;
    detailV.scrollView.scrollEnabled = NO;
    [detailV sizeToFit];
    [view addSubview:detailV];
    [detailV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subImageV.mas_bottom).offset(17);
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.height.offset(100);
    }];
    [self setWeBView:detailV WithStr:_model.content];
    _detailV = detailV;

    
    UIView *timeV = [[UIView alloc] init];
    timeV.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    [view addSubview:timeV];
    [timeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(16);
        make.right.equalTo(view).offset(-16);
        make.top.equalTo(detailV.mas_bottom).offset(18);
        make.height.equalTo(@31);
    }];
    timeV.hidden= YES;
    _timeV = timeV;
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.text = @"";
    timeLab.font = [UIFont systemFontOfSize:14];
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.textColor = [UIColor colorWithHexString:@"#444444"];
    timeLab.textAlignment = NSTextAlignmentCenter;
    [timeV addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(timeV);
    }];
    _timeLab = timeLab;
    
    UIButton *latestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [latestBtn setTitle:@"最新" forState:UIControlStateNormal];
    latestBtn.titleLabel.font= [UIFont systemFontOfSize:14];
    [latestBtn addTarget:self action:@selector(changeTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [latestBtn setTitleColor:[UIColor colorWithHexString:@"#444444" ] forState:UIControlStateNormal];
    [latestBtn setTitleColor:[UIColor colorWithHexString:@"#F35D00" ] forState:UIControlStateSelected];
    latestBtn.selected = YES;
    latestBtn.tag = 101;
    [view addSubview:latestBtn];
    [latestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_centerX).offset(-20);
        make.size.mas_equalTo(CGSizeMake(120, 35));
        make.top.equalTo(timeLab.mas_bottom).offset(14);
    }];
    latestBtn.hidden = YES;
    _latestBtn = latestBtn;
    
    UIButton *hotestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hotestBtn.titleLabel.font= [UIFont systemFontOfSize:14];
    [hotestBtn setTitle:@"最热" forState:UIControlStateNormal];
    [hotestBtn addTarget:self action:@selector(changeTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [hotestBtn setTitleColor:[UIColor colorWithHexString:@"#444444" ] forState:UIControlStateNormal];
    [hotestBtn setTitleColor:[UIColor colorWithHexString:@"#F35D00" ] forState:UIControlStateSelected];
    hotestBtn.tag = 100;
    [view addSubview:hotestBtn];
    [hotestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_centerX).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 35));
        make.top.equalTo(timeLab.mas_bottom).offset(14);
    }];
    hotestBtn.hidden = YES;
    _hotestBtn = hotestBtn;
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#F35D00"];
    [view addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 2));
        make.centerX.equalTo(latestBtn.mas_centerX);
        make.top.equalTo(latestBtn.mas_bottom).offset(2);
    }];
    lineV.hidden = YES;
    _lineV = lineV;

    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineV.mas_bottom);
    }];
    
    [self layoutIfNeeded];
    self.height = lineV.bottom;
}

- (void)setUpImageView{
    UIImageView *subImageV = [[UIImageView alloc] init];
    [_view addSubview:subImageV];
    [subImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_view);
        make.height.equalTo(subImageV.mas_width).multipliedBy(1/3.f);
    }];
    subImageV.contentMode = UIViewContentModeScaleAspectFill;
    subImageV.clipsToBounds = YES;
    _subImageV.hidden = YES;
    _subImageV =subImageV;
    
    _activityStateBgImageView = [UIImageView new];
    [_subImageV addSubview:_activityStateBgImageView];
    [_activityStateBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_subImageV.mas_bottom);
        make.right.equalTo(_subImageV.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(53, 20));
    }];

}

- (void)calculateHeadViewHeight{
    [self layoutIfNeeded];
    self.height = _lineV.bottom;
}

#pragma mark - 设置webview
- (void)setWeBView: (UIWebView *)webView WithStr: (NSString *)str{
    NSString *content = [NSString nullToString:str];
    UIFont *font = [UIFont systemFontOfSize:12];
    NSString *fontColor =@"666666";
    NSString *htmlString =[NSString stringWithFormat:@"<html> \n"
                           "<head> \n"
                           "<style type=\"text/css\"> \n"
                           "body {font-family: \"%@\"; color: #%@;}\n"
                           "a{ text-decoration: none} \n"
                           "img{max-width:%@;width:auto;}"
                           "</style> \n"
                           "</head> \n"
                           "<body>%@</body> \n"
                           "</html>",font.familyName,fontColor,@"100%",content];
    NSString * htmlcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", htmlString];
    [webView loadHTMLString:htmlcontent baseURL:nil];
}


#pragma mark - btnClick
- (void)changeTypeBtnClick:(UIButton *)sender{
    if (sender.tag == 100) {
        _latestBtn.selected = NO;
        _hotestBtn.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            _lineV.centerX = _hotestBtn.centerX;
        }];
        if ([self.delegate respondsToSelector:@selector(dataRefreshByHotBtnClick)]) {
            [self.delegate dataRefreshByHotBtnClick];
        }
    }else {
        _latestBtn.selected = YES;
        _hotestBtn.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            _lineV.centerX = _latestBtn.centerX;
        }];
        if ([self.delegate respondsToSelector:@selector(dataRefreshByLatestBtnClick)]) {
            [self.delegate dataRefreshByLatestBtnClick];
        }
    }
    
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
   
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    webView.height = clientheight;
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no\"", _detailV.frame.size.width];
    [_detailV stringByEvaluatingJavaScriptFromString:meta];
    
    //获取内容实际高度（像素）
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
    // height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
    if (frame.height == 0) height = 0;
    if (webView.tag == 101) {
        [webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
        }];

        [self calculateHeadViewHeight];
        if (_callback) {
            _callback(self.height);
        }
      
    }
    
}

// 时间戮转时间
- (NSString *)timeToStr:(NSString *) str {
    NSTimeInterval interval=[[NSString nullToString:str] doubleValue] ;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/BeiJing"];
    [objDateformat setTimeZone:timeZone];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    return timeStr;
}



@end
