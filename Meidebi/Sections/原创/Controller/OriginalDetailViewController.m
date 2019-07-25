//
//  OriginalDetailViewController.m
//  Meidebi
//  原创详情
//  Created by ZlJ_losaic on 2017/9/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OriginalDetailViewController.h"
#import "OriginalDetailSubjectView.h"
#import "OriginalDatacontroller.h"
#import "PersonalInfoIndexViewController.h"
#import "ProductInfoDataController.h"
#import "ProductInfoViewController.h"
#import "SVModalWebViewController.h"
#import "RewardHomeViewController.h"
#import "RewardRecordViewController.h"
#import "RemarkHomeViewController.h"
#import "VKLoginViewController.h"
#import "MDB_UserDefault.h"
#import "OriginalSearchResultViewController.h"
#import "XHInputView.h"
#import <FCUUID/FCUUID.h>
#import "RemarkDataController.h"
#import "IQKeyboardManager.h"
//#import "<IQKeyboardManager/IQKeyboardManager.h>"

#import "UIImage+Extensions.h"
#import "Qqshare.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
@interface OriginalDetailViewController ()
<
UIAlertViewDelegate,
XHInputViewDelagete,
OriginalDetailSubjectViewDelegate
>
@property (nonatomic, retain) OriginalDetailSubjectView *subjectView;
@property (nonatomic, retain) OriginalDatacontroller *datacontroller;
@property (nonatomic, retain) ProductInfoDataController *productDataController;
@property (nonatomic, retain) RemarkDataController *remarkDataController;
@property (nonatomic, retain) NSString *originalID;
@property (nonatomic, retain) Qqshare *shareObject;
@end

@implementation OriginalDetailViewController

