//
//  ShareSpotViewController.m
//  mdb
//
//  Created by 杜非 on 14/12/29.
//  Copyright (c) 2014年 meidebi. All rights reserved.
//

#import "ShareSpotViewController.h"
#import "FMDBHelper.h"
#import "ShareTableView.h"
#import "ShareContViewController.h"
#import "UpShareViewController.h"
#import "VKLoginViewController.h"
#import <CYLTabBarController/CYLTabBarController.h>
#import "MDB_UserDefault.h"
#define scrollViewH self.view.frame.size.height-64-50

static CGFloat const kTabBarTopPadding = 12;  // default 5

@interface ShareSpotViewController ()<ShareTableViewDelegate>

@property(nonatomic,strong)UISegmentedControl *segementControl;
@property(nonatomic,assign)int         isHot;
@property(nonatomic,strong)ShareTableView     *shareTableV;
@property(nonatomic,strong)ShareTableView     *shareTowTableV;
@property(nonatomic,strong)UIButton           *butYuan;
@end

@implementation ShareSpotViewController{
    float  _scrollHight;
}

@synthesize segementControl=_segementControl;
@synthesize isHot=_isHot;
@synthesize shareTableV=_shareTableV;
@synthesize shareTowTableV=_shareTowTableV;
@synthesize butYuan=_butYuan;

