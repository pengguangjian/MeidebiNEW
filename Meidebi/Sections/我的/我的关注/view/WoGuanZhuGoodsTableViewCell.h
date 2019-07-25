//
//  WoGuanZhuGoodsTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/26.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiangJiaTongZhiModel.h"
#import "WoGuanZhuDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface WoGuanZhuGoodsTableViewCell : UITableViewCell

@property (nonatomic ,retain) JiangJiaTongZhiModel *model;
@property (nonatomic,weak)id<WoGuanZhuDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
