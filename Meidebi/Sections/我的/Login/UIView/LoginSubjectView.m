//
//  LoginSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/12.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "LoginSubjectView.h"
#import "MDB_UserDefault.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
@interface LoginSubjectView ()<UITextFieldDelegate>
{
    UIView *viewtop;
    
}
@property (nonatomic, strong) UITextField *userInfoTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) UIButton *btTopnow;
///账号密码登录
@property (nonatomic, strong) UIView *viewPassLG;

///验证码
@property (nonatomic, strong) UIView *viewNumberLG;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *btCode;
@property (nonatomic, assign) int timeout;

@end

@implementation LoginSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
//    UIImageView *imageView = [[UIImageView alloc] init];
//    [self addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.top.equalTo(self.mas_top).offset(43 *kScale);
//        make.size.mas_equalTo(CGSizeMake(213 *kScale, 21 *kScale));
//    }];
//    imageView.image = [UIImage imageNamed:@"loginPicture"];
    
    viewtop = [self drawviewTop:CGRectMake(0, 3 *kScale, BOUNDS_WIDTH, 80 *kScale)];
    [self addSubview:viewtop];
    
    /////账号密码
    _viewPassLG = [[UIView alloc] init];
    [self addSubview:_viewPassLG];
    [_viewPassLG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(viewtop.mas_bottom);
    }];
    
    [self drawAccountPass];
    ///
    
    ///验证码登录
    _viewNumberLG = [[UIView alloc] init];
    [self addSubview:_viewNumberLG];
    [_viewNumberLG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_viewPassLG.mas_right);
        make.left.mas_equalTo(_viewPassLG.mas_left);
        make.top.mas_equalTo(viewtop.mas_bottom);
        
    }];
    [_viewNumberLG mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_viewPassLG.mas_bottom);
    }];
    [_viewNumberLG setHidden:YES];
    [self drawCodelg];
    
    
    
    [self drawbottom];
    
}


////底部
-(void)drawbottom
{
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(_viewPassLG.mas_bottom).offset(40 *kScale);
        make.height.offset(50 *kScale);
    }];
    [loginBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#FD7A0E"]] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#ff8721"]] forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [loginBtn setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds  =YES;
    loginBtn.layer.cornerRadius = 4.f;
    loginBtn.tag = 101;
    [loginBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    // 第三方登录
    UIButton *loginQQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:loginQQBtn];
    [loginQQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-110*kScale);
        make.centerX.equalTo(self.mas_centerX).offset(-28.5);
        make.size.mas_equalTo(CGSizeMake(22, 25));
    }];
    [loginQQBtn setImage:[UIImage imageNamed:@"QQ_login"] forState:UIControlStateNormal];
    loginQQBtn.tag = 102;
    [loginQQBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loginWBBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:loginWBBtn];
    [loginWBBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginQQBtn.mas_bottom);
        make.right.equalTo(loginQQBtn.mas_left).offset(-35);
        make.size.mas_equalTo(CGSizeMake(29, 23));
    }];
    [loginWBBtn setImage:[UIImage imageNamed:@"sina"] forState:UIControlStateNormal];
    loginWBBtn.tag = 103;
    [loginWBBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loginWxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:loginWxBtn];
    [loginWxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(loginQQBtn.mas_centerY);
        make.left.equalTo(loginQQBtn.mas_right).offset(35);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    [loginWxBtn setImage:[UIImage imageNamed:@"wx_login"] forState:UIControlStateNormal];
    loginWxBtn.tag = 104;
    [loginWxBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *loginTaoBaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:loginTaoBaoBtn];
    [loginTaoBaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(loginWxBtn.mas_centerY);
        make.left.equalTo(loginWxBtn.mas_right).offset(35);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    [loginTaoBaoBtn setImage:[UIImage imageNamed:@"taobaoLogin"] forState:UIControlStateNormal];
    loginTaoBaoBtn.tag = 105;
    [loginTaoBaoBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 提示
    UILabel *warningLabel = [UILabel new];
    [self addSubview:warningLabel];
    [warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(loginQQBtn.mas_top).offset(-22 *kScale);
    }];
    warningLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    warningLabel.text = @"第三方账号登录";
    warningLabel.font = [UIFont systemFontOfSize:12];
    
    UIView *warningLeftLine = [UIView new];
    [self addSubview:warningLeftLine];
    [warningLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(65);
        make.right.equalTo(warningLabel.mas_left).offset(-16);
        make.height.offset(0.7);
        make.centerY.equalTo(warningLabel.mas_centerY);
    }];
    warningLeftLine.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    
    UIView *warningRightLine = [UIView new];
    [self addSubview:warningRightLine];
    [warningRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-65);
        make.left.equalTo(warningLabel.mas_right).offset(16);
        make.height.offset(0.7);
        make.centerY.equalTo(warningLabel.mas_centerY);
    }];
    warningRightLine.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    
