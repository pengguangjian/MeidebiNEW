//
//  OneUserShareBuyController.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/12.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OneUserShareBuyController : NSObject

@property (nonatomic, retain) NSDictionary *dicresult;

// 获取我代购返利信息
- (void)requestDGFanLiInfoDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;

@end

NS_ASSUME_NONNULL_END
