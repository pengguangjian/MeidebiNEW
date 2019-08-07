//
//  DaShangView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/7.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "DaShangView.h"
#import "MDB_UserDefault.h"

@implementation DaShangView

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
    UIScrollView *scvback = [[UIScrollView alloc] init];
    [self addSubview:scvback];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self);
        make.width.offset(kMainScreenW);
    }];
    
    UIView *viewcenter = [[UIView alloc] init];
    [viewcenter setBackgroundColor:[UIColor whiteColor]];
    [scvback addSubview:viewcenter];
    [viewcenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.width.offset(kMainScreenW-30);
    }];
    [viewcenter.layer setMasksToBounds:YES];
    [viewcenter.layer setCornerRadius:6];
    
    
    UILabel *lbtopbold = [[UILabel alloc] init];
    [lbtopbold setText:@"代购菌已为比友累计下单"];
    [lbtopbold setTextColor:RGB(30, 30, 30)];
    [lbtopbold setTextAlignment:NSTextAlignmentCenter];
    [lbtopbold setFont:[UIFont boldSystemFontOfSize:22]];
    [viewcenter addSubview:lbtopbold];
    [lbtopbold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewcenter);
        make.top.offset(50);
        make.height.offset(50);
    }];
    
    
    
    UILabel *lbnumbuy = [[UILabel alloc] init];
    [lbnumbuy setText:@"50000 笔"];
    [lbnumbuy setTextColor:RGB(130, 130, 130)];
    [lbnumbuy setTextAlignment:NSTextAlignmentCenter];
    [lbnumbuy setFont:[UIFont boldSystemFontOfSize:15]];
    [viewcenter addSubview:lbnumbuy];
    [lbnumbuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewcenter);
        make.top.equalTo(lbtopbold.mas_bottom).offset(20);
        make.height.offset(30);
    }];
    [lbnumbuy setAttributedText:[MDB_UserDefault arrstring:lbnumbuy.text andstart:0 andend:(int)lbnumbuy.text.length-1 andfont:lbnumbuy.font andcolor:[UIColor redColor]]];
    
    UIImageView *imgvl0 = [[UIImageView alloc] init];
    [imgvl0 setImage:[UIImage imageNamed:@"line_xuxian_graw"]];
    [viewcenter addSubview:imgvl0];
    [imgvl0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.equalTo(viewcenter.mas_right).offset(-10);
        make.top.equalTo(lbnumbuy.mas_bottom).offset(50);
        make.height.offset(1);
    }];
    
    
    UILabel *lbdashangtit = [[UILabel alloc] init];
    [lbdashangtit setText:@"打赏代购菌"];
    [lbdashangtit setTextColor:RGB(80, 80, 80)];
    [lbdashangtit setTextAlignment:NSTextAlignmentLeft];
    [lbdashangtit setFont:[UIFont boldSystemFontOfSize:14]];
    [viewcenter addSubview:lbdashangtit];
    [lbdashangtit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgvl0);
        make.top.equalTo(imgvl0.mas_bottom).offset(30);
        make.height.offset(30);
    }];
    
    
    
    NSArray *arrmoney = @[@"￥2.00",@"￥5.00",@"￥8.00",@"￥10.00"];
    NSArray *arrimage = @[@"dashang04_nomo",@"dashang01_nomo",@"dashang02_nomo",@"dashang03_nomo"];
    UIView *viewleft;
    UIView *viewtop;
    for(int i = 0 ; i <2; i++)
    {
        viewtop = viewleft;
        viewleft = nil;
        for(int j = 0 ; j < 3; j++)
        {
            if(i*3+j>arrmoney.count)
            {
                viewtop = viewleft;
                break;
            }
            
            UIButton *btitem = [[UIButton alloc] init];
            [btitem setTitleColor:RGB(120, 120, 120) forState:UIControlStateNormal];
            [btitem.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [viewcenter addSubview:btitem];
            [btitem mas_makeConstraints:^(MASConstraintMaker *make) {
                if(viewleft==nil)
                {
                    make.left.equalTo(imgvl0);
                }
                else
                {
                    make.left.equalTo(viewleft.mas_right).offset(10);
                }
                if(viewtop== nil)
                {
                    make.top.equalTo(lbdashangtit.mas_bottom).offset(30);
                }
                else
                {
                    make.top.equalTo(viewtop.mas_bottom).offset(10);
                }
                
                make.width.offset((kMainScreenW-70)/3.0);
                make.height.offset(55*kScale);
            }];
            viewleft = btitem;
            
            
            if(i*3+j<arrmoney.count)
            {
                [btitem setImage:[UIImage imageNamed:arrimage[i*3+j]]   forState:UIControlStateNormal];
                [btitem setTitle:arrmoney[j+i*3] forState:UIControlStateNormal];
            }
            else
            {
                [btitem setTitle:@"其他金额" forState:UIControlStateNormal];
            }
            [btitem setBackgroundColor:RGB(246, 246, 246)];
            [btitem.layer setMasksToBounds:YES];
            [btitem.layer setCornerRadius:3];
            
        }
        
    }
    
    
    UIImageView *imgvl1 = [[UIImageView alloc] init];
    [imgvl1 setImage:[UIImage imageNamed:@"line_xuxian_graw"]];
    [viewcenter addSubview:imgvl1];
    [imgvl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(imgvl0);
        make.top.equalTo(viewtop.mas_bottom).offset(40);
    }];
    
    
    
    UIView *viewleiji = [[UIView alloc]init];
    [viewleiji setBackgroundColor:RGB(249, 249, 249)];
    [viewcenter addSubview:viewleiji];
    [viewleiji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(imgvl0);
        make.top.equalTo(imgvl1.mas_bottom).offset(30);
        make.height.offset(55*kScale);
    }];
    [viewleiji.layer setMasksToBounds:YES];
    [viewleiji.layer setCornerRadius:3];
    [self drawleijiView:viewleiji];
    
    
    
    
    
    UILabel *lbdashangmoney = [[UILabel alloc] init];
    [lbdashangmoney setText:@"已选￥5.00打赏代购菌"];
    [lbdashangmoney setTextColor:RGB(80, 80, 80)];
    [lbdashangmoney setTextAlignment:NSTextAlignmentLeft];
    [lbdashangmoney setFont:[UIFont boldSystemFontOfSize:14]];
    [viewcenter addSubview:lbdashangmoney];
    [lbdashangmoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgvl0);
        make.right.equalTo(viewcenter.mas_right).offset(-80);
        make.top.equalTo(viewleiji.mas_bottom).offset(50);
        make.height.offset(30);
    }];
    
    UIButton *btlijidashang = [[UIButton alloc] init];
    [btlijidashang setTitle:@"立即打赏" forState:UIControlStateNormal];
    [btlijidashang setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btlijidashang.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btlijidashang setBackgroundColor:RadMenuColor];
    [btlijidashang.layer setMasksToBounds:YES];
    [btlijidashang.layer setCornerRadius:3];
    [viewcenter addSubview:btlijidashang];
    [btlijidashang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgvl1);
        make.centerY.equalTo(lbdashangmoney);
        make.width.offset(90);
        make.height.offset(50*kScale);
    }];
    
    [viewcenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btlijidashang.mas_bottom).offset(30);
    }];
    
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewcenter.mas_bottom).offset(20);
    }];
    
}
////累计收到20次打赏
-(void)drawleijiView:(UIView *)view
{
    UILabel *lbleiji = [[UILabel alloc] init];
    [lbleiji setText:@"累计收到20次打赏"];
    [lbleiji setTextColor:RGB(120, 120, 120)];
    [lbleiji setTextAlignment:NSTextAlignmentLeft];
    [lbleiji setFont:[UIFont boldSystemFontOfSize:13]];
    [view addSubview:lbleiji];
    [lbleiji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.equalTo(view);
    }];
    
    UIImageView *imgvnext = [[UIImageView alloc] init];
    [imgvnext setImage:[UIImage imageNamed:@"dingdan_address_next"]];
    [imgvnext setContentMode:UIViewContentModeScaleAspectFit];
    [view addSubview:imgvnext];
    [imgvnext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-10);
        make.centerY.equalTo(view);
        make.size.sizeOffset(CGSizeMake(18, 18));
    }];
    
    UIView *viewleft = imgvnext;
    for(int i = 0 ; i < 3 ; i++)
    {
        UIImageView *imgvitem = [[UIImageView alloc] init];
        [imgvitem setBackgroundColor:[UIColor grayColor]];
        [view addSubview:imgvitem];
        [imgvitem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(viewleft.mas_left).offset(-5);
            make.centerY.equalTo(view);
            make.size.sizeOffset(CGSizeMake(30*kScale, 30*kScale));
        }];
        [imgvitem.layer setMasksToBounds:YES];
        [imgvitem.layer setCornerRadius:30*kScale/2.0];
        viewleft = imgvitem;
    }
    
    
}

@end
