//
//  BrokeAlertView.m
//  Meidebi
//
//  Created by losaic on 16/7/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "BrokeAlertView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
@interface BrokeAlertView ()

@property (nonatomic, strong) UIView *contairView;
@property (nonatomic, strong) UIWindow *showWindow;
@property (nonatomic, strong) UIButton *continueBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *title;
@end

@implementation BrokeAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    _contairView = [UIView new];
    [self addSubview:_contairView];
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.offset(280);
    }];
    _contairView.backgroundColor = [UIColor whiteColor];
    _contairView.layer.masksToBounds = YES;
    _contairView.layer.cornerRadius = 3.f;
    
    UILabel *title = [UILabel new];
    [_contairView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contairView.mas_centerX);
        make.top.equalTo(_contairView.mas_top).offset(23);
    }];
    title.font = [UIFont boldSystemFontOfSize:17.f];
    title.textColor = [UIColor colorWithHexString:@"#333333"];
    title.text = @"特别提醒";
    _title = title;
    
    UILabel *contentLabel = [UILabel new];
    [_contairView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(18);
        make.left.equalTo(_contairView.mas_left).offset(18);
        make.right.equalTo(_contairView.mas_right).offset(-18);
    }];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    contentLabel.font = [UIFont systemFontOfSize:14.f];
    contentLabel.text = @"您提交的商品链接已经有人提前爆料，请确认您爆料的信息更给力，否则请不要重复提交！恶意重复爆料将会扣除双倍铜币。";
    _contentLabel = contentLabel;
    
    UIView *lineView = [UIView new];
    [_contairView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contairView);
        make.top.equalTo(contentLabel.mas_bottom).offset(25);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    
    UIView *midlineView = [UIView new];
    [_contairView addSubview:midlineView];
    [midlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contairView.mas_centerX);
        make.top.equalTo(lineView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(1, 50));
    }];
    midlineView.backgroundColor = lineView.backgroundColor;

    UIButton *continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contairView addSubview:continueBtn];
    [continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contairView.mas_left);
        make.top.equalTo(lineView.mas_bottom);
        make.right.equalTo(midlineView.mas_left);
        make.height.equalTo(midlineView.mas_height);
    }];
    [continueBtn setTag:100];
    [continueBtn setTitle:@"继续提交" forState:UIControlStateNormal];
    [continueBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    continueBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [continueBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    _continueBtn = continueBtn;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contairView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(midlineView.mas_right);
        make.top.equalTo(lineView.mas_bottom);
        make.right.equalTo(_contairView.mas_right);
        make.height.equalTo(midlineView.mas_height);
    }];
    [cancelBtn setTag:110];
    [cancelBtn setTitle:@"取消爆料" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#FD7A0F"] forState:UIControlStateNormal];
     cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cancelBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn = cancelBtn;
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cancelBtn.mas_bottom);
    }];
}

- (void)respondsToBtnEvent:(id)sender{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 100:
        {
            if ([self.delegate respondsToSelector:@selector(brokeAlertViewDidPressEnsureBtnWithAlertView:)]) {
                [self hiddenAlert];
                [self.delegate brokeAlertViewDidPressEnsureBtnWithAlertView:self];
            }
        }
            break;
        case 110:
        {
            [self hiddenAlert];
            if (_style == alertStyleBrokeCopy) {
                [self.delegate brokeAlertViewDidPressCancelBtnWithAlertView:self];
            }
        }
            break;
        default:
            break;
    }
}

- (void)showAlert{
    _showWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    _showWindow.windowLevel = UIWindowLevelAlert;
    _showWindow.backgroundColor = [UIColor clearColor];
    [_showWindow addSubview:self];
    [_showWindow makeKeyAndVisible];

}

- (void)hiddenAlert{
    [self removeFromSuperview];
    _contairView = nil;
    [_showWindow resignKeyWindow];
    _showWindow.hidden = YES;
    _showWindow = nil;
}

- (void)setStyle:(alertStyle)style{
    _style = style;
    if (_style == alertStyleReport) {
        _title.text = @"过期举报";
        _contentLabel.text = @"确定商品已过期，恶意举报将扣除双倍铜币";
        [_cancelBtn setTitle:@"确定举报" forState:UIControlStateNormal];
        _cancelBtn.tag = 100;
        [_continueBtn setTitle:@"取消" forState:UIControlStateNormal];
        _continueBtn.tag = 110;

    }else if (_style == alertStyleBrokeCopy){
        _title.text = nil;
        _contentLabel.text = @"粘贴剪切板中链接？";
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont boldSystemFontOfSize:15.f];
        _contentLabel.textColor = _title.textColor;
        [_cancelBtn setTitle:@"粘贴" forState:UIControlStateNormal];
        _cancelBtn.tag = 100;
        [_continueBtn setTitle:@"取消" forState:UIControlStateNormal];
        _continueBtn.tag = 110;

    }else if (_style == alertStyleSocialBound){
        _title.text = @"提示";
        _contentLabel.text = @"解除社交账号绑定？";
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [_cancelBtn setTitle:@"确定" forState:UIControlStateNormal];
        _cancelBtn.tag = 100;
        [_continueBtn setTitle:@"取消" forState:UIControlStateNormal];
        _continueBtn.tag = 110;
    }
}


@end
