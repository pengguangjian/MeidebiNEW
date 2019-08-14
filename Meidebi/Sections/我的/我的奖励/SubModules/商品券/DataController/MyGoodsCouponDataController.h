//
//  MyGoodsCouponDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/28.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyGoodsCouponDataController : NSObject

@property (nonatomic , retain) NSArray *arrList;

/// 我的商品券优惠券列表
- (void)requestmyyouhuiListInView:(UIView *)view
                       dicpush:(NSDictionary *)dicpush
                      Callback:(completeCallback)callback;

@end

NS_ASSUME_NONNULL_END
