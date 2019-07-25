//
//  OneUserMainView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/5.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "OneUserMainView.h"

#import "OneUserMainHeaderView.h"

#import "OneUserHeadFunctionView.h"

#import "OneUserMainMoneysView.h"

#import "OneUserMainItemsActionView.h"

#import "OneUserBottomView.h"

#import "MyOrderMainViewController.h"

#import "MyhouseViewController.h"

#import "MyShareViewController.h"

#import "MyBrokeNewsViewController.h"

#import "MyCouponsViewController.h"

#import <UMAnalytics/MobClick.h>

#import "OneUserShareBuyViewController.h"

#import "VKLoginViewController.h"

#import "MDB_UserDefault.h"

@interface OneUserMainView ()<OneUserHeadFunctionViewDelegate,UIAlertViewDelegate>
{
    UIScrollView *scvback;
    
    ///
    ///用户信息
    OneUserMainHeaderView *viewHeader;
    ///账户余额
    OneUserMainMoneysView *ommv;
    ////兑换
    OneUserMainItemsActionView *omiav;
    
}
@end

@implementation OneUserMainView

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
        [self drawSon];
    }
    return self;
}

-(void)drawSon
{
    scvback = [[UIScrollView alloc] init];
    [self addSubview:scvback];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
        make.width.offset(kMainScreenW);
        
    }];
    
    ///用户信息
    viewHeader = [[OneUserMainHeaderView alloc] init];
    [scvback addSubview:viewHeader];
    [viewHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(kMainScreenW);
        make.top.offset(0);
        make.height.offset(200);
    }];
    
    ///分享购买
    UIImageView *imageShare = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"oneuser_share_fanlibt"];
    [imageShare setImage:image];
    [scvback addSubview:imageShare];
    [imageShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.equalTo(viewHeader.mas_right).offset(-20);
        make.centerY.equalTo(viewHeader.mas_bottom);
        make.height.offset(image.size.height*(kMainScreenW-20)/image.size.width);
    }];
    [imageShare setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapshare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareAction)];
    [imageShare addGestureRecognizer:tapshare];
    
    OneUserHeadFunctionView *fucV = [[OneUserHeadFunctionView alloc] init];
    fucV.delegate = self;
    [scvback addSubview:fucV];
    [fucV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(imageShare.mas_bottom);
        if (iPhone4 || iPhone5) {
            make.height.offset(120*kScale);
        }else{
            make.height.offset(120);
        }
    }];
    
    UIView *viewline0 = [[UIView alloc] init];
    [viewline0 setBackgroundColor:RGB(246, 246, 246)];
    [scvback addSubview:viewline0];
    [viewline0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewHeader);
        make.height.offset(10);
        make.top.equalTo(fucV.mas_bottom);
    }];
    
    ///账户余额
    ommv = [[OneUserMainMoneysView alloc] init];
    [scvback addSubview:ommv];
    [ommv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewHeader);
        make.top.equalTo(viewline0.mas_bottom);
        make.height.offset(65);
    }];
    
    UIView *viewline1 = [[UIView alloc] init];
    [viewline1 setBackgroundColor:RGB(246, 246, 246)];
    [scvback addSubview:viewline1];
    [viewline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewHeader);
        make.height.offset(10);
        make.top.equalTo(ommv.mas_bottom);
    }];
    
    ////兑换
    omiav = [[OneUserMainItemsActionView alloc] init];
    [scvback addSubview:omiav];
    [omiav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewHeader);
        make.top.equalTo(viewline1.mas_bottom);
    }];
    
    UIView *viewline2 = [[UIView alloc] init];
    [viewline2 setBackgroundColor:RGB(246, 246, 246)];
    [scvback addSubview:viewline2];
    [viewline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewHeader);
        make.height.offset(10);
        make.top.equalTo(omiav.mas_bottom);
    }];
    
    ///
    OneUserBottomView *bottomV = [[OneUserBottomView alloc] init];
    [scvback addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(viewHeader);
        make.top.equalTo(viewline2.mas_bottom);
        make.height.offset(67*kScale);
        
    }];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomV.mas_bottom);
    }];
    
    
}
-(void)loadViewUI
{
    ////
//    ///用户信息
//    OneUserMainHeaderView *viewHeader;
//    ///账户余额
//    OneUserMainMoneysView *ommv;
//    ////兑换
//    OneUserMainItemsActionView *omiav;
    
    [viewHeader loadViewUI];
    [ommv loadViewUI];
    [omiav loadViewUI];
    
}

#pragma mark - 订单等点击
- (void)functionSelectbyButton: (UIButton *)btn
{
    
    if (btn.tag == 100){
        [MobClick event:@"wode_dingdan"];
        
        UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
        MyOrderMainViewController *myorder=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyorderViewC"];
        [self.viewController.navigationController pushViewController:myorder animated:YES];
    }
    else if (btn.tag == 101) {
        [MobClick event:@"wode_shoucang"];
        UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
        MyhouseViewController *mybrokenews=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyhouseViewC"];
        [self.viewController.navigationController pushViewController:mybrokenews animated:YES];
    }else if (btn.tag == 102){
        UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
        MyShareViewController *myshare=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyShareViewC"];
        [self.viewController.navigationController pushViewController:myshare animated:YES];
    }else if (btn.tag == 103){
        [MobClick event:@"wode_baoliao"];
        UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
        MyBrokeNewsViewController *mybrokenews=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyBrokeNewsViewC"];
        [self.viewController.navigationController pushViewController:mybrokenews animated:YES];
        
    }else if (btn.tag == 104){
        [MobClick event:@"wode_youhuiquan"];
        UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
        MyCouponsViewController *mybrokenews=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyCouponsVC"];
        [self.viewController.navigationController pushViewController:mybrokenews animated:YES];
    }
}

#pragma mark - 分享购买
-(void)shareAction
{
 
    if (![MDB_UserDefault getIsLogin]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:110];
        [alertView show];
    }
    else
    {
        OneUserShareBuyViewController *ovc = [[OneUserShareBuyViewController alloc] init];
        [self.viewController.navigationController pushViewController:ovc animated:YES];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 110) {
        if (buttonIndex == 0) {
            VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
            [self.viewController.navigationController pushViewController:theViewController animated:YES];
            
        }
        
    }
    
}

@end
