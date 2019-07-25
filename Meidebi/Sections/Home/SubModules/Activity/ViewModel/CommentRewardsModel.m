//
//  CommentRewardsModel.m
//  Meidebi
//
//  Created by fishmi on 2017/5/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CommentRewardsModel.h"
#import <MJExtension/MJExtension.h>

@implementation CommentRewardsModel

+ (void)commentRewardsModelReplaced{
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"commodityid":@"id"
                 };
    }];
}
@end
