//
//  DailyLottoDataController.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyLottoDataController : NSObject

@property (nonatomic, strong, readonly) NSArray *requestResults;
@property (nonatomic, strong, readonly) NSDictionary *resultDict;
@property (nonatomic, strong, readonly) NSDictionary *lottoResultDict;


// 个人信息
- (void)requestPersonalDataWithInView:(UIView *)view
                             callback:(completeCallback)callback;

// 抽奖
- (void)requestDoLottoDataWithInView:(UIView *)view
                            callback:(completeCallback)callback;
// 中奖列表
- (void)requestLottoListDataWithInView:(UIView *)view
                            callback:(completeCallback)callback;
// 抽奖历史记录
- (void)requestLottoRecordListDataWithInView:(UIView *)view
                                    callback:(completeCallback)callback;
- (void)nextPageDataWithCallback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;
@end
