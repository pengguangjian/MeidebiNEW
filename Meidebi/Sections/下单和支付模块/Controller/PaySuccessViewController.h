//
//  PaySuccessViewController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/30.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "RootViewController.h"

@interface PaySuccessViewController : RootViewController

@property (nonatomic , retain)NSString *strgoodsid;

///订单id
@property (nonatomic , retain)NSString *strdid;
///订单编号
@property (nonatomic , retain)NSString *strorderno;

///是否有多个订单
@property (nonatomic , assign) BOOL ismoreorders;

@end
