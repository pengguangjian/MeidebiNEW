//
//  RegCodeDataController.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/13.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^regCompleteCallback)(NSError *error, BOOL statue, id sulteData);

@interface RegCodeDataController : NSObject

@property (nonatomic, strong, readonly) NSString *resultMessage;
@property (nonatomic, strong, readonly) NSString *vid;

@property (nonatomic, strong) NSString *strpass;

- (void)requestGetCodeWithMobilNumber:(NSString *)mobileNumber
                              regType:(RegCodeType)type
                               InView:(UIView *)view
                             callback:(completeCallback)Callback;

///验证验证码 type只有 2激活 3重置密码
- (void)requestVerificationCodeWithMobilNumber:(NSString *)mobileNumber
                                          code:(NSString *)code
                                          type:(NSString *)type
                                        InView:(UIView *)view
                                      callback:(completeCallback)Callback;

////注册
- (void)requestRegUserInfoWithData:(NSDictionary *)dataDict
                               vid:(NSString *)vid
                            InView:(UIView *)view
                        withInvite:(NSString *)invite
                          callback:(regCompleteCallback)Callback;

////新版注册
- (void)requestNewRegUserInfoWithData:(NSDictionary *)dataDict
                            InView:(UIView *)view
                          callback:(regCompleteCallback)Callback;

///判断用户密码是否存在
- (void)requestisPwdInView:(UIView *)view
                  callback:(completeCallback)Callback;

///添加空置密码
- (void)requestAddPwdWithData:(NSDictionary *)dataDict
                       InView:(UIView *)view
                     callback:(completeCallback)Callback;


@end
