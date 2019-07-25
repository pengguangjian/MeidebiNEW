//
//  MyJiangLiDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyJiangLiDataController : NSObject

@property (nonatomic , retain) NSArray *arrcancleReason;

@property (nonatomic , retain) NSDictionary *diccancleorder;

@property (nonatomic , retain) NSArray *arrdetail;
// 用户奖励金统计
- (void)requestLeiJiDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;

// 用户月奖励金统计
- (void)requestMouthDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;

// 奖励明细
- (void)requestDetailDataInView:(UIView *)view
                       dicpush:(NSDictionary *)dicpush
                      Callback:(completeCallback)callback;

@end
