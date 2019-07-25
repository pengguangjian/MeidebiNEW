//
//  RewardHomeViewController.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/4.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger, RewardType) {
    RewardTypeOriginal = 1,
    RewardTypeDiscount
};

@interface RewardHomeViewController: RootViewController

- (instancetype)initWithCommodityID:(NSString *)commodityID
                               type:(RewardType)type;


@end
