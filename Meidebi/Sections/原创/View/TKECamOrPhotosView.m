//
//  TKECamOrPhotosView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/5/22.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "TKECamOrPhotosView.h"

@interface TKECamOrPhotosView ()
{
    UIView *viewbottom;
    
}

@end

@implementation TKECamOrPhotosView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self drawUI];
        
        
    }
    return self;
}


-(void)drawUI
{
    [self setBackgroundColor:RGBAlpha(0, 0, 0, 0.1)];
    
    viewbottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 60*kScale*3+2)];
    [viewbottom setBackgroundColor:[UIColor whiteColor]];
    viewbottom.layer.shadowColor = [UIColor blackColor].CGColor;
    viewbottom.layer.shadowOpacity = 0.8f;
    viewbottom.layer.shadowRadius = 4.f;
    viewbottom.layer.shadowOffset = CGSizeMake(0,-4);
    [self addSubview:viewbottom];
    
    NSArray *arrtitle = [NSArray arrayWithObjects:@"拍摄（照片或视频）",@"从手机相册选择",@"取消", nil];
    
    for(int i = 0 ; i < arrtitle.count; i++)
    {
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 60*kScale*i+i, viewbottom.width, 60*kScale)];
        [bt setTitle:arrtitle[i] forState:UIControlStateNormal];
        [bt setTitleColor:RGB(102,102,102) forState:UIControlStateNormal];
        [bt.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [bt setBackgroundColor:[UIColor whiteColor]];
        [viewbottom addSubview:bt];
        if(i == arrtitle.count - 1)
        {
            [bt setBackgroundColor:RGB(245,245,245)];
        }
        else
        {
            UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, bt.bottom, viewbottom.width, 1)];
            [viewlin setBackgroundColor:RGB(219,219,219)];
            [viewbottom addSubview:viewlin];
        }
        [bt setTag:i];
        [bt addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        [viewbottom setBottom:self.bottom];
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)btAction:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.4 animations:^{
        [viewbottom setTop:self.bottom];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    ////
    if(self.delegate != nil)
    {
        [self.delegate selectItem:sender.tag];
    }
    
    
    
    
}

@end