//    if ([TencentOAuth iphoneQQInstalled]) {
//        loginQQBtn.hidden = NO;
//    }else{
//        loginQQBtn.hidden = YES;
//    }
}

///账号密码登录
-(void)drawAccountPass
{
    UIImageView *userIconImageView = [UIImageView new];
    [_viewPassLG addSubview:userIconImageView];
    [userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(21);
        make.top.equalTo(viewtop.mas_bottom).offset(40 *kScale);
        make.size.mas_equalTo(CGSizeMake(16, 18));
    }];
    userIconImageView.image = [UIImage imageNamed:@"phone"];
    
    
    _userInfoTextField = [UITextField new];
    [_viewPassLG addSubview:_userInfoTextField];
    [_userInfoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIconImageView.mas_right).offset(12);
        make.centerY.equalTo(userIconImageView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-21);
        make.height.offset(30);
    }];
    _userInfoTextField.font = [UIFont systemFontOfSize:14.f];
    _userInfoTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _userInfoTextField.placeholder = @"请输入手机号/用户名/邮箱";
    
//    [_userInfoTextField setText:@"15870440552"];
    
    UIView *lineView = [UIView new];
    [_viewPassLG addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userInfoTextField.mas_bottom).offset(10);
        make.left.equalTo(userIconImageView.mas_left);
        make.right.equalTo(_userInfoTextField.mas_right);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    
    
    UIImageView *passwordIconImageView = [UIImageView new];
    [_viewPassLG addSubview:passwordIconImageView];
    [passwordIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIconImageView.mas_left);
        make.top.equalTo(lineView.mas_bottom).offset(28);
        make.size.mas_equalTo(CGSizeMake(16, 18));
    }];
    passwordIconImageView.image = [UIImage imageNamed:@"user_login_password"];
    
    _passwordTextField = [UITextField new];
    [_viewPassLG addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordIconImageView.mas_right).offset(12);
        make.centerY.equalTo(passwordIconImageView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-21);
        make.height.offset(30);
    }];
    _passwordTextField.font = [UIFont systemFontOfSize:14.f];
    _passwordTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _passwordTextField.placeholder = @"请输入6位以上登录密码";
    _passwordTextField.secureTextEntry = YES;
