//
//  VolumeContentViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/2/2.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "VolumeContentViewController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import "CommentViewController.h"
#import "VKLoginViewController.h"
#import "RemarkHomeViewController.h"
#import "CompressImage.h"
#import "SVModalWebViewController.h"
#import "Qqshare.h"
#import "UIImage+Extensions.h"
#import "VolumeContentSubjectView.h"
#import "ConversionAlertView.h"
#import "WelfareHomeDataController.h"
#import "AddressListViewController.h"
#import "TaskRuleViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#import <CYLTabBarController/CYLTabBarController.h>

#import "AddressListModel.h"

@interface VolumeContentViewController ()
<
VolumeContentSubjectViewDelegate,
ConversionAlertViewDelegate,
AddressListViewControllerDelegate,
AddressListSelectViewControllerDelegate
>

@property (nonatomic, strong) ConversionAlertView *conversionAlertView;

@end

@implementation VolumeContentViewController{
    UIView              *_dockView;
    UIButton            *_GoBtn;
    NSMutableDictionary *_ContributionUrlDic;
    NSMutableDictionary *_dictData;
    Qqshare             *_qqshare;
    VolumeContentSubjectView    *_subjectView;
    NSDictionary        *_resultDict;
    
    NSString *strpresent_type;
    
    WelfareHomeDataController *dataController;
    
    AddressListModel *addressModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dictData=[[NSMutableDictionary alloc]init];
    _ContributionUrlDic=[[NSMutableDictionary alloc]init];
    [self setNavigation];
//    [self setDockView];
    [self loadJuanContentData];
    strpresent_type = @"0";
    _subjectView = [[VolumeContentSubjectView alloc] init];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 51, 0));
    }];
    _subjectView.delegate = self;
    
    UISwipeGestureRecognizer *right=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    right.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    UISwipeGestureRecognizer *left=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    left.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:left];
    
    if (_type == waresTypeMaterial) {
        self.title=@"礼品兑换";
        self.navigationItem.rightBarButtonItem = nil;
//        [_GoBtn setFrame:CGRectMake(50, 5, CGRectGetWidth(_dockView.frame)-100, 40)];
        
    }else{
        self.title=@"优惠券";
    }
    
    if(_present_type == 1)
    {
        if (_type == waresTypeMaterial)
        {
            [self setDockView:1 andisgongxian:NO];
        }
        else
        {
            [self setDockView:3 andisgongxian:NO];
        }
    }
    else if (_present_type == 2)
    {
        if (_type == waresTypeMaterial)
        {
            [self setDockView:1 andisgongxian:YES];
        }
        else
        {
            [self setDockView:3 andisgongxian:YES];
        }
    }
    else if (_present_type == 3)
    {
        if (_type == waresTypeMaterial)
        {
            [self setDockView:2 andisgongxian:YES];
        }
        else
        {
            [self setDockView:4 andisgongxian:YES];
        }
    }
    else
    {
        if (_type == waresTypeMaterial)
        {
            [self setDockView:1 andisgongxian:NO];
        }
        else
        {
            [self setDockView:3 andisgongxian:NO];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadJuanContentData{
    id strl=!_juancle?[NSString stringWithFormat:@"%@",@(_juancleid)]:_juancle.juanid;
    NSDictionary *dicURL=[MDB_UserDefault defaultInstance].usertoken?@{@"id":[NSString stringWithFormat:@"%@",strl],
                                                                       @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]}:@{@"id":[NSString stringWithFormat:@"%@",strl]};
    NSString *link = @"";
    if (_type == waresTypeCoupon) {
        link = URL_onecoupon;
    }else{
        link = URL_singlePresent;
    }
    
    [HTTPManager sendRequestUrlToService:link
                 withParametersDictionry:dicURL
                                    view:self.navigationController.view
                          completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dic=[str JSONValue];
            if ([[dic objectForKey:@"status"] integerValue] == 1) {
                if (_type == waresTypeCoupon) {
                    _resultDict=[[dic objectForKey:@"data"] objectForKey:@"coupon"];
                    [self loadde:_resultDict[@"id"]];
                    [self updateDocviewWith:_resultDict];
                    [_subjectView bindDataWithModel:_resultDict];
                }else{
                    _resultDict = dic[@"data"];
                    [_subjectView bindMaterialDataWithModel:_resultDict];
                }
            }else {
                [MDB_UserDefault showNotifyHUDwithtext:dic[@"info"] inView:self.view];
            }
            
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:@"网络错误" inView:self.view];
        }
    }];

}

