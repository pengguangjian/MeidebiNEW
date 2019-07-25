//
//  ActivityDetailModel.m
//  Meidebi
//
//  Created by fishmi on 2017/6/2.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ActivityDetailModel.h"
#import <MJExtension/MJExtension.h>

@implementation ActivityDetailModel

+ (void)activityKeyReplace{
    
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                @"commodityid":@"id",
                @"activityDescription" : @"description"
              };
    }];

}

@end
