//
//  ZLMultiLevelMenuView.h
//  FilterWares
//
//  Created by mdb-admin on 2016/11/15.
//  Copyright © 2016年 losaic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLMultiLevelMenuViewModel.h"

@class ZLMultiLevelMenuView;
@protocol ZLMultiLevelMenuViewDelegate <NSObject>

@optional
- (void)multiLevelMenuView:(ZLMultiLevelMenuView *)menuView
            didSeleteTypes:(NSArray *)types;

@end

@interface ZLMultiLevelMenuView : UIView

@property (nonatomic, weak) id<ZLMultiLevelMenuViewDelegate> delegate;
- (void)bindDataWithViewModel:(ZLMultiLevelMenuViewModel *)viewModel;
@end
