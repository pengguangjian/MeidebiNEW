//
//  DaiGouXiaDanViewController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/30.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "RootViewController.h"

@interface DaiGouXiaDanViewController : RootViewController
///代购商品id
@property (nonatomic , retain) NSString *strid;
///拼单id
@property (nonatomic , retain) NSString *strpindan_id;
///1 代购 2拼单
@property (nonatomic , assign) int itype;
///是否是参与拼团
@property (nonatomic , assign) BOOL iscanyupintuan;

@property (nonatomic , retain) NSDictionary *dicvalue;
//-(void)bindData:(NSDictionary *)dicvalue;
///是否能够编辑数量
@property (nonatomic , assign) BOOL iseditnumber;


@end
