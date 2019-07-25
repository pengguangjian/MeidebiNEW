//
//  GoodsCarDataViewController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsCarDataViewController : NSObject

@property (nonatomic , retain) NSMutableArray *arrreqList;

@property (nonatomic , retain) NSMutableDictionary *dicJieSuan;

///购物车列表
- (void)requestBuCarListDataLine:(NSDictionary *)dicpush
                            view:(UIView *)view
                       Callback:(completeCallback)callback;


///编辑商品数量 或删除
- (void)requestBuCarListItemEditDataLine:(NSDictionary *)dicpush
                            view:(UIView *)view
                        Callback:(completeCallback)callback;



///选中|取消选中商品
- (void)requestBuCarListItemSelectDataLine:(NSDictionary *)dicpush
                                    view:(UIView *)view
                                Callback:(completeCallback)callback;


////去结算
- (void)requestBuCarListJieSuanDataLine:(NSDictionary *)dicpush
                                      view:(UIView *)view
                                  Callback:(completeCallback)callback;



////修改规格
- (void)requestBuCarListChangeItemGuiGeDataLine:(NSDictionary *)dicpush
                                   view:(UIView *)view
                               Callback:(completeCallback)callback;

@end
