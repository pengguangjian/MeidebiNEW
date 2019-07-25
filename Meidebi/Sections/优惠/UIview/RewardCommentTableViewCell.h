//
//  RewardCommentTableViewCell.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/5.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RewardCommentTableViewCell;
@protocol RewardCommentTableViewCellDelegate <NSObject>

@optional - (void)commentButtonDidClickWithTableViewCell:(RewardCommentTableViewCell *)cell;

@end

@interface RewardCommentTableViewCell : UITableViewCell

@property (nonatomic, weak) id<RewardCommentTableViewCellDelegate> delegate;

- (void)bindDataWithModel:(NSString *)model withRowSelect:(BOOL)select;

@end
