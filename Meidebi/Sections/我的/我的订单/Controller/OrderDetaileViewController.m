//
//  OrderDetaileViewController.m
//  Meidebi
//  订单详情
//  Created by mdb-losaic on 2018/4/8.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "OrderDetaileViewController.h"

#import "OrderDetaileView.h"

#import "DaiGouXiaDanViewController.h"

#import "DaiGouZhiFuViewController.h"

#import "PaySuccessViewController.h"

#import "DaiGouZhiFuViewController.h"

#import "MyOrderMainViewController.h"

#import "ProductInfoViewController.h"

#import "GoodsCarViewController.h"

#import "MyOrderSearchListTableViewController.h"

@interface OrderDetaileViewController ()<OrderDetaileViewDelegate>
{
    
    OrderDetaileView *orderview;
    
    NSString *stryichangxinxi;
    
}
@end

@implementation OrderDetaileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    orderview = [[OrderDetaileView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight)];
    [orderview setDelegate:self];
    [self.view addSubview:orderview];
    [orderview bindData:_strid bindorderno:_strorderno];
    
    
    [self setNavBarBackBtn];
    
    
    
    
}



- (void)setNavBarBackBtn{
    //    UIImage *backButtonImage = [[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.navigationController.navigationBar.backIndicatorImage = backButtonImage;
    //    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backButtonImage;
    
    
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
}


-(void)rightnav
{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,5,64,34);
    [btnright setTitle:@"异常详情" forState:UIControlStateNormal];
    [btnright setTitleColor:RadMenuColor forState:UIControlStateNormal];
    [btnright.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright addTarget:self action:@selector(doClickrightAction) forControlEvents:UIControlEventTouchUpInside];
//    [btnright.layer setMasksToBounds:YES];
//    [btnright.layer setCornerRadius:3];
//    [btnright.layer setBorderColor:RadMenuColor.CGColor];
//    [btnright.layer setBorderWidth:1];
//    [btnright.titleLabel setTextAlignment:NSTextAlignmentCenter];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)doClickrightAction
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"订单异常信息" message:stryichangxinxi delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alter show];
}

- (void)doClickBackAction{
    
    NSArray *arrvcs = self.navigationController.viewControllers;
    for(UIViewController *vc in arrvcs)
    {
        if([vc isKindOfClass:[MyOrderSearchListTableViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    for(UIViewController *vc in arrvcs)
    {
        if ([vc isKindOfClass:[MyOrderMainViewController class]])
        {
            //            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"orderlistchange"];
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    for(UIViewController *vc in arrvcs)
    {
        if([vc isKindOfClass:[GoodsCarViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    for(UIViewController *vc in arrvcs)
    {
        if([vc isKindOfClass:[ProductInfoViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    /*
    
    UIViewController *vc2 = arrvcs[arrvcs.count-2];
    if([vc2 isKindOfClass:[PaySuccessViewController class]])
    {
        UIViewController *vc4 = arrvcs[arrvcs.count-4];
        if([vc4 isKindOfClass:[DaiGouXiaDanViewController class]])
        {
            UIViewController *vc5 = arrvcs[arrvcs.count-5];
            [self.navigationController popToViewController:vc5 animated:YES];
        }
        else
        {
            
            [self.navigationController popToViewController:vc4 animated:YES];
        }
    }
    else if([vc2 isKindOfClass:[DaiGouZhiFuViewController class]])
    {
        UIViewController *vc3 = arrvcs[arrvcs.count-3];
        if([vc3 isKindOfClass:[DaiGouXiaDanViewController class]])
        {
            UIViewController *vc4 = arrvcs[arrvcs.count-4];
            [self.navigationController popToViewController:vc4 animated:YES];
        }
        else
        {
            
            [self.navigationController popToViewController:vc3 animated:YES];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    */
    
}

#pragma mark - OrderDetaileViewDelegate
-(void)orderdetailAction
{
    [self doClickBackAction];
}

-(void)orderYiChangMessage:(NSString *)message
{
    [self rightnav];
    stryichangxinxi = message;
    
    NSMutableArray *arrbldj = [[NSUserDefaults standardUserDefaults] objectForKey:@"dingdanyichangyidianji"];
    NSMutableArray *arrtemp = [NSMutableArray new];
    [arrtemp addObjectsFromArray:arrbldj];
    BOOL isbool = [arrtemp containsObject: [NSString stringWithFormat:@"%@", _strid]];
    if(isbool==NO)
    {
        [arrtemp insertObject:[NSString stringWithFormat:@"%@",_strid] atIndex:0];
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"订单异常信息" message:stryichangxinxi delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        [[NSUserDefaults standardUserDefaults] setObject:arrtemp forKey:@"dingdanyichangyidianji"];
    }
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
