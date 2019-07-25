//
//  SettingViewController.m
//  Meidebi
//  设置
//  Created by fishmi on 2017/6/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SettingViewController.h"
#import "MDB_UserDefault.h"
#import "MDB_ShareExstensionUserDefault.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "PersonalInfoViewController.h"
#import "VKLoginViewController.h"
#import "HTTPManager.h"

#import "RetrievePasswordViewController.h"

#import "MDBPGGWebViewController.h"

#import "BangDingSheJiaoAccountViewController.h"

#import "PushSetingViewControoler.h"

#import "AccountAndSecurityViewController.h"


@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,assign) BOOL needUpdate;
@property (nonatomic ,strong) NSArray *tableArray;
@property (nonatomic ,weak) UIButton *quitBtn;
@property (nonatomic ,weak) UILabel *versionLabel;
@property (nonatomic, strong) UITableView *tableV;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationTitle];
    NSArray *array = @[@"个人资料",@"绑定社交账号",@"版本更新",@"非wifi不显示图片",@"清除缓存",@"给个好评"];//@[@"个人资料",@"修改密码",@"绑定社交账号",@"版本更新",@"清除缓存",@"给个好评"];
    
    if([[MDB_UserDefault defaultInstance] telphone].length == 11||[[MDB_UserDefault defaultInstance] userName].length>0 || [[MDB_UserDefault defaultInstance] emailcomfirm].intValue==1)
    {
        array = @[@"个人资料",@"绑定社交账号",@"账户与安全",@"版本更新",@"非wifi不显示图片",@"清除缓存",@"给个好评"];
    }
    
    
    _tableArray = array;
    UITableView *tableV = [[UITableView alloc] init];
    tableV.bounces= NO;
    [self.view addSubview: tableV];
    [tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _tableV = tableV;
    
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableV setShowsVerticalScrollIndicator:NO];
    [tableV setShowsHorizontalScrollIndicator:NO];
    [tableV setBounces:YES];
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 160)];
    tableV.tableFooterView = footV;
    
    
    UIButton *quitBtn = [[UIButton alloc] init];
    [quitBtn addTarget:self action:@selector(onloadbutAction) forControlEvents:UIControlEventTouchUpInside];
    [quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:RadMenuColor];
    [quitBtn.layer setMasksToBounds:YES];
    [quitBtn.layer setCornerRadius:3]; //设置矩形四个圆角半径
    [footV addSubview:quitBtn];
    [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footV);
        make.top.offset(40*kScale);
        make.size.mas_offset(CGSizeMake(kMainScreenW-50, 45 * kScale));
    }];
    _quitBtn = quitBtn;
    if ([MDB_UserDefault getIsLogin]) {
        quitBtn.hidden = NO;
    }else{
        quitBtn.hidden = YES;
    }
    
    UIButton *btyingshi = [[UIButton alloc] init];
    [btyingshi addTarget:self action:@selector(yingshiAction) forControlEvents:UIControlEventTouchUpInside];
    [btyingshi setTitle:@"隐私政策" forState:UIControlStateNormal];
    [btyingshi setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [btyingshi.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [footV addSubview:btyingshi];
    
    [btyingshi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footV);
        make.bottom.equalTo(footV).offset(- 20 *kScale);
        make.size.mas_offset(CGSizeMake(100 * kScale, 30 * kScale));
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([MDB_UserDefault getIsLogin]) {
        _quitBtn.hidden = NO;
    }else{
        _quitBtn.hidden = YES;
    }
    [self inspectionVersion];
}

- (void)setNavigationTitle{
    self.title = @"设置";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}] ;
}

