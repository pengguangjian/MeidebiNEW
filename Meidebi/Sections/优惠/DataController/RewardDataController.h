//
//  RewardDataController.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/5.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardDataController : NSObject

@property (nonatomic, strong, readonly) NSDictionary *resultDict;
@property (nonatomic, strong, readonly) NSArray *results;

- (void)requestSubmitRewardDataWithInView:(UIView *)view
                              commodityid:(NSString *)commodityid
                                     type:(NSString *)type
                                  content:(NSString *)content
                                   amount:(NSString *)amount
                                 callback:(completeCallback)Callback;

- (void)requestRewardDetailListWithInView:(UIView *)view
                              commodityid:(NSString *)commodityid
                                     type:(NSString *)type
                                 callback:(completeCallback)Callback;
@end
