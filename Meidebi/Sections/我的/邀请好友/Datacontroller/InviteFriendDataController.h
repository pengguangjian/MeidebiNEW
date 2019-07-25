//
//  InviteFriendDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteFriendDataController : NSObject

@property (nonatomic, strong, readonly) NSArray *requestResults;
@property (nonatomic, strong, readonly) NSDictionary *resultDict;

// 邀请好友
- (void)requestInviteFriendDataInView:(UIView *)view
                             Callback:(completeCallback)callback;

- (void)requestInviteFriendListDataInView:(UIView *)view
                                    order:(NSString *)order
                             Callback:(completeCallback)callback;
@end
