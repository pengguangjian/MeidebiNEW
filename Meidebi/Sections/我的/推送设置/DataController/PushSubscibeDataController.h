//
//  PushSubscibeDataController.h
//  Meidebi
//
//  Created by mdb-admin on 16/9/21.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushSubscibeDataController : NSObject

@property (nonatomic, strong, readonly) NSString *requestResults;
@property (nonatomic, strong, readonly) NSString *resultMessage;

- (void)requestSubjectDataInView:(UIView *)view
                        callback:(completeCallback)Callback;

- (void)requestSetPushKeywordDataInView:(UIView *)view
                                keyword:(NSString *)keyword
                               callback:(completeCallback)Callback;

@end
