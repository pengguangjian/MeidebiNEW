//
//  OrderRefundVCDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/24.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderRefundVCDataController : NSObject

@property (nonatomic , retain) NSDictionary *dicreuselt;

// 退款详情
- (void)requestDGHomeDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;

@end
