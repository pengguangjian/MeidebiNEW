//
//  NJScrollTableView.h
//  Meidebi
//
//  Created by mdb-admin on 16/5/30.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollTabViewDataSource;


@interface NJScrollTableView : UIView

@property (nonatomic, weak) id<ScrollTabViewDataSource> dataSource;

@property (nonatomic, assign) CGFloat tabFrameHeight; //头部tab高
@property (nonatomic, strong) UIColor* tabBackgroundColor; //头部tab背景颜色
@property (nonatomic, assign) CGFloat tabButtonFontSize; //头部tab按钮字体大小
@property (nonatomic, assign) CGFloat tabMargin; //头部tab左右两端和边缘的间隔
@property (nonatomic, strong) UIColor* tabButtonTitleColorForNormal;
@property (nonatomic, strong) UIColor* tabButtonTitleColorForSelected;
@property (nonatomic, assign) CGFloat selectedLineWidth; //下划线的宽
@property (nonatomic, assign) BOOL scrollEnable;
@property (nonatomic, assign) BOOL isBuildUI;
/*!
 * @brief 自定义完毕后开始build UI
 */
- (void)buildUI;
/*!
 * @brief 控制选中tab的button
 */
- (void)selectTabWithIndex:(NSUInteger)index animate:(BOOL)isAnimate;

- (void)showRemindView:(BOOL)isShow;

@end

@protocol ScrollTabViewDataSource <NSObject>
@required
- (NSUInteger)numberOfPagers:(NJScrollTableView *)view;
- (UITableViewController *)scrollTableViewOfPagers:(NJScrollTableView *)view
                                     indexOfPagers:(NSUInteger)index;
@optional
/*!
 * @brief 切换到不同pager可执行的事件
 */
- (void)whenSelectOnPager:(NSUInteger)number;

@end
