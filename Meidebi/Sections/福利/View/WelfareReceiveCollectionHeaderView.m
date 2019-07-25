//
//  WelfareReceiveCollectionHeaderView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "WelfareReceiveCollectionHeaderView.h"

@interface WelfareReceiveCollectionHeaderView ()

@property (nonatomic, strong) UILabel*currentCoinAndJifenLabel;

@end

@implementation WelfareReceiveCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *topBgImageView = [UIImageView new];
    [self addSubview:topBgImageView];
    [topBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.offset(120);
    }];
    topBgImageView.image = [UIImage imageNamed:@"welfare_recive_bg"];
    UIImageView *topJianTouBgImageView = [UIImageView new];
    [self addSubview:topJianTouBgImageView];
    [topJianTouBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBgImageView.mas_bottom);
        make.centerX.equalTo(topBgImageView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(18, 7));
    }];
    topJianTouBgImageView.image = [UIImage imageNamed:@"welfare_recive_bg_jiantou"];
    
    
    _currentCoinAndJifenLabel = [UILabel new];
    [topBgImageView addSubview:_currentCoinAndJifenLabel];
    [_currentCoinAndJifenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topBgImageView.mas_centerY);
        make.left.equalTo(topBgImageView.mas_left).offset(10);
        make.right.equalTo(topBgImageView.mas_right).offset(-10);
    }];
    _currentCoinAndJifenLabel.textAlignment = NSTextAlignmentCenter;
    _currentCoinAndJifenLabel.font = [UIFont boldSystemFontOfSize:18.f];
    _currentCoinAndJifenLabel.textColor = [UIColor whiteColor];
    _currentCoinAndJifenLabel.text = @"我累计获得铜币0，积分0";
    
    
    UIButton *conversionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:conversionBtn];
    [conversionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topJianTouBgImageView.mas_bottom).offset(22);
        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.mas_left).offset(87);
        make.right.equalTo(self.mas_right).offset(-87);
        make.height.offset(46);
    }];
    conversionBtn.layer.masksToBounds = YES;
    conversionBtn.layer.cornerRadius = 46/2.f;
    conversionBtn.layer.borderWidth = 1.f;
    conversionBtn.layer.borderColor = [UIColor colorWithHexString:@"#BBB09C"].CGColor;
    conversionBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [conversionBtn setTitleColor:[UIColor colorWithHexString:@"#B08E65"] forState:UIControlStateNormal
     ];
    [conversionBtn setTitle:@"去兑换礼品" forState:UIControlStateNormal];
    [conversionBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(conversionBtn.mas_bottom).offset(38);
        make.left.right.equalTo(self);
        make.height.offset(16);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(welfareReceiveHeaderViewDidClickConversionBtn)]) {
        [self.delegate welfareReceiveHeaderViewDidClickConversionBtn];
    }
}

- (void)bindDataWithModel:(NSDictionary *)dict{
    if (!dict) return;
    _currentCoinAndJifenLabel.text = [NSString stringWithFormat:@"我累计获得铜币%@，积分%@",dict[kAllCopperKey],dict[kAllIntegralKey]];
}
@end
