//
//  VolumeViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/1/5.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "VolumeViewController.h"
#import "Constants.h"
#import "JuanTableView.h"
#import "VolumeContentViewController.h"
#import "CYLTabBarController.h"
#import "FMDBHelper.h"
#define scrollViewH self.view.frame.size.height-20.0

@interface VolumeViewController ()<JuanTableViewDelegate>

@end

@implementation VolumeViewController{
    JuanTableView *_juanTableV;
    float  _scrollHight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[FMDBHelper shareInstance] createVolumeTable];
    self.navigationItem.titleView = [self titleView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.navigationController) {
        _juanTableV=[[JuanTableView alloc]initWithFrame:CGRectMake(0, 64.0, self.view.frame.size.width, scrollViewH) delegate:self];
    }else{
        _juanTableV=[[JuanTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,scrollViewH+64.0) delegate:self];
    }
    [self.view addSubview:_juanTableV];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_juanTableV.frame.origin.y==20.0) {
        [self.navigationController.navigationBar setCenter:CGPointMake(self.view.frame.size.width/2.0, -22)];
        [self hiddenTabBarWithAnimation:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setCenter:CGPointMake(self.view.frame.size.width/2.0, 42.0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)tableViewSelecte:(Juancle *)art{
    if (self.navigationController.navigationBar.center.y==-22.0) {
        [self.navigationController.navigationBar setCenter:CGPointMake(self.view.frame.size.width/2.0, 42.0)];
    }
    VolumeContentViewController *ductViewC = [[VolumeContentViewController alloc] init];
//    UIStoryboard *mainStroy=[UIStoryboard storyboardWithName:@"Volume" bundle:nil];
//    VolumeContentViewController *ductViewC=[mainStroy instantiateViewControllerWithIdentifier:@"com.mdb.VolumeContViewC"];
    ductViewC.juancle=art;
    [self.navigationController pushViewController:ductViewC animated:YES];
}
-(void)scrollViewfrom:(float)hight isend:(BOOL)isend{
    if (isend) {
        
    }else{
        if (hight>_scrollHight) {//向下滑动
       
            
            if (self.navigationController.navigationBar.center.y!=-22.0) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.navigationController.navigationBar setCenter:CGPointMake(self.view.frame.size.width/2.0, -22)];
                    _juanTableV.frame=CGRectMake(0, 20.0, self.view.frame.size.width, scrollViewH);
                }];
                [self hiddenTabBarWithAnimation:YES];
            }
        }else{
            if (self.navigationController.navigationBar.center.y!=42.0) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.navigationController.navigationBar setCenter:CGPointMake(self.view.frame.size.width/2.0, 42.0)];
                    _juanTableV.frame=CGRectMake(0, 64.0, self.view.frame.size.width, scrollViewH);
                }];
                [self showTabBarWithAnimation:YES];
            }
        }
        
    }
    
    _scrollHight=hight;

}


-(UIView *)titleView{
    
    UIView *vies=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    UITapGestureRecognizer *tapg=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(naviTap)];
    tapg.numberOfTapsRequired=1;
    tapg.numberOfTouchesRequired=1;
    [vies addGestureRecognizer:tapg];
    UILabel *labes=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    labes.text=@"领券";
    labes.textColor=[UIColor blackColor];
    labes.textAlignment=NSTextAlignmentCenter;
    [vies addSubview:labes];
    return vies;
}
-(void)naviTap{
    [_juanTableV tablevietoTop];
}

- (void)hiddenTabBarWithAnimation:(BOOL)isAnimation{
    CGFloat durationTime = 0.00;
    if (isAnimation) {
        durationTime = 0.5;
    }else{
        durationTime = 0;
    }
    if ([self.parentViewController.parentViewController isKindOfClass:[CYLTabBarController class]]) {
        CYLTabBarController *tabBarVc=(CYLTabBarController *)self.parentViewController.parentViewController;
        [UIView animateWithDuration:durationTime animations:^{
            tabBarVc.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)+5, CGRectGetWidth(self.view.frame), CGRectGetHeight(tabBarVc.tabBar.frame));
        } completion:^(BOOL finished) {
            tabBarVc.tabBar.hidden = YES;
        }];
    }
}

- (void)showTabBarWithAnimation:(BOOL)isAnimation{
    CGFloat durationTime = 0.00;
    if (isAnimation) {
        durationTime = 0.5;
    }else{
        durationTime = 0;
    }
    if ([self.parentViewController.parentViewController isKindOfClass:[CYLTabBarController class]]) {
        CYLTabBarController *tabBarVc=(CYLTabBarController *)self.parentViewController.parentViewController;
        __block CGRect barFrame = tabBarVc.tabBar.frame;
        if (CGRectGetMinY(barFrame) == CGRectGetHeight(self.view.frame)-CGRectGetHeight(barFrame)) {
            barFrame.origin.y = CGRectGetHeight(self.view.frame)+CGRectGetHeight(barFrame);
            tabBarVc.tabBar.frame = barFrame;
            tabBarVc.tabBar.hidden = YES;
        }
        [UIView animateWithDuration:durationTime animations:^{
            barFrame.origin.y = CGRectGetHeight(self.view.frame)-CGRectGetHeight(barFrame);
            tabBarVc.tabBar.frame = barFrame;
            tabBarVc.tabBar.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

@end
