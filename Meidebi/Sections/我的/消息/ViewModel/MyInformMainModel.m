//
//  MyInformMainModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/16.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "MyInformMainModel.h"
#import "MDB_UserDefault.h"

@implementation MyInformMainModel


+(MyInformMainModel *)dicvalueChange:(NSDictionary *)value
{
    MyInformMainModel *model = [[MyInformMainModel alloc] init];
    
    model.con = [NSString nullToString:[value objectForKey:@"con"]];
    model.content = [NSString nullToString:[value objectForKey:@"content"]];
    model.createtime = [NSString nullToString:[value objectForKey:@"createtime"]];
    model.fromid = [NSString nullToString:[value objectForKey:@"fromid"]];
    model.fromtype = [NSString nullToString:[value objectForKey:@"fromtype"]];
    model.did = [NSString nullToString:[value objectForKey:@"id"]];
    model.isdelete = [NSString nullToString:[value objectForKey:@"isdelete"]];
    model.ispm = [NSString nullToString:[value objectForKey:@"ispm"]];
    model.isread = [NSString nullToString:[value objectForKey:@"isread"]];
    model.relatenickname = [NSString nullToString:[value objectForKey:@"relatenickname"]];
    model.relatephoto = [NSString nullToString:[value objectForKey:@"relatephoto"]];
    model.relateuserid = [NSString nullToString:[value objectForKey:@"relateuserid"]];
    model.sysmsgid = [NSString nullToString:[value objectForKey:@"sysmsgid"]];
    model.tonickname = [NSString nullToString:[value objectForKey:@"tonickname"]];
    model.touserid = [NSString nullToString:[value objectForKey:@"touserid"]];
    model.dicall = value;
    return model;
}

@end
