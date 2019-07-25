//
//  HomeHotView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/8/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZlJTextBannerView.h"

@protocol HomeHotViewDelegate <NSObject>

@optional - (void)homeHotViewDidClichkCurrentHotWithItem:(HomeHotSticksViewModel *)item;

@end

@interface HomeHotView : UIControl
@property (nonatomic, weak) id<HomeHotViewDelegate> delegate;
- (void)bindDataWithModel:(NSArray *)model;
- (void)stopScroll;
- (void)starScroll;

@end
