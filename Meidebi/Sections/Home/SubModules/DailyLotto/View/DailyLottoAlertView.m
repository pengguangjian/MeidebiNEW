//
//  DailyLottoAlertView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/9/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "DailyLottoAlertView.h"

@interface DailyLottoAlertView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *alertDescrible;
@property (nonatomic, strong) UILabel *awardLabel;
@end

@implementation DailyLottoAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
        [self setupSubviews];
    }
    return self;
}

- (void) setupSubviews{
    _containerView = [UIView new];
    [self addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(_containerView.mas_width).multipliedBy(0.55);
    }];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.masksToBounds = YES;
    _containerView.layer.cornerRadius = 4.f;
    
    UILabel *titleLabel = [UILabel new];
    [_containerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView.mas_top).offset(28*kScale);
        make.centerX.equalTo(_containerView.mas_centerX);
    }];
    titleLabel.textColor = [UIColor colorWithHexString:@"#FF5A50"];
    titleLabel.font = [UIFont systemFontOfSize:22.f];
    titleLabel.text = @"天哪噜，中奖啦！";
    
    UIImageView *awardBgImageView = [UIImageView new];
    [_containerView addSubview:awardBgImageView];
    [awardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.equalTo(_containerView.mas_left).offset(20);
        make.right.equalTo(_containerView.mas_right).offset(-20);
        make.height.offset(50*kScale);
    }];
    awardBgImageView.image = [UIImage imageNamed:@"lotto_alert_title"];
    
    _awardLabel = [UILabel new];
    [_containerView addSubview:_awardLabel];
    [_awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(awardBgImageView.mas_left).offset(16);
        make.right.equalTo(awardBgImageView.mas_right).offset(-16);
        make.centerY.equalTo(awardBgImageView.mas_centerY);
    }];
    _awardLabel.textColor = [UIColor whiteColor];
    _awardLabel.font = [UIFont systemFontOfSize:20.f];
    _awardLabel.adjustsFontSizeToFitWidth = YES;
    _awardLabel.minimumScaleFactor = 0.5f;
    _awardLabel.textAlignment = NSTextAlignmentCenter;
    
    _alertDescrible = [UILabel new];
    [_containerView addSubview:_alertDescrible];
    [_alertDescrible mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_containerView.mas_bottom).offset(-20*kScale);
        make.left.right.equalTo(awardBgImageView);
    }];
    _alertDescrible.numberOfLines = 2;
    _alertDescrible.textColor = [UIColor colorWithHexString:@"#666666"];
    _alertDescrible.font = [UIFont systemFontOfSize:12.f];
    
    UIButton *closBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_containerView addSubview:closBtn];
    [closBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(_containerView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [closBtn setImage:[UIImage imageNamed:@"black_close_ico"] forState:UIControlStateNormal];
    [closBtn setImage:[UIImage imageNamed:@"black_close_ico"] forState:UIControlStateHighlighted];
    [closBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    [self dismiss];
}

- (void)showAlertWithAward:(NSString *)award type:(NSString *)type{
    _awardLabel.text = award;
    if ([@"3" isEqualToString:type]) {
        _alertDescrible.text = @"温馨提示：优惠券已发放到当前账户，请前往个人中心-优惠券查看。";
    }else if ([@"1" isEqualToString:type]) {
        _alertDescrible.text = @"温馨提示：请72小时内在个人中心-个人资料页面填写正确的收货地址，没得比客服会尽快联系您。逾期作废。";
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismiss{
    [self removeFromSuperview];
    _awardLabel.text = nil;
    _alertDescrible.text = nil;
}
@end
