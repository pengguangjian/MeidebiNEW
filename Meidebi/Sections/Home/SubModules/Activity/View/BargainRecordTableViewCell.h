//
//  BargainRecordTableViewCell.h
//  Meidebi
//
//  Created by leecool on 2017/10/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BargainRecordTableViewCell;
@protocol BargainRecordTableViewCellDelegate<NSObject>
@optional - (void)tableViewCellDidCickAvaterViewWithCell:(BargainRecordTableViewCell *)cell;
@end

@interface BargainRecordTableViewCell : UITableViewCell
@property (nonatomic, weak) id<BargainRecordTableViewCellDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)model;
@end
