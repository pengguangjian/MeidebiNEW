//
//  OrderDetaileModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/20.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "OrderDetaileModel.h"

@implementation OrderDetaileModel
+(OrderDetaileModel *)bindModelData:(NSDictionary *)subject
{
    if ([subject isKindOfClass:[NSNull class]]) return nil;
    OrderDetaileModel *model = [[OrderDetaileModel alloc] init];
    [model viewdata:subject];
    
    
    return model;
}
-(void)viewdata:(NSDictionary *)subject
{
    
    self.did = [NSString nullToString:subject[@"id"]];
    self.daigoutype = [NSString nullToString:subject[@"daigoutype"]];
    self.name = [NSString nullToString:subject[@"name"]];
    self.pindan_id = [NSString nullToString:subject[@"pindan_id"]];
    self.refundstatus = [NSString nullToString:subject[@"refundstatus"]];
    self.remain_pindannum = [NSString nullToString:subject[@"remain_pindannum"]];
    self.remark = [NSString nullToString:subject[@"remark"]];
    self.status = [NSString nullToString:subject[@"status"]];
    self.totalprice = [NSString nullToString:subject[@"totalprice"]];
    self.pindanusers = subject[@"pindanusers"];
    self.truename = [NSString nullToString:subject[@"truename"]];
    self.mobile = [NSString nullToString:subject[@"mobile"]];
    self.address = [NSString nullToString:subject[@"address"]];
    self.front_pic = [NSString nullToString:subject[@"front_pic"]];
    self.back_pic = [NSString nullToString:subject[@"back_pic"]];
    self.idcard = [NSString nullToString:subject[@"idcard"]];
    self.extra = [NSString nullToString:subject[@"extra"]];
    self.express = [NSString nullToString:subject[@"express"]];
    self.orderno = [NSString nullToString:subject[@"orderno"]];
    self.addtime = [NSString nullToString:subject[@"addtime"]];
    self.endtime = [NSString nullToString:subject[@"endtime"]];
    self.sendtime = [NSString nullToString:subject[@"sendtime"]];
    self.paytime = [NSString nullToString:subject[@"paytime"]];
    
    self.accident_xpln = [NSString nullToString:subject[@"accident_xpln"]];
    
    self.international = [NSString nullToString:subject[@"international"]];
    self.strnodestatus = [NSString nullToString:subject[@"nodestatus"]];
    
    if([subject[@"refund"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictemp = subject[@"refund"];
        
        self.refund = [NSString nullToString:dictemp[@"status"]];
        
    }
    
    if([subject[@"shotpics"] isKindOfClass:[NSArray class]])
    {
        self.shotpics = subject[@"shotpics"];
    }
    else
    {
        if([NSString nullToString:subject[@"shotpics"]].length>4)
        {
            self.shotpics = @[[NSString nullToString:subject[@"shotpics"]]];
        }
        
    }
    
    if([subject[@"shoppics"] isKindOfClass:[NSArray class]])
    {
        self.shoppics = subject[@"shoppics"];
    }
    else
    {
        if([NSString nullToString:subject[@"shoppics"]].length>4)
        {
            self.shoppics = @[[NSString nullToString:subject[@"shoppics"]]];
        }
    }
    
    self.abshippedpics = [NSString nullToString:subject[@"abshippedpics"]];
    self.domestic = [NSString nullToString:subject[@"expressname"]];
    self.remove_reason = [NSString nullToString:subject[@"cancel_reason"]];
    self.removetime = [NSString nullToString:subject[@"canceltime"]];
    self.guonei_cost = [NSString nullToString:subject[@"guonei_cost"]];
    self.paytype = [NSString nullToString:subject[@"paytype"]];
    self.logistics = [NSString nullToString:subject[@"logistics"]];
    self.transfertype = [NSString nullToString:subject[@"transfertype"]];
    
    
    self.share_id = [NSString nullToString:subject[@"share_id"]];
    self.qq = [NSString nullToString:subject[@"qq"]];
    self.poundage_cost = [NSString nullToString:subject[@"poundage_cost"]];
    self.orderpoundage = [NSString nullToString:subject[@"orderpoundage"]];
    self.bounty_cost = [NSString nullToString:subject[@"bounty_cost"]];
    self.coupon_cost = [NSString nullToString:subject[@"coupon_cost"]];
    
//    NSDictionary *dicsnap_goodsinfo = subject[@"snap_goodsinfo"];
    self.goods_id = [NSString nullToString:subject[@"goods_id"]];
//    self.image = [NSString nullToString:dicsnap_goodsinfo[@"image"]];
//    self.redirecturl = [NSString nullToString:dicsnap_goodsinfo[@"redirecturl"]];
//    self.title = [NSString nullToString:dicsnap_goodsinfo[@"title"]];
    self.link = [NSString nullToString:subject[@"link"]];
    self.price = [NSString nullToString:subject[@"price"]];
    self.num = [NSString nullToString:subject[@"num"]];
    self.tariff = [NSString nullToString:subject[@"tariff_cost"]];
    self.transfertype = [NSString nullToString:subject[@"transfertype"]];
    self.guoji_cost = [NSString nullToString:subject[@"guoji_cost"]];
    self.stris_slow = [NSString nullToString:subject[@"is_slow"]];
    
    if([[subject objectForKey:@"couponinfo"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *diccouponinfo = [subject objectForKey:@"couponinfo"];
        self.couponinfortype = [NSString nullToString:diccouponinfo[@"type"]];
        
        if([[diccouponinfo objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *diccouponinfo1 = [diccouponinfo objectForKey:@"data"];
            self.sendnum = [NSString nullToString:diccouponinfo1[@"sendnum"]];
            self.num = [NSString nullToString:diccouponinfo1[@"num"]];
            
        }
        
    }
    
    
    
    NSMutableArray *arrtemp = [NSMutableArray new];
    if([[subject objectForKey:@"goodsinfo"] isKindOfClass:[NSArray class]])
    {
        NSArray *arrgoodsinfo = [subject objectForKey:@"goodsinfo"];
        for(NSDictionary *dicgg in arrgoodsinfo)
        {
            [arrtemp addObject:[OrderDetaileGoodsModel binddata:dicgg]];
            self.name = [NSString nullToString:dicgg[@"name"]];
            self.endtime = [NSString nullToString:dicgg[@"endtime"]];
        }
        
    }
    self.goodsinfo = arrtemp;
}

@end


@implementation OrderDetaileGoodsModel

+(OrderDetaileGoodsModel *)binddata:(NSDictionary *)dic
{
    if ([dic isKindOfClass:[NSNull class]]) return nil;
    OrderDetaileGoodsModel *model = [[OrderDetaileGoodsModel alloc] init];
    [model viewdata:dic];
    
    
    return model;
}
-(void)viewdata:(NSDictionary *)subject
{
    
    NSDictionary *dicsnap_goodsinfo = [subject objectForKey:@"snap_goodsinfo"];
    self.price = [NSString nullToString:dicsnap_goodsinfo[@"price"]];
    self.redirecturl = [NSString nullToString:dicsnap_goodsinfo[@"redirecturl"]];
    self.title = [NSString nullToString:dicsnap_goodsinfo[@"title"]];
    self.image = [NSString nullToString:dicsnap_goodsinfo[@"image"]];
    
    
    self.goods_id = [NSString nullToString:subject[@"share_id"]];
    self.num = [NSString nullToString:subject[@"num"]];
    self.transfertype = [NSString nullToString:subject[@"transfertype"]];
    self.link = [NSString nullToString:subject[@"linkurl"]];
    self.spec_val = [NSString nullToString:subject[@"spec_val"]];
    
    ///无效
    self.tariff = [NSString nullToString:subject[@"tariff"]];
    self.colonel = [NSString nullToString:subject[@"colonel"]];
    self.guoji_cost = [NSString nullToString:subject[@"guoji_cost"]];
    
}

@end
