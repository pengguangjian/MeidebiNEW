//
//  HomeTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/8/24.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeTableViewCellDelegate <NSObject>

@required - (NSArray *)numberOfCellPages;
@required - (void)didWipeToHotNew;

@end

@interface HomeTableViewCell : UITableViewCell
@property (nonatomic, weak) id<HomeTableViewCellDelegate> delegate;
- (void)showRemind:(BOOL)isShow;
@end
