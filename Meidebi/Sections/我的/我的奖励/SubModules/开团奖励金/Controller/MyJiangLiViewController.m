//
//  MyJiangLiViewController.m
//  Meidebi
//  我的奖励
//  Created by mdb-losaic on 2018/7/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyJiangLiViewController.h"

#import "MyJiangLiView.h"
#import "JiangLiGuiZeViewController.h"

#import "MyJiangLiDataController.h"

#import "MDB_UserDefault.h"

@interface MyJiangLiViewController ()
{
    
    MyJiangLiView *jiangliView;
    
    MyJiangLiDataController *datacontroller;
    
}
@end

@implementation MyJiangLiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的奖励";
    [self drawrightButton];
    
    [self drawSubview];
    
}

-(void)drawrightButton
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-7];
    UIButton *butright=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    [butright addTarget:self action:@selector(rightBarBut) forControlEvents:UIControlEventTouchUpInside];
    [butright setTitle:@"奖励规则" forState:UIControlStateNormal];
    [butright setTitleColor:RGB(114, 114, 114) forState:UIControlStateNormal];
    [butright.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithCustomView:butright];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightBar];
    
}

-(void)rightBarBut
{
    
    JiangLiGuiZeViewController *jvc = [[JiangLiGuiZeViewController alloc] init];
    [self.navigationController pushViewController:jvc animated:YES];
    
    
}

-(void)drawSubview
{
    float ftopheith =  kStatusBarHeight+44;
    float fother = 34.0;
    if(ftopheith<66)
    {
        ftopheith = 64;
        fother = 0;
    }
    jiangliView = [[MyJiangLiView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight-fother)];
    [jiangliView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:jiangliView];
    
    datacontroller = [[MyJiangLiDataController alloc] init];
    
    [self getall];
    [self getlist];
    
    [self.view setBackgroundColor:RGB(246, 246, 246)];
    
    
}
///头部数据
-(void)getall
{
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString: [MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    [datacontroller requestLeiJiDataInView:self.view dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [jiangliView bindheaderValue:datacontroller.diccancleorder];
        }
        else
        {
//            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
    }];
    
    
}
///列表数据
-(void)getlist
{
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString: [MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    [datacontroller requestMouthDataInView:nil dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        [jiangliView bindListValue:datacontroller.arrcancleReason];
        if(state)
        {
//            [jiangliView bindListValue:datacontroller.arrcancleReason];
        }
        else
        {
            if(error!=nil)
            {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
            
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
