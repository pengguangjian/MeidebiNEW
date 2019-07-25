//
//  DaiGouReMenShopFooterCollectionReusableView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouReMenShopFooterCollectionReusableView.h"

@interface DaiGouReMenShopFooterCollectionReusableView()
{
    UIView *viewback;
}
@end

@implementation DaiGouReMenShopFooterCollectionReusableView

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
    [viewback setBackgroundColor:RGB(241,241,241)];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [viewback setFrame:CGRectMake(-5, 0, self.width+10, self.height)];
    [self addSubview:viewback];
    
}

@end
