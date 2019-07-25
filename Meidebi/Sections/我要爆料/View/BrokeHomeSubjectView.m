//
//  BrokeHomeSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/27.
//  Copyright © 2016年 meidebi. All rights reserved.
//


@interface NJBrokeHomeScrollView : UIScrollView

@end

@implementation NJBrokeHomeScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    @try
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    @finally
    {
        
    }
}

@end

#import "BrokeHomeSubjectView.h"
#import "MDB_UserDefault.h"
#import "BrokeAlertView.h"
#import "PelsonalHandleButton.h"

#import "PushYuanChuangTextView.h"

@interface BrokeHomeSubjectView ()
<
UIAlertViewDelegate,
BrokeAlertViewDelegate,
UITextViewDelegate
>
@property (nonatomic, strong) PushYuanChuangTextView *brokeLinkTextField;
@property (nonatomic, strong) PelsonalHandleButton *commodityBrokeBtn;
@property (nonatomic, strong) PelsonalHandleButton *activityBrokeBtn;
@property (nonatomic, strong) NSString *typeStr;
@end

@implementation BrokeHomeSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _typeStr = @"";
        [self setupSubview];
        [self updateSubviews];
    }
    return self;
}

- (void)setupSubview{
    NJBrokeHomeScrollView *scrollView = [NJBrokeHomeScrollView new];
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    
    UIView *contairView = [UIView new];
    [scrollView addSubview:contairView];
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    contairView.backgroundColor = [UIColor clearColor];

    PelsonalHandleButton *commodityBrokeBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:commodityBrokeBtn];
    [commodityBrokeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contairView.mas_top).offset(40);
        make.right.equalTo(contairView.mas_centerX).offset(-30);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    commodityBrokeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [commodityBrokeBtn setTitle:@"单品爆料" forState:UIControlStateNormal];
    [commodityBrokeBtn setTitleColor:[UIColor colorWithHexString:@"#837E79"] forState:UIControlStateNormal];
    [commodityBrokeBtn setTitleColor:[UIColor colorWithHexString:@"#F46304"] forState:UIControlStateSelected];
    [commodityBrokeBtn setImage:[UIImage imageNamed:@"brok_type_normal"] forState:UIControlStateNormal];
    [commodityBrokeBtn setImage:[UIImage imageNamed:@"brok_type_normal"] forState:UIControlStateNormal | UIControlStateHighlighted];
    [commodityBrokeBtn setImage:[UIImage imageNamed:@"brok_type_select"] forState:UIControlStateSelected];
    [commodityBrokeBtn addTarget:self action:@selector(responsToBrokeTypeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    commodityBrokeBtn.selected = YES;
    _typeStr = @"2";
    _commodityBrokeBtn = commodityBrokeBtn;
    
    PelsonalHandleButton *activityBrokeBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:activityBrokeBtn];
    [activityBrokeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contairView.mas_top).offset(40);
        make.left.equalTo(contairView.mas_centerX).offset(30);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    activityBrokeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [activityBrokeBtn setTitle:@"活动爆料" forState:UIControlStateNormal];
    [activityBrokeBtn setTitleColor:[UIColor colorWithHexString:@"#837E79"] forState:UIControlStateNormal];
    [activityBrokeBtn setTitleColor:[UIColor colorWithHexString:@"#F46304"] forState:UIControlStateSelected];
    [activityBrokeBtn setImage:[UIImage imageNamed:@"brok_type_normal"] forState:UIControlStateNormal];
    [activityBrokeBtn setImage:[UIImage imageNamed:@"brok_type_normal"] forState:UIControlStateNormal | UIControlStateHighlighted];
    [activityBrokeBtn setImage:[UIImage imageNamed:@"brok_type_select"] forState:UIControlStateSelected];
    [activityBrokeBtn addTarget:self action:@selector(responsToBrokeTypeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    _activityBrokeBtn = activityBrokeBtn;
    
    _brokeLinkTextField = [PushYuanChuangTextView new];
    [contairView addSubview:_brokeLinkTextField];
    [_brokeLinkTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(activityBrokeBtn.mas_bottom).offset(35);
        make.left.equalTo(contairView.mas_left).offset(17);
        make.right.equalTo(contairView.mas_right).offset(-17);
        make.height.offset(37);
    }];
    _brokeLinkTextField.backgroundColor = [UIColor whiteColor];
    _brokeLinkTextField.font = [UIFont systemFontOfSize:15.f];
    _brokeLinkTextField.PlaceholderText = @"请粘贴商品链接到此处";
    _brokeLinkTextField.layer.masksToBounds = YES;
    _brokeLinkTextField.layer.borderWidth = 1;
    _brokeLinkTextField.layer.borderColor = [UIColor colorWithHexString:@"#DEDEDE"].CGColor;
    _brokeLinkTextField.layer.cornerRadius = 3.f;
    [_brokeLinkTextField setDelegate:self];
//    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(15,0,15,26)];
//    leftView.backgroundColor = [UIColor clearColor];
//    _brokeLinkTextField.leftView = leftView;
//    _brokeLinkTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *promptLabel = [UILabel new];
    [contairView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_brokeLinkTextField.mas_bottom).offset(26);
        make.left.right.equalTo(_brokeLinkTextField);
    }];
    promptLabel.numberOfLines = 0;
    promptLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
    promptLabel.font = [UIFont systemFontOfSize:12.f];
    promptLabel.text = @"支持京东、亚马逊、某猫等网站的自动信息获取。";
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhone4 || iPhone5) {
            make.top.equalTo(promptLabel.mas_bottom).offset(65);
        }else{
            make.top.equalTo(promptLabel.mas_bottom).offset(50);
        }
        make.centerX.equalTo(contairView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(154, 51));
    }];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4.f;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [sureBtn setTitle:@"获取优惠信息" forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"broke_bg"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(responsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sureBtn.mas_bottom).offset(10);
    }];
}

