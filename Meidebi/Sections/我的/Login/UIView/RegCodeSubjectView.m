//
//  RegCodeSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/12.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "RegCodeSubjectView.h"
#import "MDB_UserDefault.h"
#import <YYKit/UIImage+YYAdd.h>

#define MOBILE_MAXLENGTH 11
#define CODE_MAXLENGTH 8

@interface RegCodeSubjectView ()
<
UITextFieldDelegate
>
@property (nonatomic, strong) UITextField *mobileNumberTextField;
@property (nonatomic ,strong) UITextField *inviteTextField;
@property (nonatomic, strong) UITextField *verifyCodeTextField;
@property (nonatomic, strong) UIButton *acquireCodeBtn;
@property (nonatomic, strong) UIButton *protocolBtn;
@property (nonatomic, strong) UIButton *regBtn;
@property (nonatomic, assign) __block int timeout;
@property (nonatomic, strong) UILabel *mobileWarningLabel;
@property (nonatomic, strong) UILabel *codeWarningLabel;
@property (nonatomic, strong) UIImageView *inviteImageView;
@property (nonatomic, strong) UIView *lineViewThree;
@property (nonatomic, strong) UITextField *fieldpassword;

@property (nonatomic, strong) UIImageView *passwordImageView;
@property (nonatomic, strong) UIView *passwordlineViewThree;

@property (nonatomic, assign) int iothertime;
@property (nonatomic, strong) NSTimer *othertimer;

@end

