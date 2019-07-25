//
//  BindingUserInfoSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/13.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "BindingUserInfoSubjectView.h"
#import <YYKit/UIImage+YYAdd.h>
#import "MDB_UserDefault.h"
@interface NJBindingScrollView : UIScrollView

@end

@implementation NJBindingScrollView

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

@interface BindingUserInfoSubjectView ()<UITextFieldDelegate>
@property (nonatomic ,strong) UITextField *mobileNumberTextField;
@property (nonatomic ,strong) UILabel *mobileWarningLabel;
@property (nonatomic ,strong) UIButton *acquireCodeBtn;
@property (nonatomic ,strong) UITextField *verifyCodeTextField;
@property (nonatomic, assign) __block int timeout;
@property (nonatomic, strong) UILabel *codeWarningLabel;
@property (nonatomic, strong) UITextField *fieldpassword;

@end

@implementation BindingUserInfoSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    NJBindingScrollView *mainScrollView = [NJBindingScrollView new];
    [self addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    mainScrollView.showsVerticalScrollIndicator = NO;
    
    UIView *contairView = [UIView new];
    [mainScrollView addSubview:contairView];
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.equalTo(mainScrollView);
    }];
    
    UIView *picBackgroundV = [UIView new];
    [contairView addSubview:picBackgroundV];
    [picBackgroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(contairView);
        make.height.offset(163 *kScale);
    }];
    picBackgroundV.backgroundColor = [UIColor colorWithHexString:@"#FFF7F2"];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [picBackgroundV addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(picBackgroundV);
        make.size.mas_equalTo(CGSizeMake(280 *kScale, 125 *kScale));
    }];
    imageV.image = [UIImage imageNamed:@"bindingImage"];

    
//    UIView *bulletinContairView = [UIView new];
//    [contairView addSubview:bulletinContairView];
//    [bulletinContairView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(contairView);
//    }];
//    bulletinContairView.backgroundColor = [UIColor colorWithHexString:@"#F9F6E5"];
//
//    UILabel *bulletinLabel = [UILabel new];
//    [bulletinContairView addSubview:bulletinLabel];
//    [bulletinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bulletinContairView.mas_top).offset(15);
//        make.left.equalTo(bulletinContairView.mas_left).offset(15);
//        make.right.equalTo(bulletinContairView.mas_right).offset(-15);
//    }];
//    bulletinLabel.numberOfLines = 0;
//    [bulletinContairView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(bulletinLabel.mas_bottom).offset(15);
//    }];
//    
//    NSString *mindStr = @"后台实名、前台自愿";
//    NSString *headerStr = @"根据国家网信办发布《移动互联网应用程序信息服务管理规定》第七条：按照“";
//    NSString *lateStr = @"”的原则，对注册用户进行基于移动电话号码等真实身份信息认证。旨在加强对移动互联网应用程序（ APP ）信息服务的规范管理。\n\n\n请比友放心，我们一定严格保护用户信息，绝不外泄。";
//    NSString *totalStr = [NSString stringWithFormat:@"%@%@%@",headerStr,mindStr,lateStr];
//    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
//    
//    [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, totalStr.length)];
//    
//    [attributedStr addAttribute:NSForegroundColorAttributeName
//                                value:[UIColor colorWithHexString:@"#716246"]
//                                range:NSMakeRange(0, headerStr.length)];
//    [attributedStr addAttribute:NSForegroundColorAttributeName
//                          value:[UIColor colorWithHexString:@"#ED6C00"]
//                          range:NSMakeRange(headerStr.length, mindStr.length)];
//    [attributedStr addAttribute:NSForegroundColorAttributeName
//                          value:[UIColor colorWithHexString:@"#716246"]
//                          range:NSMakeRange(mindStr.length+headerStr.length, lateStr.length)];
//    
//    bulletinLabel.attributedText = attributedStr;

