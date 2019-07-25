//
//  GoodsCarSuperModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "GoodsCarSuperModel.h"

@implementation GoodsCarSuperModel

+(GoodsCarSuperModel *)viewModelDic:(NSDictionary *)dic
{
    GoodsCarSuperModel *model  = [GoodsCarSuperModel new];
    [model viewkeyvalu:dic];
    
    
    return model;
}


-(void)viewkeyvalu:(NSDictionary *)dic
{
    NSDictionary *dicsiteinfo = [dic objectForKey:@"siteinfo"];
    self.strshopname =[NSString nullToString:[dicsiteinfo objectForKey:@"sitename"]];
    self.strid = [NSString nullToString:[dicsiteinfo objectForKey:@"id"]];
    
    if([[dic objectForKey:@"goodsinfo"] isKindOfClass:[NSArray class]])
    {
        NSArray *arrgoodsinfo = [dic objectForKey:@"goodsinfo"];
        NSMutableArray *arrtemp = [NSMutableArray new];
        for(NSDictionary *dictemp1 in arrgoodsinfo)
        {
            GoodsGarModel *model1 = [GoodsGarModel viewModelDic:dictemp1];
            [arrtemp addObject:model1];
        }
        self.arrlist = arrtemp;
    }
    
    
}


@end
