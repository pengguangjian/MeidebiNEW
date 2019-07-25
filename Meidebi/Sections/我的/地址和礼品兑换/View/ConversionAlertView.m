//
//  ConversionAlertView.m
//  Meidebi
//
//  Created by mdb-admin on 2016/10/27.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ConversionAlertView.h"

@interface ConversionAlertView ()

@property (nonatomic, strong) UIView *contairView;
@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertSubTitleLabel;
@property (nonatomic, strong) UILabel *alertDescribleLabel;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, strong) UIButton *conversionBtn;
@property (nonatomic, strong) UIButton *mainScreenBtn;
@end

@implementation ConversionAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kMainScreenW, kMainScreenH);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_conversionBtn.bounds
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame         = _conversionBtn.bounds;
    maskLayer.path          = maskPath.CGPath;
    _conversionBtn.layer.mask         = maskLayer;
}

- (void)setupSubviews{
    UIButton *mainScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:mainScreenBtn];
    [mainScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    mainScreenBtn.backgroundColor = [UIColor clearColor];
    [mainScreenBtn addTarget:self
                      action:@selector(respondsToMainScreenBtnEvent:)
            forControlEvents:UIControlEventTouchUpInside];
    _mainScreenBtn = mainScreenBtn;
    
    _contairView = [UIView new];
    [self addSubview:_contairView];
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhone4 || iPhone5) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-30);
        }else{
            make.center.equalTo(self);
        }
        make.size.mas_equalTo(CGSizeMake(290, 170));
    }];
    _contairView.backgroundColor = [UIColor whiteColor];
    _contairView.layer.masksToBounds = YES;
    _contairView.layer.cornerRadius = 10;
    _contairView.clipsToBounds = YES;

    _alertTitleLabel = [UILabel new];
    [_contairView addSubview:_alertTitleLabel];
    [_alertTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contairView.mas_top).offset(25);
        make.centerX.equalTo(_contairView.mas_centerX);
        make.left.equalTo(_contairView.mas_left).offset(25);
        make.right.equalTo(_contairView.mas_right).offset(-25);
    }];
    _alertTitleLabel.numberOfLines = 2;
    _alertTitleLabel.textColor = [UIColor colorWithHexString:@"#555555"];
    _alertTitleLabel.font = [UIFont systemFontOfSize:13.f];
    _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    _alertSubTitleLabel = [UILabel new];
    [_contairView addSubview:_alertSubTitleLabel];
    [_alertSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_alertTitleLabel.mas_bottom).offset(2);
        make.centerX.equalTo(_alertTitleLabel.mas_centerX);
        make.left.right.equalTo(_alertTitleLabel);
    }];
    _alertSubTitleLabel.numberOfLines = 2;
    _alertSubTitleLabel.textColor = [UIColor redColor];
    _alertSubTitleLabel.font = [UIFont systemFontOfSize:11.f];
    _alertSubTitleLabel.textAlignment = NSTextAlignmentCenter;
    _alertSubTitleLabel.hidden = YES;
    
    _numberTextField = [UITextField new];
    [_contairView addSubview:_numberTextField];
    [_numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_alertTitleLabel.mas_bottom).offset(20);
        make.left.right.equalTo(_alertTitleLabel);
        make.height.offset(40);
    }];
    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _numberTextField.layer.masksToBounds = YES;
    _numberTextField.layer.borderWidth = 0.4;
    _numberTextField.layer.borderColor = [UIColor colorWithHexString:@"#CBCBCB"].CGColor;
    _numberTextField.font = [UIFont systemFontOfSize:12.f];
    _numberTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _numberTextField.textAlignment = NSTextAlignmentCenter;
    _numberTextField.hidden = YES;
    
    _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_addressBtn];
    [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_numberTextField);
    }];
    _addressBtn.tag = 120;
    _addressBtn.layer.masksToBounds = YES;
    _addressBtn.layer.cornerRadius = 20.f;
    _addressBtn.backgroundColor = [UIColor colorWithHexString:@"#FD7A0E"];
    _addressBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_addressBtn setTitle:@"请先确认收货地址>>" forState:UIControlStateNormal];
    _addressBtn.hidden = YES;
    [_addressBtn addTarget:self action:@selector(respondsToBtnEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *conversionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:conversionBtn];
    [conversionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_contairView);
        make.height.offset(45);
    }];
    conversionBtn.tag = 100;
    conversionBtn.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    conversionBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [conversionBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [conversionBtn setTitleColor:[UIColor colorWithHexString:@"#FD7A0E"] forState:UIControlStateNormal];
    [conversionBtn addTarget:self action:@selector(respondsToBtnEvents:) forControlEvents:UIControlEventTouchUpInside];
    _conversionBtn = conversionBtn;
    
    
    _alertDescribleLabel = [UILabel new];
    [_contairView addSubview:_alertDescribleLabel];
    [_alertDescribleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_alertTitleLabel);
        make.top.equalTo(_alertTitleLabel.mas_bottom).offset(20);
    }];
    _alertDescribleLabel.numberOfLines = 5;
    _alertDescribleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _alertDescribleLabel.font = [UIFont systemFontOfSize:12.f];
    _alertDescribleLabel.textAlignment = NSTextAlignmentCenter;
    _alertDescribleLabel.hidden = YES;
}

