//
//  RecommendActivityViewController.m
//  Meidebi
//
//  Created by fishmi on 2017/5/11.
//  Copyright © 2017年 meidebi. All rights reserved.
//
#import "RecommendActivityViewController.h"
#import "RecommendDetailView.h"
#import "ActivityDetailViewController.h"
#import "RecommendActivityView.h"
#import "RecommendActivityDataController.h"
#import "JoinInActivityViewController.h"
#import "MDB_UserDefault.h"
#import "SVModalWebViewController.h"
#import "CommentRewardsDataController.h"
#import "ParticipationActAlertView.h"

// share
#import "Qqshare.h"
#import "UIImage+Extensions.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "PersonalInfoIndexViewController.h"
@interface RecommendActivityViewController()
<
UINavigationControllerDelegate,
RecommendActivityViewDelegate,
ParticipationActAlertViewDelegate
>
@property (nonatomic, strong) RecommendDetailView *detailV;
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIImageView *imageShow;
@property (nonatomic, strong) RecommendActivityDataController *dataController;
@property (nonatomic ,strong) CommentRewardsDataController *rewardsDataController;
@property (nonatomic, strong) RecommendActivityView *subjectView;
@property (nonatomic, strong) NSString *text_title;
@property (nonatomic, strong) NSString *timeout;
@end

@implementation RecommendActivityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationTitle];
    [self setSubView];
    [self setupRightBarButton];
    [self loadRecommendActivityrData];
    [self loadShareData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)setNavigationTitle{
    self.title = @"活动详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}];
}


-(void)setupRightBarButton{
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 44, 44);
    [shareBtn setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
    [shareBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareItem;
}

- (void)setSubView{
    RecommendActivityView *subjectView = [[RecommendActivityView alloc] init];
    subjectView.delegate =self;
    subjectView.activityId = self.recommendId;
    [self.view addSubview:subjectView];
    [subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectView = subjectView;
}


- (void)loadRecommendActivityrData{
    self.dataController.recommendId = self.recommendId;
    [self.dataController requestRecommendHeadViewDataInView:self.view WithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindRecommendHeadViewData:self.dataController.requestRecommendActivityResults];
            self.text_title = [[self.dataController.requestRecommendActivityResults objectForKey:@"activity"] objectForKey:@"title"];
            self.timeout = [[self.dataController.requestRecommendActivityResults objectForKey:@"activity"] objectForKey:@"timeout"];
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
    }];
    [self.dataController requestRecommendListDataInView:self.view WithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindRecommendListData:self.dataController.requestRecommendActivityResults];
        }else{
            if (![@"" isEqualToString:describle]) {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
        }
    }];
}

- (void)loadShareData{
    [self.rewardsDataController requestShareSubjectDataWithCommodityid:self.recommendId
                                                                inView:nil
                                                              callback:^(NSError *error, BOOL state, NSString *describle) {
                                                              }];
}


#pragma mark - RecommendActivityViewDelegate

- (void)subjectViewClickRecommendGoodsView:(NSString *)linkId{
    ActivityDetailViewController *activityDetailView = [[ActivityDetailViewController alloc] init];
    activityDetailView.activityId = linkId;
    activityDetailView.state = self.timeout;
    [self.navigationController pushViewController:activityDetailView animated:YES];
}

- (void)subjectViewClickJoinInActivity{
    JoinInActivityViewController *joinInVc = [[JoinInActivityViewController alloc] init];
    joinInVc.activityId = _recommendId;
    joinInVc.text_title = self.text_title;
    [self.navigationController pushViewController:joinInVc animated:YES];
    joinInVc.didFinish = ^{
        ParticipationActAlertView *alertView = [ParticipationActAlertView new];
        alertView.delegate = self;
        [alertView show];
    };
}


- (void)subjectViewClickEnterImagePicker:(UIImagePickerController *)imagePicker{
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)detailSubjectViewDidCickWebViewUrlLink:(NSString *)link{
    SVModalWebViewController *svweb=[[SVModalWebViewController alloc] initWithAddress:link];
    svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:svweb animated:NO completion:nil];
}

