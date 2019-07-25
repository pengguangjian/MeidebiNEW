//
//  ExchangeRcordDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2016/11/7.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeRcordDataController : NSObject

@property (nonatomic, strong, readonly) NSArray *requestResults;

- (void)requestSubjectDataWithInView:(UIView *)view
                            callback:(completeCallback)Callback;

- (void)nextPageDataWithCallback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;

@end
