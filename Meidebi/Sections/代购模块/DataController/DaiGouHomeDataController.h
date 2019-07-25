//
//  DaiGouHomeDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/17.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaiGouHomeDataController : NSObject

@property (nonatomic , retain) NSDictionary *resultDict;

@property (nonatomic , retain) NSMutableArray *arrListData;

// 获取代购首页数据
- (void)requestDGHomeDataInView:(UIView *)view
                     Callback:(completeCallback)callback;

// 获取代购首页数据
- (void)requestDGHomeListDataLine:(int)page
                           lastid:(NSString *)strlastid
                       Callback:(completeCallback)callback;


///加入购物车
- (void)requestAddBuCarDataLine:(NSDictionary *)dicpush
                         Callback:(completeCallback)callback;

// 获取搜索数据
- (void)requestDGSearchListDataLine:(NSDictionary *)dicpush
                             InView:(UIView *)view
                         Callback:(completeCallback)callback;

@end
