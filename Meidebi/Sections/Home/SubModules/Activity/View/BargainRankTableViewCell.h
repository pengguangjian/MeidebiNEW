//
//  BargainRankTableViewCell.h
//  Meidebi
//
//  Created by leecool on 2017/10/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BargainRankTableViewCell;
@protocol BargainRankTableViewCellDelegate<NSObject>
@optional - (void)tableViewCellDidCickAvaterViewWithCell:(BargainRankTableViewCell *)cell;
@end
@interface BargainRankTableViewCell : UITableViewCell
@property (nonatomic, weak) id<BargainRankTableViewCellDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)model;
@end
