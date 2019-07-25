//
//  ContactDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactDataController : NSObject

@property (nonatomic, strong, readonly) NSArray *requestResults;
@property (nonatomic, strong, readonly) NSDictionary *resultDict;

// 关注列表
- (void)requestFollowListInView:(UIView *)view
                       Callback:(completeCallback)callback;

// 粉丝列表
- (void)requestFansListInView:(UIView *)view
                     Callback:(completeCallback)callback;

// 加关注
- (void)requestAddFollwDataWithInView:(UIView *)view
                               userid:(NSString *)userid
                             callback:(completeCallback)callback;

// 取消关注
- (void)requestCancelFollwDataWithInView:(UIView *)view
                                  userid:(NSString *)userid
                                callback:(completeCallback)callback;
@end
