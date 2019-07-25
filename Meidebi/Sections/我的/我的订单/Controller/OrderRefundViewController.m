//
//  OrderRefundViewController.m
//  Meidebi
//  退款详情
//  Created by mdb-losaic on 2018/4/9.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "OrderRefundViewController.h"

#import "OrderRefundView.h"

#import "OrderRefundVCDataController.h"

#import "MDB_UserDefault.h"

@interface OrderRefundViewController ()
{
    
    OrderRefundView *ORView;
    
    OrderRefundVCDataController *dataControl;
    
}
@end

@implementation OrderRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款详情";
    
    ORView = [[OrderRefundView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight)];
    [self.view addSubview:ORView];
    
    dataControl = [[OrderRefundVCDataController alloc] init];
    
    NSDictionary *dicpush = @{@"order_id":_strorder_id,@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [dataControl requestDGHomeDataInView:self.view dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
       
//        NSLog(@"%@",dataControl.dicreuselt);
        if(state)
        {
            [ORView bindSubview:dataControl.dicreuselt];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
    }];
    
    
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
