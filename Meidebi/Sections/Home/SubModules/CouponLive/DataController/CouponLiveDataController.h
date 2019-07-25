//
//  CouponLiveDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/7/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponLiveDataController : NSObject

@property (nonatomic, strong, readonly) NSArray *requestResults;
@property (nonatomic, strong, readonly) NSDictionary *resultDict;

- (void)requestSubjectDataKeyword:(NSString *)keyword
                            order:(NSString *)order
                           InView:(UIView *)view
                         callback:(completeCallback)callback;

- (void)nextPageDataWithCallback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;

@end
