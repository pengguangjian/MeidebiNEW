//
//  HistoryHotView.h
//  Meidebi
//
//  Created by mdb-admin on 16/4/11.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callback)(CGFloat height);

@class HistoryHotView;
@protocol HistoryHotViewDelegate <NSObject>

@optional
- (void)historyHotViewDidPressDeleateBtn;
- (void)historyHotView:(HistoryHotView *)hotView
didPressSimpleHistoryStr:(NSString *)contentStr;

@end

@interface HistoryHotView : UIView

@property (nonatomic, weak) id<HistoryHotViewDelegate>delegate;
@property (nonatomic, strong) NSArray  *dataHistorySource;
@property (nonatomic, readonly, assign) CGFloat viewHeight;
@property (nonatomic, copy) void(^callback)(CGFloat height);

///标题
@property (nonatomic, strong) NSString *strtitle;
///是否有底部
@property (nonatomic, assign) BOOL isbottom;

@end
