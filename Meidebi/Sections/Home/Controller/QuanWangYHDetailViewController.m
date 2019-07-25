//
//  QuanWangYHDetailViewController.m
//  Meidebi
//  全网优惠详情
//  Created by mdb-losaic on 2018/10/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "QuanWangYHDetailViewController.h"

#import "QuanWangYHDetailView.h"

@interface QuanWangYHDetailViewController ()
{
    QuanWangYHDetailView *view;
}
@end

@implementation QuanWangYHDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    
    [self btrightnav];
    
    [self drawSubview];
    
}

-(void)btrightnav
{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
    [btnright setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateHighlighted];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright addTarget:self action:@selector(doShareAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)drawSubview
{
    view = [[QuanWangYHDetailView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight) andid:_strid];
    [self.view addSubview:view];
}

-(void)doShareAction
{
    [view shareAction];
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
