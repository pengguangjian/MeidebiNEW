//
//  JiangJiaZhiBoModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/26.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "JiangJiaZhiBoModel.h"
#import "MDB_UserDefault.h"

@implementation JiangJiaZhiBoModel



-(JiangJiaZhiBoModel*)initValue:(NSDictionary *)value
{
    JiangJiaZhiBoModel *model = [[JiangJiaZhiBoModel alloc] init];
    
    model.activeprice = [NSString nullToString:[value objectForKey:@"activeprice"]];
    model.did = [NSString nullToString:[value objectForKey:@"id"]];
    model.image = [NSString nullToString:[value objectForKey:@"image"]];
    model.last_price = [NSString nullToString:[value objectForKey:@"last_price"]];
    model.reduction = [NSString nullToString:[value objectForKey:@"reduction"]];
    model.title = [NSString nullToString:[value objectForKey:@"title"]];
    model.lowpricetype = [NSString nullToString:[value objectForKey:@"lowpricetype"]];
    model.sitename = [NSString nullToString:[value objectForKey:@"sitename"]];
    model.createtime = [NSString nullToString:[value objectForKey:@"createtime"]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.createtime.floatValue];
    
    model.createtime =[MDB_UserDefault CalDateIntervalFromData:date endDate:[NSDate date]];
    
    
    return model;
}

@end
