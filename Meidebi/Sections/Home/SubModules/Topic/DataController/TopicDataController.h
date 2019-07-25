//
//  TopicDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/12/1.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicDataController : NSObject
@property (nonatomic, strong, readonly) NSArray *requestResults;
// 话题
- (void)requestTopicListInView:(UIView *)view
                         callback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;
- (void)nextPageDataWithCallback:(completeCallback)callback;
@end