- (void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableArray.count;
}
///@[@"个人资料",@"绑定社交账号",@"账户与安全",@"版本更新",@"推送设置",@"非wifi不显示图片",@"清除缓存",@"给个好评"]
///@[@"个人资料",@"绑定社交账号",@"版本更新",@"推送设置",@"非wifi不显示图片",@"清除缓存",@"给个好评"];
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = _tableArray[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *lineV = [[UIView alloc] init];
    [cell addSubview:lineV];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell);
        make.height.offset(1);
    }];
    if(_tableArray.count==7)
    {
        if (indexPath.row == 0||indexPath.row == 1||indexPath.row == 2||indexPath.row == 6) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 3){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *versionLabel = [[UILabel alloc] init];
            versionLabel.text = @"1";
            versionLabel.textAlignment = NSTextAlignmentRight;
            versionLabel.font = [UIFont systemFontOfSize:14];
            versionLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            [cell addSubview:versionLabel];
            [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).offset(-38 *kScale);
                make.left.equalTo(cell).offset(10);
            }];
            _versionLabel = versionLabel;
            
            NSString *appVersion =[[MDB_UserDefault defaultInstance] applicationVersion];
            versionLabel.text=[NSString stringWithFormat:@"Ver.%@",appVersion];
            //        if (_needUpdate) {
            //            cell.userInteractionEnabled = YES;
            //        }else{
            //            cell.userInteractionEnabled = NO;
            //        }
        }else if (indexPath.row == 4){
            
            UISwitch *cellSwitch = [[UISwitch alloc] init];
            cellSwitch.on=[[MDB_UserDefault defaultInstance]getPicMode_switch];
            [cellSwitch addTarget:self action:@selector(PicMode_switched:) forControlEvents:UIControlEventValueChanged];
            cellSwitch.tag=401;
            [cell addSubview:cellSwitch];
            [cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell);
                make.right.equalTo(cell).offset(-18);
                make.size.mas_equalTo(CGSizeMake(43 *kScale, 26 *kScale));
                
            }];
            
        }else if (indexPath.row == 5){
            UILabel *numLabel = [[UILabel alloc] init];
            numLabel.text = @"1";
            numLabel.textAlignment = NSTextAlignmentRight;
            numLabel.font = [UIFont systemFontOfSize:14];
            numLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            [cell addSubview:numLabel];
            [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).offset(-19 *kScale);
                make.left.equalTo(cell).offset(10);
            }];
            
            UIView *lineV = [[UIView alloc] init];
            [cell addSubview:lineV];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                float tmpSize=[[MDB_UserDefault defaultInstance] checkTmpSize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    numLabel.hidden = NO;
                    numLabel.text=[NSString stringWithFormat:@"%.2f M",tmpSize];
                });
            });
            
        }
    }
    else
    {
        
        if (indexPath.row == 0||indexPath.row == 1||indexPath.row == 5) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 2){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *versionLabel = [[UILabel alloc] init];
            versionLabel.text = @"1";
            versionLabel.textAlignment = NSTextAlignmentRight;
            versionLabel.font = [UIFont systemFontOfSize:14];
            versionLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            [cell addSubview:versionLabel];
            [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).offset(-38 *kScale);
                make.left.equalTo(cell).offset(10);
            }];
            _versionLabel = versionLabel;
            
            NSString *appVersion =[[MDB_UserDefault defaultInstance] applicationVersion];
            versionLabel.text=[NSString stringWithFormat:@"Ver.%@",appVersion];
            //        if (_needUpdate) {
            //            cell.userInteractionEnabled = YES;
            //        }else{
            //            cell.userInteractionEnabled = NO;
            //        }
        }else if (indexPath.row == 3){
            
            UISwitch *cellSwitch = [[UISwitch alloc] init];
            cellSwitch.on=[[MDB_UserDefault defaultInstance]getPicMode_switch];
            [cellSwitch addTarget:self action:@selector(PicMode_switched:) forControlEvents:UIControlEventValueChanged];
            cellSwitch.tag=401;
            [cell addSubview:cellSwitch];
            [cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell);
                make.right.equalTo(cell).offset(-18);
                make.size.mas_equalTo(CGSizeMake(43 *kScale, 26 *kScale));
                
            }];
            
        }else if (indexPath.row == 4){
            UILabel *numLabel = [[UILabel alloc] init];
            numLabel.text = @"1";
            numLabel.textAlignment = NSTextAlignmentRight;
            numLabel.font = [UIFont systemFontOfSize:14];
            numLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            [cell addSubview:numLabel];
            [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).offset(-19 *kScale);
                make.left.equalTo(cell).offset(10);
            }];
            
            UIView *lineV = [[UIView alloc] init];
            [cell addSubview:lineV];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                float tmpSize=[[MDB_UserDefault defaultInstance] checkTmpSize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    numLabel.hidden = NO;
                    numLabel.text=[NSString stringWithFormat:@"%.2f M",tmpSize];
                });
            });
            
        }
        
    }
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66 * kScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strtemp = _tableArray[indexPath.row];
    ///@[@"个人资料",@"绑定社交账号",@"账户与安全",@"版本更新",@"推送设置",@"非wifi不显示图片",@"清除缓存",@"给个好评"];
    if([strtemp isEqualToString:@"个人资料"])
    {
        if ([MDB_UserDefault getIsLogin]) {
            PersonalInfoViewController *personlInfoVc = [[PersonalInfoViewController alloc] init];
            [self.navigationController pushViewController:personlInfoVc animated:YES];
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请登录后再试"
                                                               delegate:self
                                                      cancelButtonTitle:Nil
                                                      otherButtonTitles:@"登录",@"取消", nil];
            [alertView setTag:100];
            [alertView show];
        }
    }
    else if ([strtemp isEqualToString:@"绑定社交账号"])
    {
        if ([MDB_UserDefault getIsLogin])
        {///绑定社交账号
            BangDingSheJiaoAccountViewController *bvc = [[BangDingSheJiaoAccountViewController alloc] init];
            [self.navigationController pushViewController:bvc animated:YES];
        }
        else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请登录后再试"
                                                               delegate:self
                                                      cancelButtonTitle:Nil
                                                      otherButtonTitles:@"登录",@"取消", nil];
            [alertView setTag:100];
            [alertView show];
        }
    }
    else if ([strtemp isEqualToString:@"账户与安全"])
    {
        ///账户与安全
        if ([MDB_UserDefault getIsLogin])
        {
            AccountAndSecurityViewController *rvc = [[AccountAndSecurityViewController alloc] init];
            [self.navigationController pushViewController:rvc animated:YES];
        }
        else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请登录后再试"
                                                               delegate:self
                                                      cancelButtonTitle:Nil
                                                      otherButtonTitles:@"登录",@"取消", nil];
            [alertView setTag:100];
            [alertView show];
        }
    }
    else if ([strtemp isEqualToString:@"版本更新"])
    {
        NSString *appStoreLink = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@",@"659197645"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreLink]];
    }
    else if ([strtemp isEqualToString:@"推送设置"])
    {
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        if (types==UIUserNotificationTypeNone) {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                          message:@"请到设置->通知中心->没得比开启推送服务!"
                                                         delegate:nil
                                                cancelButtonTitle:@"好"
                                                otherButtonTitles:nil];
            [alert show];
            return;
        }
        [MDB_UserDefault setPushKeywordsDate:[NSDate date]];
        UIStoryboard *Oneselfboard = [UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
        PushSetingViewControoler *signVc=[Oneselfboard instantiateViewControllerWithIdentifier:@"com.mdb.SignVC"];
        [self.navigationController pushViewController:signVc animated:YES];
    }
    else if ([strtemp isEqualToString:@"清除缓存"])
    {
        [[MDB_UserDefault defaultInstance] clearTmpPics];
        [MDB_UserDefault showNotifyHUDwithtext:@"已清空" inView:self.view];
        [tableView reloadData];
    }
    else if ([strtemp isEqualToString:@"给个好评"])
    {
        if(IOS_VERSION_7_OR_ABOVE){//7.0-7.0.6只会跳到下载页，共用一套评价链接
            if (@available(iOS 11.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@",@"659197645"]]];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=659197645"]];
            }
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=659197645"]];
        }
    }
}

