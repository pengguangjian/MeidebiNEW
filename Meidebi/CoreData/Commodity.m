//
//  Commodity.m
//  Meidebi
//
//  Created by losaic on 16/5/8.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "Commodity.h"
#import <MJExtension/MJExtension.h>
@implementation Commodity

+ (void)load{
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"commodityDescription" : @"description",
                 @"commodityid":@"id"
                 };
    }];
}

@end
