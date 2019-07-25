//
//  SocialBoundDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/29.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialBoundDataController : NSObject

@property (nonatomic, readonly, strong) NSDictionary *resultDict;
@property (nonatomic, readonly, strong) NSMutableArray *resultArray;


// 绑定QQ
- (void)requestBoundQQWithInView:(UIView *)view
                           token:(NSString *)token
                          openid:(NSString *)openid
                        nickname:(NSString *)nickname
                       expiresIn:(NSString *)expiresIn
                        callback:(completeCallback)callback;

// 绑定sina
- (void)requestBoundSinaWithInView:(UIView *)view
                             token:(NSString *)token
                               uid:(NSString *)uid
                          nickname:(NSString *)nickname
                         expiresIn:(NSString *)expiresIn
                          callback:(completeCallback)callback;

// 绑定列表
- (void)requestBoundListWithInView:(UIView *)view
                          callback:(completeCallback)callback;

// 解绑
- (void)requestRelieveBoundWithInView:(UIView *)view
                                 type:(NSString *)type
                             callback:(completeCallback)callback;
@end
