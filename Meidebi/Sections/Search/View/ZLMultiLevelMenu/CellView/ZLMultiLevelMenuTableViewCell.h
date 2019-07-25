//
//  ZLMultiLevelMenuTableViewCell.h
//  FilterWares
//
//  Created by mdb-admin on 2016/11/15.
//  Copyright © 2016年 losaic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLMenuItem;

@protocol ZLMultiLevelMenuTableViewCellDelegate <NSObject>

@optional
- (void)menuTableViewCellDidSelectItems:(NSArray *)items;

@end

@interface ZLMultiLevelMenuTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ZLMultiLevelMenuTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, assign) BOOL isOpen;
@end
