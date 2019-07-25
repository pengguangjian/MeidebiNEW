//
//  OrderLogisticsViewController.m
//  Meidebi
//  查看物流
//  Created by mdb-losaic on 2018/4/9.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "OrderLogisticsViewController.h"
#import "OrderLogisticsView.h"

@interface OrderLogisticsViewController ()
{
    OrderLogisticsView *olView;
}
@end

@implementation OrderLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看物流";
    self.automaticallyAdjustsScrollViewInsets=NO;//scrollview预留空位
    
    olView = [[OrderLogisticsView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight)];
    [self.view addSubview:olView];
    [olView bindSubview:_strorder_id];
    
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
