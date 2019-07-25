//
//  GoodsGarModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "GoodsGarModel.h"


@implementation GoodsGarincidentalsModel

+(GoodsGarincidentalsModel *)viewModelDic:(NSDictionary *)dic;
{
    if(dic==nil)return nil;
    GoodsGarincidentalsModel *model = [[GoodsGarincidentalsModel alloc] init];
    [model viewkeyvalu:dic];
    
    
    return model;
}

-(void)viewkeyvalu:(NSDictionary *)dic
{
    _count = [NSString nullToString:[dic objectForKey:@"count"]];
    _hpostage = [NSString nullToString:[dic objectForKey:@"hpostage"]];
    _tariff = [NSString nullToString:[dic objectForKey:@"tariff"]];
    _transfermoney = [NSString nullToString:[dic objectForKey:@"transfermoney"]];
    _directmailmoney = [NSString nullToString:[dic objectForKey:@"directmailmoney"]];
}

@end


@implementation GoodsGarModel

+(GoodsGarModel *)viewModelDic:(NSDictionary *)dic
{
    
    
    GoodsGarModel *model = [[GoodsGarModel alloc] init];
    [model viewkeyvalu:dic];
    
    
    
    
    return model;
}

-(void)viewkeyvalu:(NSDictionary *)dic
{
    
    _transfertype = [NSString nullToString:[dic objectForKey:@"transfertype"]];
    _did = [NSString nullToString:[dic objectForKey:@"id"]];
    _daigoutype = [NSString nullToString:[dic objectForKey:@"daigoutype"]];
    _goods_id = [NSString nullToString:[dic objectForKey:@"goods_id"]];
    self.image = [NSString nullToString:[dic objectForKey:@"image"]];
    self.ischecked = [NSString nullToString:[dic objectForKey:@"ischecked"]];
    if(self.ischecked.intValue == 1)
    {
        self.isSelect = YES;
    }
    
    
    self.isend = [NSString nullToString:[dic objectForKey:@"isend"]];
    if(self.isend.intValue == 1)
    {
        self.isendtime = YES;
    }
    
    self.num = [NSString nullToString:[dic objectForKey:@"num"]];
    self.onelimit = [NSString nullToString:[dic objectForKey:@"onelimit"]];
    self.pindannum = [NSString nullToString:[dic objectForKey:@"pindannum"]];
    self.price = [NSString nullToString:[dic objectForKey:@"price"]];
    self.share_id = [NSString nullToString:[dic objectForKey:@"share_id"]];
    self.siteid = [NSString nullToString:[dic objectForKey:@"siteid"]];
    self.status = [NSString nullToString:[dic objectForKey:@"status"]];
    self.title = [NSString nullToString:[dic objectForKey:@"title"]];
    self.userid = [NSString nullToString:[dic objectForKey:@"userid"]];
    self.weight = [NSString nullToString:[dic objectForKey:@"weight"]];
    self.spec_val = [NSString nullToString:[dic objectForKey:@"spec_val"]];
//    self.spec_val = @"都是废话端口是东方红德生科技发啥快递费晒单是的金凤凰按设计费";
    _isspotgoods = [NSString nullToString:dic[@"isspotgoods"]];
    
    if([[dic objectForKey:@"incidentals"] isKindOfClass:[NSArray class]])
    {
        NSArray *arrtemp = [dic objectForKey:@"incidentals"];
        NSMutableArray *arrarrincidentals = [NSMutableArray new];
        for(NSDictionary *dictemp in arrtemp)
        {
            
            GoodsGarincidentalsModel *model = [GoodsGarincidentalsModel viewModelDic:dictemp];
            if(model != nil)
            {
                [arrarrincidentals addObject:model];
            }
        }
        self.arrincidentals = arrarrincidentals;
    }
    
}

@end


