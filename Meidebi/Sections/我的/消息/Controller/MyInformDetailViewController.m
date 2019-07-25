//
//  MyInformDetailViewController.m
//  Meidebi
//
//  Created by fishmi on 2017/7/3.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "MyInformDetailViewController.h"
#import "MyInformDetailView.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import "PersonalInfoIndexViewController.h"
#import "ADHandleViewController.h"

#import "ProductInfoViewController.h"
#import "OriginalDetailViewController.h"
#import "VolumeContentViewController.h"
#import "CommentRewardsViewController.h"
#import "ActivityDetailViewController.h"
#import "OrderDetaileViewController.h"

#import "ConversionViewController.h"

#import "BrokeHomeViewController.h"

#import "PushYuanChuangViewController.h"

#import "MyInformMessageDataController.h"


@interface MyInformDetailViewController ()<MyInformDetailViewDelegate>
{
    
    MyInformMessageDataController *datacontrol;
    ///原创爆料url
    NSArray *arrbaoliaourl;
    
}
@end

@implementation MyInformDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationTitle];
//    [self setLeftBarButton];
    [self setUpSubView];
    [self loadData];
}

- (void)loadData{
    NSDictionary *dic = @{@"id" : [self.dataDic objectForKey:@"id"],
                       @"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_readmessage withParametersDictionry:dic view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
//                    [MDB_UserDefault showNotifyHUDwithtext:[dicAll objectForKey:@"data"] inView:self.view];
                    state = YES;
                
            }else{
                describle = [dicAll objectForKey:@"info"];
            }
        }
    }];
}



- (void)setUpSubView{
    MyInformDetailView *subView = [[MyInformDetailView alloc] init];
    [self.view addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    subView.dataDic = self.dataDic;
    subView.delegate = self;
}

- (void)setNavigationTitle{
    
    self.title = @"消息";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}] ;
}

//- (void)setLeftBarButton{
//    //    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    //    backBtn.frame = CGRectMake(0, 0, 20, 22);
//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 21)];
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [backBtn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backItem;
//
//}
//
//- (void)backTo{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)touchWithId:(NSString *)Id{
    PersonalInfoIndexViewController *personalInfoVc = [[PersonalInfoIndexViewController alloc] initWithUserID:Id];
    [self.navigationController pushViewController:personalInfoVc animated:YES];
}

