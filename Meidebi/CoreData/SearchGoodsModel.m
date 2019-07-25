//
//  SearchGoodsModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/12.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "SearchGoodsModel.h"

@implementation SearchGoodsModel

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    SearchGoodsModel *model = [[SearchGoodsModel alloc] init];
    [model modelValueWithDict:dict];
    return model;
}

- (void)modelValueWithDict:(NSDictionary *)dict{
    
    _strid=[NSString nullToString:[dict objectForKey:@"id"]];
    _strshop=[NSString nullToString:[dict objectForKey:@"site"]];
    _strprice=[NSString nullToString:[dict objectForKey:@"price"]];
    _strpicurl=[NSString nullToString:[dict objectForKey:@"image"]];
    _strtitle=[NSString nullToString:[dict objectForKey:@"title"]];
    _stryouhuiprice=[NSString nullToString:[dict objectForKey:@"coupon_denomination"]];
    _type=[[NSString nullToString:[dict objectForKey:@"type"]] intValue];
    _tljurl = [NSString nullToString:[dict objectForKey:@"tljurl"]];
}


@end
