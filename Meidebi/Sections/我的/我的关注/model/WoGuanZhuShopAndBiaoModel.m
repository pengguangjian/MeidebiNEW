//
//  WoGuanZhuShopAndBiaoModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/1.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "WoGuanZhuShopAndBiaoModel.h"

@implementation WoGuanZhuShopAndBiaoModel
-(id)initWithdic:(NSDictionary *)dic{
    if (self) {
        self=[super init];
    }
    self.did=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    self.logo1=[NSString stringWithFormat:@"%@",[dic objectForKey:@"logo1"]];
    self.name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    self.sitesigndes=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sitesigndes"]];
    self.seourl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"seourl"]];
    
    return self;
}
@end