- (void)show{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)hidden{
    _alertDescribleLabel.text = nil;
    _alertTitleLabel.text = nil;
    _numberTextField.text = nil;
    _alertSubTitleLabel.text = nil;
    [self removeFromSuperview];
}

- (void)respondsToBtnEvents:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100) {
        if ([self.delegate respondsToSelector:@selector(conversionAlertView:handleConversionWithNumber:)]) {
            [self.delegate conversionAlertView:self handleConversionWithNumber:_numberTextField.text];
        }
        _numberTextField.text = nil;
    }else if (btn.tag == 120){
        if ([self.delegate respondsToSelector:@selector(referLogisticsAddress)]) {
            [self.delegate referLogisticsAddress];
        }
    }else if (btn.tag == 200){
        if ([self.delegate respondsToSelector:@selector(conversionAlertView:handleExchangeGiftWithNumber:)]) {
            [self.delegate conversionAlertView:self handleExchangeGiftWithNumber:_numberTextField.text];
        }
    }
    [self hidden];
}

- (void)respondsToMainScreenBtnEvent:(id)sender{
    [self hidden];
}

- (void)respondsToLabelEvents:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(referCopperRule)]) {
        [self.delegate referCopperRule];
    }
    [self hidden];
}

- (void)updateAlertLayoutsubViewWithState:(ConversionAlertState)state{
    _alertSubTitleLabel.hidden = YES;
    _addressBtn.hidden = YES;
    _numberTextField.hidden = YES;
    _alertDescribleLabel.hidden = NO;
    _mainScreenBtn.userInteractionEnabled = NO;
    _alertDescribleLabel.userInteractionEnabled = NO;
    if (state == ConversionAlertStateSuccess) {
        _alertTitleLabel.text = @"恭喜您兑换成功";
    }else if (state == ConversionAlertStateCopperFailure){
        _alertTitleLabel.text = @"对不起，您的铜币不够了";
        NSString *contentStr = @"如何赚取铜币？";
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:NSMakeRange(0, contentStr.length)];
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor colorWithHexString:@"#025096"]
                              range:NSMakeRange(0, contentStr.length)];
        [attributedStr addAttribute:NSUnderlineStyleAttributeName
                              value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                              range:NSMakeRange(0, contentStr.length)];
        _alertDescribleLabel.attributedText = attributedStr;
        _alertDescribleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLabelEvents:)];
        [_alertDescribleLabel addGestureRecognizer:tapGesture];
       
    }else if (state == ConversionAlertStateFailure){
        _alertTitleLabel.text = @"兑换失败";
    }
    [_conversionBtn setTitle:@"确定" forState:UIControlStateNormal];
    _conversionBtn.tag = 110;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}


#pragma mark - setters and getters 
- (void)setAlertType:(ConversionAlertType)alertType{
    _mainScreenBtn.userInteractionEnabled = YES;
    [_conversionBtn setTitle:@"兑换" forState:UIControlStateNormal];
    _conversionBtn.tag = 100;
    _alertType = alertType;
    _alertSubTitleLabel.hidden = YES;
    if (_alertType == ConversionAlertVirtual) {
        _addressBtn.hidden = YES;
        _numberTextField.hidden = NO;
    }else if (_alertType == ConversionAlertMaterial){
        _addressBtn.hidden = NO;
        _numberTextField.hidden = YES;
    }else if (_alertType == ConversionAlertAttendancGift){
        _alertSubTitleLabel.hidden = NO;
        _addressBtn.hidden = YES;
        _numberTextField.hidden = NO;
        _conversionBtn.tag = 200;
    }
    else if (_alertType == ConversionAlertSubTitle)
    {
        _alertSubTitleLabel.hidden = YES;
        _addressBtn.hidden = YES;
        _alertDescribleLabel.hidden = NO;
    }
   
}

- (void)setAlertState:(ConversionAlertState)alertState{
    _alertState = alertState;
    [self updateAlertLayoutsubViewWithState:alertState];
}

- (void)setWaresName:(NSString *)waresName{
    _waresName = waresName;
    _alertTitleLabel.text = waresName;
}

- (void)setPlaceholderStr:(NSString *)placeholderStr{
    _placeholderStr = placeholderStr;
    _numberTextField.placeholder = placeholderStr;
}

- (void)setSubTitleStr:(NSString *)subTitleStr{
    _subTitleStr = subTitleStr;
    _alertSubTitleLabel.text = subTitleStr;
}

- (void)setAlertDescribleStr:(NSString *)alertDescribleStr{
    _alertDescribleStr = alertDescribleStr;
    _alertDescribleLabel.text = _alertDescribleStr;
}

- (void)setFaultRemindStr:(NSString *)faultRemindStr{
    _faultRemindStr = faultRemindStr;
    _alertDescribleLabel.text = _faultRemindStr;
}

@end
