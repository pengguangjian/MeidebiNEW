//
//  MyAccountOrderListDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/13.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAccountOrderListDataController : NSObject
/// 订单明细列表
@property (nonatomic, retain) NSArray *arrresult;
///返利明细主页
@property (nonatomic, retain) NSDictionary *dicresult;

/// 订单明细列表
- (void)requestFanLiOrderListInfoDataInView:(UIView *)view
                                 dicpush:(NSDictionary *)dicpush
                                Callback:(completeCallback)callback;


///返利明细主页
- (void)requestFanLiMainInfoDataInView:(UIView *)view
                                    dicpush:(NSDictionary *)dicpush
                                   Callback:(completeCallback)callback;


@end

NS_ASSUME_NONNULL_END
