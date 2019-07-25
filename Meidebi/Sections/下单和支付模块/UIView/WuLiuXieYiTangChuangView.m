//
//  WuLiuXieYiTangChuangView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/5/8.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "WuLiuXieYiTangChuangView.h"


@interface WuLiuXieYiTangChuangView ()
{
    UIView *viewalter;
    NSTimer *timer;
    NSInteger itime;
    
    UIView *viewbottom;
    UIImageView *imgvselect;
    UILabel *lbbottom;
    UILabel *lbtime;
    
}
@end


@implementation WuLiuXieYiTangChuangView

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
        [self drawview];
        
    }
    return self;
}

-(void)drawview
{
    [self setBackgroundColor:RGBAlpha(0, 0, 0, 0.45)];
    [self setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisAction)];
    [self addGestureRecognizer:tapview];
    
    viewalter = [[UIView alloc] init];
    [self addSubview:viewalter];
    [viewalter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(210);
    }];
    [viewalter setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *tapview1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alterAction)];
    [viewalter addGestureRecognizer:tapview1];
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [viewalter addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(viewalter);
        make.height.offset(80);
    }];
    [lbtitle setText:@"物流协议条款"];
    [lbtitle setTextColor:RGB(30, 30, 30)];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setFont:[UIFont boldSystemFontOfSize:18]];
    
    
    UILabel *lbcontent = [[UILabel alloc] init];
    [viewalter addSubview:lbcontent];
    [lbcontent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewalter.mas_left).offset(15);
        make.right.equalTo(viewalter.mas_right).offset(-15);
        make.top.equalTo(lbtitle.mas_bottom);
        make.height.offset(60);
    }];
    [lbcontent setText:@"我理解和接受该海外电商网站及所在国家的转运公司可能因特殊情况导致订单耗时超过2个月，且部分电商不提供快递跟踪码。"];
    [lbcontent setTextColor:RGB(80, 80, 80)];
    [lbcontent setNumberOfLines:0];
    [lbcontent setTextAlignment:NSTextAlignmentLeft];
    [lbcontent setFont:[UIFont systemFontOfSize:14]];
    
    viewbottom = [[UIView alloc] init];
    [viewalter addSubview:viewbottom];
    [viewbottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbcontent.mas_bottom).offset(20);
        make.left.right.equalTo(lbcontent);
        make.height.offset(30);
    }];
    [viewbottom setUserInteractionEnabled:NO];
    UITapGestureRecognizer *tapbottom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selctAction)];
    [viewbottom addGestureRecognizer:tapbottom];
    
    imgvselect = [[UIImageView alloc] init];
    [viewbottom addSubview:imgvselect];
    [imgvselect setImage:[UIImage imageNamed:@"wuliuxiyiyuanquan_nomo"]];
    [imgvselect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewbottom);
        make.centerY.equalTo(viewbottom);
        make.size.sizeOffset(CGSizeMake(15, 15));
    }];
    [imgvselect.layer setMasksToBounds:YES];
    [imgvselect.layer setCornerRadius:7.5];
    [imgvselect setBackgroundColor:RGB(220, 220, 220)];
    
    lbbottom = [[UILabel alloc] init];
    [viewbottom addSubview:lbbottom];
    [lbbottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgvselect.mas_right).offset(10);
        make.top.bottom.equalTo(viewbottom);
    }];
    [lbbottom setText:@"同意物流协议条款"];
    [lbbottom setTextColor:RGB(180, 180, 180)];
    [lbbottom setTextAlignment:NSTextAlignmentLeft];
    [lbbottom setFont:[UIFont systemFontOfSize:14]];
    
    lbtime = [[UILabel alloc] init];
    [viewbottom addSubview:lbtime];
    [lbtime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbbottom.mas_right);
        make.top.bottom.equalTo(viewbottom);
    }];
    [lbtime setText:@"（8S）"];
    [lbtime setTextColor:[UIColor redColor]];
    [lbtime setTextAlignment:NSTextAlignmentLeft];
    [lbtime setFont:[UIFont systemFontOfSize:14]];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    itime = 8;
    
}


-(void)dismisAction
{
    [self removeFromSuperview];
    [timer invalidate];
    timer = nil;
    
}

-(void)alterAction
{
    
}


-(void)timerAction
{
    itime--;
    
    if(itime<=0)
    {
        [timer invalidate];
        timer = nil;
        [lbtime setText:@""];
        [imgvselect setBackgroundColor:[UIColor whiteColor]];
        [lbbottom setTextColor:RGB(30, 30, 30)];
        [viewbottom setUserInteractionEnabled:YES];
    }
    else
    {
        [lbtime setText:[NSString stringWithFormat:@"（%ldS）",(long)itime]];
    }
    
    
}

-(void)selctAction
{
    [self removeFromSuperview];
    [imgvselect setImage:[UIImage imageNamed:@"brok_type_select"]];
    ////
    [self.delegate tongyixieyiAction];
    
    
}



@end
