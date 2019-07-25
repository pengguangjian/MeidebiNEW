//
//  MyOrderMainDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/19.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Qqshare;
@interface MyOrderMainDataController : NSObject

@property (nonatomic , retain) NSArray *arrrequest;

@property (nonatomic , retain) NSArray *arrcancleReason;

@property (nonatomic , retain) NSDictionary *diccancleorder;

@property (nonatomic, strong, readonly) Qqshare *resultShareInfo;

// 获取我的订单
- (void)requestDGHomeDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;

// 取消订单原因列表
- (void)requestCancleOrderReasonDataInView:(UIView *)view
                             dicpush:(NSDictionary *)dicpush
                            Callback:(completeCallback)callback;

// 取消订单
- (void)requestCancleOrderDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;

// 确认收货
- (void)requestShouHuoOrderDataInView:(UIView *)view
                             dicpush:(NSDictionary *)dicpush
                            Callback:(completeCallback)callback;

// 删除订单
- (void)requestDelOrderDataInView:(UIView *)view
                              dicpush:(NSDictionary *)dicpush
                             Callback:(completeCallback)callback;
///爆料分享信息
- (void)requestShareSubjectDataWithCommodityid:(NSString *)commodityid inView:(UIView *)view callback:(completeCallback)callback;

@end
