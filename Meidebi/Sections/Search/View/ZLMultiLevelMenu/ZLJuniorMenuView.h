//
//  ZLJuniorMenuView.h
//  FilterWares
//
//  Created by mdb-admin on 2016/11/15.
//  Copyright © 2016年 losaic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLJuniorMenuView;
@protocol ZLJuniorMenuViewDelegate <NSObject>

@optional
- (void)juniorMenuView:(ZLJuniorMenuView *)menuView
        didSelectTypes:(NSArray *)types;

@end

@interface ZLJuniorMenuView : UIView

@property (nonatomic, weak) id<ZLJuniorMenuViewDelegate> delegate;

- (void)reloadData:(NSArray *)datas
stairMenuIndexPath:(NSIndexPath *)path
currentLocationPath:(NSIndexPath *)locationPath;
@end