-(void)loadde:(NSString *)pid{
    NSDictionary *dicr=@{@"id":[NSString nullToString:pid],@"type":@"1"};
    [HTTPManager sendGETRequestUrlToService:URL_getshare withParametersDictionry:dicr view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictr=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%@",[dictr objectForKey:@"info"]];
            if (info && [info isEqualToString:@"GET_DATA_SUCCESS"]) {
                if ([dictr objectForKey:@"data"]&&[[dictr objectForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *ss=[dictr objectForKey:@"data"];
                    [_ContributionUrlDic setObject:[ss objectForKey:@"url"] forKey:@"ContributionUrl"];
                    _qqshare=[[Qqshare alloc]initWithdic:ss];
                }
            }else{
                [_ContributionUrlDic setObject:[NSString stringWithFormat:@"%@-id-%@",URL_getshare,pid] forKey:@"ContributionUrl"];
            }
            
        }else{
            [_ContributionUrlDic setObject:[NSString stringWithFormat:@"%@-id-%@",URL_getshare,pid] forKey:@"ContributionUrl"];
        }
    }];
    
}

- (void)updateDocviewWith:(NSDictionary *)dict{
    UILabel *votesp=(UILabel *)[_dockView viewWithTag:22];//收藏
    votesp.text=[NSString stringWithFormat:@"%@",dict[@"favnum"]];
    
    UILabel *commentcount_lab=(UILabel *)[_dockView viewWithTag:33];//收藏
    commentcount_lab.text=[NSString stringWithFormat:@"%@",dict[@"commentcount"]];
    
    if ([MDB_UserDefault getIsLogin]) {
        if (dict[@"isfav"]&&[[NSString stringWithFormat:@"%@",dict[@"isfav"]]isEqualToString:@"1"]) {
            for (UIView *vies in [_dockView subviews]) {
                if (vies.tag==2) {
                    UIButton *buts=(UIButton *)vies;
                    [buts setImage:[UIImage imageNamed:@"shouchang_hou.png"] forState:UIControlStateNormal];
                    [buts setImage:[UIImage imageNamed:@"shouchang_hou.png"] forState:UIControlStateHighlighted];
                }
            }
        }
    }

}

