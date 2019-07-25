//
//  JiangJiaZhiBoController.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/26.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JiangJiaZhiBoController : NSObject
@property (nonatomic, strong) NSArray *requestResults;

/// 获取数据
- (void)requestJiangJiaZhiBoDataInView:(UIView *)view
                                 value:(NSDictionary *)dicpush
                     Callback:(completeCallback)callback;

@end

NS_ASSUME_NONNULL_END
