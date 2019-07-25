//
//  OriginalMoreTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/9/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OriginalMoreTableViewCell;
@protocol OriginalMoreTableViewCellDelegate <NSObject>

@optional - (void)OriginalMoreTableViewCellDidClickLikeBtnWithCell:(OriginalMoreTableViewCell *)cell;

@end

@interface OriginalMoreTableViewCell : UITableViewCell
@property (nonatomic, weak) id<OriginalMoreTableViewCellDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)model;
@end