//    [_passwordTextField setText:@"123456"];
    
    UIView *lineViewTwo = [UIView new];
    [_viewPassLG addSubview:lineViewTwo];
    [lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(10);
        make.left.equalTo(userIconImageView.mas_left);
        make.right.equalTo(_userInfoTextField.mas_right);
        make.height.offset(1);
    }];
    lineViewTwo.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    
    UIButton *forgetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_viewPassLG addSubview:forgetPasswordBtn];
    [forgetPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineViewTwo.mas_right);
        make.top.equalTo(lineViewTwo.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    forgetPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [forgetPasswordBtn setTitleColor:[UIColor colorWithHexString:@"#69BAF1"]
                            forState:UIControlStateNormal];
    [forgetPasswordBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [forgetPasswordBtn setTitle:@"忘记密码 ?" forState:UIControlStateNormal];
    forgetPasswordBtn.tag = 100;
    [forgetPasswordBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    [_viewPassLG mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(forgetPasswordBtn.mas_bottom);
    }];
    ////
}


-(void)drawCodelg
{
    UIImageView *userIconImageView = [UIImageView new];
    [_viewNumberLG addSubview:userIconImageView];
    [userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(21);
        make.top.equalTo(viewtop.mas_bottom).offset(40 *kScale);
        make.size.mas_equalTo(CGSizeMake(16, 18));
    }];
    userIconImageView.image = [UIImage imageNamed:@"phone"];
    
    
    _phoneTextField = [UITextField new];
    [_viewNumberLG addSubview:_phoneTextField];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIconImageView.mas_right).offset(12);
        make.centerY.equalTo(userIconImageView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-21);
        make.height.offset(30);
    }];
    _phoneTextField.font = [UIFont systemFontOfSize:14.f];
    _phoneTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _phoneTextField.placeholder = @"请输入手机号";
    [_phoneTextField setDelegate:self];
    
    
    UIView *lineView = [UIView new];
    [_viewNumberLG addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneTextField.mas_bottom).offset(10);
        make.left.equalTo(userIconImageView.mas_left);
        make.right.equalTo(_phoneTextField.mas_right);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    
    
    UIImageView *passwordIconImageView = [UIImageView new];
    [_viewNumberLG addSubview:passwordIconImageView];
    [passwordIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIconImageView.mas_left);
        make.top.equalTo(lineView.mas_bottom).offset(28);
        make.size.mas_equalTo(CGSizeMake(16, 18));
    }];
    passwordIconImageView.image = [UIImage imageNamed:@"verifyCode"];
    
    _codeTextField = [UITextField new];
    [_viewNumberLG addSubview:_codeTextField];
    [_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordIconImageView.mas_right).offset(12);
        make.centerY.equalTo(passwordIconImageView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-21);
        make.height.offset(30);
    }];
    _codeTextField.font = [UIFont systemFontOfSize:14.f];
    _codeTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _codeTextField.placeholder = @"请输入验证码";
//    _codeTextField.secureTextEntry = YES;
    [_codeTextField setDelegate:self];
    
    UIView *lineViewTwo = [UIView new];
    [_viewNumberLG addSubview:lineViewTwo];
    [lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeTextField.mas_bottom).offset(10);
        make.left.equalTo(userIconImageView.mas_left);
        make.right.equalTo(_phoneTextField.mas_right);
        make.height.offset(1);
    }];
    lineViewTwo.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    
    
    _btCode = [[UIButton alloc] init];
    [_viewNumberLG addSubview:_btCode];
    [_btCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30*kScale);
        make.width.offset(93*kScale);
        make.centerY.mas_equalTo(_codeTextField.mas_centerY);
        make.right.mas_equalTo(lineView.mas_right);
    }];
    [_btCode.layer setMasksToBounds:YES];
    [_btCode.layer setCornerRadius:4];
    [_btCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_btCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btCode.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_btCode setBackgroundColor:RGB(255,146,93)];
    [_btCode addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}


///头部
-(UIView *)drawviewTop:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *arrtitle = [NSArray arrayWithObjects:@"账号密码登录",@"手机号快捷登录", nil];
    for(int i = 0; i < arrtitle.count ; i++)
    {
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(view.width/arrtitle.count*i, 0, view.width/arrtitle.count, view.height)];
        [bt setTitle:arrtitle[i] forState:UIControlStateNormal];
        [bt setTitleColor:RGB(102,102,102) forState:UIControlStateNormal];
        [bt.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [bt setTag:i];
        [view addSubview:bt];
        UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(bt.width*0.1, bt.height-1.5, bt.width*0.8, 1.5)];
        [viewline setBackgroundColor:[UIColor whiteColor]];
        [viewline setTag:11];
        [bt addSubview:viewline];
        [bt addTarget:self action:@selector(topBtAction:) forControlEvents:UIControlEventTouchUpInside];
        if(i==0)
        {
            [bt setTitleColor:RGB(253,122,14) forState:UIControlStateNormal];
            [viewline setBackgroundColor:RGB(253,122,14)];
            _btTopnow = bt;
        }
    }
    
    
    return view;
}


