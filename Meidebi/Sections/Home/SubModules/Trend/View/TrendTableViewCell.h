//
//  TrendTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/11/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TrendTableViewCell;
@protocol TrendTableViewCellDelegate <NSObject>

@optional - (void)tableViewCellDidHandleCouponWithCell:(TrendTableViewCell *)cell;

@end

@interface TrendTableViewCell : UITableViewCell
@property (nonatomic, weak) id<TrendTableViewCellDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)model row:(NSUInteger)row;

@end
