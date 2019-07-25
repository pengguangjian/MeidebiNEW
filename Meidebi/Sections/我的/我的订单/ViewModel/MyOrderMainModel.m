//
//  MyOrderMainModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/19.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyOrderMainModel.h"

@implementation MyOrderMainModel

+(MyOrderMainModel *)binddata:(NSDictionary *)dic
{
    if ([dic isKindOfClass:[NSNull class]]) return nil;
    MyOrderMainModel *model = [[MyOrderMainModel alloc] init];
    [model viewdata:dic];
    
    
    return model;
}

-(void)viewdata:(NSDictionary *)subject
{
    _did = [NSString nullToString:subject[@"id"]];
    _daigoutype = [NSString nullToString:subject[@"daigoutype"]];
    _goods_id = [NSString nullToString:subject[@"goods_id"]];
    _name = [NSString nullToString:subject[@"name"]];
    _share_id = [NSString nullToString:subject[@"share_id"]];
    
    _accident_xpln = [NSString nullToString:subject[@"accident_xpln"]];
    
    
    _re_status = [NSString nullToString:subject[@"re_status"]];
    _pindan_id = [NSString nullToString:subject[@"pindan_id"]];
    _refundstatus = [NSString nullToString:subject[@"refundstatus"]];
//    _refund = [NSString nullToString:subject[@"refund"]];
    _remain_pindannum = [NSString nullToString:subject[@"remain_pindannum"]];
    _remark = [NSString nullToString:subject[@"remark"]];
    
    _status = [NSString nullToString:subject[@"status"]];
    _totalprice = [NSString nullToString:subject[@"totalprice"]];
    _userimg = subject[@"userimg"];
    _orderon = [NSString nullToString:subject[@"orderno"]];
    _link = [NSString nullToString:subject[@"link"]];
    _colonel = [NSString nullToString:subject[@"colonel"]];
    NSMutableArray *arrgoosinfotemp = [NSMutableArray new];
    if([[subject objectForKey:@"goodsinfo"] isKindOfClass:[NSArray class]])
    {
        NSArray *arrgoodsinfo = [subject objectForKey:@"goodsinfo"];
        
        for(NSDictionary *dictemp in arrgoodsinfo)
        {
           MyOrderGoodsModel *goodsmodel =  [MyOrderGoodsModel binddata:dictemp];
            goodsmodel.colonel = _colonel;
            goodsmodel.daigoutype = _daigoutype;
            if(goodsmodel!=nil)
            {
                [arrgoosinfotemp addObject:goodsmodel];
            }
            
        }
        
    }
    _goodsinfo = arrgoosinfotemp;
    
    
    
}

@end


@implementation MyOrderGoodsModel

+(MyOrderGoodsModel *)binddata:(NSDictionary *)dic
{
    if ([dic isKindOfClass:[NSNull class]]) return nil;
    MyOrderGoodsModel *model = [[MyOrderGoodsModel alloc] init];
    [model viewdata:dic];
    
    
    return model;
}

-(void)viewdata:(NSDictionary *)subject
{
    _num = [NSString nullToString:subject[@"num"]];
    _spec_val = [NSString nullToString:subject[@"spec_val"]];
    NSDictionary *dicsnap_goodsinfo = [subject objectForKey:@"snap_goodsinfo"];
    _image = [NSString nullToString:dicsnap_goodsinfo[@"image"]];
    _redirecturl = [NSString nullToString:dicsnap_goodsinfo[@"redirecturl"]];
    _title = [NSString nullToString:dicsnap_goodsinfo[@"title"]];
    _spprice = [NSString nullToString:subject[@"price"]];
    _spot = [NSString nullToString:dicsnap_goodsinfo[@"spot"]];
    _goods_id = [NSString nullToString:dicsnap_goodsinfo[@"goods_id"]];
}
@end