#pragma mark - 顶部按钮选择
-(void)topBtAction:(UIButton *)sender
{
    [_btTopnow setTitleColor:RGB(102,102,102) forState:UIControlStateNormal];
    UIView *viewline = [_btTopnow viewWithTag:11];
    [viewline setBackgroundColor:[UIColor whiteColor]];
    _btTopnow  = sender;
    [_btTopnow setTitleColor:RGB(253,122,14) forState:UIControlStateNormal];
    UIView *viewline1 = [_btTopnow viewWithTag:11];
    [viewline1 setBackgroundColor:RGB(253,122,14)];
    
    ///页面切换
    if(sender.tag ==0)
    {///账号密码登录
        [_viewPassLG setHidden:NO];
        
        [_viewNumberLG setHidden:YES];
    }
    else
    {///手机号快捷登录
        [_viewPassLG setHidden:YES];
        
        [_viewNumberLG setHidden:NO];
    }
    
}

#pragma mark - 获取验证码
-(void)codeAction
{
    if([_phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length != 11)
    {
        
        [MDB_UserDefault showNotifyHUDwithtext:@"请输入正确的手机号" inView:self];
        return;
    }
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
//    [self timing];
    
    
    [self.delegate loginCodeAction:self phone:_phoneTextField.text];
    
    
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
                [_btCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                _btCode.userInteractionEnabled = YES;
            });
        }else{
            int seconds = _timeout % 60;
            __block NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([strTime isEqual:@"00"]) {
                    strTime = @"60";
                }
                [_btCode setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                _btCode.userInteractionEnabled = NO;
            });
            _timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)responsToButtonEvents:(id)sender{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 100:
        {
            if ([_delegate respondsToSelector:@selector(loginSubjectViewDidPressForgetBtn)]) {
                [_delegate loginSubjectViewDidPressForgetBtn];
            }
        }
            break;
        case 101:
        {
            if(_btTopnow.tag == 0)
            {
                if (_userInfoTextField.text.length <= 0) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"请输入登录帐号！"
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    break;
                }
                
                if (_passwordTextField.text.length <= 0) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"请输入登录密码！"
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    break;
                }
                if ([_delegate respondsToSelector:@selector(loginSubjectView:didPressLoginBtnWithUserName:andPassword:)]) {
                    [_delegate loginSubjectView:self didPressLoginBtnWithUserName:_userInfoTextField.text andPassword:_passwordTextField.text];
                }
            }
            else
            {///验证码登录
                
                if (_phoneTextField.text.length != 11) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"请输入正确的手机号！"
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    break;
                }
                
                if (_codeTextField.text.length <= 3) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"请输入正确的验证码！"
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    break;
                }
                
                [self.delegate loginFastSubjectView:self didPressLoginBtnWithPhone:_phoneTextField.text andcode:_codeTextField.text];
                
            }
            
        }
            break;
        case 102:
        {
            if ([_delegate respondsToSelector:@selector(loginSubjectView:didPressTriplicitiesLoginWithType:)]) {
                [_delegate loginSubjectView:self didPressTriplicitiesLoginWithType:LoginTypeQQ];
            }
        }
            break;
        case 103:
        {
            if ([_delegate respondsToSelector:@selector(loginSubjectView:didPressTriplicitiesLoginWithType:)]) {
                [_delegate loginSubjectView:self didPressTriplicitiesLoginWithType:LoginTypeWeiBo];
            }
        }
            break;
        case 104:
        {
            if ([_delegate respondsToSelector:@selector(loginSubjectView:didPressTriplicitiesLoginWithType:)]) {
                [_delegate loginSubjectView:self didPressTriplicitiesLoginWithType:LoginTypeWx];
            }
        }
            break;
        case 105:
        {
            if ([_delegate respondsToSelector:@selector(loginSubjectView:didPressTriplicitiesLoginWithType:)]) {
                [_delegate loginSubjectView:self didPressTriplicitiesLoginWithType:LoginTypeTaoBao];
            }
        }
            break;
        default:
            break;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if([textField isEqual:_phoneTextField])
    {
        
        if(textField.text.length>=11 && ![string isEqualToString:@""])
        {
            return NO;
        }
        
    }
    else if ([textField isEqual:_codeTextField])
    {
        if(_phoneTextField.text.length<11)
        {
            return NO;
        }
    }
    
    
    return YES;
}

@end
