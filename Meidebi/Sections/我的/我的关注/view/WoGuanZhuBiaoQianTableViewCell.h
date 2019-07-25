//
//  WoGuanZhuBiaoQianTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/26.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WoGuanZhuDelegate.h"
#import "WoGuanZhuShopAndBiaoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WoGuanZhuBiaoQianTableViewCell : UITableViewCell
@property (nonatomic,weak)id<WoGuanZhuDelegate>delegate;
@property (nonatomic,retain)WoGuanZhuShopAndBiaoModel *model;
@end

NS_ASSUME_NONNULL_END
