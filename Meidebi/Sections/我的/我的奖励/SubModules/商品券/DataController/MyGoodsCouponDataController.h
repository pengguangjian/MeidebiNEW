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

// 用户奖励金统计
- (void)requestmyyouhuiListInView:(UIView *)view
                       dicpush:(NSDictionary *)dicpush
                      Callback:(completeCallback)callback;

@end

NS_ASSUME_NONNULL_END