-(void)webViewDidPresseeUrlWithLinkType:(NSString *)strtype andid:(NSString *)strid andurl:(NSString *)strurl
{
    NSString *type = strtype;
    NSString *productId = strid;
    if(strid.integerValue>0)
    {
        if ([[NSString nullToString:type] isEqualToString:@"1"]) {
            
            ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
            productInfoVc.productId = [NSString nullToString:productId];
            [self.navigationController pushViewController:productInfoVc animated:YES];
            
        }else if ([[NSString nullToString:type] isEqualToString:@"2"]){
            OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:productId];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([[NSString nullToString:type] isEqualToString:@"3"]){
            
            VolumeContentViewController *voluVc = [[VolumeContentViewController alloc] init];
            voluVc.juancleid = productId.integerValue;
            [self.navigationController pushViewController:voluVc animated:YES];
            
        }else if ([[NSString nullToString:type] isEqualToString:@"4"]){
            
            CommentRewardsViewController *commentRewardVc = [[CommentRewardsViewController alloc] init];
            commentRewardVc.activityId = productId;
            [self.navigationController pushViewController:commentRewardVc animated:YES];
            
        }else if ([[NSString nullToString:type] isEqualToString:@"5"]){
            
            ActivityDetailViewController *activityVc = [[ActivityDetailViewController alloc] init];
            activityVc.activityId = productId;
            [self.navigationController pushViewController:activityVc animated:YES];
            
        }
        else if ([[NSString nullToString:type] isEqualToString:@"7"]){
            OrderDetaileViewController *activityVc = [[OrderDetaileViewController alloc] init];
            activityVc.strid = productId;
            [self.navigationController pushViewController:activityVc animated:YES];
        }
        else if ([[NSString nullToString:type] isEqualToString:@"8"]){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"tabbarselectother" object:@"2"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else if ([[NSString nullToString:type] isEqualToString:@"9"]){
            ///发布原创  URL_Unboxing_orderShowDanData
            if(arrbaoliaourl.count>0)
            {
                PushYuanChuangViewController *pvc = [[PushYuanChuangViewController alloc] init];
                pvc.arrbaoliaourl = arrbaoliaourl;
                [self.navigationController pushViewController:pvc animated:YES];
            }
            else
            {
                
            }
            if(datacontrol==nil)
            {
                datacontrol = [[MyInformMessageDataController alloc] init];
            }
            NSDictionary *dicpush = @{@"id":strid,@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
            [datacontrol requestMyInformYuanChuangKaPianInView:self.view dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
                if(state)
                {
                    if(datacontrol.dicmessage != nil)
                    {
                        arrbaoliaourl = [datacontrol.dicmessage objectForKey:@"linkUrl"];
                        PushYuanChuangViewController *pvc = [[PushYuanChuangViewController alloc] init];
                        pvc.arrbaoliaourl = arrbaoliaourl;
                        [self.navigationController pushViewController:pvc animated:YES];

                    }
                    else
                    {
//                        [MDB_UserDefault showNotifyHUDwithtext:@"消息发生未知错误" inView:self.view];
                    }
                    
                }
                else
                {
                    [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                }
            }];
            
        }
        else if ([[NSString nullToString:type] isEqualToString:@"100"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"0"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else if ([[NSString nullToString:type] isEqualToString:@"101"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"1"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if ([[NSString nullToString:type] isEqualToString:@"102"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"3"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if ([[NSString nullToString:type] isEqualToString:@"103"]){
            
            ConversionViewController *cvc = [[ConversionViewController alloc] init];
            [self.navigationController pushViewController:cvc animated:YES];
            
            
        }
        else if ([[NSString nullToString:type] isEqualToString:@"104"]){
            BrokeHomeViewController *brokeVc = [[BrokeHomeViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:brokeVc animated:YES];
        }
        else
        {
            ADHandleViewController *webHandleVC = [[ADHandleViewController alloc] initWithAdLink:strurl];
            [self.navigationController pushViewController:webHandleVC animated:YES];
        }
    }
    else
    {
        if ([[NSString nullToString:type] isEqualToString:@"100"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"0"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else if ([[NSString nullToString:type] isEqualToString:@"101"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"1"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if ([[NSString nullToString:type] isEqualToString:@"102"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"3"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if ([[NSString nullToString:type] isEqualToString:@"103"]){
            ConversionViewController *cvc = [[ConversionViewController alloc] init];
            [self.navigationController pushViewController:cvc animated:YES];
        }
        else if ([[NSString nullToString:type] isEqualToString:@"104"]){
            BrokeHomeViewController *brokeVc = [[BrokeHomeViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:brokeVc animated:YES];
        }
        else
        {
            ADHandleViewController *webHandleVC = [[ADHandleViewController alloc] initWithAdLink:strurl];
            [self.navigationController pushViewController:webHandleVC animated:YES];
        }
    }
    
    
    
    
}

- (void)webViewDidPreseeUrlWithLink:(NSString *)link{
    
    NSString *type = [NSString nullToString:[self.dataDic objectForKey:@"fromtype"]];
    NSString *productId = [NSString nullToString:[self.dataDic objectForKey:@"fromid"]];
    
    
    
     if ([[NSString nullToString:type] isEqualToString:@"1"]) {
     
         ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
         productInfoVc.productId = [NSString nullToString:productId];
         [self.navigationController pushViewController:productInfoVc animated:YES];
     
     }else if ([[NSString nullToString:type] isEqualToString:@"2"]){
         OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:productId];
         [self.navigationController pushViewController:vc animated:YES];
     
     }else if ([[NSString nullToString:type] isEqualToString:@"3"]){
     
         VolumeContentViewController *voluVc = [[VolumeContentViewController alloc] init];
         voluVc.juancleid = productId.integerValue;
         [self.navigationController pushViewController:voluVc animated:YES];
     
     }else if ([[NSString nullToString:type] isEqualToString:@"4"]){
     
         CommentRewardsViewController *commentRewardVc = [[CommentRewardsViewController alloc] init];
         commentRewardVc.activityId = productId;
         [self.navigationController pushViewController:commentRewardVc animated:YES];
     
     }else if ([[NSString nullToString:type] isEqualToString:@"5"]){
     
         ActivityDetailViewController *activityVc = [[ActivityDetailViewController alloc] init];
         activityVc.activityId = productId;
         [self.navigationController pushViewController:activityVc animated:YES];
     
     }
    else if ([[NSString nullToString:type] isEqualToString:@"7"]){
        OrderDetaileViewController *activityVc = [[OrderDetaileViewController alloc] init];
        activityVc.strid = productId;
        [self.navigationController pushViewController:activityVc animated:YES];
    }
    else if ([[NSString nullToString:type] isEqualToString:@"8"]){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"tabbarselectother" object:@"2"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    else
    {
        ADHandleViewController *webHandleVC = [[ADHandleViewController alloc] initWithAdLink:link];
        [self.navigationController pushViewController:webHandleVC animated:YES];
    }
    
}

@end
