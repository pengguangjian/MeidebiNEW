//
//  WoGuanZhuPeopleModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/1.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "WoGuanZhuPeopleModel.h"

@implementation WoGuanZhuPeopleModel
-(id)initWithdic:(NSDictionary *)dic{
    if (self) {
        self=[super init];
    }
    self.did=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    self.avatar=[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
    self.follow_time=[NSString stringWithFormat:@"%@",[dic objectForKey:@"follow_time"]];
    self.nickname=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
    
    
    return self;
}
@end
