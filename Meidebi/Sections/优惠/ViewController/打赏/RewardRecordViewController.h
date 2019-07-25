//
//  RewardRecordViewController.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/7.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RootTableViewController.h"

typedef NS_ENUM(NSInteger, RewardLogType) {
    RewardLogTypeOriginal = 1,
    RewardLogTypeDiscount
};

@interface RewardRecordViewController: RootTableViewController

- (instancetype)initWithCommodityID:(NSString *)commodityID
                               type:(RewardLogType)type;

@end