- (void)updateSubviews{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *urlLink = pasteboard.string;
    if (urlLink && ([urlLink hasPrefix:@"www"] ||
                    [urlLink hasPrefix:@"http"] ||
                    [urlLink hasPrefix:@"https"])) {
        BrokeAlertView *alertView = [[BrokeAlertView alloc] init];
        alertView.style = alertStyleBrokeCopy;
        alertView.delegate = self;
        [alertView showAlert];
    }
}

- (void)inspectPasteboard{
    [self updateSubviews];
}
- (void)responsToBrokeTypeBtnEvent:(UIButton *)sender{
    if (sender == _activityBrokeBtn) {
        _activityBrokeBtn.selected = !_activityBrokeBtn.selected;
        _commodityBrokeBtn.selected = NO;
        if (_activityBrokeBtn.selected) {
            _typeStr = @"1";
        }else{
            _typeStr = @"";
        }
    }else{
        _activityBrokeBtn.selected = NO;
        _commodityBrokeBtn.selected = !_commodityBrokeBtn.selected;
        if (_commodityBrokeBtn.selected) {
            _typeStr = @"2";
        }else{
            _typeStr = @"";
        }
    }
}
- (void)responsToBtnEvent:(id)sender{
    [self endEditing:YES];
    NSString *urlLink = _brokeLinkTextField.text;
    if ([urlLink isEqualToString:@""]) {
        return;
    }
    if ([_typeStr isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请选择爆料类型"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    NSArray<NSTextCheckingResult *> *results = [[self regexUrl] matchesInString:urlLink options:kNilOptions range:NSMakeRange(0, urlLink.length)];
    for (NSTextCheckingResult *emo in results) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        if ((emo.range.length + emo.range.location) <= urlLink.length) {
            urlLink = [urlLink substringWithRange:emo.range];
            _brokeLinkTextField.text = urlLink;
        }
    }

    if (![MDB_UserDefault getIsLogin]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:110];
        [alertView show];
        
    }else{
        if ([_delegate respondsToSelector:@selector(brokeHomeSubjectView:didPressEnsureBtnWithBrokeLink:type:)]) {
            [_delegate brokeHomeSubjectView:self didPressEnsureBtnWithBrokeLink:urlLink type:_typeStr];
        }
    }
        
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (NSRegularExpression *)regexUrl {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:kNilOptions error:NULL];
    });
    return regex;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        if ([self.delegate respondsToSelector:@selector(brokeHomeSubjectViewIntoLoginVc)]) {
            [self.delegate brokeHomeSubjectViewIntoLoginVc];
        }
        
    }
    
}

#pragma mark - BrokeAlertViewDelegate
- (void)brokeAlertViewDidPressEnsureBtnWithAlertView:(BrokeAlertView *)alertView{
    NSString *urlLink = [UIPasteboard generalPasteboard].string;
    if (!urlLink) return;
    NSArray<NSTextCheckingResult *> *results = [[self regexUrl] matchesInString:urlLink options:kNilOptions range:NSMakeRange(0, urlLink.length)];
    for (NSTextCheckingResult *emo in results) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        @try
        {
            urlLink = [urlLink substringWithRange:emo.range];
        }
        @catch(NSException *exc)
        {
            
        }
        @finally
        {
            
        }
        
    }
    if (!urlLink) return;
    _brokeLinkTextField.text = urlLink;
    [_brokeLinkTextField hiddenPlaceholder];
    [UIPasteboard generalPasteboard].string = @"";
}

- (void)brokeAlertViewDidPressCancelBtnWithAlertView:(BrokeAlertView *)alertView{
    [UIPasteboard generalPasteboard].string = @"";
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    [_brokeLinkTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        NSString *str = textView.text;
        float fheight = [MDB_UserDefault countTextSize:CGSizeMake(_brokeLinkTextField.width, 200) andtextfont:_brokeLinkTextField.font andtext:str].height+15;
        if(fheight>120)
        {
            fheight=120;
        }
        if(fheight<37)
        {
            make.height.offset(37);
        }
        else
        {
            make.height.offset(fheight);
        }
        
    }];
}



@end
