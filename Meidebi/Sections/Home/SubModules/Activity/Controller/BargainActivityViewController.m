//
//  BargainActivityViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/10/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BargainActivityViewController.h"
#import "BargainActivitySubjectView.h"
#import "BargainParticipationRecordViewController.h"
#import "BargainActivityDataController.h"
#import "BargainActivityDetailViewController.h"
#import "PersonalInfoIndexViewController.h"
#import "RemarkHomeViewController.h"
#import "SVModalWebViewController.h"
#import "CommentRewardsDataController.h"
#import "MDB_UserDefault.h"
#import "VKLoginViewController.h"
// share
#import "Qqshare.h"
#import "UIImage+Extensions.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "PersonalInfoIndexViewController.h"
@interface BargainActivityViewController ()
<
UIAlertViewDelegate,
BargainActivitySubjectViewDelegate
>
@property (nonatomic, strong) NSString *activityID;
@property (nonatomic, strong) BargainActivitySubjectView *subjectView;
@property (nonatomic, strong) BargainActivityDataController *datacontroller;
@property (nonatomic, strong) CommentRewardsDataController *rewardsDataController;
@end

@implementation BargainActivityViewController

- (instancetype)initWithActivityID:(NSString *)activityID{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _activityID = activityID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    [self setNavRightBtn];
    [self loadData];
    _subjectView = [BargainActivitySubjectView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavRightBtn{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];
    btnright.frame = CGRectMake(0,0,70,44);
    btnright.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btnright setTitleColor:[UIColor colorWithHexString:@"#BE6E34"] forState:UIControlStateNormal];
    [btnright setTitle:@"参与记录" forState:UIControlStateNormal];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright addTarget:self action:@selector(respondsToNavRightBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)loadData{
    [self.datacontroller requestActivityDetailWithID:_activityID
                                          targetView:self.view
                                            callback:^(NSError *error, BOOL state, NSString *describle) {
                                                [self renderSubjectView];
    }];
    [self loadShareData];
}

- (void)loadShareData{
    [self.rewardsDataController requestShareSubjectDataWithCommodityid:_activityID
                                                                inView:nil
                                                              callback:^(NSError *error, BOOL state, NSString *describle) {
                                                              }];
    
}

- (void)renderSubjectView{
    BargainActivityViewModel *model = [BargainActivityViewModel viewModelWithSubject:self.datacontroller.resultDict];
    [_subjectView bindDataWithModel:model];
}

#pragma mark - events
- (void)respondsToNavRightBtnEvent:(UIButton *)sender{
    if ([MDB_UserDefault getIsLogin]) {
        BargainParticipationRecordViewController *vc = [[BargainParticipationRecordViewController alloc] initWithBargainActivityID:_activityID];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VKLoginViewController *vc = [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

#pragma mark - BargainActivitySubjectViewDelegate
- (void)subjectTableViewDidSelectItem:(NSString *)itemID{
    BargainActivityDetailViewController *vc = [[BargainActivityDetailViewController alloc] initWithBargainItemID:itemID];
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)detailSubjectViewDidCickAvaterViewWithUserid:(NSString *)userid{
    PersonalInfoIndexViewController *personalInfoVc = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    [self.navigationController pushViewController:personalInfoVc animated:YES];
}


- (void)bargainActivitySubjectViewDidClickedShareButtonAtType:(ShareHandleType)type{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    SSDKPlatformType platformType;
    switch (type) {
        case ShareHandleTypeWeChat:
        {
            platformType = SSDKPlatformSubTypeWechatSession;
        }
            break;
            
        case ShareHandleTypeWeMoments:
        {
            platformType = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
            
        case ShareHandleTypeQQ:
        {
            platformType = SSDKPlatformSubTypeQQFriend;
        }
            break;
            
        case ShareHandleTypeSinaWeibo:
        {
            platformType = SSDKPlatformTypeSinaWeibo;
        }
            break;
        case ShareHandleTypeQQSpace:
        {
            platformType = SSDKPlatformSubTypeQZone;
        }
            break;
            
        default:
            break;
    }
    
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
        [shareParams SSDKSetupSinaWeiboShareParamsByText:shareStr title:nil image:imageArray url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupTencentWeiboShareParamsByText:shareStr images:imageArray latitude:0 longitude:0 type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupWeChatParamsByText:share.qqsharecontent title:[NSString stringWithFormat:@"%@%@",share.qqsharecontent,share.qqsharetitle] url:[NSURL URLWithString:share.url] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        //2、分享
        [ShareSDK share:platformType
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         }];
    }

}

- (void)detailSubjectViewDidCicklikeBtn:(void (^)(BOOL))didComplete{
    if ([MDB_UserDefault getIsLogin]){
        [self.datacontroller requestZanDataWithInView:_subjectView Commodityid:_activityID callback:^(NSError *error, BOOL state, NSString *describle) {
            if (!error && self.datacontroller.isSuccessZan) {
                if (didComplete) {
                    didComplete(NO);
                }
            }
        }];
    }else{
        [self showAlertView];
    }
}
- (void)detailSubjectViewDidCickInputRemarkView{
    [self detailSubjectViewDidCickReadMoreRemark];
}
- (void)detailSubjectViewDidCickReadMoreRemark{
    RemarkHomeViewController *remarkHomeVc = [[RemarkHomeViewController alloc] init];
    remarkHomeVc.type = RemarkTypeCommentAwards;
    remarkHomeVc.linkid = _activityID;
    [self.navigationController pushViewController:remarkHomeVc animated:YES];
}

- (void)showAlertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请登录后再试"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"登录",@"取消", nil];
    [alertView show];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
    }
}
#pragma mark - settrs and getters
- (BargainActivityDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[BargainActivityDataController alloc] init];
    }
    return _datacontroller;
}

- (CommentRewardsDataController *)rewardsDataController{
    if (!_rewardsDataController) {
        _rewardsDataController = [[CommentRewardsDataController alloc] init];
    }
    return _rewardsDataController;
}


@end
