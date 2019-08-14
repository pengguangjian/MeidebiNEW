//
//  OneUserMainMoneysView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/5.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "OneUserMainMoneysView.h"


#import "MyGoodsCouponViewController.h"
#import "MyJiangLiViewController.h"

#import "MDB_UserDefault.h"
#import "VKLoginViewController.h"
#import "MyAccountBalanceViewController.h"

@interface OneUserMainMoneysView ()<UIAlertViewDelegate>
{
    UIScrollView *scvback;
    
    NSMutableArray *arrallLb;
    
}
@end

@implementation OneUserMainMoneysView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self drawUI];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

-(void)drawUI
{
    
    scvback = [[UIScrollView alloc] init];
    [self addSubview:scvback];
    [scvback setShowsHorizontalScrollIndicator:NO];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-50);
    }];
    arrallLb = [NSMutableArray new];
    NSArray *arrtitle = @[@"账户余额",@"奖励金",@"商品券",@"铜币",@"贡献值",@"积分"];
    UIView *viewlast = nil;
    for(int i = 0 ; i < arrtitle.count; i++)
    {
        UIView *viewitem = [[UIView alloc] init];
        [scvback addSubview:viewitem];
        [viewitem mas_makeConstraints:^(MASConstraintMaker *make) {
            if(viewlast==nil)
            {
                make.left.offset(0);
            }
            else
            {
                make.left.equalTo(viewlast.mas_right);
            }
            
            make.top.bottom.equalTo(self);
            make.width.offset((kMainScreenW-50)/4.0);
        }];
        UILabel *lbitem = [self drawItem:viewitem andtitle:arrtitle[i]];
        [arrallLb addObject:lbitem];
        if(i<arrtitle.count-1)
        {
            UIView *viewlne = [[UIView alloc] init];
            [viewlne setBackgroundColor:RGB(240, 240, 240)];
            [scvback addSubview:viewlne];
            [viewlne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(12);
                make.bottom.equalTo(self.mas_bottom).offset(-12);
                make.left.equalTo(viewitem.mas_right);
                make.width.offset(1);
            }];
        }
        viewlast = viewitem;
        
        [viewitem setTag:i];
        [viewitem setUserInteractionEnabled:YES];
        
        
        UITapGestureRecognizer *tapitem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)];
        [viewitem addGestureRecognizer:tapitem];
        
    }
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewlast.mas_right);
    }];
    
    ////
    UIButton *btnext = [[UIButton alloc] init];
    [btnext setImage:[UIImage imageNamed:@"myusermain_action_next"] forState:UIControlStateNormal];
    [self addSubview:btnext];
    [btnext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scvback.mas_right);
        make.right.equalTo(self);
        make.top.height.equalTo(scvback);
    }];
    [btnext addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *viewlne = [[UIView alloc] init];
    [viewlne setBackgroundColor:RGB(240, 240, 240)];
    [btnext addSubview:viewlne];
    [viewlne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(12);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
        make.left.offset(0);
        make.width.offset(1);
    }];
    
    
}

-(UILabel *)drawItem:(UIView *)view andtitle:(NSString *)title
{
    UILabel *lbvalue = [[UILabel alloc] init];
    [lbvalue setText:@"--"];
    [lbvalue setTextColor:RGB(102, 102, 102)];
    [lbvalue setTextAlignment:NSTextAlignmentCenter];
    [lbvalue setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbvalue];
    [lbvalue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.offset(12.5);
        make.height.offset(20);
    }];
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [lbtitle setText:title];
    [lbtitle setTextColor:RGB(177, 177, 177)];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(lbvalue.mas_bottom);
        make.height.equalTo(lbvalue.mas_height);
    }];
    return lbvalue;
}

-(void)loadViewUI
{
    if ([MDB_UserDefault getIsLogin])
    {
        @try {
            MDB_UserDefault *_userDefault=[MDB_UserDefault defaultInstance];
            NSArray *arrvalue = @[[NSString nullToString: _userDefault.balance],[NSString nullToString:_userDefault.commission_balance],[NSString nullToString:_userDefault.goods_coupon_balance],[NSString nullToString:_userDefault.usercoper],[NSString nullToString:_userDefault.ueserContribution],[NSString nullToString:_userDefault.userjifen]];
            ///更新信息
            for(int i = 0 ; i < arrvalue.count; i++)
            {
                UILabel *lbvalue = arrallLb[i];
                [lbvalue setText:arrvalue[i]];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    else
    {
        ///更新信息
        for(int i = 0 ; i < arrallLb.count; i++)
        {
            UILabel *lbvalue = arrallLb[i];
            [lbvalue setText:@"--"];
        }
    }
    
}

-(void)nextAction
{
    [scvback setContentOffset:CGPointMake(scvback.contentSize.width-scvback.width, 0) animated:YES];
}


-(void)itemAction:(UIGestureRecognizer *)gesture
{
    if ([MDB_UserDefault getIsLogin] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        return;
    }
    
    switch (gesture.view.tag) {
        case 0:
        {///账户余额
            MyAccountBalanceViewController *mvc = [[MyAccountBalanceViewController alloc]init];
            [self.viewController.navigationController pushViewController:mvc animated:YES];
        }
            break;
        case 1:
        {///奖励金
            MyJiangLiViewController *mvc = [[MyJiangLiViewController alloc] init];
            [self.viewController.navigationController pushViewController:mvc animated:YES];
        }
            break;
        case 2:
        {///商品券
            
            MyGoodsCouponViewController *mvc = [[MyGoodsCouponViewController alloc] init];
            [self.viewController.navigationController pushViewController:mvc animated:YES];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111) {
        if (buttonIndex == 0) {
            VKLoginViewController *vc = [[VKLoginViewController alloc] init];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

@end
