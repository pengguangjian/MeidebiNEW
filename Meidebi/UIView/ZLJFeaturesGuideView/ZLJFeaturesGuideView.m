//
//  ZLJFeaturesGuideView.m
//  ZLJNavigationSwipeView
//
//  Created by mdb-admin on 2017/7/4.
//  Copyright © 2017年 losaic. All rights reserved.
//

#import "ZLJFeaturesGuideView.h"
#import <objc/runtime.h>
#import "CMPopTipView.h"
#ifndef SYNTHESIZE_SINGLETON_FOR_CLASS

#define SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(__CLASSNAME__)	\
\
+ (__CLASSNAME__*) sharedInstance;	\


#define SYNTHESIZE_SINGLETON_FOR_CLASS(__CLASSNAME__)	\
\
static __CLASSNAME__ *instance = nil;   \
\
+ (__CLASSNAME__ *)sharedInstance{ \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
if (nil == instance){   \
instance = [[__CLASSNAME__ alloc] init];    \
}   \
}); \
\
return instance;   \
}   \

#endif

@interface ZLJFeaturesGuideView ()
<
CMPopTipViewDelegate
>
///点击的次数
@property (nonatomic,assign) NSInteger tapNumber;
///点击的view数组
@property (nonatomic,strong) NSArray *guideViews;
///需要显示的文字数组
@property (nonatomic,strong) NSArray *tipsViews;
@end

@implementation ZLJFeaturesGuideView

SYNTHESIZE_SINGLETON_FOR_CLASS(ZLJFeaturesGuideView)

+ (void)showGuideViewWithRects:(NSArray<NSValue *> *)rects
                          tips:(NSArray<NSString *> *)tips{
    if (rects.count <= 0) return;
    [[ZLJFeaturesGuideView sharedInstance] creatGuideViewWithTapView:rects tips:tips];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tapNumber  = 0;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    }
    return self;
}

- (void)creatGuideViewWithTapView:(NSArray<NSValue *> *)rects tips:(NSArray<NSString *> *)tips
{
    NSMutableArray *mutableRectsArr = [NSMutableArray array];
    for (NSValue *rect in rects) {
        CGRect frame = rect.CGRectValue;
        UIView *view = [[UIView alloc] initWithFrame:frame];
        [self addSubview:view];
        [self drawDashLine:view lineLength:10 lineSpacing:8 lineColor:[UIColor orangeColor]];
        view.hidden = YES;
        [mutableRectsArr addObject:view];
    }
    self.guideViews = mutableRectsArr.mutableCopy;
    NSMutableArray *mutableTipsArr = [NSMutableArray array];
    for (NSString *tip in tips) {
        CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:tip];
        popTipView.dismissTapAnywhere = YES;
        popTipView.delegate = self;
        popTipView.has3DStyle = NO;
        popTipView.borderWidth = 0;
        popTipView.cornerRadius = 3.f;
        popTipView.textFont = [UIFont systemFontOfSize:12.f];
        popTipView.textColor =[UIColor whiteColor];
        popTipView.textAlignment = NSTextAlignmentCenter;
        popTipView.backgroundColor = [UIColor colorWithRed:253/250.0 green:115/250.0 blue:20/250.0 alpha:1.f];
        popTipView.topMargin = 6.f;
        popTipView.sidePadding = 6.f;
        popTipView.bubblePaddingX = 6.f;
        popTipView.bubblePaddingY = 6.f;
        [mutableTipsArr addObject:popTipView];
    }
    self.tipsViews = mutableTipsArr.mutableCopy;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self showGuideViewWithIndex:0];

}

- (void)showGuideViewWithIndex:(NSInteger)index{
    if (index >= self.guideViews.count) {
        [self removeFromSuperview];
        for (UIView *view in self.guideViews) {
            [view removeFromSuperview];
        }
        self.guideViews = nil;
        self.tipsViews = nil;
        self.tapNumber = 0;
    };
    if (index <= self.guideViews.count-1) {
        NSMutableArray *guides = [NSMutableArray arrayWithArray:self.guideViews];
        for (NSInteger i = 0; i<self.guideViews.count; i++) {
            UIView *view = self.guideViews[i];
            if (i == index) {
                view.hidden = NO;
            }else{
                view.hidden = YES;
            }
            [guides replaceObjectAtIndex:i withObject:view];

        }
        self.guideViews = guides.mutableCopy;
    };

    if (index <= self.tipsViews.count-1) {
        for (NSInteger i = 0; i<self.tipsViews.count; i++) {
            CMPopTipView *popView = self.tipsViews[i];
            if (i == index) {
                [popView presentPointingAtView:self.guideViews[index] inView:self animated:YES];
            }else{
                [popView dismissAnimated:YES];
            }
        }
    };
}

- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:lineView.bounds cornerRadius:4.f];
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = lineColor.CGColor;
    border.fillColor = nil;
    border.path = maskPath.CGPath;
    border.frame = lineView.bounds;
    border.lineWidth = 1.f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@(lineLength), @(lineSpacing)];
    [lineView.layer addSublayer:border];
    
}

#pragma mark - CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
     self.tapNumber += 1;
    [self showGuideViewWithIndex:self.tapNumber];
}


@end
