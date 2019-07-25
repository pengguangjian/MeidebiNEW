//
//  JinRiPinDanListDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/17.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JinRiPinDanListDataController : NSObject


@property (nonatomic , retain) NSMutableArray *arrListData;

@property (nonatomic , retain) NSMutableArray *arrdgpaihangbangData;
// 获取列表数据
- (void)requestDGHomeListDataInView:(UIView *)view
                               Line:(int)page
                         Callback:(completeCallback)callback;

///加入购物车
- (void)requestAddBuCarDataLine:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;


/// 获取分类列表数据
- (void)requestDGHomeListDataInView:(UIView *)view
                          pushvalue:(NSDictionary *)dicpush
                             andurl:(NSString *)strurl
                              ipost:(int)ipost
                           Callback:(completeCallback)callback;

///代购排行榜
- (void)requestdgpaihangbangInView:(UIView *)view
                         pushvalue:(NSDictionary *)dicpush
                          Callback:(completeCallback)callback;


@end
