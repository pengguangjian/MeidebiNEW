//
//  MyGoodsCouponModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/28.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyGoodsCouponModel.h"

@implementation MyGoodsCouponModel

+(MyGoodsCouponModel *)dicValueChangeModelValue:(NSDictionary *)dic
{
    MyGoodsCouponModel *model = [[MyGoodsCouponModel alloc] init];
    
    model.denomination = [NSString nullToString:[dic objectForKey:@"denomination"]];
    model.did = [NSString nullToString:[dic objectForKey:@"id"]];
    model.istimeout = [NSString nullToString:[dic objectForKey:@"istimeout"]];
    model.name = [NSString nullToString:[dic objectForKey:@"name"]];
    model.type = [NSString nullToString:[dic objectForKey:@"type"]];
    model.use_endtime = [NSString nullToString:[dic objectForKey:@"use_endtime"]];
    model.use_starttime = [NSString nullToString:[dic objectForKey:@"use_starttime"]];
    model.usecondition = [NSString nullToString:[dic objectForKey:@"usecondition"]];
    
    return model;
}

@end
