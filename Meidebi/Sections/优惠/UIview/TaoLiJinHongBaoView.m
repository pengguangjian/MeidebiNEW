//
//  TaoLiJinHongBaoView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/27.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "TaoLiJinHongBaoView.h"

@implementation TaoLiJinHongBaoView

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
        [self setBackgroundColor:[UIColor clearColor]];
     
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.4f;
        self.layer.shadowOffset = CGSizeMake(0,0);
        self.layer.shadowRadius = 2.0;
        
        UIView *viewback = [[UIView alloc] init];
        [viewback setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:viewback];
        [viewback mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        [viewback.layer setMasksToBounds:YES];
        [viewback.layer setCornerRadius:3];
        
        
        
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.4f;
        self.layer.shadowOffset = CGSizeMake(0,0);
        
        UIImageView *imgv = [[UIImageView alloc] init];
        [imgv setImage:[UIImage imageNamed:@"hongbao_tanchukuang"]];
        [imgv setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:imgv];
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(70*kScale, 70*kScale));
            make.centerX.equalTo(self.mas_centerX);
            make.top.offset(20);
        }];
        
        UILabel *lbtext = [[UILabel alloc] init];
        [lbtext setTextColor:RGBAlpha(50, 50, 50, 1)];
        [self addSubview:lbtext];
        [lbtext setTextAlignment:NSTextAlignmentCenter];
        [lbtext setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
        [lbtext setText:@"恭喜获得1个红包"];
        [lbtext mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.offset(25);
            make.top.equalTo(imgv.mas_bottom).offset(15);
        }];
        
        
        UILabel *lbtext1 = [[UILabel alloc] init];
        [lbtext1 setTextColor:RGBAlpha(150, 150, 150, 1)];
        [self addSubview:lbtext1];
        [lbtext1 setTextAlignment:NSTextAlignmentCenter];
        [lbtext1 setFont:[UIFont systemFontOfSize:13]];
        [lbtext1 setText:@" 分享商品给好友即可获得\n（分享后返回没得比点击直达链接即可 ）"];
        [lbtext1 setNumberOfLines:2];
        [lbtext1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.offset(35);
            make.top.equalTo(lbtext.mas_bottom).offset(10);
        }];
        
        UIView *viewline = [[UIView alloc] init];
        [self addSubview:viewline];
        [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.offset(1);
            make.bottom.equalTo(self.mas_bottom).offset(-41);
        }];
        
        [viewline setBackgroundColor:RGB(221, 221, 221)];
        
        
        
        NSArray *arrtitle = [NSArray arrayWithObjects:@"分享给好友",@"取消", nil];
        
        for(int i = 0 ; i < arrtitle.count; i++)
        {
            
            UIButton *bt = [[UIButton alloc] init];
            [bt setTitle:arrtitle[i] forState:UIControlStateNormal];
            
            [bt setTitleColor:RGBAlpha(50, 50, 50, 1) forState:UIControlStateNormal];
            if(i==0)
            {
                [bt setTitleColor:RadMenuColor forState:UIControlStateNormal];
            }
            [bt.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self addSubview:bt];
            
            [bt mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.height.offset(40);
                make.width.equalTo(self.mas_width).multipliedBy(0.5);
                make.bottom.equalTo(self.mas_bottom);
                if(i==0)
                {
                    make.left.offset(0);
                }
                else
                {
                    make.right.equalTo(self.mas_right);
                }
                
            }];
            
            [bt setTag:i];
            [bt addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        UIView *viewline1 = [[UIView alloc] init];
        [self addSubview:viewline1];
        [viewline1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewline.mas_bottom);
            make.width.offset(1);
            make.bottom.equalTo(self.mas_bottom);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [viewline1 setBackgroundColor:RGB(221, 221, 221)];
        
    }
    return self;
}

-(void)itemAction:(UIButton *)sender
{
    if(sender.tag == 0)
    {
        if(self.delegate)
        {
            [self.delegate fenxianghongbao];
        }
        
    }
    [self removeFromSuperview];
}

@end
