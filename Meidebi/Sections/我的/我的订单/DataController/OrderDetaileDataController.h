//
//  OrderDetaileDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/20.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Qqshare;

@interface OrderDetaileDataController : NSObject

@property (nonatomic , retain) NSDictionary *dicreuselt;

@property (nonatomic , retain) NSDictionary *dicshare;

@property (nonatomic, strong, readonly) Qqshare *resultShareInfo;
// 获取订单详情(直下和拼单)
- (void)requestDGHomeDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;

// 创建获取分享红包信息
- (void)requestDGHomeHongBaoSharedicpush:(NSDictionary *)dicpush
                                  InView:(UIView *)view
                                Callback:(completeCallback)callback;

// 获取分享红包信息
- (void)requestDGHomeGetHongBaoSharedicpush:(NSDictionary *)dicpush
                                  InView:(UIView *)view
                                Callback:(completeCallback)callback;


///爆料分享信息
- (void)requestShareSubjectDataWithCommodityid:(NSString *)commodityid inView:(UIView *)view callback:(completeCallback)callback;

@end