//    _codeSubview = [RegCodeSubjectView new];
//    [contairView addSubview:_codeSubview];
//    [_codeSubview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(contairView);
//        make.top.equalTo(picBackgroundV.mas_bottom);
//        make.height.offset(160);
//    }];
//    _codeSubview.regType = RegCodeTypeBinding;
//    _codeSubview.delegate = self;
    
    UIImageView *mobileIconImageView = [UIImageView new];
    [self addSubview:mobileIconImageView];
    [mobileIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25*kScale);
        make.top.equalTo(picBackgroundV.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(13, 18));
    }];
    mobileIconImageView.image = [UIImage imageNamed:@"reg_mobile"];
    
    
    _mobileNumberTextField = [UITextField new];
    [self addSubview:_mobileNumberTextField];
    [_mobileNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mobileIconImageView.mas_right).offset(12);
        make.centerY.equalTo(mobileIconImageView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-21);
        make.height.offset(30 *kScale);
    }];
    _mobileNumberTextField.font = [UIFont systemFontOfSize:14.f];
    _mobileNumberTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _mobileNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _mobileNumberTextField.placeholder = @"请输入手机号";
    _mobileNumberTextField.delegate = self;
    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mobileNumberTextField.mas_bottom).offset(15*kScale);
        make.left.equalTo(mobileIconImageView.mas_left);
        make.right.equalTo(_mobileNumberTextField.mas_right);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    
    _mobileWarningLabel = [UILabel new];
    [self addSubview:_mobileWarningLabel];
    [_mobileWarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_left);
        make.right.equalTo(lineView.mas_right);
        make.top.equalTo(lineView.mas_bottom).offset(5);
    }];
    _mobileWarningLabel.font = [UIFont systemFontOfSize:12.f];
    _mobileWarningLabel.textColor = [UIColor colorWithHexString:@"#F86300"];
    
    UIImageView *codeIconImageView = [UIImageView new];
    [self addSubview:codeIconImageView];
    [codeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mobileIconImageView.mas_left);
        make.top.equalTo(_mobileWarningLabel.mas_bottom).offset(35 *kScale);
        make.size.mas_equalTo(CGSizeMake(17, 18));
    }];
    codeIconImageView.image = [UIImage imageNamed:@"verifyCode"];
    
    _acquireCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_acquireCodeBtn];
    [_acquireCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView.mas_right);
        make.centerY.equalTo(codeIconImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100 *kScale, 30 *kScale));
    }];
    _acquireCodeBtn.backgroundColor = [UIColor colorWithHexString:@"#FD7A0E"];
    _acquireCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_acquireCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _acquireCodeBtn.tag = 100;
    _acquireCodeBtn.layer.cornerRadius = 4;
    _acquireCodeBtn.clipsToBounds = YES;
    [_acquireCodeBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    _verifyCodeTextField = [UITextField new];
    [self addSubview:_verifyCodeTextField];
    [_verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeIconImageView.mas_right).offset(12);
        make.centerY.equalTo(codeIconImageView.mas_centerY);
        make.right.equalTo(_acquireCodeBtn.mas_left).offset(-10);
        make.height.offset(30 *kScale);
    }];
    _verifyCodeTextField.font = [UIFont systemFontOfSize:14.f];
    _verifyCodeTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _verifyCodeTextField.placeholder = @"请输入验证码";
    _verifyCodeTextField.delegate = self;
    
    UIView *lineViewTwo = [UIView new];
    [self addSubview:lineViewTwo];
    [lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verifyCodeTextField.mas_bottom).offset(15*kScale);
        make.left.equalTo(codeIconImageView.mas_left);
        make.right.equalTo(lineView.mas_right);
        make.height.offset(1);
    }];
    lineViewTwo.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    
    _codeWarningLabel = [UILabel new];
    [self addSubview:_codeWarningLabel];
    _codeWarningLabel.font = [UIFont systemFontOfSize:12.f];
    [_codeWarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineViewTwo.mas_left);
        make.right.equalTo(lineViewTwo.mas_right);
        make.top.equalTo(lineViewTwo.mas_bottom).offset(5);
    }];
    
    _codeWarningLabel.textColor = [UIColor colorWithHexString:@"#F86300"];

    if(_isPwd==NO)
    {
        ////密码
        UIImageView *passwordIconImageView = [UIImageView new];
        [self addSubview:passwordIconImageView];
        [passwordIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mobileIconImageView.mas_left);
            make.top.equalTo(_codeWarningLabel.mas_bottom).offset(35 *kScale);
            make.size.mas_equalTo(CGSizeMake(17, 18));
        }];
        passwordIconImageView.image = [UIImage imageNamed:@"user_login_password"];
        
        _fieldpassword = [UITextField new];
        [self addSubview:_fieldpassword];
        [_fieldpassword mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passwordIconImageView.mas_right).offset(12);
            make.centerY.equalTo(passwordIconImageView.mas_centerY);
            make.right.equalTo(_mobileWarningLabel.mas_right);
            make.height.offset(30 *kScale);
        }];
        _fieldpassword.font = [UIFont systemFontOfSize:14.f];
        _fieldpassword.textColor = [UIColor colorWithHexString:@"#999999"];
        _fieldpassword.placeholder = @"请输入密码";
        _fieldpassword.delegate = self;
        [_fieldpassword setSecureTextEntry:YES];
        
        UIView *lineViewThree = [UIView new];
        [self addSubview:lineViewThree];
        [lineViewThree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fieldpassword.mas_bottom).offset(15*kScale);
            make.left.equalTo(passwordIconImageView.mas_left);
            make.right.equalTo(lineView.mas_right);
            make.height.offset(1);
        }];
        lineViewThree.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    }
    
    
    ///
    
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:protocolBtn];
    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contairView).offset(20);
        if(_isPwd==NO)
        {
            make.top.equalTo(_codeWarningLabel.mas_bottom).offset(70*kScale+10);
        }
        else
        {
            make.top.equalTo(lineViewTwo.mas_bottom).offset(10);
        }
        make.size.mas_equalTo(CGSizeMake(160, 16));
    }];
    NSString *agreeStr = @"同意";
    NSString *str = @"《没得比用户注册协议》";
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [protocolBtn setTitle:[agreeStr stringByAppendingString:str] forState:UIControlStateNormal];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[agreeStr stringByAppendingString:str]];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithHexString:@"#999999"]
                             range:NSMakeRange(0, agreeStr.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithHexString:@"#5CC0FA"]
                             range:NSMakeRange(agreeStr.length, str.length)];
    [protocolBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    protocolBtn.tag = 102;
    [protocolBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *bindingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:bindingBtn];
    [bindingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contairView.mas_right).offset(-20);
        make.left.equalTo(contairView.mas_left).offset(20);
        make.top.equalTo(protocolBtn.mas_bottom).offset(50);
        make.height.offset(45);
    }];
    [bindingBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#FD7A0E"]] forState:UIControlStateNormal];
    [bindingBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#ff8721"]] forState:UIControlStateHighlighted];
    bindingBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [bindingBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
    [bindingBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
    bindingBtn.layer.masksToBounds  =YES;
    bindingBtn.layer.cornerRadius = 4.f;
    bindingBtn.tag = 103;
    [bindingBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *notBindingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:notBindingBtn];
    [notBindingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.height.equalTo(bindingBtn);
        make.top.equalTo(bindingBtn.mas_bottom).offset(14);
    }];
    [notBindingBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#D7D7D7"]] forState:UIControlStateNormal];
    notBindingBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [notBindingBtn setTitleColor:[UIColor colorWithHexString:@"#666666"]
                     forState:UIControlStateNormal];
    [notBindingBtn setTitle:@"暂不绑定" forState:UIControlStateNormal];
    notBindingBtn.layer.masksToBounds = YES;
    notBindingBtn.layer.cornerRadius = 4.f;
    notBindingBtn.tag = 101;
    [notBindingBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(notBindingBtn.mas_bottom).offset(10);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)bindMobileWarnData:(NSString *)warnContent{
    _mobileWarningLabel.text = warnContent;
    _timeout = 0;
}

- (void)bindCodeWarnData:(NSString *)warnContent{
    _codeWarningLabel.text = warnContent;
}

- (void)responsToButtonEvents:(id)sender{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 100:
        {

            if (![MDB_UserDefault checkTelNumber:_mobileNumberTextField.text]) {
                [self bindMobileWarnData:@"请输入正确的手机号"];
                break;
            }
            _mobileWarningLabel.text = @"";
                [self timing];
                [self didPressAcquireCodeBtn];

        }
            break;
        case 101:{
            if ([_delegate respondsToSelector:@selector(bindingUserInfoViewDidPressNotSubmitBtn)]) {
                [_delegate bindingUserInfoViewDidPressNotSubmitBtn];
            }
        }
            break;
        case 102:{
            if ([_delegate respondsToSelector:@selector(bindingViewDidPressUserProtocolBtn)]) {
                [_delegate bindingViewDidPressUserProtocolBtn];
            }
        }
            break;
        case 103:{
            if (_mobileNumberTextField.text.length == 11 && _verifyCodeTextField.text.length == 6) {
                if ([self.delegate respondsToSelector:@selector(bindingUserInfoView:didPressSubmitBtnWithMobile:andCode:andpassword:)]) {
                    [self.delegate bindingUserInfoView:self didPressSubmitBtnWithMobile:_mobileNumberTextField.text andCode:_verifyCodeTextField.text andpassword:_fieldpassword.text];
                }
            }
        }
            break;
        default:
            break;
    }
}

-(void)timing
{
    _timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(_timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_acquireCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                _acquireCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = _timeout % 60;
            __block NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([strTime isEqual:@"00"]) {
                    strTime = @"60";
                }
                [_acquireCodeBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                _acquireCodeBtn.userInteractionEnabled = NO;
            });
            _timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}


- (void)didPressAcquireCodeBtn{
    if ([_delegate respondsToSelector:@selector(bindingUserInfoView:didPressAcquireCodeBtnWithMobile:)]) {
        [_delegate bindingUserInfoView:self didPressAcquireCodeBtnWithMobile:_mobileNumberTextField.text];
    }

}
@end
