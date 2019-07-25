//
//  VKRegSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/12.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "VKRegSubjectView.h"
#import "MDB_UserDefault.h"
#import <YYKit/UIImage+YYAdd.h>
@interface NJScrollView : UIScrollView
@end
@implementation NJScrollView

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


@interface VKRegSubjectView ()

@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmTextField;
@property (nonatomic, strong) UITextField *mailTextField;

@end

@implementation VKRegSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    NJScrollView *mainScrollView = [NJScrollView new];
    [self addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *contairView = [UIView new];
    [mainScrollView addSubview:contairView];
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.equalTo(mainScrollView);
    }];
    
    // 用户名
    UIImageView *userIconImageView = [UIImageView new];
    [contairView addSubview:userIconImageView];
    [userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contairView.mas_left).offset(25);
        make.top.equalTo(contairView.mas_top).offset(28);
        make.size.mas_equalTo(CGSizeMake(16, 18));
    }];
    userIconImageView.image = [UIImage imageNamed:@"user_login_icon"];
    
    _userNameTextField = [UITextField new];
    [contairView addSubview:_userNameTextField];
    [_userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIconImageView.mas_right).offset(12);
        make.centerY.equalTo(userIconImageView.mas_centerY);
        make.right.equalTo(contairView.mas_right).offset(-21);
        make.height.offset(30);
    }];
    _userNameTextField.font = [UIFont systemFontOfSize:14.f];
    _userNameTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _userNameTextField.placeholder = @"请输入没得比用户名";
    
    UIView *lineView = [UIView new];
    [contairView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameTextField.mas_bottom).offset(10);
        make.left.equalTo(userIconImageView.mas_left);
        make.right.equalTo(_userNameTextField.mas_right);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    
    // 密码
    UIImageView *passwordIconImageView = [UIImageView new];
    [contairView addSubview:passwordIconImageView];
    [passwordIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contairView.mas_left).offset(25);
        make.top.equalTo(lineView.mas_top).offset(28);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    passwordIconImageView.image = [UIImage imageNamed:@"user_login_password"];
    
    
    _passwordTextField = [UITextField new];
    [contairView addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordIconImageView.mas_right).offset(12);
        make.right.equalTo(contairView.mas_right).offset(-21);
        make.centerY.equalTo(passwordIconImageView.mas_centerY);
        make.height.offset(30);
    }];
    _passwordTextField.font = [UIFont systemFontOfSize:14.f];
    _passwordTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _passwordTextField.placeholder = @"请输入6位以上登录密码";
    _passwordTextField.secureTextEntry = YES;
    
    UIView *lineViewTwo = [UIView new];
    [contairView addSubview:lineViewTwo];
    [lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(10);
        make.left.equalTo(passwordIconImageView.mas_left);
        make.right.equalTo(_passwordTextField.mas_right);
        make.height.offset(1);
    }];
    lineViewTwo.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    
    // 确认密码
    UIImageView *confirmIconImageView = [UIImageView new];
    [contairView addSubview:confirmIconImageView];
    [confirmIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordIconImageView.mas_left);
        make.top.equalTo(lineViewTwo.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    confirmIconImageView.image = [UIImage imageNamed:@"confirm_password"];
    
    
    _confirmTextField = [UITextField new];
    [contairView addSubview:_confirmTextField];
    [_confirmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmIconImageView.mas_right).offset(12);
        make.centerY.equalTo(confirmIconImageView.mas_centerY);
        make.right.height.equalTo(_passwordTextField);
    }];
    _confirmTextField.font = [UIFont systemFontOfSize:14.f];
    _confirmTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _confirmTextField.placeholder = @"请再次输入登录密码";
    _confirmTextField.secureTextEntry = YES;
    
    UIView *lineViewThree = [UIView new];
    [contairView addSubview:lineViewThree];
    [lineViewThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_confirmTextField.mas_bottom).offset(10);
        make.left.equalTo(confirmIconImageView.mas_left);
        make.right.equalTo(_confirmTextField.mas_right);
        make.height.offset(1);
    }];
    lineViewThree.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    
    // 邮箱
    UIImageView *mailIconImageView = [UIImageView new];
    [contairView addSubview:mailIconImageView];
    [mailIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordIconImageView.mas_left);
        make.top.equalTo(lineViewThree.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(18, 12));
    }];
    mailIconImageView.image = [UIImage imageNamed:@"login_mail"];

    _mailTextField = [UITextField new];
    [contairView addSubview:_mailTextField];
    [_mailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mailIconImageView.mas_right).offset(12);
        make.centerY.equalTo(mailIconImageView.mas_centerY);
        make.right.height.equalTo(_passwordTextField);
    }];
    _mailTextField.font = [UIFont systemFontOfSize:14.f];
    _mailTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _mailTextField.placeholder = @"请输入常用邮箱 (选填）";

    UIView *lineViewFore = [UIView new];
    [contairView addSubview:lineViewFore];
    [lineViewFore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mailTextField.mas_bottom).offset(10);
        make.left.equalTo(mailIconImageView.mas_left);
        make.right.equalTo(_mailTextField.mas_right);
        make.height.offset(1);
    }];
    lineViewFore.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    

    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contairView.mas_right).offset(-20);
        make.left.equalTo(contairView.mas_left).offset(20);
        make.top.equalTo(lineViewFore.mas_bottom).offset(59);
        make.height.offset(50);
    }];
    [submitBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#FD7A0E"]] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#ff8721"]] forState:UIControlStateHighlighted];
     submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [submitBtn setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.layer.masksToBounds  =YES;
    submitBtn.layer.cornerRadius = 4.f;
    [submitBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(submitBtn.mas_bottom).offset(10);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)responsToButtonEvents:(id)sender{
    [self endEditing:YES];
    
    if (_userNameTextField.text.length <= 0) {
        [MDB_UserDefault showNotifyHUDwithtext:@"请输入要注册的帐号！" inView:self];
        return;
    }
    if (_passwordTextField.text.length < 6) {
        [MDB_UserDefault showNotifyHUDwithtext:@"密码长度至少要6位！" inView:self];
        return;
    }
    if (![_passwordTextField.text isEqualToString:_confirmTextField.text]) {
        [MDB_UserDefault showNotifyHUDwithtext:@"两次输入的密码不一致！" inView:self];
        return;
        
    }
//    if (_mailTextField.text.length<=0) {
//        [MDB_UserDefault showNotifyHUDwithtext:@"请输入邮箱!" inView:self];
//        return;
//    }
    
    
    if (_mailTextField.text.length >0) {
        
        if (![MDB_UserDefault isValidateEmail:_mailTextField.text]) {
            [MDB_UserDefault showNotifyHUDwithtext:@"邮箱格式不正确!" inView:self];
            return;
        }
        NSMutableDictionary *dict = [@{@"password":_passwordTextField.text,
                                   @"email":_mailTextField.text,
                                    @"username":_userNameTextField.text
                                   } mutableCopy];
        if ([_delegate respondsToSelector:@selector(regUserInfoView:didPressSubmitBtnWithData:)]) {
            [_delegate regUserInfoView:self didPressSubmitBtnWithData:[dict mutableCopy]];
        }
    }else{
        NSMutableDictionary *dict = [@{@"password":_passwordTextField.text,@"username":_userNameTextField.text} mutableCopy];
        if ([_delegate respondsToSelector:@selector(regUserInfoView:didPressSubmitBtnWithData:)]) {
            [_delegate regUserInfoView:self didPressSubmitBtnWithData:[dict mutableCopy]];
        }
    }


    
}

@end
