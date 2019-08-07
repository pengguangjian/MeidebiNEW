//
//  ActivityDetailViewController.m
//  Meidebi
//
//  Created by fishmi on 2017/5/12.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityDetailView.h"
#import "ActivityDetailViewControllerDataController.h"
#import "MDB_UserDefault.h"
#import "VKLoginViewController.h"
#import "SVModalWebViewController.h"
#import "XHInputView.h"
#import <FCUUID/FCUUID.h>
#import "RemarkDataController.h"
// 分享
#import "Qqshare.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "UIImage+Extensions.h"
@interface ActivityDetailViewController ()<ActivityDetailViewDelegate,XHInputViewDelagete>
@property (nonatomic ,strong) UIView *detailV;
@property (nonatomic ,strong) UIView *AttentionV;
@property (nonatomic ,strong) ActivityDetailViewControllerDataController *dataController;
@property (nonatomic, strong) RemarkDataController *remarkDataController;
@property (nonatomic ,strong) ActivityDetailView *subjectView;

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationTitle];
    [self setSubView];
    [self setLeftBarButton];
    [self loadActivityDetailData];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setNavigationTitle{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}] ;
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


- (void)setSubView{
    ActivityDetailView *subjectView = [[ActivityDetailView alloc] init];
    subjectView.delegate = self;
    subjectView.bottomV.linkId = self.activityId;
    subjectView.linkId = self.activityId;
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

- (UIControl *)setupSubControlWithTitle:(NSString *)title
                       stateNormalImage:(UIImage *)normalImage{
    
    UIControl *control = [UIControl new];
    control.backgroundColor = [UIColor clearColor];
    
    UIImageView *headerImageView = [UIImageView new];
    [control addSubview:headerImageView];
    
    headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    headerImageView.tag = 2222;
    headerImageView.image = normalImage;
    
    UILabel *label = [UILabel new];
    [control addSubview:label];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    label.tag = 1100;
    label.text = title;
    
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(control).offset(11);
        make.centerY.equalTo(control);
        make.size.mas_equalTo(CGSizeMake(16, 15));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(control).offset(-11);
        make.centerY.equalTo(control);
        make.left.equalTo(headerImageView.mas_right).offset(4);
    }];
    
    
    return control;
}

#pragma mark -ActivityDetailViewDelegate

- (void)clickToRemarkHomeViewController:(UIViewController *)targetVc{
    [self.navigationController pushViewController:targetVc animated:YES];
}

- (void)imageViewClickedtoController:(UIViewController *)targetVc{
    [self.navigationController pushViewController:targetVc animated:YES];
}