@implementation RegCodeSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(43*kScale);
        make.size.mas_equalTo(CGSizeMake(212 *kScale, 21*kScale));
    }];
    imageV.image = [UIImage imageNamed:@"loginPicture"];
    
    UIImageView *mobileIconImageView = [UIImageView new];
    [self addSubview:mobileIconImageView];
    [mobileIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25*kScale);
        make.top.equalTo(imageV.mas_bottom).offset(59 *kScale);
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
    [_codeWarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineViewTwo.mas_left);
        make.right.equalTo(lineViewTwo.mas_right);
        make.top.equalTo(lineViewTwo.mas_bottom).offset(15*kScale + 6);
        make.bottom.equalTo(lineViewTwo.mas_bottom).offset(15*kScale + 26);
    }];
    _codeWarningLabel.font = [UIFont systemFontOfSize:12.f];
    _codeWarningLabel.textColor = [UIColor colorWithHexString:@"#F86300"];

    ////
    
    UIImageView *passwordIconImageView = [UIImageView new];
    [self addSubview:passwordIconImageView];
    [passwordIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mobileIconImageView.mas_left);
        make.top.equalTo(lineViewTwo.mas_bottom).offset(35 *kScale);
        make.size.mas_equalTo(CGSizeMake(17, 18));
    }];
    passwordIconImageView.image = [UIImage imageNamed:@"user_login_password"];
    _passwordImageView = passwordIconImageView;
    
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
    _fieldpassword.placeholder = @"请输入6位以上密码";
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
    _passwordlineViewThree = lineViewThree;
    
    ////
    
    
    UIImageView *inviteImageView = [UIImageView new];
    [self addSubview:inviteImageView];
    [inviteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25*kScale);
        make.top.equalTo(lineViewThree.mas_bottom).offset(40 *kScale);
        make.size.mas_equalTo(CGSizeMake(13, 18));
    }];
    inviteImageView.image = [UIImage imageNamed:@"invite_code"];
    _inviteImageView = inviteImageView;
    
    _inviteTextField = [UITextField new];
    [self addSubview:_inviteTextField];
    [_inviteTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inviteImageView.mas_right).offset(12);
        make.centerY.equalTo(inviteImageView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-21);
        make.height.offset(30 *kScale);
    }];
    _inviteTextField.font = [UIFont systemFontOfSize:14.f];
    _inviteTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _inviteTextField.keyboardType = UIKeyboardTypeNumberPad;
    _inviteTextField.placeholder = @"请输入邀请码 （选填）";
    _inviteTextField.delegate = self;
    
    UIView *lineViewfhore = [UIView new];
    [self addSubview:lineViewfhore];
    [lineViewfhore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inviteImageView.mas_bottom).offset(15*kScale);
        make.left.equalTo(inviteImageView.mas_left);
        make.right.equalTo(_inviteTextField.mas_right);
        make.height.offset(1);
    }];
    lineViewfhore.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    _lineViewThree = lineViewfhore;
    
    
    NSString *headerStr = @"同意";
    NSString *protocolStr = @"《没得比用户注册协议》";
    _protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_protocolBtn];
    [_protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeIconImageView.mas_left);
        make.width.offset(165);
        make.top.equalTo(lineViewfhore.mas_bottom).offset(30*kScale);
        make.height.offset(25*kScale);
    }];
    
    _protocolBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _protocolBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_protocolBtn setTitleColor:[UIColor grayColor]
                       forState:UIControlStateNormal];
    [_protocolBtn setTitle:[headerStr stringByAppendingString:protocolStr] forState:UIControlStateNormal];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[headerStr stringByAppendingString:protocolStr]];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithHexString:@"#999999"]
                             range:NSMakeRange(0, headerStr.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithHexString:@"#5CC0FA"]
                             range:NSMakeRange(headerStr.length, protocolStr.length)];
    [_protocolBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    _protocolBtn.tag = 102;
    [_protocolBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    _regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_regBtn];
    [_regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(_protocolBtn.mas_bottom).offset(35 *kScale);
        make.height.offset(50*kScale);
    }];
    [_regBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#FD7A0E"]] forState:UIControlStateNormal];
    [_regBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#ff8721"]] forState:UIControlStateHighlighted];
    _regBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_regBtn setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
    [_regBtn setTitle:@"注册" forState:UIControlStateNormal];
    _regBtn.layer.masksToBounds  =YES;
    _regBtn.layer.cornerRadius = 4.f;
    _regBtn.tag = 101;
    [_regBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];

   
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)responsToButtonEvents:(id)sender{
    [self endEditing:YES];
    UIButton *button = (id)sender;
    switch (button.tag) {
        case 100:
        {
            if (![MDB_UserDefault checkTelNumber:_mobileNumberTextField.text]) {
                [self bindMobileWarnData:@"请输入正确的手机号"];
                break;
            }
            _mobileWarningLabel.text = @"";
            if ([_delegate respondsToSelector:@selector(regCodeView:didPressAcquireCodeBtnWithMobile:)]) {
//                [self timing];
                [_delegate regCodeView:self didPressAcquireCodeBtnWithMobile:_mobileNumberTextField.text];
            }
        }
            break;
        case 101:
        {
            
            if (_mobileNumberTextField.text.length<11 || _verifyCodeTextField.text.length<6) {
                break;
            }
            if ([_delegate respondsToSelector:@selector(regCodeView:didPressRegBtnWithMobile:andCode:withInvite:andpassword:)]) {
                [_delegate regCodeView:self didPressRegBtnWithMobile:_mobileNumberTextField.text andCode:_verifyCodeTextField.text withInvite: _inviteTextField.text andpassword:_fieldpassword.text];
            }

        }
            break;
        case 102:
        {
            if ([_delegate respondsToSelector:@selector(regCodeViewDidPressUserProtocolBtn)]) {
                [_delegate regCodeViewDidPressUserProtocolBtn];
            }
        }
            break;
        case 103:
        {
            if ([_delegate respondsToSelector:@selector(regCodeViewDidPressRetrieveMailBtn)]) {
                [_delegate regCodeViewDidPressRetrieveMailBtn];
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

- (void)updateSubViews{
    if(_ischangepassword)return;
    
    UIButton *retrieveMailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:retrieveMailBtn];
    [retrieveMailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_regBtn.mas_right);
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(_regBtn.mas_bottom).offset(10);
        make.height.offset(30);
    }];
    retrieveMailBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [retrieveMailBtn setTitleColor:[UIColor colorWithHexString:@"#69BAF1"]
                            forState:UIControlStateNormal];
    [retrieveMailBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [retrieveMailBtn setTitle:@"使用邮箱找回密码" forState:UIControlStateNormal];
     retrieveMailBtn.tag = 103;
    [retrieveMailBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)bindMobileWarnData:(NSString *)warnContent{
    _mobileWarningLabel.text = warnContent;
    _timeout = 0;
    int itemp = [[self getNumberFromStr:warnContent] intValue];
    if(itemp >0 && itemp<200)
    {///进行倒计时
        [self timing];
        if(_othertimer!=nil)
        {
            
            [_othertimer invalidate];
            _othertimer = nil;
        }
        _iothertime = itemp;
        _othertimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(otherTishiAction) userInfo:nil repeats:YES];
    }
    
}

-(void)otherTishiAction
{
    NSString *strtemp =_mobileWarningLabel.text;
    
    if(_iothertime<=1)
    {
        [_othertimer invalidate];
        _othertimer = nil;
        _mobileWarningLabel.text = @"";
    }
    else
    {
        strtemp = [strtemp stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%d",_iothertime] withString:[NSString stringWithFormat:@"%d",_iothertime-1]];
        _mobileWarningLabel.text = strtemp;
        _iothertime-=1;
    }
    
}

- (NSString *)getNumberFromStr:(NSString *)str
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return[[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

- (void)bindCodeWarnData:(NSString *)warnContent{
    _codeWarningLabel.text = warnContent;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    // limit maxlength
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    if (textField == _verifyCodeTextField) {
        if (textField.text.length<6) {
            _codeWarningLabel.text = @"";
        }
        return newLength <= CODE_MAXLENGTH || returnKey;
    }else if (textField == _mobileNumberTextField){
        if (textField.text.length<MOBILE_MAXLENGTH) {
            _mobileWarningLabel.text = @"";
        }
        return newLength <= MOBILE_MAXLENGTH || returnKey;
    }
    else if (textField == _fieldpassword)
    {
        return [self checkPassWord:string];
        
    }
    else{
        return YES;
    }
}

-(BOOL)checkPassWord:(NSString *)inputString
{
    //6-20位数字和字母组成
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    
//    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
//    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:inputString];
}

#pragma mark - setters and getters
- (void)setRegType:(RegCodeType)regType{
    if (regType == RegCodeTypeRetrieve) {
        _mobileNumberTextField.placeholder = @"请输入您的手机号";
        [_regBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _protocolBtn.hidden = YES;
        _lineViewThree.hidden = YES;
        _inviteTextField.hidden = YES;
        _inviteImageView.hidden = YES;
        
        _passwordlineViewThree.hidden = YES;
        _passwordImageView.hidden = YES;
        _fieldpassword.hidden = YES;
        
//        [_codeWarningLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.offset(20);
//        }];
//        [_codeWarningLabel setText:@"12314"];
        [_regBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_codeWarningLabel.mas_bottom).offset(5);
        }];
        
        
        [self updateSubViews];
        
        
        
        
    }
    if (regType == RegCodeTypeBinding) {
        _mobileNumberTextField.placeholder = @"请输入您的手机号";
        _protocolBtn.hidden = YES;
        _regBtn.hidden = YES;
        _lineViewThree.hidden = YES;
        _inviteTextField.hidden = YES;
        _inviteImageView.hidden = YES;
    }
}

- (NSString *)phoneNumber{
    return _mobileNumberTextField.text;
}

- (NSString *)codeNumber{
    return _verifyCodeTextField.text;
}

-(void)dealloc
{
    [_othertimer invalidate];
    _othertimer = nil;
}

@end
