//
//  DaiGouZhiFuViewController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/30.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "RootViewController.h"

@interface DaiGouZhiFuViewController : RootViewController

///订单编号
@property (nonatomic , retain)NSString *strorderid;

///订单id
@property (nonatomic , retain)NSString *strdid;


///多个订单号
@property (nonatomic , retain)NSArray *arrordernumbers;
@property (nonatomic , retain)NSArray *arrorderids;
///商品id
@property (nonatomic , retain)NSString *strgoodsid;

@property (nonatomic , retain) NSString *strprice;

////是否抵扣运费 1:是 0:否
@property (nonatomic , assign) BOOL is_deduction;


@end
