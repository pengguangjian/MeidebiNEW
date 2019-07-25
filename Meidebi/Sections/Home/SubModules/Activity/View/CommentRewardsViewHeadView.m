//
//  CommentRewardsViewHeadView.m
//  Meidebi
//
//  Created by fishmi on 2017/5/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CommentRewardsViewHeadView.h"
#import <UIImageView+WebCache.h>
#import "CommentWebView.h"
#import "MDB_UserDefault.h"


@interface CommentRewardsViewHeadView ()
<
CommentWebViewDelegate
>
@property (nonatomic ,strong) UIView *view;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIImageView *clockImageV;
@property (nonatomic ,strong) UILabel *clockLabel;
@property (nonatomic ,strong) UIButton *amazonBtn;
@property (nonatomic ,strong) UIButton *labelBtn;
@property (nonatomic ,strong) UIButton *baoYouBtn;
@property (nonatomic ,strong) UIButton *cheapBtn;
@property (nonatomic ,strong) UIView *lineV;
@property (nonatomic, strong) UIImageView *activityStateBgImageView;
@property (nonatomic ,strong) UIView *lineV1;
@property (nonatomic ,strong) UILabel *numLabel;
@property (nonatomic ,strong) NSString *content;
@property (nonatomic ,strong) UIView *backgroundV;
@property (nonatomic ,strong) UIImageView *commentImageV;

@property (nonatomic ,strong) CommentWebView *supplementV;
@property (nonatomic ,strong) CommentWebView *ruleV;
@property (nonatomic ,strong) CommentWebView *grantV;
@property (nonatomic ,strong) CommentWebView *introduceV;

@property (nonatomic ,strong) UIView *timeV;
@property (nonatomic ,strong) UILabel *timeLabel;
@property (nonatomic ,strong) UILabel *timeTextLabel;
@end

@implementation CommentRewardsViewHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubView];
    }
    return self;
}



- (void)setModel:(CommentRewardsModel *)model{
    _model = model;
    _titleLabel.text = [NSString nullToString:model.title];
    NSString *str = [self timeToStr:model.createtime];
    _clockLabel.text = [NSString nullToString:str];
     [[MDB_UserDefault defaultInstance] setViewWithImage:_imageV url:model.image];
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

    if (![model.content isEqualToString:@""]) {
        _introduceV.hidden = NO;
        _introduceV.titleLabel.text = @"活动介绍";
        [self setWeBView:_introduceV.webView WithStr:model.content];
    }else{
        _introduceV.hidden = YES;
    }
    
    if (![model.starttime isEqualToString:@""]) {
        _timeV.hidden = NO;
        _timeLabel.text = @"活动时间";
        NSString *startTime = [self timeToStr:model.starttime];
        NSString *endTime = [self timeToStr:model.endtime];
        _timeTextLabel.text = [NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];
        
    }else{
        _timeV.hidden = YES;
    }
    
    if (![model.prizes isEqualToString:@""]) {
        _ruleV.hidden = NO;
        _ruleV.titleLabel.text = @"奖项及评奖规则";
        [self setWeBView:_ruleV.webView WithStr:model.prizes];
    }else{
        _ruleV.hidden = YES;
    }
    
    if (![model.victoryway isEqualToString:@""]) {
        _grantV.hidden = NO;
        _grantV.titleLabel.text = @"发奖方式";
        [self setWeBView:_grantV.webView WithStr:model.victoryway];
    }else{
        _grantV.hidden = YES;
    }
    
    if (![model.explain isEqualToString:@""]) {
        _supplementV.hidden = NO;
        _supplementV.titleLabel.text = @"补充说明";
        [self setWeBView:_supplementV.webView WithStr:model.explain];
    }else{
        _supplementV.hidden = YES;
    }
    if ([model.commentcount isEqualToString:@"0"]) {
        _lineV1.hidden = YES;
        _commentImageV.hidden = YES;
        _numLabel.hidden = YES;
    }else{
        _lineV1.hidden = NO;
        _commentImageV.hidden = NO;
        _numLabel.hidden = NO;
        _numLabel.text = [NSString stringWithFormat:@"评论(%@)",model.commentcount];
    }
    
    
    __weak __typeof__(self) weakself = self;
    
    if (_timeLabel.hidden) {
        [_ruleV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_introduceV.mas_bottom).offset(20);
        }];
        [self layoutIfNeeded];
        _view.height = _numLabel.bottom;
        self.height = _view.height;
    }
    _introduceV.callback = ^(CGFloat height) {
        [weakself.introduceV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
        }];
        [weakself layoutIfNeeded];
        weakself.view.height = weakself.numLabel.bottom;
        weakself.height = weakself.view.bottom;
        if (weakself.callback) {
            weakself.callback(CGRectGetHeight(weakself.frame));
        }
    };
    
    _ruleV.callback = ^(CGFloat height) {
        [weakself.ruleV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
        }];
        [weakself layoutIfNeeded];
        weakself.view.height = weakself.numLabel.bottom;
        weakself.height = weakself.view.bottom;
        if (weakself.callback) {
            weakself.callback(CGRectGetHeight(weakself.frame));
        }
    };
    
    _grantV.callback = ^(CGFloat height) {
        [weakself.grantV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
        }];
        [weakself layoutIfNeeded];
        weakself.view.height = weakself.numLabel.bottom;
        weakself.height = weakself.view.bottom;
        if (weakself.callback) {
            weakself.callback(CGRectGetHeight(weakself.frame));
        }
    };

    _supplementV.callback = ^(CGFloat height) {
        [weakself.supplementV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
        }];
        [weakself layoutIfNeeded];
        weakself.view.height = weakself.numLabel.bottom;
        weakself.height = weakself.view.bottom;
        if (weakself.callback) {
            weakself.callback(CGRectGetHeight(weakself.frame));
        }
    };
  
    
}


