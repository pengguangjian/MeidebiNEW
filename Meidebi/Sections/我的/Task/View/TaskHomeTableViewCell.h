//
//  TaskHomeTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 16/8/19.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskHomeTableViewCell;
@protocol TaskHomeTableViewCellDelegate <NSObject>

- (void)tableViewCellDidPressHandleBtnWithHomeCell:(TaskHomeTableViewCell *)cell;

@end

@interface TaskHomeTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *taskItemDict;
@property (nonatomic, weak) id<TaskHomeTableViewCellDelegate>delegate;

@end
