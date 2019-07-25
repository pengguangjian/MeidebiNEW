//
//  ZLJNavigationSwipeView.h
//  ZLJNavigationSwipeView
//
//  Created by mdb-admin on 2017/6/23.
//  Copyright © 2017年 losaic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLJNavMenusSwipeView;
@protocol ZLJNavMenusSwipViewDataSource<NSObject>

@required - (NSInteger)numberOfPages:(ZLJNavMenusSwipeView *)swipeViewController;
@required - (UIViewController *)scrollTableViewOfPagers:(ZLJNavMenusSwipeView *)swipeView
                                          indexOfPagers:(NSUInteger)index;
@end

@interface ZLJNavMenusSwipeView : UIView


@property (nonatomic, weak) id<ZLJNavMenusSwipViewDataSource> dataSource;
@property (nonatomic, strong, readonly) UIView *navigationBarView;
- (instancetype)initWithCurrentNavigationController:(UINavigationController *)nav;
- (void)setupSubviews;
@end


