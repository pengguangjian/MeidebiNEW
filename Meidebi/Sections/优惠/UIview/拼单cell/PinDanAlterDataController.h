//
//  PinDanAlterDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinDanAlterDataController : NSObject

@property (nonatomic , retain) NSDictionary *dicreuset;

// 获取拼单数据
- (void)requestDGHomeDataInView:(UIView *)view
                      pindan_id:(NSString *)strpindan_id
                       Callback:(completeCallback)callback;

@end
