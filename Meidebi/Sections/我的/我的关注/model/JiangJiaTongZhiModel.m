//
//  JiangJiaTongZhiModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/20.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "JiangJiaTongZhiModel.h"

@implementation JiangJiaTongZhiModel
-(id)initWithdic:(NSDictionary *)dic{
    if (self) {
        self=[super init];
    }
    self.did=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    self.title=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    self.image=[NSString stringWithFormat:@"%@",[dic objectForKey:@"image"]];
    self.price=[NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
    self.statue = [NSString stringWithFormat:@"%@",[NSString nullToString:dic[@"state"]]];  // 1过期
    self.name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    self.coinsign=[NSString stringWithFormat:@"%@",[dic objectForKey:@"coinsign"]];
    self.agttype=[NSString stringWithFormat:@"%@",[dic objectForKey:@"agttype"]];
    self.linktype=[NSString stringWithFormat:@"%@",[dic objectForKey:@"linktype"]];
    self.lowpricetype=[NSString stringWithFormat:@"%@",[dic objectForKey:@"lowpricetype"]];
    
    return self;
}

@end
