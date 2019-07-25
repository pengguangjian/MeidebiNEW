//
//  TaskHomeViewController.m
//  Meidebi
//
//  Created by mdb-admin on 16/8/18.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "TaskHomeViewController.h"
#import "TaskHomeSubjectView.h"
#import "OneUserViewController.h"
#import "BrokeHomeViewController.h"
#import <CYLTabBarController/CYLTabBarController.h>
#import "UIImage+Extensions.h"
#import "TaskRuleViewController.h"
#import "MDB_UserDefault.h"
#import "UpShareViewController.h"
#import "VKLoginViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDKUI/SSUIShareActionSheetController.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
@interface TaskHomeViewController ()
<
TaskHomeSubjectViewDelegate,
UIAlertViewDelegate
>
@property (nonatomic, strong) TaskHomeSubjectView *subjectView;
@end

@implementation TaskHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要做任务";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigation];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _subjectView = [[TaskHomeSubjectView alloc] init];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectView.delegate = self;
    [MDB_UserDefault setClickTaskStatue:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_subjectView updateData];
}

-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setTitle:@"规则" forState:UIControlStateNormal];
    [btnright setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    btnright.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright addTarget:self action:@selector(respondsToNavRightBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

-(void)doClickLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToNavRightBtnEvent:(id)sender{
    TaskRuleViewController *ruleVc = [[TaskRuleViewController alloc] init];
    [self.navigationController pushViewController:ruleVc animated:YES];
}

- (void)shareApp{
    
    NSString *urlLink = [NSString stringWithFormat:@"%@Content-apptaskone.html?userid=%@",URL_HR,[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]];
   
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *images=[[UIImage imageNamed:@"icon120"] imageByScalingProportionallyToMinimumSize:CGSizeMake(120.0, 120.0)];
    NSArray* imageArray = @[images];
    [shareParams SSDKSetupShareParamsByText:@"没时间了，赶快戳进来"
                                     images:imageArray
                                        url:[NSURL URLWithString:urlLink]
                                      title:@"网购省钱没得比，好友叫您领红包了！"
                                       type:SSDKContentTypeAuto];
    
    [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"网购省钱没得比，好友叫您领红包了！%@",urlLink] title:nil image:images url:[NSURL URLWithString:urlLink] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    
    [shareParams SSDKSetupTencentWeiboShareParamsByText:[NSString stringWithFormat:@"网购省钱没得比，好友叫您领红包了！%@",urlLink] images:images latitude:0 longitude:0 type:SSDKContentTypeAuto];
    
    //2、分享
    [ShareSDK showShareActionSheet:self.view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {

                       case SSDKResponseStateSuccess:
                       {
                           [MDB_UserDefault setFinishShareDate:[NSDate date]];
                           [_subjectView updateData];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           
                           break;
                       }
                       default:
                           break;
                   }
               }];
}


-(void)gotoBaskVc{
    
    if ([MDB_UserDefault defaultInstance].usertoken) {
        [self.navigationController.navigationBar setCenter:CGPointMake(self.view.frame.size.width/2.0, 42.0)];
        UIStoryboard *mainStroy=[UIStoryboard storyboardWithName:@"Share" bundle:nil];
        UpShareViewController *ductViewC=[mainStroy instantiateViewControllerWithIdentifier:@"com.mdb.UpShareViewC"];
        [self.navigationController pushViewController:ductViewC animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        VKLoginViewController*theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
    }
}

#pragma mark - TaskHomeSubjectViewDelegate

- (void)taskHomeSubjectViewDidPressMoreCardBtn{
    [self cyl_popSelectTabBarChildViewControllerAtIndex:2];
}

- (void)taskHomeSubjectViewDelegate:(TaskHomeSubjectView *)subjectView
      didPressHandleTaskBtnWithType:(HandleTaskType)type{
    
    switch (type) {
        case HandleTaskTypeLogin:
        {
            [self cyl_popSelectTabBarChildViewControllerAtIndex:4 completion:^(__kindof UIViewController *selectedTabBarChildViewController) {
                OneUserViewController *userViewController = selectedTabBarChildViewController;
                [userViewController intoLoginVC];
            }];
        }
            break;
        
        case HandleTaskTypeShare:
        {
            [self shareApp];
        }
            break;

        case HandleTaskTypeShaiDan:
        {
            [self gotoBaskVc];
        }
            break;
            
        case HandleTaskTypeBroke:
        {
            BrokeHomeViewController *brokeHomeVc = [[BrokeHomeViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:brokeHomeVc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}


@end
