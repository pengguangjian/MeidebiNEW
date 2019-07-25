//
//  ShareHongBaoView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/21.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "ShareHongBaoView.h"

@interface ShareHongBaoView ()
{
    
}

@property (nonatomic , retain) NSString *strtitle;
@property (nonatomic , retain) NSString *strcontent;
@end

@implementation ShareHongBaoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame andtitle:(NSString *)strtitle andcontent:(NSString *)strcontent
{
    if(self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:RGBAlpha(0, 0, 0, 0.35)];
        _strtitle = strtitle;
        _strcontent = strcontent;
        [self drawView];
        
        
    }
    return self;
}

-(void)drawView
{
    
    UIView *viewback = [[UIView alloc] initWithFrame:CGRectMake(25, 0, self.width-50, 100)];
    [viewback setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:viewback];
    [viewback.layer setMasksToBounds:YES];
    [viewback.layer setCornerRadius:5];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewback.width*0.2, viewback.width*0.2)];
    [imgv setImage:[UIImage imageNamed:@"hongbao_tanchukuang"]];
    [imgv setCenterX:viewback.width/2.0];
    [imgv setTop:10];
    [viewback addSubview:imgv];
    
    UIScrollView *scvback = [[UIScrollView alloc] initWithFrame:CGRectMake(0, imgv.bottom, viewback.width, 100)];
    [viewback addSubview:scvback];
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, viewback.width-20, 30)];
    [lbtitle setNumberOfLines:0];
    [lbtitle setText:_strtitle];
    [lbtitle setTextColor:RGB(30, 30, 30)];
    [lbtitle setFont:[UIFont boldSystemFontOfSize:16]];
    [lbtitle sizeToFit];
    [lbtitle setCenterX:viewback.width/2.0];
    [scvback addSubview:lbtitle];
    
    UILabel *lbcontent = [[UILabel alloc] initWithFrame:CGRectMake(10, lbtitle.bottom+10, viewback.width-20, 30)];
    [lbcontent setNumberOfLines:0];
    [lbcontent setText:_strcontent];
    [lbcontent setTextColor:RGB(130, 130, 130)];
    [lbcontent setFont:[UIFont systemFontOfSize:13]];
    [lbcontent sizeToFit];
    [lbcontent setCenterX:viewback.width/2.0];
    [scvback addSubview:lbcontent];
    
    
    if(lbcontent.bottom>self.height*0.65)
    {
        [scvback setHeight:self.height*0.65];
        [scvback setContentSize:CGSizeMake(0, lbcontent.bottom+10)];
    }
    else
    {
        [scvback setHeight:lbcontent.bottom+10];
    }
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, scvback.bottom+10, viewback.width, 1)];
    [viewline setBackgroundColor:RGB(234, 234, 234)];
    [viewback addSubview:viewline];
    
    
    UIButton *btfx = [[UIButton alloc] initWithFrame:CGRectMake(0, viewline.bottom, viewback.width*0.6, 50)];
    [btfx setTitle:@"分享红包给好友" forState:UIControlStateNormal];
    [btfx setTitleColor:RadMenuColor forState:UIControlStateNormal];
    [btfx.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [viewback addSubview:btfx];
    [btfx addTarget:self action:@selector(fenxiangAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectMake(btfx.right, btfx.top, 1, btfx.height)];
    [viewline1 setBackgroundColor:RGB(234, 234, 234)];
    [viewback addSubview:viewline1];
    
    UIButton *btcancle = [[UIButton alloc] initWithFrame:CGRectMake(viewline1.right, viewline.bottom, viewback.width-viewline1.right, btfx.height)];
    [btcancle setTitle:@"取消" forState:UIControlStateNormal];
    [btcancle setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    [btcancle.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [viewback addSubview:btcancle];
    [btcancle addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    
    [viewback setHeight:btcancle.bottom];
    [viewback setCenter:CGPointMake(self.width/2.0, self.height/2.0)];
    
    
    
}

-(void)fenxiangAction
{
    if(self.delegate)
    {
        [self.delegate shareAction];
    }
    
}
-(void)cancleAction
{
    [self removeFromSuperview];
}

@end
