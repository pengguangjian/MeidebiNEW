//
//  RegCodeSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/12.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>



@class RegCodeSubjectView;
@protocol RegCodeSubjectViewDelegate <NSObject>

@optional
- (void)regCodeView:(RegCodeSubjectView *)subView
didPressRegBtnWithMobile:(NSString *)mobileNumber
            andCode:(NSString *)code withInvite: (NSString *)invite andpassword:(NSString *)password;

- (void)regCodeView:(RegCodeSubjectView *)subView
didPressAcquireCodeBtnWithMobile:(NSString *)mobileNumber;

- (void)regCodeViewDidPressUserProtocolBtn;
- (void)regCodeViewDidPressRetrieveMailBtn;

@end

@interface RegCodeSubjectView : UIView
@property (nonatomic, strong, readonly) NSString *codeNumber;
@property (nonatomic, strong, readonly) NSString *phoneNumber;

@property (nonatomic , assign) BOOL ischangepassword;

@property (nonatomic, weak) id<RegCodeSubjectViewDelegate> delegate;
@property (nonatomic, assign) RegCodeType regType;

- (void)bindMobileWarnData:(NSString *)warnContent;
- (void)bindCodeWarnData:(NSString *)warnContent;

-(void)timing;

@end
