//
//  RegSuccessSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/14.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "RegSuccessSubjectView.h"
#import "MDB_UserDefault.h"

#import "MDB_ShareExstensionUserDefault.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

#import "HTTPManager.h"

@interface RegSuccessSubjectView ()

@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UILabel *subPromptLabel;
@property (nonatomic, strong) UIButton *goToLoginBtn;

@end

@implementation RegSuccessSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{

    UIImageView *successImageView = [UIImageView new];
    [self addSubview:successImageView];
    [successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(100);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    successImageView.image = [UIImage imageNamed:@"reg_successs"];
    
    _promptLabel = [UILabel new];
    [self addSubview:_promptLabel];
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(successImageView.mas_centerX);
        make.top.equalTo(successImageView.mas_bottom).offset(34);
    }];
    _promptLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    _promptLabel.font = [UIFont systemFontOfSize:20.f];
    
    
    _subPromptLabel = [UILabel new];
    [self addSubview:_subPromptLabel];
    [_subPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(_promptLabel.mas_bottom).offset(17);
    }];
    _subPromptLabel.textAlignment = NSTextAlignmentCenter;
    _subPromptLabel.font = [UIFont systemFontOfSize:14.f];
    _subPromptLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _subPromptLabel.numberOfLines = 0;
    
    _goToLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_goToLoginBtn];
    [_goToLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(21);
        make.right.equalTo(self.mas_right).offset(-21);
        make.top.equalTo(_promptLabel.mas_bottom).offset(98);
        make.height.offset(50);
    }];
    [_goToLoginBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#FD7A0E"]] forState:UIControlStateNormal];
    [_goToLoginBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#ff8721"]] forState:UIControlStateHighlighted];
    _goToLoginBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_goToLoginBtn setTitle:@"马上去登录" forState:UIControlStateNormal];
    _goToLoginBtn.layer.masksToBounds = YES;
    _goToLoginBtn.layer.cornerRadius =4.f;
    [_goToLoginBtn addTarget:self action:@selector(respondsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    _goToLoginBtn.hidden = YES;
    
}

- (void)respondsToButtonEvents:(id)sender{
    if ([_delegate respondsToSelector:@selector(regSuccessViewDidPressLoginBtn)]) {
        [_delegate regSuccessViewDidPressLoginBtn];
    }
}

- (void)setSuccessType:(RegSuccessType)successType{
    if (successType == RegSuccessTypeNormal) {
        _promptLabel.text = @"恭喜您注册成功";
        
        
    }else if (successType == RegSuccessTypeBinding){
        _promptLabel.text = @"绑定成功";
        _subPromptLabel.text = @"";//请前往我的-设置-修改密码设置新密码
    }else{
        _promptLabel.text = @"新密码设置成功！";
        _goToLoginBtn.hidden = NO;
        [self removeAllLoginData];
    }
}

#pragma mark - 退出登录 清空登录数据

-(void)removeAllLoginData
{
    
    [[MDB_UserDefault defaultInstance] setUserNil];
    [[MDB_ShareExstensionUserDefault defaultInstance] saveUserToken:@""];
    
    //退出第三方登录
    [SSEThirdPartyLoginHelper logout:[SSEThirdPartyLoginHelper currentUser]];
    //消息清空
    [MDB_UserDefault setMessage:NO];
    NSInteger needPhone = 1;
    [MDB_UserDefault setNeedPhoneStatue:needPhone==1?YES:NO];
    
}


@end
