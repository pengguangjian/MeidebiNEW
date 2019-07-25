//
//  WelfareStrategyCollectionHeaderView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "WelfareStrategyCollectionHeaderView.h"
#import "ScrollLabel.h"
#import "MDB_UserDefault.h"
#import "PaddingLabel.h"
@interface WelfareStrategyCollectionHeaderView ()

@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UIView *adLabelContainerView;
@property (nonatomic, strong) ScrollLabel *paomaLabel;
@property (nonatomic, strong) PaddingLabel *receivedNumLabel;
@property (nonatomic, strong) UIControl *receivedControl;
@property (nonatomic, strong)  UIView *lineView;
@property (nonatomic, strong)  UIView *lineView1;
@end

@implementation WelfareStrategyCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = [UIColor clearColor];
    UIView *adLabelContainerView = [UIView new];
    [self addSubview:adLabelContainerView];
    [adLabelContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(8);
        make.height.offset(43);
    }];
    adLabelContainerView.backgroundColor = [UIColor whiteColor];
    _adLabelContainerView = adLabelContainerView;
    _adLabelContainerView.hidden = YES;
    
    _paomaLabel = [[ScrollLabel alloc]initWithFrame:CGRectMake(15, 16, kMainScreenW-65, 14)];
    _paomaLabel.hyk_timeInterval = 20;
    _paomaLabel.hyk_direction = Horizontal;
    _paomaLabel.backgroundColor = [UIColor clearColor];
    [adLabelContainerView addSubview:_paomaLabel];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_adLabelContainerView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_paomaLabel.mas_right);
        make.right.top.bottom.equalTo(adLabelContainerView);
    }];
    [closeBtn setImage:[UIImage imageNamed:@"welfare_home_closead"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _adImageView = [UIImageView new];
    [self addSubview:_adImageView];
    [_adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(adLabelContainerView.mas_bottom);
        make.height.equalTo(_adImageView.mas_width).multipliedBy(0.376);
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adImageViewTap:)];
    [_adImageView addGestureRecognizer:tapGesture];

    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_adImageView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.offset(8);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    
    _lineView = lineView;
    
    UIControl *receivedControl = [UIControl new];
    [self addSubview:receivedControl];
    [receivedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.offset(43);
    }];
    receivedControl.backgroundColor = [UIColor whiteColor];
    [receivedControl addTarget:self action:@selector(respondsToControlEvent:) forControlEvents:UIControlEventTouchUpInside];
    _receivedControl = receivedControl;
    
    UILabel *titleLabel = [UILabel new];
    [receivedControl addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(receivedControl.mas_left).offset(12);
        make.centerY.equalTo(receivedControl.mas_centerY);
    }];
    titleLabel.font = [UIFont systemFontOfSize:13.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    titleLabel.text = @"我领取的福利";
    
    _receivedNumLabel = [PaddingLabel new];
    [receivedControl addSubview:_receivedNumLabel];
    [_receivedNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(receivedControl.mas_right).offset(-18);
        make.centerY.equalTo(receivedControl.mas_centerY);
        
    }];
    _receivedNumLabel.font = [UIFont systemFontOfSize:13.f];
    _receivedNumLabel.textColor = [UIColor whiteColor];
    _receivedNumLabel.backgroundColor = [UIColor colorWithHexString:@"#EF0000"];
    _receivedNumLabel.textAlignment = NSTextAlignmentCenter;
    _receivedNumLabel.hidden = YES;
    
    UIView *lineView1 = [UIView new];
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(receivedControl.mas_bottom);
        make.left.right.equalTo(self);
        make.height.offset(8);
    }];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    _lineView1 = lineView1;
}

- (void)respondsToControlEvent:(UIButton *)sender{
    
    
    _receivedNumLabel.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(didClickMyWelfareBtn)]) {
        [self.delegate didClickMyWelfareBtn];
    }
}
- (void)respondsToBtnEvent:(UIButton *)sender{
    [_adLabelContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
    }];
    _paomaLabel.hidden = YES;
    [_paomaLabel hyk_pause];
    if ([self.delegate respondsToSelector:@selector(didClickCloseAdBtn)]) {
        [self.delegate didClickCloseAdBtn];
    }
}

- (void)adImageViewTap:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(didClickMyWelfareAd)]) {
        [self.delegate didClickMyWelfareAd];
    }
}

- (void)bindDataWithModel:(NSDictionary *)dict{
    if (!dict)
    {
        [_adLabelContainerView setHidden:YES];

        [_adImageView setHidden:YES];

        [_adLabelContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(1);
        }];
        [_adImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_adImageView.mas_width).multipliedBy(0.01);
        }];

        return;
    }
    _adImageView.userInteractionEnabled = YES;
    _adLabelContainerView.hidden = NO;
    [_paomaLabel hyk_scrollTitle:[NSString nullToString:dict[@"notice"]]
                   andTitleColor:[UIColor colorWithHexString:@"#999999"]
                    andTitleSize:12.f];
    // 防止后台在没数据时给的数据类型不正常
    if ([dict[@"advertise"] isKindOfClass:[NSDictionary class]]) {
        [[MDB_UserDefault defaultInstance] setViewWithImage:_adImageView url:[NSString nullToString:dict[@"advertise"][@"imgurl"]]];
    }
}

#pragma mark - setters and getters
- (void)setReceivedNumStr:(NSString *)receivedNumStr{
    _receivedNumStr = receivedNumStr;
    if (![receivedNumStr isEqualToString:@""] && receivedNumStr.intValue>0) {
        _receivedNumLabel.text = receivedNumStr;
        _receivedNumLabel.hidden = NO;
    }
}

@end
