//
//  NJSegmentedControl.m
//  Meidebi
//
//  Created by mdb-admin on 16/4/13.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "NJSegmentedControl.h"

#define kRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define kICPSegmentedControlCornerRadius 3.0f
#define kICPSegmentedControlBorderWidth  1.0f

@interface NJSegmentedControl()
@property (nonatomic,strong) NSMutableArray *segments;
@property (nonatomic) NSUInteger currentSelected;
@property (nonatomic,copy) selectedBlcok selBlock;

//- (void)setSelectedIndex:(NSInteger)index;

- (UIImage *)imageWithPureColor:(UIColor *)tintColor
                        andSize:(CGSize)imgSize;

- (void)roundCorners:(UIRectCorner)corners view:(UIView *)view;

@end

@implementation NJSegmentedControl

- (void)setDefaultConfigure{
    _segments=[[NSMutableArray alloc] init];
    _bgColor = kRGBA(74.0,76.0,76.0,1.0);
    _borderWidth = kICPSegmentedControlBorderWidth;
    _cornerRadius = kICPSegmentedControlCornerRadius;
    _itemBackGroundColor = [UIColor whiteColor];
    _textColor = kRGBA(74.0,76.0,76.0,1.0);
    _textSelectColor = [UIColor whiteColor];
    _font = [UIFont systemFontOfSize:14.0f];
}

- (void)setFrameWidth:(CGFloat)width{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height)];
}

- (void)setTitleColor:(UIColor *)color button:(UIButton *)button{
    [button setTitleColor:color forState:UIControlStateHighlighted];
    [button setTitleColor:color forState:UIControlStateNormal];
}

- (id)initWithFrame:(CGRect)frame
              items:(NSArray*)items
  andSelectionBlock:(selectedBlcok)block
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultConfigure];
        self.backgroundColor=_bgColor;
        self.layer.cornerRadius=_cornerRadius;
        self.layer.masksToBounds=YES;
        
        _selBlock=block;
        _currentSelected=-1;
        
        //        NSAssert(isValidArray(items),@"items必须为数组");
        
        for (int i = 0; i < [items count]; i++) {
            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:items[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
            //            [button setBackgroundImage:[self imageWithPureColor:_itemBackGroundColor andSize:CGSizeMake(buttonWith, buttonHeight)] forState:UIControlStateNormal];
            //            [button setBackgroundImage:[self imageWithPureColor:_borderColor andSize:CGSizeMake(buttonWith, buttonHeight)] forState:UIControlStateSelected];
            [self.segments addObject:button];
            [self addSubview:button];
        }
        [self updateSegments];
    }
    return self;
}

#pragma mark - Actions
-(void)segmentSelected:(UIButton *)button{
    if(button){
        NSInteger index = [self.segments indexOfObject:button];
        if (index == _currentSelected)return;
        NSArray *array = [self withoutSegment:button];
        for (UIButton *btn in array) {
            [self setTitleColor:_textColor button:btn];
            [btn setBackgroundColor:_itemBackGroundColor];
        }
        [self setTitleColor:_textSelectColor button:button];
        [button setBackgroundColor:_bgColor];
        if(self.selBlock){
            _currentSelected = index;
            self.selBlock(_currentSelected);
        }
    }
}

- (void)setSelectedIndex:(NSInteger)index
{
    if (index>=0 && [_segments count]>index) {
        [self segmentSelected:_segments[index]];
    }
}

#pragma mark - Setters
-(void)updateSegments
{
    _currentSelected=-1;
    self.backgroundColor = _bgColor;
    self.layer.cornerRadius=_cornerRadius;
    self.layer.masksToBounds=YES;
    
    float buttonWith = roundf((self.frame.size.width - _borderWidth*(_segments.count+1))/[self.segments count]);
    float buttonHeight= self.frame.size.height - _borderWidth*2;
    [self setFrameWidth:buttonWith*_segments.count+(_segments.count+1)*_borderWidth];
    CGFloat marginLeft = 0.0;
    
    for (int i = 0; i < [_segments count]; i++) {
        UIButton *button = (UIButton *)_segments[i];
        [button setBackgroundColor:_itemBackGroundColor];
        [button.titleLabel setFont:_font];
        
        marginLeft+= _borderWidth;
        CGRect frame = CGRectMake(marginLeft, _borderWidth, buttonWith,buttonHeight);
        [button setFrame:frame];
        marginLeft+= buttonWith;
        
        [self setTitleColor:_textColor button:button];
        
        if (i==0) {
            [self roundCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft view:button];
        }else if(i == [_segments count]-1){
            [self roundCorners:UIRectCornerTopRight|UIRectCornerBottomRight view:button];
        }
    }
    [self setSelectedIndex:0];
}

//圆角弧度
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self updateSegments];
}

//边框/背景颜色
- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    [self updateSegments];
}

//segment item的背景色
- (void)setItemBackGroundColor:(UIColor *)itemBackGroundColor
{
    _itemBackGroundColor = itemBackGroundColor;
    [self updateSegments];
}

//边宽
-(void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth=borderWidth;
    [self updateSegments];
}

//字体正常颜色
-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [self updateSegments];
}

//选中时的字体颜色
-(void)setTextSelectColor:(UIColor *)textSelectColor{
    _textSelectColor = textSelectColor;
    [self updateSegments];
}

//字体
- (void)setFont:(UIFont *)font
{
    _font = font;
    [self updateSegments];
}

#pragma mark round corners
- (void)roundCorners:(UIRectCorner)corners view:(UIView *)view{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.masksToBounds = YES;
    [maskLayer setAllowsEdgeAntialiasing:YES];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark create image with color

- (UIImage *)imageWithPureColor:(UIColor *)tintColor
                        andSize:(CGSize)imgSize{
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 0.0f);
    
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, imgSize.width, imgSize.height);
    UIRectFill(bounds);
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return tintedImage;
}

#pragma mark filter array
- (NSArray*)withoutSegment:(UIButton*) btn {
    return [self.segments filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIButton* button, NSDictionary *bindings) {
        return button != btn;
    }]];
}

@end
