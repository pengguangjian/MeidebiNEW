//
//  RelevanceTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelevanceCellViewModel.h"
@class RelevanceTableViewCell;
@protocol RelevanceTableViewCellDelegate <NSObject>

@optional - (void)RelevanceTableViewCellDidClickLikeBtn:(RelevanceTableViewCell *)cell;

@end

@interface RelevanceTableViewCell : UITableViewCell
@property (nonatomic, weak) id<RelevanceTableViewCellDelegate> delegate;
- (void)bindHotRecommendData:(RelevanceCellViewModel *)model;


@end