- (void)dataRefreshByHotBtnClick{
    
    [self.dataController hotDataInView:self.view WithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindRecommendListData:self.dataController.requestRecommendActivityResults];
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

- (void)dataRefreshByLatestBtnClick{
    [self.dataController latestDataInView:self.view WithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindRecommendListData:self.dataController.requestRecommendActivityResults];
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

- (void)dataRefreshByMJRefresh{
    [self.dataController nextPageDataInView:self.view WithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindRecommendListData:self.dataController.requestRecommendActivityResults];
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}


- (void)dataRefreshGetBackFromVKLoginViewControllerl{
    
    [self.dataController requestRecommendHeadViewDataInView:self.view WithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindRecommendHeadViewData:self.dataController.requestRecommendActivityResults];

        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

- (void)clickToVKLoginViewController:(UIViewController *)contorller{
    [self.navigationController pushViewController:contorller animated:YES];
}

- (void)shareBtnClicked:(UIButton *)sender{
    Qqshare *share = self.rewardsDataController.resultShareInfo;
    if (share) {
        //1、创建分享参数（必要）
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        UIImage *images=_subjectView.activityImage;
        NSArray* imageArray = images==nil?@[]:@[images];
        [shareParams SSDKSetupShareParamsByText:share.qqsharetitle
                                         images:imageArray
                                            url:[NSURL URLWithString:share.url]
                                          title:share.qqsharecontent
                                           type:SSDKContentTypeAuto];
        
        NSString *shareStr = [NSString stringWithFormat:@"%@%@%@",share.qqsharecontent,share.qqsharetitle,share.url];
//        [shareParams SSDKSetupSinaWeiboShareParamsByText:shareStr title:nil image:imageArray url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        ////分享更改
        [shareParams SSDKSetupSinaWeiboShareParamsByText:shareStr title:nil images:imageArray video:nil url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupTencentWeiboShareParamsByText:shareStr images:imageArray latitude:0 longitude:0 type:SSDKContentTypeAuto];
        
//        [shareParams SSDKSetupWeChatParamsByText:share.qqsharecontent title:[NSString stringWithFormat:@"%@%@",share.qqsharecontent,share.qqsharetitle] url:[NSURL URLWithString:share.url] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        ////分享更改
        [shareParams SSDKSetupWeChatParamsByText:share.qqsharecontent title:[NSString stringWithFormat:@"%@%@",share.qqsharecontent,share.qqsharetitle] url:[NSURL URLWithString:share.url] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        NSArray *arritems = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)];
        ////分享更改
        [ShareSDK showShareActionSheet:self.view customItems:arritems shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
        }];
//        //2、分享
//        [ShareSDK showShareActionSheet:self.view
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                   }];
        
    }else{
        [self.rewardsDataController requestShareSubjectDataWithCommodityid:self.recommendId
                                                             inView:self.view
                                                           callback:^(NSError *error, BOOL state, NSString *describle) {
                                                               if (state) {
                                                                   [self shareBtnClicked:nil];
                                                               }
                                                           }];
    }

}

#pragma mark - ParticipationActAlertViewDelegate
- (void)shareAlertViewDidClickedShareButtonAtType:(ActAlertHandleShareType)type{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    ///分享更改
    //    [shareParams SSDKEnableUseClientShare];
//    SSDKPlatformType platformType;
//    switch (type) {
//        case ActAlertHandleShareTypeWeChat:
//        {
//            platformType = SSDKPlatformSubTypeWechatSession;
//        }
//            break;
//
//        case ActAlertHandleShareTypeWeMoments:
//        {
//            platformType = SSDKPlatformSubTypeWechatTimeline;
//        }
//            break;
//
//        case ActAlertHandleShareTypeQQ:
//        {
//            platformType = SSDKPlatformSubTypeQQFriend;
//        }
//            break;
//
//        case ActAlertHandleShareTypeSinaWeibo:
//        {
//            platformType = SSDKPlatformTypeSinaWeibo;
//        }
//            break;
//
//        default:
//            break;
//    }
    
    Qqshare *share = self.rewardsDataController.resultShareInfo;
    if (share) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        UIImage *images=_subjectView.activityImage;
        NSArray* imageArray = images==nil?@[]:@[images];
        [shareParams SSDKSetupShareParamsByText:share.qqsharetitle
                                         images:imageArray
                                            url:[NSURL URLWithString:share.url]
                                          title:share.qqsharecontent
                                           type:SSDKContentTypeAuto];
        
        NSString *shareStr = [NSString stringWithFormat:@"%@%@%@",share.qqsharecontent,share.qqsharetitle,share.url];
//        [shareParams SSDKSetupSinaWeiboShareParamsByText:shareStr title:nil image:imageArray url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        ///分享更改
        [shareParams SSDKSetupSinaWeiboShareParamsByText:shareStr title:nil images:imageArray video:nil url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
        
        
        [shareParams SSDKSetupTencentWeiboShareParamsByText:shareStr images:imageArray latitude:0 longitude:0 type:SSDKContentTypeAuto];
        
//        [shareParams SSDKSetupWeChatParamsByText:share.qqsharecontent title:[NSString stringWithFormat:@"%@%@",share.qqsharecontent,share.qqsharetitle] url:[NSURL URLWithString:share.url] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        ///分享更改
        [shareParams SSDKSetupWeChatParamsByText:share.qqsharecontent title:[NSString stringWithFormat:@"%@%@",share.qqsharecontent,share.qqsharetitle] url:[NSURL URLWithString:share.url] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        
        [ShareSDK showShareActionSheet:self.view customItems:nil shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
        }];
//        //2、分享
//        [ShareSDK share:platformType
//             parameters:shareParams
//         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//         }];
    }
}
#pragma mark - setters and getters
- (CommentRewardsDataController *)rewardsDataController{
    if (!_rewardsDataController) {
        _rewardsDataController = [[CommentRewardsDataController alloc] init];
    }
    return _rewardsDataController;
}

- (RecommendActivityDataController *)dataController{
    if (!_dataController) {
        _dataController = [[RecommendActivityDataController alloc] init];
    }
    return _dataController;
}


@end
