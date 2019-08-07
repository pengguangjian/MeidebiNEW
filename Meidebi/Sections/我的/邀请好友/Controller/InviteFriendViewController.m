//
//  InviteFriendViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "InviteFriendSubjectView.h"
#import "InviteFriendDataController.h"
#import "MDB_UserDefault.h"
#import "InviteFriendListViewController.h"
#import "MDBShareActionSheet.h"
#import "UIImage+Extensions.h"


//shareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
@interface InviteFriendViewController ()
<
MDBShareActionSheetDelegate,
InviteFriendSubjectViewDelegate
>
@property (nonatomic, strong) InviteFriendSubjectView *subjectView;
@property (nonatomic, strong) InviteFriendDataController *dataController;
@property (nonatomic, strong) NSString *invitationCode;
@end

@implementation InviteFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    [self setupSubviews];
    [self setupNavRightBtn];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData{
    [self.dataController requestInviteFriendDataInView:_subjectView Callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindDataWithModel:self.dataController.resultDict];
            _invitationCode = [NSString stringWithFormat:@"%@",[NSString nullToString:self.dataController.resultDict[@"invitation_code"]]];
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

- (void)setupSubviews{
    _subjectView = [InviteFriendSubjectView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    _subjectView.delegate = self;
}

- (void)setupNavRightBtn{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];
    btnright.frame = CGRectMake(0,0,60,44);
    btnright.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btnright setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [btnright setTitle:@"邀请明细" forState:UIControlStateNormal];
    [btnright addTarget:self action:@selector(respondsToRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)respondsToRightBtn:(UIButton *)sender{
    InviteFriendListViewController *friendListVc = [[InviteFriendListViewController alloc] init];
    [self.navigationController pushViewController:friendListVc animated:YES];
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
    
    NSString *strtitle = [NSString stringWithFormat:@"好友送你￥%@红包，快来领取吧~",_subjectView.stryaoqingmoney];
    NSString *strcontent = @"国内外超值优惠推荐";
    
    NSString *link = [NSString stringWithFormat:@"http://m.meidebi.com/H5-invite-invitationcode-%@",_invitationCode];
    [shareParams SSDKSetupShareParamsByText:strcontent
                                     images:@[images]
                                        url:[NSURL URLWithString:link]
                                      title:strtitle
                                       type:SSDKContentTypeAuto];
    NSString *sinaShareText = [NSString stringWithFormat:@"%@%@%@",strtitle,strcontent,link];

//    [shareParams SSDKSetupSinaWeiboShareParamsByText:sinaShareText title:strtitle image:@[images] url:[NSURL URLWithString:[NSString nullToString:link]] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    ///分享更改
    [shareParams SSDKSetupSinaWeiboShareParamsByText:sinaShareText title:strtitle images:@[images] video:nil url:[NSURL URLWithString:[NSString nullToString:link]] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
    
//    [shareParams SSDKSetupTencentWeiboShareParamsByText:sinaShareText images:@[images] latitude:0 longitude:0 type:SSDKContentTypeAuto];
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

#pragma mark - InviteFriendSubjectViewDelegate
- (void)inviteFriendSubjectViewDidClickInviteBtn{
    MDBShareActionSheet *actionSheet = [MDBShareActionSheet new];
    actionSheet.delegate = self;
    [actionSheet show];
}

#pragma mark - MDBShareActionSheetDelegate
- (void)shareActionSheetDidClickedSharButtonAtType:(MDBShareType)type{
    [self shareChannelType:type];
}

#pragma mark - setters and getters
- (InviteFriendDataController *)dataController{
    if (!_dataController) {
        _dataController = [[InviteFriendDataController alloc] init];
    }
    return _dataController;
}

@end
