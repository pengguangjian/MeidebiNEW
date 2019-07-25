//
//  RegUserInfoDataController.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/13.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^regCompleteCallback)(NSError *error, BOOL statue, id sulteData);

@interface RegUserInfoDataController : NSObject

@property (nonatomic, strong, readonly) NSString *resultMessage;

- (void)requestRegUserInfoWithData:(NSDictionary *)dataDict
                               vid:(NSString *)vid
                             InView:(UIView *)view
                           withInvite:(NSString *)invite
                          callback:(regCompleteCallback)Callback;


@end
