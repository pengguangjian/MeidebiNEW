//
//  GuiGeLianXiModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/7.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "GuiGeLianXiModel.h"

@implementation GuiGeLianXiModel

+(GuiGeLianXiModel *)geigeDicValue:(NSDictionary *)dic
{
    GuiGeLianXiModel *model = [GuiGeLianXiModel new];
    
    model.availability = [NSString nullToString:[dic objectForKey:@"availability"]];
    model.spec_id = [[NSString nullToString:[dic objectForKey:@"spec_id"]] componentsSeparatedByString:@"_"];
    
    return model;
    
}


@end
