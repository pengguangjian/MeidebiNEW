//
//  PersonalInfoViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalInfoIndexViewController.h"
#import "PersonalInfoIndexSubjectView.h"
#import "PersonalInfoIndexDataController.h"
#import "TKNavigationBarOverlay.h"
#import "MDB_UserDefault.h"
#import "ContactDataController.h"
#import "ProductInfoViewController.h"
#import "OriginalDetailViewController.h"
#import "MDBShareActionSheet.h"
#import "UIImage+Extensions.h"


//shareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDK/ShareSDK+Base.h>
@interface PersonalInfoIndexViewController ()
<
MDBShareActionSheetDelegate,
PersonalInfoSubjectViewDelegate
>
@property (nonatomic, strong) PersonalInfoIndexDataController *dataController;
@property (nonatomic, strong) ContactDataController *contactDataController;
@property (nonatomic, strong) PersonalInfoIndexSubjectView *subjectView;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
@end

@implementation PersonalInfoIndexViewController

- (instancetype)initWithUserID:(NSString *)userid{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _userID = userid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBarView];
    [self setupSubviews];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 设置navbar背景颜色
    [self.navigationController.navigationBar lt_setBackgroundColor:[self.view.backgroundColor colorWithAlphaComponent:0]];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"tabbar_line_select"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupNavBarView{
    // 移除nav bar下方的线条
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    // 设置返回按钮
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-7];
    
    UIButton *butLeft=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    [butLeft setImage:[UIImage imageNamed:@"back_white"]
             forState:UIControlStateNormal];
    [butLeft setImage:[UIImage imageNamed:@"back_white"]
             forState:UIControlStateHighlighted];
    [butLeft addTarget:self action:@selector(respondsNavLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithCustomView:butLeft];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBar];
    
}

- (void)setupSubviews{
    _subjectView = [[PersonalInfoIndexSubjectView alloc] initWithUserID:_userID];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view);
        }
    }];
    _subjectView.delegate = self;
}

- (void)loadData{
    [self.dataController requestPersonalInfoInView:_subjectView userid:_userID callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self renderSubjectView];
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

- (void)renderSubjectView{
    PersonalInfoIndexViewModel *model = [PersonalInfoIndexViewModel viewModelWithSubject:self.dataController.resultDict];
    [_subjectView bindDataWithModel:model];
}

- (void)respondsNavLeftBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareChannelType:(MDBShareType)channel{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    SSDKPlatformType platformType;
    switch (channel) {
        case MDBShareTypeWeChat:
        {
            platformType = SSDKPlatformSubTypeWechatSession;
        }
            break;
            
        case MDBShareTypeWeMoments:
        {
            platformType = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
            
        case MDBShareTypeQQ:
        {
            platformType = SSDKPlatformSubTypeQQFriend;
        }
            break;
            
        case MDBShareTypeSpace:
        {
            platformType = SSDKPlatformSubTypeQZone;
        }
            break;
            
        case MDBShareTypeSinaWeibo:
        {
            platformType = SSDKPlatformTypeSinaWeibo;
        }
            break;
            
        case MDBShareTypeTencentWeibo:
        {
            platformType = SSDKPlatformTypeTencentWeibo;
        }
            break;
        default:
            break;
    }
    UIImage *images = [UIImage imageNamed:@"icon120"];
    if (platformType != SSDKPlatformTypeSinaWeibo) {
        images = [images imageByScalingProportionallyToMinimumSize:CGSizeMake(120, 120)];
    }
    
    NSString *link = [NSString stringWithFormat:@"%@/V2-Homepage-indexH5.html?userid=%@",URL_HR,[NSString nullToString:_userID]];
    
    NSString *content = [NSString stringWithFormat:@"小伙伴们，快来围观\" %@ \"的个人主页吧！",_userName];
    
    
    NSString *strtitle = @"省钱购物，一手掌控！";
    
    
    if(self.dataController.resultDict !=nil)
    {
        NSString *strtemp = [NSString nullToString:[self.dataController.resultDict objectForKey:@"share_url"]];
        if([strtemp length] > 0)
        {
            
            link = strtemp;
        }
        else
        {
            link = @"m.meidebi.com";
        }
        
         NSString *strtemp1 = [NSString nullToString:[self.dataController.resultDict objectForKey:@"title"]];
        if([strtemp1 length] > 0)
        {
            
            strtitle = strtemp1;
        }
        
        NSString *strtemp2 = [NSString nullToString:[self.dataController.resultDict objectForKey:@"content"]];
        if([strtemp2 length] > 0)
        {
            
            content = strtemp2;
        }
        
    }
    else
    {
        link = @"m.meidebi.com";
    }
    
    
    
    
    [shareParams SSDKSetupShareParamsByText:content
                                     images:@[images]
                                        url:[NSURL URLWithString:link]
                                      title:strtitle
                                       type:SSDKContentTypeAuto];
    NSString *sinaShareText = [NSString stringWithFormat:@"%@%@%@",strtitle,content,link];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:sinaShareText title:strtitle image:@[images] url:[NSURL URLWithString:[NSString nullToString:link]] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    [shareParams SSDKSetupTencentWeiboShareParamsByText:sinaShareText images:@[images] latitude:0 longitude:0 type:SSDKContentTypeAuto];
    //进行分享
    [ShareSDK share:platformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 break;
             }
             case SSDKResponseStateFail:
             {
                 //                 NSLog(@"分享失败%@",[NSString stringWithFormat:@"%@", error]);
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 break;
             }
             default:
                 break;
         }
     }];
    
    
}

#pragma mark - PersonalInfoSubjectViewDelegate
- (void)personalInfoSubjectViewDidClickShareBtn:(NSString *)username{
    _userName = username;
    MDBShareActionSheet *actionSheet = [MDBShareActionSheet new];
    actionSheet.delegate = self;
    [actionSheet show];
}
///加关注
- (void)personalInfoSubjectViewDidClickFollowBtn{
    if(_userID==nil || [_userID isEqualToString:@""])
    {
     
        [MDB_UserDefault showNotifyHUDwithtext:@"关注信息错误" inView:self.view];
        return;
    }
    
    [self.contactDataController requestAddFollwDataWithInView:_subjectView userid:_userID callback:^(NSError *error, BOOL state, NSString *describle) {
        [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        if(state)
        {
            [_subjectView bottomTitleAction];
        }
    }];
}

- (void)personalInfoSubjectViewDidSelectShaidan:(NSString *)shaidanid{
    OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:shaidanid];
//    UIStoryboard *mainStroy=[UIStoryboard storyboardWithName:@"Share" bundle:nil];
//    ShareContViewController *ductViewC=[mainStroy instantiateViewControllerWithIdentifier:@"com.mdb.ShareContViewC"];
//    ductViewC.shareid=[shaidanid integerValue];
//    ductViewC.isRightBut=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)personalInfoSubjectViewDidSelectBroke:(NSString *)brokeid{
    ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
    productInfoVc.productId = brokeid;
    [self.navigationController pushViewController:productInfoVc animated:YES];
}

#pragma mark - MDBShareActionSheetDelegate
- (void)shareActionSheetDidClickedSharButtonAtType:(MDBShareType)type{
    [self shareChannelType:type];
}


#pragma mark - setters and getters 
- (PersonalInfoIndexDataController *)dataController{
    if (!_dataController) {
        _dataController = [[PersonalInfoIndexDataController alloc] init];
    }
    return _dataController;
}

- (ContactDataController *)contactDataController{
    if (!_contactDataController) {
        _contactDataController = [[ContactDataController alloc] init];
    }
    return _contactDataController;
}

@end
