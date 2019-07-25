//
//  NJSegmentedControl.h
//  Meidebi
//
//  Created by mdb-admin on 16/4/13.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedBlcok) (NSInteger  segmentIndex);

@interface NJSegmentedControl : UIView
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic,strong) UIFont *font;
@property (nonatomic,strong) UIColor *bgColor;
@property (nonatomic,strong) UIColor *itemBackGroundColor;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *textSelectColor;

- (id)initWithFrame:(CGRect)frame items:(NSArray*)items andSelectionBlock:(selectedBlcok)block;
- (void)setSelectedIndex:(NSInteger)index;
@end
