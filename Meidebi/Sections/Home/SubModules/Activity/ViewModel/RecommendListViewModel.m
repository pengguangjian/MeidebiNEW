//
//  RecomendListViewModel.m
//  Meidebi
//
//  Created by fishmi on 2017/6/5.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RecommendListViewModel.h"
#import <MJExtension/MJExtension.h>

@implementation RecommendListViewModel


+ (void)recommendReplaceKey{
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"commodityid":@"id",
                 @"recommendDescription" : @"description"
                 };
    }];
}
@end
