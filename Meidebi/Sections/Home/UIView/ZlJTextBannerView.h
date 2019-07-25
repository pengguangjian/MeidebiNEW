//
//  ZlJTextBannerView.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/31.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewModel.h"

@protocol ZlJTextBannerViewDelegate <NSObject>

@optional - (void)textBnnanerViewDidSelectItem:(HomeHotSticksViewModel *)itemModel;

@end

@interface ZlJTextBannerView : UIView
@property (nonatomic, weak) id<ZlJTextBannerViewDelegate> delegate;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat fontSize;
- (void)textBannerPages:(NSArray *)pages;
- (void)star;
- (void)stop;
@end
