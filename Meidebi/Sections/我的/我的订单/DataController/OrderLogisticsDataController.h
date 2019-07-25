//
//  OrderLogisticsDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/20.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderLogisticsDataController : NSObject

@property (nonatomic , retain) NSDictionary *dicreuselt;

// 查看物流
- (void)requestDGHomeDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;

@end