-(void)handleSwipes:(UISwipeGestureRecognizer *)sender{
    if (sender.direction==UISwipeGestureRecognizerDirectionLeft) {
        [self comBtnClicked:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setImage:[UIImage imageNamed:@"fengxiang.png"] forState:UIControlStateNormal];
    [btnright setImage:[UIImage imageNamed:@"fengxiang_click.png"] forState:UIControlStateHighlighted];
    [btnright addTarget:self action:@selector(doShareAction) forControlEvents:UIControlEventTouchUpInside];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)doClickLeftAction:(UIButton *)sender{
//    [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)doShareAction{
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *images=[_subjectView.iconImageView.image imageByScalingProportionallyToMinimumSize:CGSizeMake(120.0, 120.0)];
    NSArray* imageArray = images==nil?@[]:@[images];
    if ([[NSString nullToString:_qqshare.qqsharecontent] isEqualToString:@""]) return;
    [shareParams SSDKSetupShareParamsByText:_qqshare.qqsharecontent
                                     images:imageArray
                                        url:[NSURL URLWithString:_qqshare.url]
                                      title:_qqshare.qqsharetitle
                                       type:SSDKContentTypeAuto];
    NSString *contentStr = [NSString stringWithFormat:@"%@%@",_qqshare.qqsharetitle,_qqshare.url];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentStr title:nil image:images url:[NSURL URLWithString:_qqshare.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    
    [shareParams SSDKSetupTencentWeiboShareParamsByText:contentStr images:images latitude:0 longitude:0 type:SSDKContentTypeAuto];
    //2、分享
    [ShareSDK showShareActionSheet:self.view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
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
////1 礼品兑换（1个按钮） 2礼品兑换（2个按钮） 3优惠券兑换（1个按钮） 4优惠券兑换（2个按钮） isgongxian:是否是贡献值兑换
-(void)setDockView:(int)type andisgongxian:(BOOL)isgongxian{
    _dockView=[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame)-50, self.view.frame.size.width, 50)];
    _dockView.backgroundColor=[UIColor  whiteColor];
    _dockView.layer.masksToBounds = YES;
    _dockView.layer.shadowPath =[UIBezierPath bezierPathWithRect:_dockView.bounds].CGPath;
    _dockView.clipsToBounds = NO;
    _dockView.layer.shadowColor = [[UIColor grayColor] CGColor];
    _dockView.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
    _dockView.layer.shadowOpacity = .5f;
    _dockView.layer.shadowRadius = .2f;
    _dockView.layer.shadowRadius=1;
    [self.view addSubview:_dockView];

    float h=CGRectGetWidth(self.view.frame)/2.0;

    if(type==1)
    {
        UIButton *GoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        if(isgongxian)
        {
            GoBtn.tag=99999;
            [GoBtn setTitle:@"贡献值兑换" forState:UIControlStateNormal];
        }
        else
        {
            GoBtn.tag=9999;
            [GoBtn setTitle:@"铜币兑换" forState:UIControlStateNormal];
        }
        
        [GoBtn setBackgroundColor:RadMenuColor];
        [GoBtn.layer setMasksToBounds:YES];
        [GoBtn.layer setCornerRadius:2.0];
        [GoBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [GoBtn setFrame:CGRectMake(h+34.0, 5,  100, 40)];
        [GoBtn addTarget:self action:@selector(GoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _GoBtn = GoBtn;
        [_GoBtn setFrame:CGRectMake(50, 5, CGRectGetWidth(_dockView.frame)-100, 40)];
        [_dockView addSubview:GoBtn];
        
    }
    else if (type == 2)
    {
        UIButton *GoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        GoBtn.tag=9999;
        [GoBtn setTitle:@"铜币兑换" forState:UIControlStateNormal];
        [GoBtn setBackgroundColor:RadMenuColor];
        [GoBtn.layer setMasksToBounds:YES];
        [GoBtn.layer setCornerRadius:2.0];
        [GoBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [GoBtn setFrame:CGRectMake(50, 5,(CGRectGetWidth(_dockView.frame)-100)/2.0-20, 40)];
        [GoBtn addTarget:self action:@selector(GoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_dockView addSubview:GoBtn];
        
        
        UIButton *GoBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
        GoBtn1.tag=99999;
        [GoBtn1 setTitle:@"贡献值兑换" forState:UIControlStateNormal];
        [GoBtn1 setBackgroundColor:RadMenuColor];
        [GoBtn1.layer setMasksToBounds:YES];
        [GoBtn1.layer setCornerRadius:2.0];
        [GoBtn1.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [GoBtn1 setFrame:CGRectMake(GoBtn.right+20, 5,(CGRectGetWidth(_dockView.frame)-100)/2.0-20, 40)];
        [GoBtn1 addTarget:self action:@selector(GoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_dockView addSubview:GoBtn1];
        
    }
    else if (type == 3)
    {
        UIButton *ruoBtn=[[UIButton alloc]initWithFrame:CGRectMake(h-115.0, 4,  44, 44)];
        [ruoBtn setTag:2];
        [ruoBtn setImage:[UIImage imageNamed:@"shouchang.png"] forState:UIControlStateNormal];
        [ruoBtn setImage:[UIImage imageNamed:@"shouchang_click.png"] forState:UIControlStateHighlighted];
        [ruoBtn addTarget:self action:@selector(ShouBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *comBtn=[[UIButton alloc]initWithFrame:CGRectMake(h-45.0, 3,  44, 44)];
        [comBtn setTag:3];
        [comBtn setImage:[UIImage imageNamed:@"pinglun.png"] forState:UIControlStateNormal];
        [comBtn setImage:[UIImage imageNamed:@"pinglun_click.png"] forState:UIControlStateHighlighted];
        [comBtn addTarget:self action:@selector(comBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *GoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if(isgongxian)
        {
            GoBtn.tag=99999;
            [GoBtn setTitle:@"贡献值兑换" forState:UIControlStateNormal];
        }
        else
        {
            GoBtn.tag=9999;
            [GoBtn setTitle:@"铜币兑换" forState:UIControlStateNormal];
        }
        [GoBtn setBackgroundColor:RadMenuColor];
        [GoBtn.layer setMasksToBounds:YES];
        [GoBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [GoBtn.layer setCornerRadius:2.0];
        [GoBtn setFrame:CGRectMake(h+34.0, 5,  100, 40)];
        [GoBtn addTarget:self action:@selector(GoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _GoBtn = GoBtn;
        
        UILabel *votesm=[[UILabel alloc] initWithFrame:CGRectMake(h-72, 3, 34, 44)];
        votesm.tag=22;
        votesm.backgroundColor=[UIColor clearColor];
        votesm.text=@"0";
        [votesm setTextColor:RadshuziColor];
        [_dockView addSubview:votesm];
        
        UILabel *commentcount_lab=[[UILabel alloc] initWithFrame:CGRectMake(h+8.0-10, 3, 34, 44)];
        commentcount_lab.tag=33;
        commentcount_lab.backgroundColor=[UIColor clearColor];
        commentcount_lab.text=@"0";
        [commentcount_lab setTextColor:RadshuziColor];
        [_dockView addSubview:commentcount_lab];
        
        [votesm setFont:[UIFont systemFontOfSize:13]];
        [commentcount_lab setFont:[UIFont systemFontOfSize:13]];
        [_dockView addSubview:ruoBtn];
        [_dockView addSubview:comBtn];
        [_dockView addSubview:GoBtn];
    }
    else if (type == 4)
    {
        UIButton *ruoBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 4,  44, 44)];
        [ruoBtn setTag:2];
        [ruoBtn setImage:[UIImage imageNamed:@"shouchang.png"] forState:UIControlStateNormal];
        [ruoBtn setImage:[UIImage imageNamed:@"shouchang_click.png"] forState:UIControlStateHighlighted];
        [ruoBtn addTarget:self action:@selector(ShouBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_dockView addSubview:ruoBtn];
        
        UILabel *votesm=[[UILabel alloc] initWithFrame:CGRectMake(ruoBtn.right, 3, 34, 44)];
        votesm.tag=22;
        votesm.backgroundColor=[UIColor clearColor];
        votesm.text=@"0";
        [votesm setTextColor:RadshuziColor];
        [_dockView addSubview:votesm];
        
        
        UIButton *comBtn=[[UIButton alloc]initWithFrame:CGRectMake(votesm.right, 3,  44, 44)];
        [comBtn setTag:3];
        [comBtn setImage:[UIImage imageNamed:@"pinglun.png"] forState:UIControlStateNormal];
        [comBtn setImage:[UIImage imageNamed:@"pinglun_click.png"] forState:UIControlStateHighlighted];
        [comBtn addTarget:self action:@selector(comBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_dockView addSubview:comBtn];
        
        UILabel *commentcount_lab=[[UILabel alloc] initWithFrame:CGRectMake(comBtn.right, 3, 34, 44)];
        commentcount_lab.tag=33;
        commentcount_lab.backgroundColor=[UIColor clearColor];
        commentcount_lab.text=@"0";
        [commentcount_lab setTextColor:RadshuziColor];
        [_dockView addSubview:commentcount_lab];
        
        float fbtwidth = (_dockView.width - commentcount_lab.right - 50)/2.0;
        
        UIButton *GoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        GoBtn.tag=9999;
        [GoBtn setTitle:@"铜币兑换" forState:UIControlStateNormal];
        [GoBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [GoBtn setBackgroundColor:RadMenuColor];
        [GoBtn.layer setMasksToBounds:YES];
        [GoBtn.layer setCornerRadius:2.0];
        [GoBtn setFrame:CGRectMake(commentcount_lab.right+10, 5,  fbtwidth, 40)];
        [GoBtn addTarget:self action:@selector(GoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _GoBtn = GoBtn;
        [_dockView addSubview:GoBtn];
        
        UIButton *GoBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
        GoBtn1.tag=99999;
        [GoBtn1 setTitle:@"贡献值兑换" forState:UIControlStateNormal];
        [GoBtn1 setBackgroundColor:RadMenuColor];
        [GoBtn1.layer setMasksToBounds:YES];
        [GoBtn1.layer setCornerRadius:2.0];
        [GoBtn1.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [GoBtn1 setFrame:CGRectMake(GoBtn.right+20, 5,fbtwidth, 40)];
        [GoBtn1 addTarget:self action:@selector(GoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_dockView addSubview:GoBtn1];
        
        
        [votesm setFont:[UIFont systemFontOfSize:13]];
        [commentcount_lab setFont:[UIFont systemFontOfSize:13]];
        
        
        
    }
    else
    {
        
        UIButton *GoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        GoBtn.tag=9999;
        [GoBtn setTitle:@"铜币兑换" forState:UIControlStateNormal];
        [GoBtn setBackgroundColor:RadMenuColor];
        [GoBtn.layer setMasksToBounds:YES];
        [GoBtn.layer setCornerRadius:2.0];
        [GoBtn setFrame:CGRectMake(h+34.0, 5,  100, 40)];
        [GoBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [GoBtn addTarget:self action:@selector(GoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _GoBtn = GoBtn;
        [_GoBtn setFrame:CGRectMake(50, 5, CGRectGetWidth(_dockView.frame)-100, 40)];
        [_dockView addSubview:GoBtn];
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==111||alertView.tag==110){
        if (buttonIndex==0) {
            [self jumpLoginVc];
        }
    }
    
}

- (void)jumpLoginVc{
    VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
    [self.navigationController pushViewController:theViewController animated:YES ];
}

-(void)GoBtnClicked:(UIButton *)sender{
    if ([MDB_UserDefault getIsLogin]) {
    
        if (_type == waresTypeCoupon) {
            if(sender.tag == 9999)
            {
                [self exchangedCoupon:1];
            }
            else
            {
                [self exchangedCoupon:2];
            }
            
        }else{
            NSString *title = [NSString stringWithFormat:@"你正在兑换“%@”",[NSString nullToString:_resultDict[@"title"]]];
            ConversionAlertType alertType;
            NSString *alertPlaceholderStr = nil;
            if ([_haveto isEqualToString:@"qq"]) {
                alertType = ConversionAlertVirtual;
                alertPlaceholderStr = @"请输入领取QQ号码";
            }else if ([_haveto isEqualToString:@"phone"]){
                alertType = ConversionAlertVirtual;
                alertPlaceholderStr = @"请输入领取手机号";
            }else if ([_haveto isEqualToString:@"address"]){
                alertType = ConversionAlertMaterial;
            }else{
                alertType = ConversionAlertNormal;
            }
            self.conversionAlertView.alertType = alertType;
            self.conversionAlertView.waresName = title;
            self.conversionAlertView.placeholderStr = alertPlaceholderStr;
            [self.conversionAlertView show];
            if(sender.tag == 9999)
            {
                strpresent_type = @"0";
            }
            else
            {
                strpresent_type = @"1";
            }
            
        }
        
    }else{
        [self jumpLoginVc];
    }

}

////1 铜币兑换 2贡献值兑换
- (void)exchangedCoupon:(int)typep{
//    NSString *userkey=[MDB_UserDefault defaultInstance].usertoken;
    NSString *stljuan=_juancle?[NSString stringWithFormat:@"%@",_juancle.juanid]:[NSString stringWithFormat:@"%@",@(_juancleid)];
//    NSDictionary *dicURL=@{@"id":stljuan,@"userkey":userkey};
//    NSString *urlStrr=URL_dealcoupon;
//    [HTTPManager  sendRequestUrlToService:urlStrr withParametersDictionry:dicURL view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
//        if (responceObjct) {
//            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
//            NSDictionary *dic=[str JSONValue];
//            NSString *infostr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
//            NSString *statusstr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
//            if ([infostr isEqualToString:@"GET_DATA_SUCCESS"]&&[statusstr isEqualToString:@"1"]) {
//                [MDB_UserDefault showNotifyHUDwithtext:[NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]] inView:self.view];
//            }else {
//
//                [MDB_UserDefault showNotifyHUDwithtext:[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] inView:self.view];
//            }
//        }else{
//            [MDB_UserDefault showNotifyHUDwithtext:@"兑换失败" inView:self.view];
//        }
//
//    }];
    
    strpresent_type = @"0";
    if(typep==2)
    {
        strpresent_type = @"1";
    }
    
     if(dataController == nil)
     {
         dataController = [[WelfareHomeDataController alloc] init];
     }
     
     NSString *type = @"";
     if (_type == waresTypeMaterial) {
         type = @"present";
     }else{
         type = @"coupon";
     }
     [dataController requestGiftExchangeDataWithView:self.view
                                              giftID:[NSString stringWithFormat:@"%@",stljuan]
                                                type:type
                                            userInfo:@""
                                        present_type:strpresent_type callback:^(NSError *error, BOOL state, NSString *describle) {
                                            
                                            
                                            if(state){
                                                if (_type == waresTypeMaterial)
                                                {
                                                    self.conversionAlertView.alertState = ConversionAlertStateSuccess;
                                                    self.conversionAlertView.alertDescribleStr = describle;
                                                    [self.conversionAlertView show];
                                                }
                                                else
                                                {///优惠券
                                                    
                                                    self.conversionAlertView.alertState = ConversionAlertStateSuccess;
                                                    self.conversionAlertView.alertDescribleStr = @"兑换成功，请在我的-优惠券里查看券码";
                                                    [self.conversionAlertView show];
                                                }
                                                
                                                
                                            }else{
                                                    if ([describle isEqualToString:@"铜币不足"]) {
                                                        self.conversionAlertView.alertState = ConversionAlertStateCopperFailure;
                                                    }else{
                                                        self.conversionAlertView.faultRemindStr = describle;
                                                        self.conversionAlertView.alertState = ConversionAlertStateFailure;
                                                    }
                                                    [self.conversionAlertView show];
                                                }
     }];
    

}

-(void)ShouBtnClicked:(UIButton *)sender{
    if ([MDB_UserDefault getIsLogin]) {
        UILabel *votesp=(UILabel *)[_dockView viewWithTag:22];//收藏
        
        NSString *userkey=[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
        NSString *junid=_juancleid?[NSString stringWithFormat:@"%@",@(_juancleid)]:[NSString stringWithFormat:@"%@",_juancle.juanid];
        NSDictionary *dicURL=@{@"id":junid,@"fetype":@"5",@"userkey":userkey};
        [HTTPManager  sendRequestUrlToService:URL_favorite withParametersDictionry:dicURL view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            if (responceObjct) {
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dic=[str JSONValue];
                if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"GET_DATA_SUCCESS"]&&[[dic objectForKey:@"status"] integerValue]) {
                    if ([[dic objectForKey:@"data"]isEqualToString:@"取消收藏成功！"]) {
                        votesp.text=[NSString stringWithFormat:@"%@",@([votesp.text integerValue]-1)];
                        float h=CGRectGetWidth(self.view.frame)/2.0;
                        UILabel * _labelCommend=[[UILabel alloc] init];
                        _labelCommend.frame=CGRectMake(h-95.0+15.0, 3.0, 25.0, 25.0);
                        _labelCommend.text=@"-1";
                        _labelCommend.alpha=0.0;
                        _labelCommend.textColor=[UIColor redColor];
                        [_dockView addSubview:_labelCommend];
                        
                        [sender setImage:[UIImage imageNamed:@"shouchang.png"] forState:UIControlStateNormal];
                        [sender setImage:[UIImage imageNamed:@"shouchang_click.png"] forState:UIControlStateHighlighted];
                        
                        CAAnimation *animation =[CompressImage groupAnimation:_labelCommend];
                        [_labelCommend.layer addAnimation:animation forKey:@"animations"];
                    }else{
                        votesp.text=[NSString stringWithFormat:@"%@",@([votesp.text integerValue]+1)];
                        float h=CGRectGetWidth(self.view.frame)/2.0;
                        UILabel *_labelCommend=[[UILabel alloc] init];
                        _labelCommend.frame=CGRectMake(h-95.0+15.0, 3.0, 25.0, 25.0);
                        _labelCommend.text=@"+1";
                        _labelCommend.alpha=0.0;
                        _labelCommend.textColor=[UIColor redColor];
                        [_dockView addSubview:_labelCommend];
                        [sender setImage:[UIImage imageNamed:@"shouchang_hou.png"] forState:UIControlStateNormal];
                        [sender setImage:[UIImage imageNamed:@"shouchang_hou.png"] forState:UIControlStateHighlighted];
                        CAAnimation *animation =[CompressImage groupAnimation:_labelCommend];
                        [_labelCommend.layer addAnimation:animation forKey:@"animations"];
                    }
                }else if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"YOUR_ARE_VOTEED"]){
                    [MDB_UserDefault showNotifyHUDwithtext:@"你已经收藏了" inView:self.view];
                }
            }
            
        }];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        
    }
}
-(void)comBtnClicked:(id)sender{
    RemarkHomeViewController *remarkHomeVc = [[RemarkHomeViewController alloc] init];
    remarkHomeVc.type = RemarkTypeCoupon;
    if (_juancle.juanid) {
        remarkHomeVc.linkid = [NSString stringWithFormat:@"%@",_juancle.juanid];
    }else{
        remarkHomeVc.linkid = [NSString stringWithFormat:@"%@",@(_juancleid)];
    }
    [self.navigationController pushViewController:remarkHomeVc animated:YES];
}

#pragma mark - VolumeContentSubjectViewDelegate
- (void)volumeSubjectView:(VolumeContentSubjectView *)subjectView didSelectWebLink:(NSString *)linkStr{
    SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:linkStr];
    svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:svweb animated:NO completion:nil];
}

#pragma mark - ConversionAlertViewDelegate
- (void)conversionAlertView:(ConversionAlertView *)alertView handleConversionWithNumber:(NSString *)numberStr{
    
    if (_type == waresTypeMaterial)
    {
        numberStr = addressModel.strid;
        if(numberStr.length<1)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"兑换信息不能为空" inView:self.view];
            return;
        }
    }
    
    if (alertView.alertType != ConversionAlertMaterial) {
        if ([numberStr isEqualToString:@""]) {
            [MDB_UserDefault showNotifyHUDwithtext:@"兑换信息不能为空" inView:self.view];
            return;
        }
    }
    
    if(dataController == nil)
    {
        dataController = [[WelfareHomeDataController alloc] init];
    }
    
    NSString *type = @"";
    if (_type == waresTypeMaterial) {
        type = @"present";
    }else{
        type = @"coupon";
    }
    [dataController requestGiftExchangeDataWithView:self.view
                                             giftID:[NSString stringWithFormat:@"%@",@(_juancleid)]
                                               type:type
                                           userInfo:[NSString nullToString:numberStr]
                                       present_type:strpresent_type callback:^(NSError *error, BOOL state, NSString *describle) {
                                               if(state){
                                                   self.conversionAlertView.alertState = ConversionAlertStateSuccess;
                                                   self.conversionAlertView.alertDescribleStr = describle;
                                                   [self.conversionAlertView show];                                               }else{
                                                       if ([describle isEqualToString:@"铜币不足"]) {
                                                           self.conversionAlertView.alertState = ConversionAlertStateCopperFailure;
                                                       }else{
                                                           self.conversionAlertView.faultRemindStr = describle;
                                                           self.conversionAlertView.alertState = ConversionAlertStateFailure;
                                                       }
                                                       [self.conversionAlertView show];
                                                   }
    }];
}

- (void)referLogisticsAddress{
    AddressListViewController *addressListVc = [[AddressListViewController alloc] init];
    addressListVc.delegate = self;
    addressListVc.delegateitem = self;
    [self.navigationController pushViewController:addressListVc animated:YES];
}

- (void)referCopperRule{
    TaskRuleViewController *ruleVc = [[TaskRuleViewController alloc] init];
    [self.navigationController pushViewController:ruleVc animated:YES];
}

#pragma mark - AddressListViewControllerDelegate
- (void)afreshConversionAlertView{
    [self GoBtnClicked:nil];
}

-(void)addressSelectItem:(id)value
{
    addressModel = value;
    NSString *title = [NSString stringWithFormat:@"你正在兑换“%@”",[NSString nullToString:_resultDict[@"title"]]];
    ConversionAlertType alertType;
    NSString *alertPlaceholderStr = nil;
    if ([_haveto isEqualToString:@"qq"]) {
        alertType = ConversionAlertVirtual;
        alertPlaceholderStr = @"请输入领取QQ号码";
    }else if ([_haveto isEqualToString:@"phone"]){
        alertType = ConversionAlertVirtual;
        alertPlaceholderStr = @"请输入领取手机号";
    }else if ([_haveto isEqualToString:@"address"]){
        alertType = ConversionAlertSubTitle;
    }else{
        alertType = ConversionAlertNormal;
    }
    self.conversionAlertView.alertType = alertType;
    self.conversionAlertView.waresName = title;
    self.conversionAlertView.faultRemindStr = addressModel.straddress;
    [self.conversionAlertView show];
}
///删除item
-(void)addressDelItem:(id)value
{
    
}

#pragma mark - setters and getters

- (ConversionAlertView *)conversionAlertView{
    if (!_conversionAlertView) {
        _conversionAlertView = [[ConversionAlertView alloc] init];
        _conversionAlertView.delegate =self;
    }
    return _conversionAlertView;
}
@end
