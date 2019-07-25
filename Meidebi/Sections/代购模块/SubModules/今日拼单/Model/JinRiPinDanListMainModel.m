//
//  JinRiPinDanListMainModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/17.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "JinRiPinDanListMainModel.h"
#import "MDB_UserDefault.h"

@implementation JinRiPinDanListMainModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject
{
    if ([subject isKindOfClass:[NSNull class]]) return nil;
    JinRiPinDanListMainModel *model = [[JinRiPinDanListMainModel alloc] init];
    [model viewModelWithSubjects:subject];
    
    
    
    return model;
}

- (void)viewModelWithSubjects:(NSDictionary *)subject
{
    
    _strtitletime = [NSString nullToString:subject[@"day"]];
    if(_strtitletime.length == 0)
    {
        _strtitletime = [MDB_UserDefault strTimefromData:[[NSString nullToString:subject[@"addtime"]] integerValue] dataFormat:@"MM-dd"];
    }
    _strid = [NSString nullToString:subject[@"id"]];
    _strgoods_id = [NSString nullToString:subject[@"goods_id"]];
    _straddtime = [MDB_UserDefault strTimefromData:[[NSString nullToString:subject[@"addtime"]] integerValue] dataFormat:@"yyyy-MM-dd HH:mm"];
    _strname = [NSString nullToString:subject[@"name"]];
    _strstatus = [NSString nullToString:subject[@"status"]];
    _strstate = [NSString nullToString:subject[@"state"]];
    
    _strimage = [NSString nullToString:subject[@"image"]];
    _arrpindanusers = subject[@"pindanusers"];
    
//    NSDictionary *dicgoods_message = [subject objectForKey:@"goods_message"];
    
    _strpindannum = [NSString nullToString:subject[@"pindannum"]];
    _strpurchased_nums = [NSString nullToString:subject[@"purchased_nums"]];
    _strtitle = [NSString nullToString:subject[@"title"]];
    _strprice = [NSString nullToString:subject[@"price"]];
     _strshare_id = [NSString nullToString:subject[@"share_id"]];
    _strisend = [NSString nullToString:subject[@"isend"]];
    
    _isspiderorder = [NSString nullToString:subject[@"isspiderorder"]];
    
    _isspotgoods = [NSString nullToString:subject[@"isspotgoods"]];
    
}

@end
