//
//  oneUserHeadView.h
//  Meidebi
//
//  Created by fishmi on 2017/6/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneUserHeadFunctionView.h"

@class OneUserHeadTopView;

@protocol OneUserHeadViewDelegate <NSObject>

- (void)functionSelectbyButton: (UIButton *)btn;
- (void)clickToViewController:(UIViewController *)Vc;
@optional - (void)headerViewShowGuideElementRects:(NSArray *)rects;

@end

@interface OneUserHeadView : UIView
@property (nonatomic ,weak) id <OneUserHeadViewDelegate> delegate;

@property (nonatomic ,weak) UIView *view;
@property (nonatomic ,strong) OneUserHeadTopView *topView;
@property (nonatomic ,strong) OneUserHeadFunctionView *fucV;
@property (nonatomic ,assign) CGFloat _height;

- (void)setUpheadViewData;
- (void)setUpImageV: (UIImage *)image;
@end
