//
//  OneUserMainItemsActionView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/8.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "OneUserMainItemsActionView.h"

#import <UMAnalytics/MobClick.h>

#import "MDB_UserDefault.h"

#import "ConversionViewController.h"

#import "DailyLottoViewController.h"

#import "MyTrackViewController.h"

#import "InviteFriendViewController.h"

#import "BindingUserInfoViewController.h"

#import "PushSetingViewControoler.h"

#import <YWFeedbackFMWK/YWFeedbackKit.h>

#import "AboutMDBViewController.h"

#import "SettingViewController.h"

#import "WoGuanZhuMainViewController.h"

#import "VKLoginViewController.h"

static NSString * const kAliFeedbackAppKey = @"23342874";

@interface OneUserMainItemsActionView ()<UIAlertViewDelegate>
{
    UIView *viewbottom;
    ///绑定手机红点
    UIView *viewbdred;
}

@property (nonatomic,retain) YWFeedbackKit *feedbackKit;

@property (nonatomic,retain) NSMutableArray *arrtitleAndimage;

@end

@implementation OneUserMainItemsActionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setdata];
        [self drawUI];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


-(void)setdata
{
    NSArray *arrtemp    = @[@{@"title":@"兑换",@"image":@"oneusermainitems_dh"},
                          @{@"title":@"抽奖",@"image":@"oneusermainitems_cj"},
                          @{@"title":@"足迹",@"image":@"oneusermainitems_zj"},
                          @{@"title":@"邀请好友",@"image":@"oneusermainitems_yqhy"},
                          @{@"title":@"我关注的",@"image":@"oneusermainitems_wgzd"},
                          @{@"title":@"绑定手机",@"image":@"oneusermainitems_bdsj"},
                          @{@"title":@"推送设置",@"image":@"oneusermainitems_tssz"},
                          @{@"title":@"意见反馈",@"image":@"oneusermainitems_yjfk"},
                          @{@"title":@"关于我们",@"image":@"oneusermainitems_gywm"},
                          @{@"title":@"设置",@"image":@"oneusermainitems_sz"},
                          ];
    _arrtitleAndimage = [NSMutableArray new];
    [_arrtitleAndimage addObjectsFromArray:arrtemp];
}

-(void)drawUI
{
    
    int iline = (int)_arrtitleAndimage.count/5;
    if(_arrtitleAndimage.count%5!=0)
    {
        iline+=1;
    }
    UIView *viewlast = nil;
    UIView *viewtop = nil;
    float fwitem = kMainScreenW/5.0;
    for(int i = 0; i<iline; i++)
    {
        if(i>0)
        {
            viewtop = viewlast;
            viewlast = nil;
        }
        for(int j = 0 ; j < 5;j++)
        {
            if(i*5+j>=_arrtitleAndimage.count)break;
            
            UIView *viewitem = [[UIView alloc] init];
            [self addSubview:viewitem];
            [viewitem mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if(viewlast == nil)
                {
                    make.left.offset(0);
                }
                else
                {
                    make.left.equalTo(viewlast.mas_right);
                }
                
                make.width.offset(fwitem);
                make.height.offset(fwitem*1.1);
                if(viewtop==nil)
                {
                    make.top.offset(0);
                }
                else
                {
                    make.top.equalTo(viewtop.mas_bottom);
                }
                
            }];
            viewlast = viewitem;
            [viewitem setTag:i*5+j];
            [self drawItem:viewitem andtitle:[_arrtitleAndimage[i*5+j] objectForKey:@"title"] andimage:[_arrtitleAndimage[i*5+j] objectForKey:@"image"]];
            [viewitem setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tapitem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)];
            [viewitem addGestureRecognizer:tapitem];
            
            if(i*5+j==5 && [[_arrtitleAndimage[i*5+j] objectForKey:@"title"] isEqualToString:@"绑定手机"])
            {
                viewbdred = [[UIView alloc] init];
                [viewbdred setBackgroundColor:[UIColor redColor]];
                [viewitem addSubview:viewbdred];
                [viewbdred mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(viewitem.mas_right).offset(-10*kScale);
                    make.top.offset(10*kScale);
                    make.width.offset(5);
                    make.height.offset(5);
                }];
                [viewbdred.layer setMasksToBounds:YES];
                [viewbdred.layer setCornerRadius:2.5];
            }
        }
    }
        
    viewbottom = viewlast;
    
    
}

-(void)drawItem:(UIView *)view andtitle:(NSString *)title andimage:(NSString *)imagestr
{
    
    UIImageView *image = [[UIImageView alloc] init];
    [image setImage:[UIImage imageNamed:imagestr]];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    [view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(25*kScale, 25*kScale));
        make.centerX.equalTo(view);
        make.centerY.equalTo(view).offset(-10);
    }];
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [lbtitle setText:title];
    [lbtitle setTextColor:RGB(177, 177, 177)];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(image.mas_bottom);
        make.height.offset(20);
    }];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewbottom.mas_bottom);
    }];
    
}

