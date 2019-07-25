//
//  RecommendActivityModel.m
//  Meidebi
//
//  Created by fishmi on 2017/5/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RecommendActivityHeadViewModel.h"
#import <MJExtension/MJExtension.h>

@implementation RecommendActivityHeadViewModel

+ (void)recommendActivityReplaced{
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"commodityid":@"id"
                 };
    }];
}
@end
