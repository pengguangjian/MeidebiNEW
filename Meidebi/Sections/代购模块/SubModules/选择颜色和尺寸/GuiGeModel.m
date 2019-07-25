//
//  GuiGeModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/11/15.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "GuiGeModel.h"



@implementation GuiGeModel

+(GuiGeModel *)geigeDicValue:(NSDictionary *)dic
{
    
    GuiGeModel *model = [GuiGeModel new];
    
    model.strid = [NSString nullToString:[dic objectForKey:@"id"]];
    model.strname = [NSString nullToString:[dic objectForKey:@"spec_name"]];
    model.strspecvaltype = [NSString nullToString:[dic objectForKey:@"specvaltype"]];
    if([[dic objectForKey:@"specvals"] isKindOfClass:[NSArray class]])
    {
        NSArray *specvals = [dic objectForKey:@"specvals"];
        NSMutableArray *arritemtemp = [NSMutableArray new];
        for(NSDictionary *dictemp  in specvals)
        {
            [arritemtemp addObject:[GuiGeItemModel geigeDicValue:dictemp]];
        }
        model.arritem = arritemtemp;
    }
    
    model.purchased_nums = [NSString nullToString:[dic objectForKey:@"purchased_nums"]];
    
    return model;
    
}

@end