//- (void)setNeedPhone:(NSInteger)needPhone{
//    _needPhone = needPhone;
//    if (needPhone == 1) {
//        [self removeAllSubviews];
//        [self.arrtitleAndimage removeObjectAtIndex:4];
//        [self drawUI];
//    }
//
//}
-(void)loadViewUI
{
    [self removeAllSubviews];
    [self setdata];
    if ([MDB_UserDefault getIsLogin])
    {
        if([MDB_UserDefault needPhoneStatue])
        {
            [self drawUI];
            [viewbdred setHidden:NO];
        }
        else
        {
            if([[self.arrtitleAndimage[5] objectForKey:@"title"] isEqualToString:@"绑定手机"])
            {
                [self.arrtitleAndimage removeObjectAtIndex:5];
            }
            [self drawUI];
            [viewbdred setHidden:YES];
        }
    }
    else
    {
        [self drawUI];
       [viewbdred setHidden:YES];
    }
    
}

-(void)alterTishi
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请登录后再试"
                                                       delegate:self
                                              cancelButtonTitle:Nil
                                              otherButtonTitles:@"登录",@"取消", nil];
    [alertView setTag:111];
    [alertView show];
}

-(void)itemAction:(UIGestureRecognizer *)gesture
{
    
    NSString *strtemp = [_arrtitleAndimage[gesture.view.tag] objectForKey:@"title"];
    if([strtemp isEqualToString:@"兑换"])
    {
        if ([MDB_UserDefault getIsLogin] == NO) {
            [self alterTishi];
            return;
        }
        [MobClick event:@"wode_duihuan"];
        ConversionViewController *conversionVc = [[ConversionViewController alloc] init];
        [self.viewController.navigationController pushViewController:conversionVc animated:YES];
    }
    else if([strtemp isEqualToString:@"抽奖"])
    {
        if ([MDB_UserDefault getIsLogin] == NO) {
            [self alterTishi];
            return;
        }
        [MobClick event:@"zhuye_choujiang"];
        DailyLottoViewController *conversionVc = [[DailyLottoViewController alloc] init];
        [self.viewController.navigationController pushViewController:conversionVc animated:YES];
    }
    else if([strtemp isEqualToString:@"足迹"])
    {
        if ([MDB_UserDefault getIsLogin] == NO) {
            [self alterTishi];
            return;
        }
        MyTrackViewController *vc = [[MyTrackViewController alloc] init];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    else if([strtemp isEqualToString:@"邀请好友"])
    {
        if ([MDB_UserDefault getIsLogin] == NO) {
            [self alterTishi];
            return;
        }
        [MobClick event:@"wode_yaoqing"];
        InviteFriendViewController *inviteFridendVc = [[InviteFriendViewController alloc] init];
        [self.viewController.navigationController pushViewController:inviteFridendVc animated:YES];
    }
    else if([strtemp isEqualToString:@"我关注的"])
    {
        if ([MDB_UserDefault getIsLogin] == NO) {
            [self alterTishi];
            return;
        }
        WoGuanZhuMainViewController *tvc = [[WoGuanZhuMainViewController alloc] init];
        [self.viewController.navigationController pushViewController:tvc animated:YES];
    }
    else if([strtemp isEqualToString:@"绑定手机"])
    {
        if ([MDB_UserDefault getIsLogin] == NO) {
            [self alterTishi];
            return;
        }
        BindingUserInfoViewController *bindingUserInfoVc = [[BindingUserInfoViewController alloc] init];
        [self.viewController.navigationController pushViewController:bindingUserInfoVc animated:YES];
    }
    else if([strtemp isEqualToString:@"推送设置"])
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
        [self.viewController.navigationController pushViewController:signVc animated:YES];
    }
    else if([strtemp isEqualToString:@"意见反馈"])
    {
        if ([MDB_UserDefault getIsLogin] == NO) {
            [self alterTishi];
            return;
        }
        self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                     @"visitPath":@"个人中心->反馈",
                                     @"userid":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                     @"systemVeriosn":[NSString getSystemName]};
        
        //            __weak typeof weakSelf = self.viewController;
        [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
            if (viewController != nil) {
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
                [self.viewController presentViewController:nav animated:YES completion:nil];
                [viewController setCloseBlock:^(UIViewController *aParentController){
                    [aParentController dismissViewControllerAnimated:YES completion:nil];
                }];
            } else {
                /** 使用自定义的方式抛出error时，此部分可以注释掉 */
                NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
                [MDB_UserDefault showNotifyHUDwithtext:title inView:self];
            }
        }];
    }
    else if([strtemp isEqualToString:@"关于我们"])
    {
        [MobClick event:@"wode_guanyu"];
        AboutMDBViewController *vc = [[AboutMDBViewController alloc] init];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    else if([strtemp isEqualToString:@"设置"])
    {
        SettingViewController *settingVc = [[SettingViewController alloc] init];
        [self.viewController.navigationController pushViewController:settingVc animated:YES];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111) {
        if (buttonIndex == 0) {
            VKLoginViewController *vc = [[VKLoginViewController alloc] init];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

#pragma mark - setters and getters
- (YWFeedbackKit *)feedbackKit{
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAliFeedbackAppKey];
    }
    return _feedbackKit;
}

@end
