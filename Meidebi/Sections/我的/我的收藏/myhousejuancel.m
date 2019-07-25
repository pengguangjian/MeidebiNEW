//
//  myhousejuancel.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/20.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "myhousejuancel.h"

@implementation myhousejuancel

-(id)initWithdic:(NSDictionary *)dic{
    if (self) {
        self=[super init];
    }
    self.juanid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    self.strDown=[NSString stringWithFormat:@"%@",[dic objectForKey:@"strDown"]];
    self.strImgUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"strImgUrl"]];
    self.strUp=[NSString stringWithFormat:@"%@",[dic objectForKey:@"strUp"]];
    self.statue = [NSString stringWithFormat:@"%@",[NSString nullToString:dic[@"state"]]];  // 1过期
    return self;
}

@end
