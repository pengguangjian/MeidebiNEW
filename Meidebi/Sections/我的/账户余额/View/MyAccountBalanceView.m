//
//  MyAccountBalanceView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/10.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountBalanceView.h"

#import "MDB_UserDefault.h"

#import "MyAccountCashWViewController.h"

#import "MyAccountTXJLTableViewController.h"

#import "MyAccountFLMXViewController.h"

@interface MyAccountBalanceView ()
{
    
}

@end

@implementation MyAccountBalanceView

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
    UIImageView *imgvtop = [[UIImageView alloc] init];
    [imgvtop setImage:[UIImage imageNamed:@"myaccount_yuan_money"]];
    [self addSubview:imgvtop];
    [imgvtop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(60*kScale, 60*kScale));
        make.top.offset(50);
        make.centerX.equalTo(self);
    }];
    
    
    UILabel *lbprice = [[UILabel alloc] init];
    [lbprice setText:@"￥0.00"];
    [lbprice setTextColor:[UIColor blackColor]];
    [lbprice setTextAlignment:NSTextAlignmentCenter];
    [lbprice setFont:[UIFont boldSystemFontOfSize:35]];
    [self addSubview:lbprice];
    [lbprice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(imgvtop.mas_bottom).offset(20);
        make.height.offset(40);
    }];
    [lbprice setAttributedText:[MDB_UserDefault arrstring:lbprice.text andstart:0 andend:1 andfont:[UIFont boldSystemFontOfSize:25] andcolor:[UIColor blackColor]]];
    
    UILabel *lbpricemx = [[UILabel alloc] init];
    [lbpricemx setText:@"（可提现金额￥0.0，￥0.0待生效）"];
    [lbpricemx setTextColor:RGB(150, 150, 150)];
    [lbpricemx setTextAlignment:NSTextAlignmentCenter];
    [lbpricemx setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:lbpricemx];
    [lbpricemx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(lbprice.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    
    UIButton *bttixian = [[UIButton alloc] init];
    [bttixian setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bttixian setTitle:@"提现" forState:UIControlStateNormal];
    [bttixian.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [bttixian.layer setMasksToBounds:YES];
    [bttixian.layer setCornerRadius:4];
    [bttixian setBackgroundColor:RGB(11, 185, 85)];
    [self addSubview:bttixian];
    [bttixian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(kMainScreenW*0.4, 45));
        make.top.equalTo(lbpricemx.mas_bottom).offset(30);
        make.centerX.equalTo(self);
    }];
    [bttixian setTag:0];
    [bttixian addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *bttixianjl = [[UIButton alloc] init];
    [bttixianjl setTitleColor:RGB(11, 185, 85) forState:UIControlStateNormal];
    [bttixianjl setTitle:@"提现记录" forState:UIControlStateNormal];
    [bttixianjl.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [bttixianjl.layer setMasksToBounds:YES];
    [bttixianjl.layer setCornerRadius:4];
    [bttixianjl setBackgroundColor:RGB(232, 232, 232)];
    [self addSubview:bttixianjl];
    [bttixianjl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(bttixian);
        make.top.equalTo(self.mas_bottom).offset(-130);
        make.centerX.equalTo(self);
    }];
    [bttixianjl setTag:1];
    [bttixianjl addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bttixianmx = [[UIButton alloc] init];
    [bttixianmx setTitleColor:RGB(11, 185, 85) forState:UIControlStateNormal];
    [bttixianmx setTitle:@"返利明细" forState:UIControlStateNormal];
    [bttixianmx.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [bttixianmx.layer setMasksToBounds:YES];
    [bttixianmx.layer setCornerRadius:4];
    [bttixianmx setBackgroundColor:RGB(232, 232, 232)];
    [self addSubview:bttixianmx];
    [bttixianmx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(bttixian);
        make.top.equalTo(bttixianjl.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
    [bttixianmx setTag:2];
    [bttixianmx addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)allAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            MyAccountCashWViewController *mvc = [[MyAccountCashWViewController alloc] init];
            [self.viewController.navigationController pushViewController:mvc animated:YES];
        }
            break;
        case 1:
        {
            MyAccountTXJLTableViewController *mvc = [[MyAccountTXJLTableViewController alloc] init];
            [self.viewController.navigationController pushViewController:mvc animated:YES];
        }
            break;
        case 2:
        {
            MyAccountFLMXViewController *mvc = [[MyAccountFLMXViewController alloc] init];
            [self.viewController.navigationController pushViewController:mvc animated:YES];
            
        }
            break;
        default:
            break;
    }
}

@end
