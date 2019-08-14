//
//  MyAccountTXJLDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/13.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAccountTXJLDataController : NSObject
/// 提现记录
@property (nonatomic, retain) NSArray *arrresult;

/// 提现记录
- (void)requestTXJLInfoDataInView:(UIView *)view
                                    dicpush:(NSDictionary *)dicpush
                                   Callback:(completeCallback)callback;

@end

NS_ASSUME_NONNULL_END
