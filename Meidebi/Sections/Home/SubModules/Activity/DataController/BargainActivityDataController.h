//
//  BargainActivityDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/10/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BargainActivityDataController : NSObject
@property (nonatomic, strong, readonly) NSArray *requestResults;
@property (nonatomic, strong, readonly) NSDictionary *resultDict;
@property (nonatomic, strong, readonly) NSDictionary *resultShareInfoDict;
@property (nonatomic, assign, readonly) BOOL isSuccessZan;
@property (nonatomic, assign, readonly) BOOL isSuccessShou;
@property (nonatomic, assign, readonly) BOOL resportStatue;

// 详情
- (void)requestActivityDetailWithID:(NSString *)activityID
                         targetView:(UIView *)view
                           callback:(completeCallback)callback;


- (void)requestActivityItemDetailWithID:(NSString *)itemID
                             targetView:(UIView *)view
                               callback:(completeCallback)callback;

- (void)requestParticipationActivityWithID:(NSString *)itemID
                                targetView:(UIView *)view
                                  callback:(completeCallback)callback;

- (void)requestBargainSelfActivityWithID:(NSString *)itemID
                              targetView:(UIView *)view
                                callback:(completeCallback)callback;

- (void)requestShareBargainActivityWithID:(NSString *)itemID
                                      cID:(NSString *)cID
                               targetView:(UIView *)view
                                  callback:(completeCallback)callback;

- (void)requestZanDataWithInView:(UIView *)view
                     Commodityid:(NSString *)commodityid
                        callback:(completeCallback)callback;

- (void)requestBargainRecorActivityWithID:(NSString *)itemID
                              targetView:(UIView *)view
                                callback:(completeCallback)callback;

- (void)requestParticipationRecordActivityWithTargetView:(UIView *)view
                                              activityID:(NSString *)activityID
                                                callback:(completeCallback)callback;

- (void)requestBargainRankActivityWithID:(NSString *)itemID
                               targetView:(UIView *)view
                                 callback:(completeCallback)callback;
@end
