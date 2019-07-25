//
//  BindingUserInfoSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/13.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegCodeSubjectView.h"

@class BindingUserInfoSubjectView;
@protocol BindingUserInfoSubjectViewDelegate <NSObject>

@optional
- (void)bindingUserInfoView:(BindingUserInfoSubjectView *)subView
didPressAcquireCodeBtnWithMobile:(NSString *)mobileNumber;

- (void)bindingUserInfoView:(BindingUserInfoSubjectView *)subView
didPressSubmitBtnWithMobile:(NSString *)mobileNumber
                    andCode:(NSString *)code
                andpassword:(NSString *)password;

- (void)bindingUserInfoViewDidPressNotSubmitBtn;
- (void)bindingViewDidPressUserProtocolBtn;

@end

@interface BindingUserInfoSubjectView : UIView

@property (nonatomic , assign) BOOL isPwd;

@property (nonatomic, weak) id<BindingUserInfoSubjectViewDelegate> delegate;
//@property (nonatomic, strong) RegCodeSubjectView *codeSubview;
- (void)bindMobileWarnData:(NSString *)warnContent;
- (void)bindCodeWarnData:(NSString *)warnContent;


@end
