//
//  CommentRewardsViewController.m
//  Meidebi
//
//  Created by fishmi on 2017/5/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CommentRewardsViewController.h"
#import "CommentRewardsView.h"
#import "CommentRewardsDataController.h"

// 分享
#import "Qqshare.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "PersonalInfoIndexViewController.h"
#import "UIImage+Extensions.h"
#import "MDB_UserDefault.h"
#import "VKLoginViewController.h"
#import "SVModalWebViewController.h"
@interface CommentRewardsViewController ()<CommentRewardsViewDelegate>
@property (nonatomic ,strong) CommentRewardsDataController *dataController;
@property (nonatomic ,strong) CommentRewardsView *subView;
@end

@implementation CommentRewardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setSubView];
    [self setLeftBarButton];
    [self setupRightBarButton];
    [self setNavigationTitle];
    [self loadCommentRewardsData];
    [self loadShareData];

}

- (void)setSubView{
    CommentRewardsView *subView = [[CommentRewardsView alloc] init];
    subView.bottomV.linkId = self.activityId;
    subView.linkId = self.activityId;
    subView.delegate = self;
    [self.view addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view);
        }
    }];
    _subView = subView;
}

- (void)setNavigationTitle{
    self.title = @"活动详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}] ;
}


-(void)setupRightBarButton{
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 44, 44);
    [shareBtn setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
    [shareBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareItem;
    
}

- (void)setLeftBarButton{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)refreshData{
//    [self.dataController requestCommentRewardsDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
//        if (state) {
//            [_subView bindCommentRewardsData:self.dataController.requestCommentRewardsDataControllerResults];
//        }
//    }];
//    
//}

- (void)loadShareData{
   [self.dataController requestShareSubjectDataWithCommodityid:self.activityId
                                                        inView:nil
                                                      callback:^(NSError *error, BOOL state, NSString *describle) {
       
   }];
}

- (void)loadCommentRewardsData{
    self.dataController.activityId = self.activityId;
    
    [self.dataController requestCommentRewardsDataInView:self.view WithCallback:^(NSError *error, BOOL state, NSString *describle) {
        
        if (state) {
            [_subView bindCommentRewardsData:self.dataController.requestCommentRewardsDataControllerResults];

        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subView];
        }
    }];
}

- (void)shareBtnClicked{
    
    Qqshare *share = self.dataController.resultShareInfo;
    if (share) {
        //1、创建分享参数（必要）
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        UIImage *images=_subView.rewardsImage;
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
        
        NSArray *arritems = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)];
        ///分享更改
        [ShareSDK showShareActionSheet:self.view customItems:arritems shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
        }];
//        //2、分享
//        [ShareSDK showShareActionSheet:self.view
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//
//                   }];
        
    }else{
        [self.dataController requestShareSubjectDataWithCommodityid:self.activityId
                                                             inView:self.view
                                                           callback:^(NSError *error, BOOL state, NSString *describle) {
                                                               if (state) {
                                                                   [self shareBtnClicked];
                                                               }
                                                           }];
    }
}

#pragma mark - CommentRewardsViewDelegate

- (void)clickToRemarkHomeViewController:(UIViewController *)targetVc{
    [self.navigationController pushViewController:targetVc animated:YES];
}

- (void)imageViewClickedtoControllerByUserid:(NSString *)userid{
    PersonalInfoIndexViewController *personalInfoIndexVc = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    [self.navigationController pushViewController:personalInfoIndexVc animated:YES];
}

- (void)remarkHomeSubjectClickUrl:(NSString *)urlStr{
    if (!urlStr) return;
    SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:urlStr];
    svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:svweb animated:NO completion:nil];
}

- (void)photoGroupView:(YYPhotoGroupView *)photoGroupView didClickImageView:(UIView *)fromeView{
    [photoGroupView presentFromImageView:fromeView
                             toContainer:self.navigationController.view
                                animated:YES
                              completion:nil];
}

- (void)detailSubjectViewDidCickWebViewUrlLink:(NSString *)link{
    SVModalWebViewController *svweb=[[SVModalWebViewController alloc] initWithAddress:link];
    svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:svweb animated:NO completion:nil];
}

- (void)tabBarViewdidPressShouItem{
    if ([MDB_UserDefault getIsLogin]&&_activityId) {
//        linkType = @"6";
        [self.dataController requestShouDataWithInView:self.view
                                           Commodityid:_activityId
                                              callback:^(NSError *error, BOOL state, NSString *describle) {
                                                  if (!error) {
                                                      if (self.dataController.isSuccessShou) {
                                                          [_subView updateSubjectViewWithType:UpdateViewTypeShou isMinus:NO];
                                                      }else{
                                                          [_subView updateSubjectViewWithType:UpdateViewTypeShou isMinus:YES];
                                                      }
                                                  }
                                              }];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView show];
    }

}

- (void)tabBarViewdidPressZanItem{
    if ([MDB_UserDefault getIsLogin]&&_activityId) {
        [self.dataController requestZanDataWithInView:self.view
                                          Commodityid:_activityId
                                             callback:^(NSError *error, BOOL state, NSString *describle) {
                                                 if (state) {
                                                     if (self.dataController.isSuccessZan) {
                                                         [_subView updateSubjectViewWithType:UpdateViewTypeZan isMinus:NO];
                                                     }
                                                 }else{
                                                     [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subView];
                                                 }
                                             }];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView show];
    }

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
    }
}

#pragma mark - setters and getters
- (CommentRewardsDataController *)dataController{
    if (!_dataController) {
        _dataController = [[CommentRewardsDataController alloc] init];
    }
    return _dataController;
}



@end
