//
//  BrokeSuccessSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "BrokeSuccessSubjectView.h"

@interface BrokeSuccessSubjectView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UILabel *subPromptLabel;
@property (nonatomic, strong) UILabel *stepLabel;
@end

@implementation BrokeSuccessSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview{
    
    _iconImageView = [UIImageView new];
    [self addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-50);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    _promptLabel = [UILabel new];
    [self addSubview:_promptLabel];
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_iconImageView.mas_centerX);
        make.top.equalTo(_iconImageView.mas_bottom).offset(40);
    }];
    _promptLabel.font = [UIFont systemFontOfSize:28];
    _promptLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    
    _subPromptLabel = [UILabel new];
    [self addSubview:_subPromptLabel];
    [_subPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_promptLabel.mas_centerX);
        make.top.equalTo(_promptLabel.mas_bottom).offset(10);
    }];
    _subPromptLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _subPromptLabel.font = [UIFont systemFontOfSize:14.f];
    
    _stepLabel = [UILabel new];
    [self addSubview:_stepLabel];
    [_stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_subPromptLabel.mas_centerX);
        make.top.equalTo(_subPromptLabel.mas_bottom).offset(10);
    }];
    _stepLabel.textColor = [UIColor colorWithHexString:@"#7ca41e"];
    _stepLabel.font = [UIFont systemFontOfSize:12.f];
    _stepLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToBtnEvent:)];
    [_stepLabel addGestureRecognizer:tapGesture];
    

}

- (void)setBrokeType:(BrokeSuccessType)brokeType{
    _brokeType = brokeType;
    if (_brokeType == BrokeSuccessTypeFailed) {
        _iconImageView.image = [UIImage imageNamed:@"reg_failed"];
        _promptLabel.text = @"爆料失败";
        _subPromptLabel.text = @"很抱歉此商城无法爆料，请换个商城试试";
        _stepLabel.hidden = YES;
    }else{
        _iconImageView.image = [UIImage imageNamed:@"reg_successs"];
        _stepLabel.hidden = NO;
        _promptLabel.text = @"爆料成功";
        _subPromptLabel.text = @"感谢您为没得比信息库做出重大贡献";
        _stepLabel.text = @"查看我的爆料：没得比  >  我的  >  我的爆料";
    }
}

- (void)respondsToBtnEvent:(id)sender{
    if ([self.delegate respondsToSelector:@selector(brokeSuccessSubjectViewdidPressJumpBtn)]) {
        [self.delegate brokeSuccessSubjectViewdidPressJumpBtn];
    }
}

@end
