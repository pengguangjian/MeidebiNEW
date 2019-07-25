//
//  GuiGeItemModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/11/15.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "GuiGeItemModel.h"

@implementation GuiGeItemModel

+(GuiGeItemModel *)geigeDicValue:(NSDictionary *)dic
{
    GuiGeItemModel *model = [GuiGeItemModel new];
    
    model.strid = [NSString nullToString:[dic objectForKey:@"spec_val_id"]];
    model.strname = [NSString nullToString:[dic objectForKey:@"spec_val"]];
    model.strcolor = [NSString nullToString:[dic objectForKey:@"colorcodes"]];
    return model;
}

@end