- (instancetype)initWithOriginalID:(NSString *)originalID{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if([originalID isEqual:[NSNull null]])
        {
            originalID = @"";
        }
        _originalID = originalID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"原创详情";
    [self setupRightBarButton];
    [self setupSubviews];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubviews{
    _subjectView = [OriginalDetailSubjectView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectView.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    
}

-(void)setupRightBarButton{
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 44, 44);
    [shareBtn setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
    [shareBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareItem;
    
    
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)doClickLeftAction
{
    [_subjectView backNavAction];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    [self.datacontroller requestOriginalDetailWithID:_originalID
                                          targetView:self.view
                                            callback:^(NSError *error, BOOL state, NSString *describle) {
                                                [self renderSubjectView];
    }];
    [self.datacontroller requestOriginalShareWithID:_originalID
                                           callback:^(NSError *error, BOOL state, NSString *describle) {
                                               if (state) {
                                                   _shareObject = [[Qqshare alloc] initWithdic:self.datacontroller.resultShareDict];
                                               }
    }];
}

- (void)renderSubjectView{
    OriginalDetailViewModel *model = [OriginalDetailViewModel viewModelWithSubject:self.datacontroller.resultDict];
    [_subjectView bindDataWithModel:model];
}

-(void)shareBtnClicked:(UIButton *)sender{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *images=[_subjectView.originalImage imageByScalingProportionallyToSize:CGSizeMake(120.0, 120.0)];
    if (!images) return;
    NSArray* imageArray = @[images];
    if ([[NSString nullToString:_shareObject.qqsharecontent] isEqualToString:@""]) return;
    [shareParams SSDKSetupShareParamsByText:_shareObject.qqsharecontent
                                     images:imageArray
                                        url:[NSURL URLWithString:_shareObject.url]
                                      title:_shareObject.qqsharetitle
                                       type:SSDKContentTypeAuto];
    NSString *contentStr = [NSString stringWithFormat:@"%@%@",_shareObject.qqsharetitle,_shareObject.url];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentStr title:nil image:_shareObject.image url:[NSURL URLWithString:_shareObject.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
//    [shareParams SSDKSetupTencentWeiboShareParamsByText:contentStr images:images latitude:0 longitude:0 type:SSDKContentTypeAuto];
    [ShareSDK showShareActionSheet:self.view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
               }];
}
#pragma mark - OriginalDetailSubjectViewDelegate
- (void)originalDetailSubjectViewDidSelectTableViewCellWithID:(NSString *)originalID{
    OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:originalID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)originalDetailSubjectViewDidClickAvaterWithUserID:(NSString *)userID{
    PersonalInfoIndexViewController *vc = [[PersonalInfoIndexViewController alloc] initWithUserID:userID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)originalDetailSubjectViewDidPressNonstopItemWithOutUrlStr:(NSString *)urlLink{
    
    NSString *strproductid = @"";
    strproductid = [NSString nullToString:[self judgeUrlId:urlLink]];
    if([urlLink rangeOfString:@"meidebi.com"].location != NSNotFound && strproductid.length>0&&strproductid.length<10&&[urlLink rangeOfString:@"s-"].location == NSNotFound)
    {///
        ProductInfoViewController *pv = [[ProductInfoViewController alloc] init];
        pv.productId = strproductid;
        [self.navigationController pushViewController:pv animated:YES];
    }
    else if([urlLink rangeOfString:@"s-"].location != NSNotFound&& strproductid.length>0&&strproductid.length<10)
    {
        OriginalDetailViewController *ovc = [[OriginalDetailViewController alloc] initWithOriginalID:strproductid];
        [self.navigationController pushViewController:ovc animated:YES];
    }
    else{
        SVModalWebViewController  *vc=[[SVModalWebViewController alloc] initWithAddress:urlLink];
        vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:NO completion:nil];
    }
    
    
}
-(NSString *)judgeUrlId:(NSString *)strurl
{
    
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    NSString *strtemp = [NSString nullToString:[strurl stringByTrimmingCharactersInSet:nonDigits]];
    
    
    return strtemp;
    
}

- (void)originalDetailSubjectViewDidCickRewardButton{
    if ([MDB_UserDefault getIsLogin]&&_originalID) {
        RewardHomeViewController *rewardVC = [[RewardHomeViewController alloc] initWithCommodityID:_originalID
                                                                                              type:RewardTypeOriginal];
        [self.navigationController pushViewController:rewardVC animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView show];
    }

}

- (void)originalDetailSubjectViewDidCickRewardInfo{
    RewardRecordViewController *rewardRecordVC = [[RewardRecordViewController alloc] initWithCommodityID:_originalID
                                                                                                    type:RewardLogTypeOriginal];
    [self.navigationController pushViewController:rewardRecordVC animated:YES];

}

- (void)originalDetailSubjectViewDidCickReadMoreRemark{
    RemarkHomeViewController *remarkHomeVc = [[RemarkHomeViewController alloc] init];
    remarkHomeVc.type = RemarkTypeShare;
    remarkHomeVc.linkid = _originalID;
    [self.navigationController pushViewController:remarkHomeVc animated:YES];
}

- (void)originalDetailSubjectViewDidClickFollowBtn:(NSString *)userID complete:(void (^)(BOOL))callback{
//    if ([MDB_UserDefault getIsLogin]&&_originalID) {
    if (_originalID) {
        [self.productDataController requestAddFollwDataWithInView:_subjectView userid:userID
                                                         callback:^(NSError *error, BOOL state, NSString *describle) {
                                                             if (state) {
                                                                 callback(state);
                                                             }else{
                                                                 [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
                                                             }
                                                         }];

    }else{
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"请登录后再试"
//                                                           delegate:self
//                                                  cancelButtonTitle:Nil
//                                                  otherButtonTitles:@"登录",@"取消", nil];
//        [alertView show];
    }

}

- (void)originalDetailSubjectViewDidClickTage:(NSString *)tage{
    OriginalSearchResultViewController *vc = [[OriginalSearchResultViewController alloc] initWithTagName:tage];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)originalDetailSubjectViewOtherWorkCellDidCilckLikeBtn:(NSString *)relevanceID
                                                  didComplete:(void (^)(void))didComplete{
//    if ([MDB_UserDefault getIsLogin]&&relevanceID) {
    if (relevanceID) {
        [self.datacontroller requestOriginalLinkWithOriginalID:relevanceID
                                                    targetView:self.view
                                                      callback:^(NSError *error, BOOL state, NSString *describle) {
                                                          if ([describle isEqualToString:@"VOTES_SUCCESS"]&&state) {
                                                              didComplete();
                                                              [MDB_UserDefault showNotifyHUDwithtext:@"投票成功" inView:self.view];
                                                          }else if ([describle isEqualToString:@"YOUR_ARE_VOTEED"]){
                                                              [MDB_UserDefault showNotifyHUDwithtext:@"你已经投过票了" inView:self.view];
                                                          }else{
                                                              [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                                                          }
                                                          
                                                      }];
    }else{
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"请登录后再试"
//                                                           delegate:self
//                                                  cancelButtonTitle:Nil
//                                                  otherButtonTitles:@"登录",@"取消", nil];
//        [alertView show];
    }

}

- (void)originalDetailSubjectViewDidPressCollectBtnDidComplete:(void (^)(BOOL))didComplete{
    if ([MDB_UserDefault getIsLogin]&&_originalID) {
        [self.datacontroller requestOriginalCollectWithOriginalID:_originalID
                                                       targetView:self.view
                                                         callback:^(NSError *error, BOOL state, NSString *describle) {
                                                             if (state) {
                                                                 if ([@"取消收藏成功！"isEqualToString:self.datacontroller.resultStr]) {
                                                                     didComplete(NO);
                                                                 }else if ([describle isEqualToString:@"YOUR_ARE_VOTEED"]){
                                                                     [MDB_UserDefault showNotifyHUDwithtext:@"你已经收藏了" inView:self.view];
                                                                 }else{
                                                                     didComplete(YES);
                                                                 }
                                                             }else{
                                                                 [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
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

- (void)originalDetailSubjectViewDidPressLikeBtnComplete:(void (^)(void))didComplete{
//    if ([MDB_UserDefault getIsLogin]&&_originalID) {
    if (_originalID) {
        [self.datacontroller requestOriginalLinkWithOriginalID:_originalID
                                                    targetView:self.view
                                                      callback:^(NSError *error, BOOL state, NSString *describle) {
            if ([describle isEqualToString:@"VOTES_SUCCESS"]&&state) {
                didComplete();
                [MDB_UserDefault showNotifyHUDwithtext:@"投票成功" inView:self.view];
            }else if ([describle isEqualToString:@"YOUR_ARE_VOTEED"]){
                [MDB_UserDefault showNotifyHUDwithtext:@"你已经投过票了" inView:self.view];
            }else{
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
            
        }];
    }else{
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"请登录后再试"
//                                                           delegate:self
//                                                  cancelButtonTitle:Nil
//                                                  otherButtonTitles:@"登录",@"取消", nil];
//        [alertView show];
    }
    
}

- (void)originalDetailSubjectViewDidPressRemarkBtn{
    [self originalDetailSubjectViewDidCickReadMoreRemark];
}

- (void)originalDetailSubjectViewDidPressCommentItemWithToUserID:(NSString *)userid{
    if ([MDB_UserDefault getIsLogin]&&_originalID) {
        [XHInputView showWithStyle:InputViewStyleDefault configurationBlock:^(XHInputView *inputView) {
            inputView.placeholder = @"请输入回复内容...";
            inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
            inputView.sendButtonBackgroundColor = [UIColor colorWithHexString:@"#F27A30"];
            inputView.sendButtonCornerRadius = 4.f;
            inputView.sendButtonTitle = @"回复";
            inputView.delegate = self;
        } sendBlock:^BOOL(NSString *text) {
            if(text.length){
                NSDictionary *parameters = @{
                                               @"userid":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                               @"type":@"2",
                                               @"fromid":[NSString nullToString:_originalID],
                                               @"touserid":[NSString nullToString:userid],
                                               @"content":text,
                                               @"uniquetoken":[FCUUID uuidForDevice]
                                               };
                [self.remarkDataController requestCommentReplySubjectData:parameters InView:self.view callback:^(NSError *error, BOOL state, NSString *describle) {
                    if (state) {
                        [self loadData];
                    }else{
                        [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                    }
                }];
                return YES;
            }else{
                [MDB_UserDefault showNotifyHUDwithtext:@"请输入回复内容" inView:self.view];
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
    }
}

#pragma mark - XHInputViewDelagete
-(void)xhInputViewWillShow:(XHInputView *)inputView{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
}

-(void)xhInputViewWillHide:(XHInputView *)inputView{
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
}

#pragma mark - setters and getters
- (OriginalDatacontroller *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[OriginalDatacontroller alloc] init];
    }
    return _datacontroller;
}

- (ProductInfoDataController *)productDataController{
    if (!_productDataController) {
        _productDataController = [[ProductInfoDataController alloc] init];
    }
    return _productDataController;
}

- (RemarkDataController *)remarkDataController{
    if (!_remarkDataController) {
        _remarkDataController = [[RemarkDataController alloc] init];
    }
    return _remarkDataController;
}

-(void)dealloc
{
    [_subjectView removeFromSuperview];
    _subjectView = nil;
    _datacontroller = nil;
    _productDataController=nil;
    _remarkDataController = nil;
    _shareObject = nil;
    
    
}

@end
