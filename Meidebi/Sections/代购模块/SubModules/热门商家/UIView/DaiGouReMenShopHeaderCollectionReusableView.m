//
//  DaiGouReMenShopHeaderCollectionReusableView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouReMenShopHeaderCollectionReusableView.h"

@interface DaiGouReMenShopHeaderCollectionReusableView()
{
    UIView *viewback;
    UILabel *lbtitle;
    UIView *viewline;
    UIView *viewline1;
}


@end

@implementation DaiGouReMenShopHeaderCollectionReusableView

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self drawSubview];
    }
    return self;
}


-(void)drawSubview
{
    viewback = [[UIView alloc] initWithFrame:CGRectZero];
    [viewback setBackgroundColor:[UIColor whiteColor]];
    
    lbtitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [lbtitle setTextColor:RGB(243,93,0)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:14]];
    
    viewline = [[UIView alloc] initWithFrame:CGRectZero];
    [viewline setBackgroundColor:RGB(236,236,236)];
    
    viewline1 = [[UIView alloc] initWithFrame:CGRectZero];
    [viewline1 setBackgroundColor:RGB(243,93,0)];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [viewback setFrame:CGRectMake(-5, 0, self.width+10, self.height)];
    [self addSubview:viewback];
    
    
    [lbtitle setFrame:CGRectMake(20, 0, 100, viewback.height)];
    [lbtitle setText:_strtitle];
    [lbtitle sizeToFit];
    [lbtitle setHeight:viewback.height];
    [viewback addSubview:lbtitle];
    
    [viewline setFrame:CGRectMake(0, viewback.height-1, viewback.width, 1)];
    [viewback addSubview:viewline];
    
    [viewline1 setFrame:CGRectMake(10, viewback.height-1.5, lbtitle.width+20, 1.5)];
    [viewback addSubview:viewline1];
    
}


@end
