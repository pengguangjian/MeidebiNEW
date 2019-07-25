//
//  MyZanAndCallMeTableViewCell.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/7.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyZanAndCallMeTableViewCell;
@protocol MyZanAndCallMeTableViewCellDelegate <NSObject>

@optional - (void)tableViewCellDidClickAvaterImageView:(MyZanAndCallMeTableViewCell *)cell;

@end

@interface MyZanAndCallMeTableViewCell : UITableViewCell
@property (nonatomic, weak) id<MyZanAndCallMeTableViewCellDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)model;
@end