- (void)setSubView{
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
    }];
    _view = view;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(22);
        make.left.equalTo(view).offset(16);
    }];
    _titleLabel = titleLabel;
    
    [self setLabelBtn];
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#DADADA"];
    [view addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(_clockLabel.mas_bottom).offset(22);
        make.height.equalTo(@1);
    }];
//    lineV.hidden = YES;
    _lineV = lineV;
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(16);
        make.right.equalTo(view).offset(-16);
        make.top.equalTo(lineV.mas_bottom).offset(15);
        make.height.equalTo(imageV.mas_width).multipliedBy(1/3.f);
    }];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.clipsToBounds = YES;
    _imageV = imageV;
    
    
    _activityStateBgImageView = [UIImageView new];
    [_imageV addSubview:_activityStateBgImageView];
    [_activityStateBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_imageV.mas_bottom).offset(-5);
        make.right.equalTo(_imageV.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(53, 20));
    }];
    
    CommentWebView *introduceV = [[CommentWebView alloc] init];
    [view addSubview:introduceV];
    [introduceV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(_imageV.mas_bottom);
        make.height.offset(0);
    }];
    introduceV.hidden = YES;
    introduceV.delegate = self;
    _introduceV = introduceV;
    
    UIView *timeV = [[UIView alloc] init];
    [view addSubview:timeV];
    [timeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(introduceV.mas_bottom);
        make.bottom.equalTo(timeV.mas_top).offset(50);
    }];
    timeV.hidden = YES;
    _timeV = timeV;
    
    UIImageView *icoImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico"]];
    [timeV addSubview:icoImageV];
    
    [icoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeV).offset(16);
        make.top.equalTo(timeV).offset(20);
        make.size.mas_equalTo(CGSizeMake(13, 14));
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"";
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor colorWithHexString:@"#F77210"];
    [_timeV addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(icoImageV.mas_centerY);
        make.left.equalTo(icoImageV.mas_right).offset(5);
        make.right.equalTo(_timeV).offset(16);
    }];
    _timeLabel = timeLabel;
    
    UILabel *timeTextLabel = [[UILabel alloc] init];
    timeTextLabel.text = @"";
    timeTextLabel.font = [UIFont systemFontOfSize:14];
    timeTextLabel.textAlignment = NSTextAlignmentLeft;
    timeTextLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [_timeV addSubview:timeTextLabel];
    [timeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeV).offset(16);
        make.right.equalTo(_timeV).offset(-16);
        make.top.equalTo(timeLabel.mas_bottom).offset(20);
    }];
    _timeTextLabel = timeTextLabel;

    
    CommentWebView *ruleV = [[CommentWebView alloc] init];
    [view addSubview:ruleV];
    [ruleV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(timeV.mas_bottom).offset(25);
        make.height.offset(0);
    }];
    ruleV.delegate = self;
    ruleV.hidden =YES;
    _ruleV = ruleV;
    
    CommentWebView *grantV = [[CommentWebView alloc] init];
    [view addSubview:grantV];
    [grantV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(ruleV.mas_bottom);
        make.height.offset(0);
    }];
    grantV.hidden =YES;
    grantV.delegate = self;
    _grantV = grantV;
    
    CommentWebView *supplementV = [[CommentWebView alloc] init];
    [view addSubview:supplementV];
    [supplementV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(grantV.mas_bottom);
        make.height.offset(0);
    }];
    supplementV.hidden = YES;
    supplementV.delegate = self;
    _supplementV = supplementV;
    
    

    UIView *lineV1 = [[UIView alloc] init];
    [view addSubview:lineV1];
    lineV1.backgroundColor = [UIColor colorWithHexString:@"#DADADA"];
    [lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(supplementV.mas_bottom).offset(23);
        make.height.equalTo(@1);
    }];
    lineV1.hidden = YES;
    _lineV1 = lineV1;
    
    UIImageView *commentImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commendImage"]];
    [view addSubview:commentImageV];
    [commentImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(16);
        make.top.equalTo(lineV1.mas_bottom).offset(22);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    commentImageV.hidden = YES;
    _commentImageV = commentImageV;
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = @"评论()";
    numLabel.font = [UIFont systemFontOfSize:14];
    numLabel.textColor = [UIColor colorWithHexString:@"#F77210"];
    [view addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commentImageV.mas_right).offset(4);
        make.centerY.equalTo(commentImageV.mas_centerY);
        make.right.equalTo(view).offset(-16);
        make.bottom.equalTo(view.mas_bottom);
    }];
    numLabel.hidden = YES;
    _numLabel = numLabel;
    
