//
//  WelfareHomeDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2016/10/31.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WelfareHomeDataController : NSObject

@property (nonatomic, readonly, strong) NSDictionary *resultDict;
@property (nonatomic, readonly, strong) NSMutableArray *resultArray;

// 签到
- (void)requestDosignDataWithView:(UIView *)view
                         callback:(completeCallback)callback;

// 获取签到信息
- (void)requestAttendanceInfoDataWithView:(UIView *)view
                                 callback:(completeCallback)callback;
// 福利频道礼物数据
- (void)requestGiftInfoDataWithView:(UIView *)view
                               type:(NSString *)type
                           callback:(completeCallback)callback;
- (void)nextPageDataWithCallback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;


// 礼品兑换
- (void)requestGiftExchangeDataWithView:(UIView *)view
                                 giftID:(NSString *)giftID
                                   type:(NSString *)type
                               userInfo:(NSString *)userInfo
                           present_type:(NSString *)present_type
                               callback:(completeCallback)callback;

// 兑换记录
- (void)requestGiftExchangeRecordDataWithView:(UIView *)view
                                     callback:(completeCallback)callback;

// 签到30天
- (void)requestExchangeAttendanceGiftInView:(UIView *)view
                                      phone:(NSString *)phone
                                   callback:(completeCallback)callback;

// 悬浮通知和广告
- (void)requestWelfareAdvertiseDataWithView:(UIView *)view
                                 callback:(completeCallback)callback;

// 福利-动态
- (void)requestWelfareDynamicDataWithView:(UIView *)view
                                   callback:(completeCallback)callback;

// 福利-攻略
- (void)requestWelfareRaidersDataWithView:(UIView *)view
                                 callback:(completeCallback)callback;

// 福利-我领取的福利
- (void)requestMyWelfareDataWithView:(UIView *)view
                            callback:(completeCallback)callback;
@end
