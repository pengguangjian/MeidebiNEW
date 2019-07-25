//
//  RewardRecordTableViewCell.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/7.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RewardRecordTableViewCell;
@protocol RewardRecordTableViewCellDelegate <NSObject>

@optional - (void)tableViewCellDidSelctAvater:(RewardRecordTableViewCell *)cell;

@end

@interface RewardRecordTableViewCell : UITableViewCell
@property (nonatomic, weak) id<RewardRecordTableViewCellDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)model;

@end
