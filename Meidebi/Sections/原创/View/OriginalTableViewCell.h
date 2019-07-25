//
//  OriginalTableViewCell.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJFlagView.h"
#import "Sharecle.h"
@class OriginalTableViewCell;
@protocol OriginalTableViewCellDelegate <NSObject>

@optional - (void)tableViewCellDidClickAvaterImageView:(OriginalTableViewCell *)cell;
@optional - (void)tableViewCellDidClickFollowBtn:(OriginalTableViewCell *)cell;
@optional - (void)tableViewCellDidClickFlageWithItem:(NSDictionary *)item;

@end

@interface OriginalTableViewCell : UITableViewCell
@property (nonatomic, weak) id<OriginalTableViewCellDelegate> delegate;
- (void)bindDataWithModel:(Sharecle *)model;

@end
