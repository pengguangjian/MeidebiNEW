//
//  PersonalDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfoIndexDataController : NSObject

@property (nonatomic, strong, readonly) NSArray *requestResults;
@property (nonatomic, strong, readonly) NSDictionary *resultDict;

// 个人主页
- (void)requestPersonalInfoInView:(UIView *)view
                           userid:(NSString *)userid
                         callback:(completeCallback)callback;

// 我的爆料列表
- (void)requestMyBrokeListDataWithInView:(UIView *)view
                                  userid:(NSString *)userid
                                callback:(completeCallback)Callback;
- (void)myBrokeListNextPageDataWithCallback:(completeCallback)callback;
- (void)myBrokeListLastNewPageDataWithCallback:(completeCallback)callback;


// 我的晒单列表
- (void)requestMyShareListDataWithInView:(UIView *)view
                                  userid:(NSString *)userid
                                callback:(completeCallback)Callback;
- (void)myShareListNextPageDataWithCallback:(completeCallback)callback;
- (void)myShareListLastNewPageDataWithCallback:(completeCallback)callback;
@end
