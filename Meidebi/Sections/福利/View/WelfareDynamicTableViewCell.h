//
//  WelfareDynamicTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/26.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WelfareDynamicTableViewCell;
@protocol WelfareDynamicTableViewCellDelegate <NSObject>

@optional - (void)welfareDynamicTableViewDidClickAvaterWithCell:(WelfareDynamicTableViewCell *)cell;

@end

@interface WelfareDynamicTableViewCell : UITableViewCell
@property (nonatomic, weak) id<WelfareDynamicTableViewCellDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)dict;

@end
