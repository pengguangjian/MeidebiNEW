//
//  ResetPasswordSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/13.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ResetPasswordSubjectView.h"
#import "MDB_UserDefault.h"

@interface ResetPasswordSubjectView ()

@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmTextField;
@end

@implementation ResetPasswordSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
 
    _passwordTextField = [UITextField new];
    [self addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(25);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.offset(30);
    }];
    _passwordTextField.font = [UIFont systemFontOfSize:14.f];
    _passwordTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _passwordTextField.placeholder = @"请输入6位以上登录密码";
    _passwordTextField.secureTextEntry = YES;
    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(10);
        make.left.right.equalTo(_passwordTextField);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    
    // 确认密码
     _confirmTextField = [UITextField new];
    [self addSubview:_confirmTextField];
    [_confirmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_passwordTextField);
        make.top.equalTo(_passwordTextField.mas_bottom).offset(25);
    }];
    _confirmTextField.font = [UIFont systemFontOfSize:14.f];
    _confirmTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _confirmTextField.placeholder = @"请再次输入登录密码";
    _confirmTextField.secureTextEntry = YES;
    
    UIView *lineViewTwo = [UIView new];
    [self addSubview:lineViewTwo];
    [lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_confirmTextField.mas_bottom).offset(10);
        make.left.right.equalTo(_confirmTextField);
        make.height.offset(1);
    }];
    lineViewTwo.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];

    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(lineViewTwo.mas_bottom).offset(59);
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
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)responsToButtonEvents:(id)sender{
    [self endEditing:YES];
    if([_passwordTextField.text isEqualToString:_confirmTextField.text])
    {
        if ([_delegate respondsToSelector:@selector(resetPasswordView:didPressSubmitBtnWithPassword:)]) {
            [_delegate resetPasswordView:self didPressSubmitBtnWithPassword:_passwordTextField.text];
        }
    }
    else
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"两次密码不一致，请重新输入" inView:self];
    }
}


@end