- (void)viewDidLoad {
    [super viewDidLoad];
    _isHot=1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [self titleView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self rightBarButton];
//    [self setNavigation];
    [self setTableViewsishot];
    [[FMDBHelper shareInstance] createMarkeTable];
    _butYuan=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-16.0-44.0, self.view.frame.size.height-30.0-44.0-50, 44.0, 44.0)];
    [_butYuan addTarget:self action:@selector(butSeletctYuan) forControlEvents:UIControlEventTouchUpInside];
    [_butYuan setBackgroundImage:[UIImage imageNamed:@"saidan.png"] forState:UIControlStateNormal];
    [_butYuan setBackgroundImage:[UIImage imageNamed:@"saidan-click.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_butYuan];

   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (_shareTableV.frame.origin.y==20.0) {
//        [self.navigationController.navigationBar setCenter:CGPointMake(self.view.frame.size.width/2.0, -22)];
//        [self hiddenTabBarWithAnimation:NO];
//    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setCenter:CGPointMake(self.view.frame.size.width/2.0, 42.0)];
}

-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)doClickLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)butSeletctYuan{
    
    if ([MDB_UserDefault defaultInstance].usertoken) {
        UIStoryboard *mainStroy=[UIStoryboard storyboardWithName:@"Share" bundle:nil];
        UpShareViewController *ductViewC=[mainStroy instantiateViewControllerWithIdentifier:@"com.mdb.UpShareViewC"];
        [self.navigationController pushViewController:ductViewC animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==111||alertView.tag==110){
        if (buttonIndex==0) {
            VKLoginViewController*theViewController= [[VKLoginViewController alloc] init];
            [self.navigationController pushViewController:theViewController animated:YES ];
        }
    }
    
}

-(void)setTableViewsishot{
    CGRect rects;
    if (_isHot==1) {
    if (!_shareTableV) {
        rects=CGRectMake(0, 64, self.view.frame.size.width, scrollViewH);//+47
        _shareTableV=[[ShareTableView alloc]initWithFrame:rects  isHot:YES delegate:self];
        [self.view addSubview:_shareTableV];
        [self.view bringSubviewToFront:_butYuan];
    }else{
        [self.view bringSubviewToFront:_shareTableV];
        [self.view bringSubviewToFront:_butYuan];
        }
    }else{
        if (!_shareTowTableV) {
            rects=CGRectMake(0, 64, self.view.frame.size.width, scrollViewH);//+47
            _shareTowTableV=[[ShareTableView alloc]initWithFrame:rects isHot:NO delegate:self];
            [self.view addSubview:_shareTowTableV];
            [self.view bringSubviewToFront:_butYuan];
        }else {
            [self.view bringSubviewToFront:_shareTowTableV];
            [self.view bringSubviewToFront:_butYuan];
        }
    }
}

-(void)scrollViewfrom:(float)hight isend:(BOOL)isend{
//    if (isend) {
//        
//    }else{
//        if (hight>_scrollHight) {//向下滑动
//          
//            if (self.navigationController.navigationBar.center.y!=-22.0) {
//                
//                [UIView animateWithDuration:0.5 animations:^{
//                    [self.navigationController.navigationBar setCenter:CGPointMake(self.view.frame.size.width/2.0, -22)];
//                    
//                    _shareTableV.frame=CGRectMake(0, 20.0, self.view.frame.size.width, scrollViewH);
//                    if (_shareTowTableV) {
//                        _shareTowTableV.frame=CGRectMake(0, 20.0, self.view.frame.size.width, scrollViewH);
//                    }
//                }];
//                [self hiddenTabBarWithAnimation:YES];
//
//            }
//        }else{
//            if (self.navigationController.navigationBar.center.y!=42.0) {
//                [UIView animateWithDuration:0.5 animations:^{
//                    [self.navigationController.navigationBar setCenter:CGPointMake(self.view.frame.size.width/2.0, 42.0)];
//                    
//                    _shareTableV.frame=CGRectMake(0, 64.0, self.view.frame.size.width, scrollViewH);
//                    if (_shareTowTableV) {
//                        _shareTowTableV.frame=CGRectMake(0, 64.0, self.view.frame.size.width, scrollViewH);
//                    }
//                }];
//                [self showTabBarWithAnimation:YES];
//            }
//        }
//        
//    }
//    
//    _scrollHight=hight;
}
-(void)tableViewSelecte:(Sharecle *)art{
    UIStoryboard *mainStroy=[UIStoryboard storyboardWithName:@"Share" bundle:nil];
    ShareContViewController *ductViewC=[mainStroy instantiateViewControllerWithIdentifier:@"com.mdb.ShareContViewC"];
    ductViewC.share=art;
//    if (self.navigationController.navigationBar.center.y==-22.0) {
//        [self.navigationController.navigationBar setCenter:CGPointMake(self.view.frame.size.width/2.0, 42.0)];
//    }
    [self.navigationController pushViewController:ductViewC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIView *)titleView{
    
    UIView *vies=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    UITapGestureRecognizer *tapg=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(naviTap)];
    tapg.numberOfTapsRequired=1;
    tapg.numberOfTouchesRequired=1;
    [vies addGestureRecognizer:tapg];
    UILabel *labes=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    
    labes.text=@"原创";
    labes.textColor=[UIColor blackColor];
    labes.textAlignment=NSTextAlignmentCenter;
    [vies addSubview:labes];
    return vies;
}
-(void)naviTap{
    if(_isHot){
        [_shareTableV tablevietoTop];
    }else{
        [_shareTowTableV tablevietoTop];
    }

}
-(void)rightBarButton{
    _segementControl=[[UISegmentedControl alloc]initWithItems:@[@"精华",@"最新"]];
    [_segementControl setFrame:CGRectMake(0, 20, 80, 28)];//80,32
    [_segementControl setTintColor:RadMenuColor];
    [_segementControl.layer setMasksToBounds:YES];
    [_segementControl.layer setCornerRadius:4.0];
    [_segementControl.layer setBorderWidth:1.0];
    [_segementControl.layer setBorderColor:RadMenuColor.CGColor];
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_segementControl];
    if (_isHot==0) {
        _segementControl.selectedSegmentIndex=1;
    }else{
        _segementControl.selectedSegmentIndex=0;
    }
    [_segementControl addTarget:self action:@selector(segebtnValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceBarItem.width = -5;
    self.navigationItem.rightBarButtonItems = @[spaceBarItem,rightBarButtonItem];
}

-(void)segebtnValueChanged:(UISegmentedControl *)sender{
    
    if (sender.selectedSegmentIndex==0) {
        _isHot=1;
        [self setTableViewsishot];
    }else if(sender.selectedSegmentIndex==1){
        _isHot=0;
      [self setTableViewsishot];
    }
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
            tabBarVc.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)+kTabBarTopPadding, CGRectGetWidth(self.view.frame), CGRectGetHeight(tabBarVc.tabBar.frame));
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
