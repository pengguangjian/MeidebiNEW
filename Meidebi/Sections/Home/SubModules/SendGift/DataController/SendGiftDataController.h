//
//  SendGiftDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/11/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendGiftDataController : NSObject
@property (nonatomic, strong, readonly) NSArray *requestResults;

// 逢节送礼
- (void)requestSendGiftListInView:(UIView *)view
                        callback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;
- (void)nextPageDataWithCallback:(completeCallback)callback;
@end
