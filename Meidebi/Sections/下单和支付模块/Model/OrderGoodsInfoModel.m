//
//  OrderGoodsInfoModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/19.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "OrderGoodsInfoModel.h"
#import "MDB_UserDefault.h"

@implementation OrderGoodsMoneyInfoModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject
{
    if ([subject isKindOfClass:[NSNull class]]) return nil;
    OrderGoodsMoneyInfoModel *model = [[OrderGoodsMoneyInfoModel alloc] init];
    [model viewModelWithSubjects:subject];
    
    
    
    return model;
    
}
- (void)viewModelWithSubjects:(NSDictionary *)subject
{
    _tariff = [NSString nullToString:subject[@"tariff"]];
    _transfermoney = [NSString nullToString:subject[@"transfermoney"]];
    _hpostage = [NSString nullToString:subject[@"hpostage"]];
    _directmailmoney = [NSString nullToString:subject[@"directmailmoney"]];
}

@end



@implementation OrderShopInfoModel
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject
{
    if ([subject isKindOfClass:[NSNull class]]) return nil;
    OrderShopInfoModel *model = [[OrderShopInfoModel alloc] init];
    NSDictionary *dicsiteinfo = [subject objectForKey:@"siteinfo"];
    model.share_id = [NSString nullToString:dicsiteinfo[@"id"]];
    model.name = [NSString nullToString:dicsiteinfo[@"sitename"]];
    NSMutableArray *arrtemp = [NSMutableArray new];
    if([[subject objectForKey:@"goodsinfo"] isKindOfClass:[NSArray class]])
    {
        NSArray *arrce = [subject objectForKey:@"goodsinfo"];
        for(NSDictionary *dic in arrce)
        {
            [arrtemp addObject:[OrderGoodsInfoModel viewModelWithSubject:dic]];
        }
        model.arrgoods = arrtemp;
    }
    else if([[subject objectForKey:@"goodsinfo"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = [subject objectForKey:@"goodsinfo"];
        
         [arrtemp addObject:[OrderGoodsInfoModel viewModelWithSubject:dic]];
         model.arrgoods = arrtemp;
    }
    
    return model;
}

@end

@implementation OrderGoodsInfoModel
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject
{
    if ([subject isKindOfClass:[NSNull class]]) return nil;
    OrderGoodsInfoModel *model = [[OrderGoodsInfoModel alloc] init];
    [model viewModelWithSubjects:subject];
    
    
    
    return model;
}
- (void)viewModelWithSubjects:(NSDictionary *)subject
{
    _did = [NSString nullToString:subject[@"id"]];
    _image = [NSString nullToString:subject[@"image"]];
    _title = [NSString nullToString:subject[@"title"]];
    _price = [NSString nullToString:subject[@"price"]];
    _remain_bonus = [NSString nullToString:subject[@"remain_bonus"]];
    _addtime = [MDB_UserDefault strTimefromData:[[NSString nullToString:subject[@"addtime"]] integerValue] dataFormat:@"yyyy-MM-dd HH:mm"];
    _istop = [NSString nullToString:subject[@"istop"]];
    _transfertype = [NSString nullToString:subject[@"transfertype"]];
    _addymd = [NSString nullToString:subject[@"addymd"]];
    _daigoutype = [NSString nullToString:subject[@"daigoutype"]];
    _directmailmoney = [NSString nullToString:subject[@"directmailmoney"]];
    _endtime = [NSString nullToString:subject[@"endtime"]];
    _has_pindantimes = [NSString nullToString:subject[@"has_pindantimes"]];
    _hpostage = [NSString nullToString:subject[@"hpostage"]];
    _onelimit = [NSString nullToString:subject[@"onelimit"]];
    _pindannum = [NSString nullToString:subject[@"pindannum"]];
    _pindantimes = [NSString nullToString:subject[@"pindantimes"]];
    _purchased_nums = [NSString nullToString:subject[@"purchased_nums"]];
    _share_id = [NSString nullToString:subject[@"share_id"]];
    _siteid = [NSString nullToString:subject[@"siteid"]];
    _status = [NSString nullToString:subject[@"status"]];
    _stock = [NSString nullToString:subject[@"stock"]];
    _tariff = [NSString nullToString:subject[@"tariff"]];
    _transfermoney = [NSString nullToString:subject[@"transfermoney"]];
    _transitelineid = [NSString nullToString:subject[@"transitelineid"]];
    _weight = [NSString nullToString:subject[@"weight"]];
    _name = [NSString nullToString:subject[@"name"]];
    _pindanid = [NSString nullToString:subject[@"pindanid"]];
    _iselectnumber = [[NSString nullToString:subject[@"num"]] intValue];
    
    
    _isspotgoods = [NSString nullToString:subject[@"isspotgoods"]];
    
    _spec_val = [NSString nullToString:subject[@"spec_val"]];
    _goodsdetail_id = [NSString nullToString:subject[@"goodsdetail_id"]];
    if(_iselectnumber<=0)
    {
        _iselectnumber=1;
    }
    if([subject[@"incidentals"] isKindOfClass:[NSArray class]])
    {
        NSArray *arrincidentals = subject[@"incidentals"];
        NSMutableArray *arrtemp = [NSMutableArray new];
        for(NSDictionary *dicinci in arrincidentals)
        {
            
            OrderGoodsMoneyInfoModel *model = [OrderGoodsMoneyInfoModel viewModelWithSubject:dicinci];
            model.ikey = [[NSString nullToString:dicinci[@"count"]] intValue];
            [arrtemp addObject:model];
            
        }
        _incidentals =arrtemp;
    }
    
}
@end
