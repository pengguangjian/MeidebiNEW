//
//  ShopMainDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopMainDataController : NSObject

@property (nonatomic , retain) NSMutableArray *arrListData;

// 获取列表数据
- (void)requestDGHomeListDataInView:(UIView *)view
                               Line:(int)page
                            site_id:(NSString *)strsiteid
                           Callback:(completeCallback)callback;

///加入购物车
- (void)requestAddBuCarDataLine:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;

@end