//    [view mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(numLabel.mas_bottom);
//    }];
//    
//    [self layoutIfNeeded];
//    view.height = numLabel.bottom;

}

- (void)setLabelBtn{
    UIImageView *clockImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock"]];
    [_view addSubview:clockImageV];
    [clockImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view).offset(16);
        make.top.equalTo(_titleLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    clockImageV.height = 14;
    _clockImageV = clockImageV;
    
    UILabel *clockLabel = [[UILabel alloc] init];
    clockLabel.text = @"";
    clockLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    clockLabel.textAlignment = NSTextAlignmentCenter;
    clockLabel.font = [UIFont systemFontOfSize:11];
    [_view addSubview:clockLabel];
    [clockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(clockImageV.mas_right).offset(5);
        make.centerY.equalTo(clockImageV.mas_centerY);
    }];
    _clockLabel = clockLabel;
    
}

#pragma mark - calculate

- (void)calculateSubViewHeight{
    [self layoutIfNeeded];
    self.height = _view.bottom;
}

#pragma mark - setWevView
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
                           "</html>", font.familyName,@"100%",fontColor,content];
    NSString * htmlcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", htmlString];
    [webView loadHTMLString:htmlcontent baseURL:nil];
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


#pragma mark - CommentWebViewDelegate
- (void)webViewDidPreseeUrlWithLink:(NSString *)link{
    if ([self.delegate respondsToSelector:@selector(rewardsViewHeadViewWebViewDidClikUrl:)]) {
        [self.delegate rewardsViewHeadViewWebViewDidClikUrl:link];
    }
}

@end
