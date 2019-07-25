//
//  MyJiangLiMingXiViewController.m
//  Meidebi
//  奖励明细
//  Created by mdb-losaic on 2018/7/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyJiangLiMingXiViewController.h"

#import "MyJiangLiMingXiView.h"

@interface MyJiangLiMingXiViewController ()
{
    MyJiangLiMingXiView *jlmxView;
}
@end

@implementation MyJiangLiMingXiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"奖励明细";
    
    jlmxView = [[MyJiangLiMingXiView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight)];
    [self.view addSubview:jlmxView];
    
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
