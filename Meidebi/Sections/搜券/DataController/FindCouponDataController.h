//
//  FindCouponDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/7/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindCouponDataController : NSObject

@property (nonatomic, readonly, strong) NSDictionary *resultDict;
@property (nonatomic, readonly, strong) NSMutableArray *resultArray;


- (void)requestCouponSearchHomeDataWithView:(UIView *)view
                                   callback:(completeCallback)callback;

- (void)requestCouponSearchDataWithView:(UIView *)view
                                keyword:(NSString *)keyword
                                  order:(NSString *)order
                               callback:(completeCallback)callback;
- (void)nextPageDataWithCallback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;
@end
