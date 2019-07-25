//
//  TrendDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/11/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrendDataController : NSObject
@property (nonatomic, strong, readonly) NSArray *requestResults;
@property (nonatomic, strong, readonly) NSDictionary *resultDict;

- (void)requestTrendListInView:(UIView *)view
                            type:(NSString *)type
                        callback:(completeCallback)callback;
@end
