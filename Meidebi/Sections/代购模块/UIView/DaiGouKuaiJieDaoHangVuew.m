//
//  DaiGouKuaiJieDaoHangVuew.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/11/26.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouKuaiJieDaoHangVuew.h"

@interface DaiGouKuaiJieDaoHangVuew ()
{
 
    float fbottom;
    
}
@end

@implementation DaiGouKuaiJieDaoHangVuew

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

        [self setBackgroundColor:[UIColor whiteColor]];
        

        
        NSArray *arrtitle = @[@"下单\n须知",@"热门\n商城",@"订单"];//@"今日\n拼单",
        NSArray *arrimage = @[@"daigoudaohang_cjwt",@"daigoudaohang_rmsc",@"daigoudaohang_dingdan"];//@"daigoudaohang_jrpd",
        fbottom = 0.0;
        for(int i = 0 ; i < arrtitle.count; i++)
        {
         
            UIButton *btitem = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.width*1.3*i, frame.size.width, frame.size.width*1.3)];
            [self addSubview:btitem];
            [btitem setTag:i];
            [btitem addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
            fbottom = btitem.bottom;
            
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(btitem.width*0.3, 0, btitem.width*0.4, btitem.width*0.4)];
            [imgv setImage:[UIImage imageNamed:arrimage[i]]];
            [imgv setContentMode:UIViewContentModeScaleAspectFit];
            [btitem addSubview:imgv];
            
            UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btitem.width, 30)];
            [lbtitle setText:arrtitle[i]];
            [lbtitle setTextColor:RGB(50, 50, 50)];
            [lbtitle setTextAlignment:NSTextAlignmentCenter];
            [lbtitle setNumberOfLines:2];
            [lbtitle setFont:[UIFont systemFontOfSize:10]];
            [btitem addSubview:lbtitle];
            
            [imgv setTop:(btitem.height-imgv.height-lbtitle.height)/2.0];
            [lbtitle setTop:imgv.bottom];
            
            UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(10, btitem.height-1, btitem.width-20, 1)];
            [viewline setBackgroundColor:RGBAlpha(245,245,245,1)];//RGB(232,82,0) RGB(255,151,69)
            [btitem addSubview:viewline];
            
            
        }
        
        
        UIButton *btsousuo = [[UIButton alloc] initWithFrame:CGRectMake(0, fbottom, frame.size.width, frame.size.width*0.6)];
        
        [btsousuo setImage:[UIImage imageNamed:@"daigoudaohang_jiantou"] forState:UIControlStateNormal];
        [btsousuo setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [btsousuo addTarget:self action:@selector(sousuoAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btsousuo];
        fbottom = btsousuo.bottom;
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setHeight:fbottom];
}


-(void)sousuoAction
{
 
    [UIView animateWithDuration:0.2 animations:^{
        [self setLeft:BOUNDS_WIDTH];
    } completion:^(BOOL finished) {
        [_superbt setHidden:NO];
    }];
}

-(void)itemAction:(UIButton *)sender
{
    
    [self.delegate kuaiJieDaoHangItemAction:sender.tag];
}

@end
