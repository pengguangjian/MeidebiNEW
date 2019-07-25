//
//  ResetPassDataController.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/14.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResetPassDataController : NSObject

@property (nonatomic, strong, readonly) NSString *resultMessage;

- (void)requestResetPassWithPassword:(NSString *)password
                                 vid:(NSString *)vid
                              InView:(UIView *)view
                            callback:(completeCallback)Callback;

@end
