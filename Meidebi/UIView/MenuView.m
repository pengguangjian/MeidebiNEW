//
//  MenuView.m
//  Meidebi
//
//  Created by 杜非 on 15/1/6.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MenuView.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

#define kMenuPadding 10.0f
#define kMenuAnimationDuration 0.25f

@interface MenuView(){
    NSInteger  menuInt;

}
/**
 * 移除旧按钮,添加新按钮
 */
- (void)updateTitlesWithArray:(NSArray*)titles;

/**
 * 创建按钮
 */
- (UIButton*)buttonWithTitle:(NSString*)title index:(NSInteger)index;

/**
 * 高亮
 */
- (void)updateHightlightedStatusWithView:(UIButton*)hightlightView;

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView*  tagImageView;
@property (nonatomic, assign) CGSize    imageSize;
@property (nonatomic, assign) NSInteger counts;

@end


@implementation MenuView
@synthesize index=_index;
- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles delegat:(id<MenuDelegate>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:delegate];
        if (titles) {
            _counts=titles.count;
            
            //_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 4, CGRectGetWidth(frame)-40, CGRectGetHeight(frame)-8)];
            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
            [self addSubview:_scrollView];
            [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame))];
            [_scrollView setShowsHorizontalScrollIndicator:NO];
            [_scrollView setShowsVerticalScrollIndicator:NO];
            
            
            UIView *vies=[[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-1.0, frame.size.width, 1.0)];
            [vies setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]];
            [self addSubview:vies];
            
             menuInt=0;
            _tagImageView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame), CGRectGetWidth(frame)/titles.count, 2)];
            [_tagImageView setBackgroundColor:RadMenuColor];
            _imageSize =CGSizeMake(60, CGRectGetHeight(frame)-17);

            [_scrollView addSubview:_tagImageView];
            [_tagImageView setHidden:NO];
            [self setBackgroundColor:[UIColor whiteColor]];
            [self updateTitlesWithArray:titles];
        }
        return self;
    }
    return nil;
}
- (void)updateTitlesWithArray:(NSArray*)titles{

    for (UIView* view in _scrollView.subviews) {
        if ([view isMemberOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    int index = 0;
    for (NSString* title in titles) {
        UIButton* btn = [self buttonWithTitle:title index:index];
        [_scrollView addSubview:btn];
        if (index==0) {
            [_tagImageView setHidden:NO];
            [_tagImageView setCenter:CGPointMake(btn.center.x, 45.0)];
        }
        index++;
    }
    
    //  默认选中最前面的那一个
    if (index > 0) {
        for (UIView* view in _scrollView.subviews) {
            if ([view isMemberOfClass:[UIButton class]] && view.tag == 0) {
                [self actionOfButtons:(UIButton*)view];
                // return;
            }
        }
    }
}


#pragma mark -
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    [_scrollView setBackgroundColor:backgroundColor];
}
#pragma mark - button actions
- (IBAction)actionOfButtons:(UIButton*)sender{
    if (sender.tag >= 0) {
        menuInt=sender.tag;
        
        if (_delegate && [_delegate respondsToSelector:@selector(MenuSelect:index:title:)]) {
            [self move2Point:CGPointMake(sender.center.x, 45.0) view:_tagImageView]; // 移动滑块
            _index=sender.tag;
            [_delegate MenuSelect:self index:sender.tag title:sender.titleLabel.text];
            // TODO : 点中后把当前sender完全显示出来(修改scrollView的contentOffset)
         //   [self performSelector:@selector(updateHightlightedStatusWithView:) withObject:sender afterDelay:0.001f];
            [self updateHightlightedStatusWithView:sender];
        }
    }
}
-(void)setSelectOne{
    for (UIView* view in _scrollView.subviews) {
        if ([view isMemberOfClass:[UIButton class]] && view.tag == 0) {
            [self actionOfButtons:(UIButton*)view];
             return;
        }
    }
}
-(void)setMenuIndex:(NSInteger)index{
    UIButton *sender;
    _index=index;
    for (UIButton *butx in [_scrollView subviews]) {
        if (butx.tag==index) {
            sender=butx;
        }
    }
   [self move2Point:CGPointMake(sender.center.x, 45.0) view:_tagImageView]; // 移动滑块
   [self updateHightlightedStatusWithView:sender];
}
#pragma mark - 创建Button
- (UIButton*)buttonWithTitle:(NSString *)title index:(NSInteger)index{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:RadMenuColor forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(actionOfButtons:) forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn setFrame:CGRectMake(0, 0, _imageSize.width, _imageSize.height)];
    CGFloat y = 6.0;
    CGFloat xWidth=(CGRectGetWidth(_scrollView.frame)/_counts-_imageSize.width)/2;
    CGFloat x = xWidth +CGRectGetWidth(_scrollView.frame)/_counts*index;
    [btn setFrame:CGRectMake(x, y, _imageSize.width, _imageSize.height)];
    [btn setTag:index];
    return btn;
}
#pragma mark - 让某个视图移到某个位置
- (void)move2Point:(CGPoint)point view:(UIView*)view{
    [UIView animateWithDuration:kMenuAnimationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [view setCenter:point];
                     } completion:^(BOOL finished) {
                         
                     }];
}
#pragma mark - 更新是否为hightlight的状态
- (void)updateHightlightedStatusWithView:(UIButton*)hightlightView{
    for (UIView* view in _scrollView.subviews) {
        if ([view isMemberOfClass:[UIButton class]]) {
            if ([view isEqual:hightlightView]) {
                [hightlightView setTitleColor:RadMenuColor forState:UIControlStateNormal];
            } else {
                UIButton *buto=(UIButton *)view;
                [buto setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];            }
        }
        
    }
}
@end


