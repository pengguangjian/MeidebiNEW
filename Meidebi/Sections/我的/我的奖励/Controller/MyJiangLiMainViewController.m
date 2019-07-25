//
//  MyJiangLiMainViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/24.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyJiangLiMainViewController.h"

#import "MyJiangLiViewController.h"

#import "MDB_UserDefault.h"

#import "MyGoodsCouponViewController.h"

@interface MyJiangLiMainViewController ()

@end

@implementation MyJiangLiMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的奖励";
    
    
    [self drawSubview];
    
}


-(void)drawSubview
{
    
    NSArray *arrimage = @[@"wodejiangli_shangpinquan",@"wodejiangli_kaituanjianglijin"];
    NSArray *arrtitle = @[@"商品券",@"开团奖励金"];
    NSArray *arrvalue = @[@"￥30.00",@"￥30.00"];
    
    for(int i = 0 ; i < arrimage.count; i++)
    {
        
        UIView *viewitem = [self drawitem:CGRectMake(0, kTopHeight+80*kScale*i, kMainScreenW, 80*kScale) andimage:arrimage[i] andtitle:arrtitle[i] andvalue:arrvalue[i]];
        [self.view addSubview:viewitem];
        [viewitem setTag:i];
        [viewitem setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapitem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)];
        [viewitem addGestureRecognizer:tapitem];
    }
    
//    float ftopheith =  kStatusBarHeight+44;
//    float fother = 60.0;
//    if(ftopheith<66)
//    {
//        ftopheith = 64;
//        fother = 45;
//    }
//    
//    
//    UIButton *btbottom = [[UIButton alloc] initWithFrame:CGRectMake(0, kMainScreenH-fother, kMainScreenW, fother)];
//    [btbottom setBackgroundColor:RGB(255, 236, 225)];
//    [btbottom setTitle:@"使用规则说明" forState:UIControlStateNormal];
//    [btbottom setTitleColor:RGB(227, 31, 0) forState:UIControlStateNormal];
//    [btbottom.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [btbottom addTarget:self action:@selector(bottomAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btbottom];
    
}

-(UIView *)drawitem:(CGRect)rect andimage:(NSString *)strimage andtitle:(NSString *)strtitle andvalue:(NSString *)strvalue
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, view.height*0.45, view.height*0.45)];
    [imagev setImage:[UIImage imageNamed:strimage]];
    [imagev setBackgroundColor:RGB(234, 234, 234)];
    [view addSubview:imagev];
    [imagev setContentMode:UIViewContentModeScaleAspectFit];
    [imagev setCenterY:view.height/2.0];
    
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(imagev.right+10, 0, 200, view.height)];
    [lbtitle setText:strtitle];
    [lbtitle setTextColor:RGB(30, 30, 30)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:lbtitle];
    
    
    UILabel *lbvalue = [[UILabel alloc] initWithFrame:CGRectMake(view.width-115, 0,70, view.height)];
//    [lbvalue setText:strvalue];
    [lbvalue setTextColor:RGB(30, 30, 30)];
    [lbvalue setTextAlignment:NSTextAlignmentRight];
    [lbvalue setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbvalue];
    
    UIImageView *imavnext =  [[UIImageView alloc] initWithFrame:CGRectMake(lbvalue.right+7, 0, 18, 18)];
    [imavnext setImage:[UIImage imageNamed:@"wodejiangli_next"]];
    [imavnext setBackgroundColor:RGB(234, 234, 234)];
    [imavnext setCenterY:view.height/2.0];
    [view addSubview:imavnext];
    
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, view.width, 1)];
    [viewline setBackgroundColor:RGB(235, 235, 235)];
    [view addSubview:viewline];
    
    return view;
}


-(void)itemAction:(UIGestureRecognizer *)gesture
{
    
    switch (gesture.view.tag) {
        case 0:
        {
            MyGoodsCouponViewController *mvc = [[MyGoodsCouponViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }
            break;
        case 1:
        {
            MyJiangLiViewController *mvc = [[MyJiangLiViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }
            break;
        default:
            break;
    }
    
}

-(void)bottomAction
{
    
    
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