- (void)detailSubjectViewDidCickAddFollowWithUserid:(NSString *)userid didComplete:(void (^)(BOOL))didComplete{
    [self.dataController requestAddFollwDataWithInView:_subjectView userid:userid callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            didComplete(state);
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

- (void)tabBarViewdidPressCommentItemWithType:(NSString *)type linkID:(NSString *)linkID{
    if ([MDB_UserDefault getIsLogin]&&_activityId) {
        [XHInputView showWithStyle:InputViewStyleDefault configurationBlock:^(XHInputView *inputView) {
            inputView.delegate = self;
            inputView.placeholder = @"请输入评论文字...";
            inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
            inputView.sendButtonBackgroundColor = [UIColor colorWithHexString:@"#F27A30"];
            inputView.sendButtonCornerRadius = 4.f;
        } sendBlock:^BOOL(NSString *text) {
            if(text.length){
                NSDictionary *dics =@{
                                      @"userid":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                      @"type":[NSString nullToString:type],
                                      @"fromid":[NSString nullToString:linkID],
                                      @"content":[NSString nullToString:text],
                                      @"uniquetoken":[FCUUID uuidForDevice]
                                      };
                [self.remarkDataController requestCommentReplySubjectData:dics InView:self.view callback:^(NSError *error, BOOL state, NSString *describle) {
                    if (state) {
                        [self loadActivityDetailData];
                    }else{
                        [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                    }
                }];
                return YES;
            }else{
                [MDB_UserDefault showNotifyHUDwithtext:@"请输入要评论的的内容" inView:self.view];
                return NO;
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

- (void)tabBarViewdidPressShouItem{
    //    if ([MDB_UserDefault getIsLogin]&&_activityId){
    if (_activityId) {
//        if ([@"1" isEqualToString:_state]) {
//            [MDB_UserDefault showNotifyHUDwithtext:@"活动已结束，不能再投票了哦" inView:_subjectView];
//            return;
//        }
        [self.dataController requestShouDataWithInView:self.view
                                           Commodityid:_activityId
                                              callback:^(NSError *error, BOOL state, NSString *describle) {
                                                  if (!error) {
                                                      if (self.dataController.isSuccessShou) {
                                                          [_subjectView updateSubjectViewWithType:UpdateViewTypeShou isMinus:NO];
                                                      }else{
                                                          [_subjectView updateSubjectViewWithType:UpdateViewTypeShou isMinus:YES];
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
                                                         [_subjectView updateSubjectViewWithType:UpdateViewTypeZan isMinus:NO];
                                                     }
                                                     else
                                                     {
                                                         [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
                                                     }
                                                 }else{
                                                     [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
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


- (void)loadActivityDetailData{
    self.dataController.activityId = _activityId;
    [self.dataController requestActivityDetailDataWithInView:self.view callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindActivityDetailData:self.dataController.requestActivityDetailResults];
            self.title = self.dataController.requestActivityDetailResults[@"activityjoin"][@"title"];
            [self loadShareData];
        }else{
            if (![@"" isEqualToString:describle]) {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
        }
    }];
}

- (void)loadShareData{
    [self.dataController requestActivityShareDataWithJoinID:self.dataController.requestActivityDetailResults[@"activityjoin"][@"actid"] callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self setupRightBarButton];
        }
    }];
}

- (ActivityDetailViewControllerDataController *)dataController{
    if (!_dataController) {
        _dataController = [[ActivityDetailViewControllerDataController alloc] init];
    }
    return _dataController;
}

- (void)detailSubjectViewDidCickWebViewUrlLink:(NSString *)link{
    SVModalWebViewController *svweb=[[SVModalWebViewController alloc] initWithAddress:link];
    svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:svweb animated:NO completion:nil];
}


- (void)shareBtnClicked: (UIButton *)sender{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *images=[_subjectView.participationImage imageByScalingProportionallyToMinimumSize:CGSizeMake(120.0, 120.0)];
    if (!images) return;
    NSArray* imageArray = @[images];
    if ([[NSString nullToString:self.dataController.resultShareInfo.content] isEqualToString:@""]) return;
    [shareParams SSDKSetupShareParamsByText:self.dataController.resultShareInfo.title
                                     images:imageArray
                                        url:[NSURL URLWithString:self.dataController.resultShareInfo.url]
                                      title:self.dataController.resultShareInfo.defaultWord
                                       type:SSDKContentTypeAuto];
    NSString *contentStr = [NSString stringWithFormat:@"%@%@",self.dataController.resultShareInfo.title,self.dataController.resultShareInfo.url];
//    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentStr title:nil image:images url:[NSURL URLWithString:self.dataController.resultShareInfo.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    ////分享更改
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentStr title:nil images:images video:nil url:[NSURL URLWithString:self.dataController.resultShareInfo.url] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
    
    [shareParams SSDKSetupTencentWeiboShareParamsByText:contentStr images:images latitude:0 longitude:0 type:SSDKContentTypeAuto];
    
    NSArray *arritems = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)];
    ////分享更改
    [ShareSDK showShareActionSheet:self.view customItems:arritems shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
        
    }];
//    [ShareSDK showShareActionSheet:self.view
//                             items:nil
//                       shareParams:shareParams
//               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//               }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
    }
}

#pragma mark - setters and getters
- (RemarkDataController *)remarkDataController{
    if (!_remarkDataController) {
        _remarkDataController = [[RemarkDataController alloc] init];
    }
    return _remarkDataController;
}


//XHInputView 将要显示
-(void)xhInputViewWillShow:(XHInputView *)inputView{
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
//    [IQKeyboardManager sharedManager].enable = NO;
}

//XHInputView 将要影藏
-(void)xhInputViewWillHide:(XHInputView *)inputView{
//    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
//    [IQKeyboardManager sharedManager].enable = YES;
}


@end
