//
//  LoginSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/12.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LoginType) {
    LoginTypeQQ = 1,
    LoginTypeWeiBo,
    LoginTypeWx,
    LoginTypeTaoBao
};

@class LoginSubjectView;
@protocol LoginSubjectViewDelegate <NSObject>

@optional
- (void)loginSubjectViewDidPressForgetBtn;
- (void)loginSubjectView:(LoginSubjectView *)subView
didPressLoginBtnWithUserName:(NSString *)userName
             andPassword:(NSString *)password;

- (void)loginSubjectView:(LoginSubjectView *)subView
didPressTriplicitiesLoginWithType:(LoginType)type;


-(void)loginCodeAction:(LoginSubjectView *)subView phone:(NSString *)strphone;

///验证码登录
- (void)loginFastSubjectView:(LoginSubjectView *)subView
didPressLoginBtnWithPhone:(NSString *)Phone
             andcode:(NSString *)code;

@end

@interface LoginSubjectView : UIView

@property (nonatomic, weak) id<LoginSubjectViewDelegate> delegate;

///启动倒计时
-(void)timing;

@end
