//
//  ZLStairMenuView.h
//  FilterWares
//
//  Created by mdb-admin on 2016/11/15.
//  Copyright © 2016年 losaic. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const kTableDefaultRowHeight = 55;

@class ZLStairMenuView;
@protocol ZLStairMenuViewDelegate <NSObject>

@optional
- (void)stairMenuView:(ZLStairMenuView *)menuView
   didSelectIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZLStairMenuView : UIView

@property (nonatomic, weak) id<ZLStairMenuViewDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *currentLocationIndexPath;
@property (nonatomic, strong) NSIndexPath *lastSelectIndexPath;
@property (nonatomic, assign) BOOL defaultSelected;
- (void)bindMenuViewData:(NSArray *)items;
@end
