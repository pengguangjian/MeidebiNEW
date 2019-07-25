//
//  PusnYuanChuangItemModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/5.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PusnYuanChuangItemModel.h"

@implementation PusnYuanChuangItemModel

////链接卡片处理
+(id)viewmodellinedata:(NSDictionary *)dicpush
{
    PusnYuanChuangItemModel *model = [[PusnYuanChuangItemModel alloc] init];
    
    model.strid = [NSString nullToString:[dicpush objectForKey:@"id"]];
    model.strlinetype = [NSString nullToString:[dicpush objectForKey:@"type"]];
    model.strimageurl = [NSString nullToString:[dicpush objectForKey:@"image"]];
    model.strprice = [NSString nullToString:[dicpush objectForKey:@"price"]];
    model.strsitename = [NSString nullToString:[dicpush objectForKey:@"sitename"]];
    model.strtitle = [NSString nullToString:[dicpush objectForKey:@"title"]];
    model.strlineurl = [NSString nullToString:[dicpush objectForKey:@"url"]];
    if(model.strlinetype.integerValue==2)
    {
        model.strtype = @"goodscard";
    }
    else
    {
        model.strtype = @"link";
    }
    
    
    return model;
}

+(id)viewmodeldata:(NSDictionary *)dicvalue
{
    PusnYuanChuangItemModel *model = [[PusnYuanChuangItemModel alloc] init];
    if([[dicvalue objectForKey:@"type"] isEqualToString:@"image"])
    {
        model.strimageurl = [NSString nullToString:[dicvalue objectForKey:@"imageurl"]];
        model.strtype = @"image";
        model.strcontent = [NSString nullToString:[dicvalue objectForKey:@"remark"]];
        
        
    }
    else if([[dicvalue objectForKey:@"type"] isEqualToString:@"video"])
    {
        model.strimageurl = [NSString nullToString:[dicvalue objectForKey:@"imageurl"]];
        model.strtype = @"video";
        model.strcontent = [NSString nullToString:[dicvalue objectForKey:@"remark"]];
        model.strvideourl = [NSString nullToString:[dicvalue objectForKey:@"videourl"]];
        
    }
    else if([[dicvalue objectForKey:@"type"] isEqualToString:@"goodscard"])
    {
        model.strimageurl = [NSString nullToString:[dicvalue objectForKey:@"imageurl"]];
        model.strtype = @"goodscard";
        model.strcontent = [NSString nullToString:[dicvalue objectForKey:@"remark"]];
        model.strtitle = [NSString nullToString:[dicvalue objectForKey:@"title"]];
        model.strlineurl = [NSString nullToString:[dicvalue objectForKey:@"linkurl"]];
        model.strprice = [NSString nullToString:[dicvalue objectForKey:@"price"]];
        model.strsitename = [NSString nullToString:[dicvalue objectForKey:@"sitename"]];
        
    }
    else if([[dicvalue objectForKey:@"type"] isEqualToString:@"link"])
    {
        model.strtype = @"link";
        model.strtitle = [NSString nullToString:[dicvalue objectForKey:@"title"]];
        model.strlineurl = [NSString nullToString:[dicvalue objectForKey:@"linkurl"]];
    }
    return model;
}


@end