-(void)PicMode_switched:(UISwitch *)sender{
    if (sender.tag==401) {
        BOOL boos=sender.isOn;
        [[MDB_UserDefault defaultInstance] setPicMode_swithc:boos];
    }
}

-(void)onloadbutAction{
    if ([MDB_UserDefault defaultInstance].usertoken) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您确定要退出登录吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView setTag:1000];
        [alertView show];
        
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [[MDB_UserDefault defaultInstance] setUserNil];
            [[MDB_ShareExstensionUserDefault defaultInstance] saveUserToken:@""];
            [_quitBtn setHidden:YES];
            //退出第三方登录
            [SSEThirdPartyLoginHelper logout:[SSEThirdPartyLoginHelper currentUser]];
            //消息清空
            [MDB_UserDefault setMessage:NO];
            NSInteger needPhone = 1;
            [MDB_UserDefault setNeedPhoneStatue:needPhone==1?YES:NO];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"weiduxiaoxinumpgg"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarnumessagenum" object:nil];
            [self backTo];
        }
        
    }else if(alertView.tag == 100){
        if (buttonIndex == 0) {
            VKLoginViewController *vkVc = [[VKLoginViewController alloc] init];
            [self.navigationController pushViewController:vkVc animated:YES];
        }
        
    }
    
}

- (void)inspectionVersion{
    NSDictionary *dic=@{@"version":[[MDB_UserDefault defaultInstance] applicationVersion]};
    [HTTPManager sendGETRequestUrlToService:URL_getversion
                    withParametersDictionry:dic
                                       view:nil
                             completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                                 if (responceObjct){
                                     NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                     NSDictionary *resultDict=[str JSONValue];
                                     if ([[NSString nullToString:resultDict[@"status"]] intValue] == 1) {
                                         if ([[NSString stringWithFormat:@"%@",resultDict[@"data"][@"needUpdate"]] isEqualToString:@"1"]) {
                                             _needUpdate = YES;
                                             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                                             [self.tableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                         }
                                     }
                                     
                                 }
                             }];
}


-(void)yingshiAction
{
    
    MDBPGGWebViewController *pvc = [[MDBPGGWebViewController alloc] init];
    pvc.strurl = @"https://www.meidebi.com/page/360.html";
    pvc.strtitle = @"隐私政策";
    [self.navigationController pushViewController:pvc animated:YES];
}

@end
