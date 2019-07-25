//
//  ConversionDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConversionDataController : NSObject

@property (nonatomic, readonly, strong) NSDictionary *resultDict;
@property (nonatomic, readonly, strong) NSMutableArray *resultArray;

// 获取签到信息
- (void)requestAttendanceInfoDataWithView:(UIView *)view
                                 callback:(completeCallback)callback;

// 兑换数据
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
                           present_type:(NSNumber *)present_type
                               callback:(completeCallback)callback;

@end
