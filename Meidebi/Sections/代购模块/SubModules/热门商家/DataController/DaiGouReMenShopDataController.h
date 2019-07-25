//
//  DaiGouReMenShopDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/17.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaiGouReMenShopDataController : NSObject

@property (nonatomic , retain) NSDictionary *dicReustData;

// 获取列表数据
- (void)requestDGHomeListDataInView:(UIView *)view
                           Callback:(completeCallback)callback;

@end
