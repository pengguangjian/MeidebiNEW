//
//  ProductInfoViewController.m
//  Meidebi
//  爆料详情
//  Created by mdb-admin on 16/4/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "ProductInfoSubjectsViewModel.h"
#import "ProductInfoDataController.h"
#import "ProductInfoSubjectsView.h"
#import "SVModalWebViewController.h"
#import "CommentViewController.h"
#import "RemarkHomeViewController.h"
#import "SpecialInfoViewController.h"
#import "VKLoginViewController.h"
#import "CourseViewController.h"
#import "MDB_UserDefault.h"
#import "Commodity.h"
#import "Article.h"
#import "Qqshare.h"
#import "UIImage+Extensions.h"
#import "NJPushSetAlertView.h"
//#import "BrokeAlertView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#import <AlibcTradeSDK/AlibcTradeSDK/AlibcTradeSDK.h>
#import "ADHandleViewController.h"
#import "SearchEndViewController.h"
#import "SearchMainViewController.h"
#import "PersonalInfoIndexViewController.h"
#import "ZLJFeaturesGuideView.h"
#import "RewardHomeViewController.h"
#import "OriginalDetailViewController.h"
#import "RewardRecordViewController.h"

#import "DaiGouXiaDanViewController.h"

#import "ProductInfoJBAalterView.h"

#import "ProductInfoWebMessageViewController.h"

#import "MDBPGGWebViewController.h"


#import "WeiboSDK.h"

#import <ShareSDKConnector/ShareSDKConnector.h>

#import <JDKeplerSDK/KeplerApiManager.h>

#import "WXApi.h"

#import "WoGuanZhuBiaoQianSearchListTableViewController.h"

static UIEdgeInsets kPadding = {64,0,0,0};
@interface ProductInfoViewController ()
<
ProductInfoSubjectsViewDelegate,
//BrokeAlertViewDelegate,
UIAlertViewDelegate,
ProductInfoJBAalterViewDelegate
>
@property (nonatomic, retain) ProductInfoSubjectsView *subjectView;
@property (nonatomic, retain) ProductInfoDataController *dataController;
@property (nonatomic, retain) ProductInfoSubjectsViewModel *viewModel;
@property (nonatomic, retain) NSString *commodityid;

@property (nonatomic , retain) ProductInfoJBAalterView *jubaoview;

@property (nonatomic , assign) BOOL istljshare;

@end

@implementation ProductInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setNavigation];
    if (_theObject) {
        [self initRenderSubjectView];
    }
    [self fetchSubjectData];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)setupSubviews{
    _subjectView = [ProductInfoSubjectsView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(kPadding);
        }
    }];
    _subjectView.delegate = self;
    _subjectView.userInteractionEnabled = NO;
    UISwipeGestureRecognizer *right=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    right.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    
    //    [NSTimer scheduledTimerWithTimeInterval:3 block:^(NSTimer * _Nonnull timer) {
    //        NSLog(@"%lf",_subjectView.height);
    //        NSLog(@"%lf",_subjectView.bottom);
    //        NSLog(@"%lf",self.view.height);
    //    } repeats:NO];
    
}





-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
    [btnright setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateHighlighted];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright addTarget:self action:@selector(doShareAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)handleSwipes:(UISwipeGestureRecognizer *)sender{
    //    if(_subjectView != nil)
    //    {
    //        [_subjectView removeFromSuperview];
    //        _subjectView = nil;
    //    }
    [_subjectView backNavAction];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doClickLeftAction{
    //    if(_subjectView != nil)
    //    {
    //        [_subjectView removeFromSuperview];
    //        _subjectView = nil;
    //    }
    [_subjectView backNavAction];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchSubjectData {
    _commodityid = @"";
    if ([_theObject isKindOfClass:[Commodity class]]) {
        _commodityid = [(Commodity *)_theObject commodityid];
    }else if ([_theObject isKindOfClass:[Article class]]){
        _commodityid = [NSString stringWithFormat:@"%@",[(Article *)_theObject artid]];
    }else{
        _commodityid = [NSString nullToString:_productId];
    }
    [self.dataController requestSubjectDataWithInView:self.view
                                          commodityid:_commodityid
                                             callback:^(NSError *error, BOOL state, NSString *describle) {
                                                 _subjectView.userInteractionEnabled = YES;
                                                 if (!error) {
                                                     [self renderSubjectView];
                                                 }
                                             }];
}

- (void)initRenderSubjectView{
    _viewModel = [ProductInfoSubjectsViewModel viewModelInitializeWithSubject:_theObject];
    self.title = _viewModel.navTitle;
    [_subjectView bindDataWithViewModel:_viewModel];
}

- (void)renderSubjectView {
    _viewModel = [ProductInfoSubjectsViewModel viewModelWithSubject:self.dataController.resultDict];
    self.title = _viewModel.navTitle;
    [_subjectView bindDataWithViewModel:_viewModel];
    
    //////
    if(_viewModel.linkType.integerValue == 1)
    {
        if(_viewModel.is_attention.integerValue == 1)
        {
            [self guanzhunavBottom:YES];
        }
        else
        {
            [self guanzhunavBottom:NO];
        }
    }
    
    
}

-(void)guanzhunavBottom:(BOOL)isselect
{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
    [btnright setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateHighlighted];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright addTarget:self action:@selector(doShareAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btnright1 = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright1.frame = CGRectMake(0,0,44,44);
    [btnright1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright1 addTarget:self action:@selector(guanzhuAction) forControlEvents:UIControlEventTouchUpInside];
    if(isselect)
    {
        [btnright1 setImage:[UIImage imageNamed:@"guanzhubaoliao_yes"] forState:UIControlStateNormal];
        [btnright1 setImage:[UIImage imageNamed:@"guanzhubaoliao_yes"] forState:UIControlStateHighlighted];
    }else{
        [btnright1 setImage:[UIImage imageNamed:@"guanzhubaoliao_no"] forState:UIControlStateNormal];
        [btnright1 setImage:[UIImage imageNamed:@"guanzhubaoliao_yes"] forState:UIControlStateHighlighted];
    }
    [btnright1 setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    UIBarButtonItem* rightBarButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnright1];
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem,rightBarButtonItem1];
}




int innumshare = 1;
- (void)doShareAction{
    Qqshare *share = self.dataController.resultShareInfo;
    if (share) {
        //1、创建分享参数（必要）
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        UIImage *images=[_subjectView.productImage imageByScalingProportionallyToSize:CGSizeMake(120.0, 120.0)];//
        NSArray* imageArray = images==nil?@[]:@[images];
        [shareParams SSDKSetupShareParamsByText:share.qqsharecontent
                                         images:imageArray
                                            url:[NSURL URLWithString:share.url]
                                          title:share.qqsharetitle
                                           type:SSDKContentTypeAuto];
        
        
//        UIImageView *imgvtemp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
//        [imgvtemp setImage:images];
//        [imgvtemp setContentMode:UIViewContentModeScaleAspectFit];
//        [self.view addSubview:imgvtemp];
//        
//        return;
        
        [shareParams SSDKSetupSinaWeiboShareParamsByText:share.sinaweibocontent title:nil image:share.image url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupTencentWeiboShareParamsByText:share.qqweibocontent images:images latitude:0 longitude:0 type:SSDKContentTypeAuto];
        
        NSString *shareWeChatTitle = share.qqsharetitle;
        if (_viewModel.commodityPirce.string) {
            shareWeChatTitle = [NSString stringWithFormat:@"%@！%@",shareWeChatTitle,_viewModel.commodityPirce.string];
        }
        [shareParams SSDKSetupWeChatParamsByText:share.qqsharecontent title:shareWeChatTitle url:[NSURL URLWithString:share.url] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        
        if(share.applet_url.length>6)
        {
            if([[MDB_UserDefault defaultInstance] imagediskImageExistsForURL:share.image])
            {
                images = [[MDB_UserDefault defaultInstance] getImageExistsForURL:share.image];
            }
            else
            {
                images = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:share.image]]];
                [[MDB_UserDefault defaultInstance] setSaveImageToCache:images forURL:[NSURL URLWithString:share.image]];
            }
            
            images=[images imageByScalingProportionallyToSize:CGSizeMake(images.size.width, images.size.width/4*3)];//
            
            if(UIImagePNGRepresentation(images).length>36720)
            {
                images=[images imageByScalingProportionallyToSize:CGSizeMake(images.size.width*0.8, images.size.height*0.8)];
            }
            ////小程序分享  需要判断是否需要分享小程序
            [shareParams SSDKSetupWeChatParamsByTitle:shareWeChatTitle description:share.qqsharecontent webpageUrl:[NSURL URLWithString:share.url] path:share.applet_url thumbImage:images userName:WXXiaoChengXuID forPlatformSubType:SSDKPlatformSubTypeWechatSession];
        }
        
        
        
        ///SSDKContentTypeMiniProgram  SSDKContentTypeAuto
        //2、分享
        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:self.view items:@[@(SSDKPlatformTypeSinaWeibo),
//                                                                                                 @(SSDKPlatformTypeTencentWeibo),
                                                                                                 @(SSDKPlatformTypeWechat),
                                                                                                 @(SSDKPlatformTypeQQ),
                                                                                                 @(SSDKPlatformTypeCopy)]
                                                                   shareParams:shareParams
                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                               if(platformType == SSDKPlatformTypeCopy)
                                                               {
                                                                   UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                                                   pasteboard.string = share.url;
                                                                   [MDB_UserDefault showNotifyHUDwithtext:@"链接复制成功" inView:self.view.window];
                                                               }
                                                               else if(platformType == SSDKPlatformTypeSinaWeibo)
                                                               {
//                                                                   WBAuthorizeRequest *authrequest = [WBAuthorizeRequest request];
//                                                                   authrequest.redirectURI = share.url;
//                                                                   authrequest.scope = @"all";
                                                                   
                                                                   [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                                                   
                                                               }
                                                               else
                                                               {
                                                                   [self.dataController requestShareRecordDataWithUrl:share.url callback:^(NSError *error, BOOL state, NSString *describle) {
                                                                   }];
                                                               }
                                                               
                                                           }];
        
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeCopy)];
        
    }else{
        [self.dataController requestShareSubjectDataWithCommodityid:self.dataController.resultDict[@"id"]
                                                             inView:self.view
                                                           callback:^(NSError *error, BOOL state, NSString *describle) {
                                                               if (!error) {
                                                                   if(innumshare==1)
                                                                   {
                                                                       [self doShareAction];
                                                                       innumshare=2;
                                                                   }
                                                                   
                                                               }
                                                           }];
    }
}



#pragma mark - 关注
-(void)guanzhuAction
{
    if ([MDB_UserDefault getIsLogin] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:110];
        [alertView show];
        return;
    
    }
    NSString *strstatus = @"0";
    if(_viewModel.is_attention.integerValue == 1)
    {
        strstatus = @"0";
    }
    else
    {
        strstatus = @"1";
    }
    
    NSDictionary *parmaters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"share_id":_commodityid,@"status":strstatus};
    
    [self.dataController requestguanzhushangpingDataWithInView:self.view value:parmaters callback:^(NSError *error, BOOL state, NSString *describle) {
        
        if(state)
        {
            
            if(_viewModel.is_attention.integerValue == 1)
            {
                _viewModel.is_attention = @"0";
                [self guanzhunavBottom:NO];
                
            }
            else
            {
                _viewModel.is_attention = @"1";
                [self guanzhunavBottom:YES];
                
                
            }
            [MDB_UserDefault showNotifyHUDwithtext:[NSString nullToString:describle] inView:self.view];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:[NSString nullToString:describle] inView:self.view];
        }
        
    }];
    
}

#pragma mark - ProductInfoSubjectsViewDelegate

///免邮教程
-(void)mianyoujiaochengPushAction:(NSString *)strlink
{
    MDBPGGWebViewController *vc = [[MDBPGGWebViewController alloc] init];
    vc.strurl = strlink;
    vc.strtitle = @"免邮教程";
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)fenxianghongbaov
{
    
    Qqshare *share = self.dataController.resultShareInfo;
    if (share) {
        NSString *strtitle = @"你有一个红包待领取！ 先领红包再下单，更便宜";
        NSString *strcontent = @"没得比";
        //1、创建分享参数（必要）
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        UIImage *images = [UIImage imageNamed:@"hongbao_tanchukuang"];
        //        UIImage *images=[imagetemp imageByScalingProportionallyToMinimumSize:CGSizeMake(120.0, 120.0)];
        NSArray* imageArray = images==nil?@[]:@[images];
        [shareParams SSDKSetupShareParamsByText:strcontent
                                         images:imageArray
                                            url:[NSURL URLWithString:share.url]
                                          title:strtitle
                                           type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupSinaWeiboShareParamsByText:strtitle title:nil image:images url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupTencentWeiboShareParamsByText:strtitle images:images latitude:0 longitude:0 type:SSDKContentTypeAuto];
        
        NSString *shareWeChatTitle =strtitle;
        [shareParams SSDKSetupWeChatParamsByText:strcontent title:shareWeChatTitle url:[NSURL URLWithString:share.url] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        
        //2、分享
        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:self.view items:nil
                                                                   shareParams:shareParams
                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                               
                                                               
                                                               if(state != SSDKResponseStateBegin && platformType != SSDKPlatformTypeUnknown)
                                                               {
                                                                   _istljshare=YES;
                                                                   _subjectView.istljshare = YES;
                                                                   [_subjectView zhidalianjiezidong];
                                                               }
                                                               
                                                               if(platformType == SSDKPlatformTypeCopy)
                                                               {
                                                                   UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                                                   pasteboard.string = share.url;
                                                                   [MDB_UserDefault showNotifyHUDwithtext:@"链接复制成功" inView:self.view.window];
                                                               }
                                                               else
                                                               {
                                                                   [self.dataController requestShareRecordDataWithUrl:share.url callback:^(NSError *error, BOOL state, NSString *describle) {
                                                                   }];
                                                               }
                                                               
                                                           }];
        
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeCopy)];
        
    }else{
        [self.dataController requestShareSubjectDataWithCommodityid:self.dataController.resultDict[@"id"]
                                                             inView:self.view
                                                           callback:^(NSError *error, BOOL state, NSString *describle) {
                                                               if (!error) {
                                                                   if(innumshare==1)
                                                                   {
                                                                       [self fenxianghongbaov];
                                                                       innumshare=2;
                                                                   }
                                                                   
                                                               }
                                                           }];
    }
}
///求开团
-(void)qiukaituanPushAction:(NSString *)strmessage
{
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:_commodityid forKey:@"share_id"];
    [dicpush setObject:[NSString nullToString:strmessage] forKey:@"msg"];
    NSString *userkey=[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
    [dicpush setObject:userkey forKey:@"userkey"];
    [self.dataController requestQiukaiTuanHomeDataInView:self.view dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        
        if(state)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"代购菌收到后会尽快处理哦，请随时关注APP代购频道，以免错过~" inView:self.view];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
        
    }];
    
}

- (void)productInfoSubjectsView:(ProductInfoSubjectsView *)subjectView
              didPressItemIndex:(NSInteger)index{
    
}

- (void)productInfoSubjectsViewDidPressCourseBtnWithLink:(NSString *)courseLink
                                                 sitName:(NSString *)name{
    CourseViewController *couresVc = [[CourseViewController alloc] init];
    couresVc.courselink = courseLink;
    couresVc.sitName = name;
    [self.navigationController pushViewController:couresVc animated:YES];
}

- (void)tabBarViewdidPressZanItem{
    //    if ([MDB_UserDefault getIsLogin]&&_commodityid){
    if (_commodityid) {
        [self.dataController requestZanDataWithInView:self.view
                                          Commodityid:_commodityid
                                             callback:^(NSError *error, BOOL state, NSString *describle) {
                                                 if (!error && self.dataController.isSuccessZan) {
                                                     [_subjectView updateSubjectViewWithType:UpdateViewTypeZan isMinus:NO];
                                                 }
                                             }];
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请重新尝试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
        //                                                            message:@"请登录后再试"
        //                                                           delegate:self
        //                                                  cancelButtonTitle:Nil
        //                                                  otherButtonTitles:@"登录",@"取消", nil];
        //        [alertView show];
    }
}
- (void)tabBarViewdidPressShouItemWithLinkType:(NSString *)linkType{
    if ([MDB_UserDefault getIsLogin]&&_commodityid) {
        if (!_theObject) {
            linkType = @"1";
        }
        [self.dataController requestShouDataWithInView:self.view
                                           Commodityid:_commodityid
                                              linkType:linkType
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
- (void)tabBarViewdidPressComItem{
    
    RemarkHomeViewController *remarkHomeVc = [[RemarkHomeViewController alloc] init];
    remarkHomeVc.type = RemarkTypeNormal;
    remarkHomeVc.linkid = _commodityid;
    [self.navigationController pushViewController:remarkHomeVc animated:YES];
}
- (void)tabBarViewdidPressNonstopItemWithOutUrlStr:(NSString *)urlLink andsafari:(NSString *)safaritype{
    
    //    urlLink = @"https://p.eqifa.com/c?w=428888&c=254&i=160&pf=y&e=test&t=https://item.m.jd.com/product/4838712.html";
    
//    NSString *strproductid = @"";
//    strproductid = [NSString nullToString:[self judgeUrlId:urlLink]];
//    if([urlLink rangeOfString:@"meidebi.com"].location != NSNotFound && strproductid.length>0&&strproductid.length<10&&[urlLink rangeOfString:@"s-"].location == NSNotFound)
//    {///
//        ProductInfoViewController *pv = [[ProductInfoViewController alloc] init];
//        pv.productId = strproductid;
//        [self.navigationController pushViewController:pv animated:YES];
//    }
//    else if([urlLink rangeOfString:@"s-"].location != NSNotFound&& strproductid.length>0&&strproductid.length<10)
//    {
//        OriginalDetailViewController *ovc = [[OriginalDetailViewController alloc] initWithOriginalID:strproductid];
//        [self.navigationController pushViewController:ovc animated:YES];
//    }
//    else
//    {
//        SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:urlLink];
//        svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:svweb animated:NO completion:nil];
//    }
    SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:urlLink];
    svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:svweb animated:NO completion:nil];
    
}
///详情中的链接
- (void)detailViewdidPressNonstopItemWithOutUrlStr:(NSString *)urlLink andsafari:(NSString *)safaritype
{
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
    else
    {
        SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:urlLink];
        svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:svweb animated:NO completion:nil];
    }
}

-(NSString *)judgeUrlId:(NSString *)strurl
{
    
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    NSString *strtemp = [NSString nullToString:[strurl stringByTrimmingCharactersInSet:nonDigits]];
    
    
    return strtemp;
    
}

////关注按钮显示问题
-(void)guanzhuButtonShow
{
    
    [self guanzhunavBottom:NO];
}

#pragma mark - ///d京东链接跳转
- (void)tabBarViewdidPressNonstopItemWithOutUrlStrJDPush:(NSString *)urlLink
{
//    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
//    launchMiniProgramReq.userName = @"没得比现货"; //没得比现货 没得比海淘  //拉起的小程序的username
////    launchMiniProgramReq.path = urlLink;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
//    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
//     BOOL iswx = [WXApi sendReq:launchMiniProgramReq];///SendAuthReq、SendMessageToWXReq、PayReq
    
    
//    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
//    launchMiniProgramReq.userName = @"gh_xhdfjegew78";
////    launchMiniProgramReq.path = path;
//    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease;
//
//    [WXApi sendReq:launchMiniProgramReq];
//
//    NSString *strrr = @"";
    
//    urlLink = @"https://wq.jd.com/mjgj/link/GetOpenLink?callback=getOpenLink&rurl=https://dc2.jd.com/auto.php?service=transfer&type=pms&to=https://www.meidebi.com/";
//    ///OpenWebviewReq
//    OpenWebviewReq* req =[[OpenWebviewReq alloc ] init ];
//    req.url = urlLink ;
////    req.openID = @"wx482499aac0e8d8f7";
//    //第三方向微信终端发送一个SendAuthReq消息结构
//    [WXApi sendReq:req];
    
    
    
    ///url跳转
    KeplerApiManager *kmanager = [KeplerApiManager sharedKPService];
    kmanager.openJDTimeout = 15;
    kmanager.isOpenByH5 = NO;
    kmanager.JDappBackTagID = jd_app_keplerID;
//    kmanager.actId = @"没得比";
//    kmanager.ext = @"没得比";
    NSDictionary *dicinfo = @{@"keplerCustomerInfo":@"没得比"};
    [kmanager openKeplerPageWithURL:urlLink sourceController:self jumpType:2 userInfo:dicinfo];
    
}

- (void)tabBarViewdidPressNonstopItemWithTmallUrlStr:(NSString *)urlLink{
    id<AlibcTradePage> page = [AlibcTradePageFactory page:urlLink];
    [self callTaobaoWith:page taokeParam:nil];
    
}

- (void)tabBarViewdidPressNonstopItemWithTmallidStr:(NSString *)tmallid{
    id<AlibcTradePage> page = [AlibcTradePageFactory itemDetailPage:tmallid];
    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
    taokeParams.pid = @"mm_10004210_14552080_57192450";
    taokeParams.adzoneId = @"57192450";
    taokeParams.subPid = @"";
    taokeParams.unionId = @"";
    [self callTaobaoWith:page taokeParam:taokeParams];
    
}

- (void)callTaobaoWith:(id<AlibcTradePage>)page taokeParam:(AlibcTradeTaokeParams *)taokeParams{
    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    showParams.openType = AlibcOpenTypeNative;
    //    showParams.backUrl = @"";
    showParams.linkKey = @"taobao";
    [service show:self
             page:page
       showParams:showParams
      taoKeParams:taokeParams
       trackParam:nil
tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
} tradeProcessFailedCallback:^(NSError * _Nullable error) {
}];
}

- (void)tabBarViewDidPressReportItem{
    
    ProductInfoJBAalterView *alterview = [[ProductInfoJBAalterView alloc] init];
    [alterview setDelegate:self];
    [alterview showAlert];
    
    _jubaoview = alterview;
}

- (void)detailSubjectViewDidCickReadMoreRemark{
    [self tabBarViewdidPressComItem];
}

- (void)remarkHomeSubjectClickUrl:(NSString *)urlStr{
    if (!urlStr) return;
    ADHandleViewController *vc = [[ADHandleViewController alloc] initWithAdLink:urlStr];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)photoGroupView:(YYPhotoGroupView *)photoGroupView didClickImageView:(UIView *)fromeView{
    [photoGroupView presentFromImageView:fromeView
                             toContainer:self.navigationController.view
                                animated:YES
                              completion:nil];
}

- (void)relevanceCellDidCilckCellWithID:(NSString *)relevanceID{
    ProductInfoViewController *ProductInfoVc = [[ProductInfoViewController alloc] init];
    ProductInfoVc.productId = relevanceID;
    [self.navigationController pushViewController:ProductInfoVc animated:YES];
}

- (void)relevanceCellDidCilckCellWithLinkUrl:(NSString *)link{
    SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:link];
    svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:svweb animated:NO completion:nil];
}

- (void)relevanceCellDidCilckLikeBtn:(NSString *)relevanceID didComplete:(void (^)(void))didComplete{
    if ([MDB_UserDefault getIsLogin]&&relevanceID) {
        [self.dataController requestZanDataWithInView:self.view
                                          Commodityid:relevanceID
                                             callback:^(NSError *error, BOOL state, NSString *describle) {
                                                 if (!error && self.dataController.isSuccessZan) {
                                                     if (didComplete) {
                                                         didComplete();
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

- (void)relevanceRecommendCellDidCilckCellWithID:(NSString *)recommendID{
    SpecialInfoViewController *specialInfoVc = [[SpecialInfoViewController alloc] initWithSpecialInfo:recommendID];
    [self.navigationController pushViewController:specialInfoVc animated:YES];
}

- (void)detailSubjectViewDidCickFlagViewSimpleSearch:(NSString *)searchStr{
    
    WoGuanZhuBiaoQianSearchListTableViewController *pvc = [[WoGuanZhuBiaoQianSearchListTableViewController alloc] init];
    pvc.seourl = searchStr;
    pvc.strtitle = searchStr;
    [self.navigationController pushViewController:pvc animated:YES];
    /*
    UIStoryboard *mainStroy=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchEndViewController *ductViewC=[mainStroy instantiateViewControllerWithIdentifier:@"com.mdb.SearchEndView.ViewController"];
    ductViewC.searchStr=searchStr;
    [self.navigationController pushViewController:ductViewC animated:YES];
     */
}

- (void)detailSubjectViewDidCickFlagViewComplexSearchID:(NSString *)searchID name:(NSString *)name type:(FlagType)type{
    if([NSString nullToString:searchID].length<1)
    {
        return;
    }
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchMainViewController *searchM=[story instantiateViewControllerWithIdentifier:@"com.mdb.SearchMainView.ViewController"];
    
//    if (type == FlagTypeCategory) {
//        searchM.vcType = SearchMainVcTypeCategory;
//    }else{
//        searchM.vcType = SearchMainVcTypeHot;
//    }
    if(type == FlagTypeSite)
    {
        NSMutableArray *arrtemp = [NSMutableArray new];
        NSDictionary *dictemp = @{@"dependentPathRow":@"0",@"dependentPathSection":@"1",@"itemID":searchID,@"itemName":[NSString nullToString:[name componentsSeparatedByString:@"："].lastObject]};
        [arrtemp addObject:dictemp];
        searchM.searchContents = arrtemp;
    }
    else
    {
        searchM.cats = searchID.intValue;
        searchM.catName = [name componentsSeparatedByString:@"："].lastObject;
        searchM.vcType = SearchMainVcTypeCategory;
    }
    
    [self.navigationController pushViewController:searchM animated:YES];
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

- (void)detailSubjectViewDidCickAvaterViewWithUserid:(NSString *)userid{
    PersonalInfoIndexViewController *personalInfoVc = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    [self.navigationController pushViewController:personalInfoVc animated:YES];
}

- (void)detailSubjectViewShowGuideElementRects:(NSArray *)rects{
    //    NSArray *tips = @[@"关注比友，快速获取好友更新；点击头像可进入他的个人主页哦~"];
    //    [ZLJFeaturesGuideView showGuideViewWithRects:rects tips:tips];
    //    [MDB_UserDefault setShowAppProductGuide:YES];
}

- (void)detailSubjectViewDidCickRewardButton{
    if ([MDB_UserDefault getIsLogin]&&_commodityid) {
        RewardHomeViewController *rewardVC = [[RewardHomeViewController alloc] initWithCommodityID:_commodityid
                                                                                              type:RewardTypeDiscount];
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

- (void)detailSubjectViewDidCickRewardInfo{
    RewardRecordViewController *rewardRecordVC = [[RewardRecordViewController alloc] initWithCommodityID:_commodityid
                                                                                                    type:RewardLogTypeDiscount];
    [self.navigationController pushViewController:rewardRecordVC animated:YES];
}

- (void)detailSubjectViewDidCickByButtonWithType:(NSString *)type didComplete:(void (^)(BOOL))didComplete{
    if ([MDB_UserDefault getIsLogin]&&_commodityid) {
        [self.dataController requestByInfoSubjectDataWithCommodityid:_commodityid
                                                                type:type
                                                              inView:self.view
                                                            callback:^(NSError *error, BOOL state, NSString *describle) {
                                                                didComplete(state);
                                                                if (!state) {
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

- (void)hotShowdanCellDidCilckCellWithID:(NSString *)shwodanID{
    OriginalDetailViewController *showdanVC = [[OriginalDetailViewController alloc] initWithOriginalID:shwodanID];
    [self.navigationController pushViewController:showdanVC animated:YES];
}

///拼单代购  1处理
-(void)bindPinDanOrder:(int)itype andgoodsid:(NSString *)goodsid andgeid:(NSString *)strguigeid andnum:(NSString *)strnum
{
    NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"id":goodsid,@"num":strnum,@"goodsdetailid":strguigeid};
    [self.dataController requestDGHomeDataInView:self.view dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        
        if(state)
        {
            
            NSString *strneedIdcard = [NSString nullToString:[self.dataController.dicValue objectForKey:@"needIdcard"]];
            int istate = 2;
            BOOL iscanyu = NO;
            if([strneedIdcard intValue] == 1)
            {
                istate = 1;
                iscanyu = NO;
            }
            else
            {
                istate = 2;
                iscanyu = YES;
            }
            ////需要判断是否还有代购数量
            DaiGouXiaDanViewController *dvc = [[DaiGouXiaDanViewController alloc] init];
            dvc.strid = goodsid;/////
            dvc.itype = istate;
            dvc.iscanyupintuan = iscanyu;
            dvc.dicvalue = self.dataController.dicValue;
            dvc.iseditnumber = YES;
            [self.navigationController pushViewController:dvc animated:YES];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
    }];
    
}
///加入购物车
-(void)bindPinDanAddCar:(int)itype andgoodsid:(NSString *)goodsid andgeid:(NSString *)strguigeid andnum:(NSString *)strnum
{
    
    if ([MDB_UserDefault getIsLogin] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:110];
        [alertView show];
        return;
    }
    
    if(goodsid==nil)return;
    
    NSDictionary *dicpush = @{@"id":goodsid,@"num":strnum,@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"goodsdetailid":strguigeid};
    
    
    
    [self.dataController requestAddBuCarDataLine:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            
            //动画
//            UIImageView *imgvtemp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//            [imgvtemp setImage:[UIImage imageNamed:@"addgouwuche_remu"]];
//            [imgvtemp setCenter:CGPointMake(self.view.width/2.0, self.view.height/2.0)];
//            [self.view addSubview:imgvtemp];
//            [UIView animateWithDuration:0.5 animations:^{
//                [imgvtemp setWidth:1];
//                [imgvtemp setHeight:1];
//                [imgvtemp setTop:10];
//                [imgvtemp setRight:self.view.width-20];
//                
//                
//            } completion:^(BOOL finished) {
//                [imgvtemp removeFromSuperview];
//                ///购物车数量处理
////                if(self.delegate)
////                {
////                    [self.delegate gouwucheadd];
////                }
//            }];
            [MDB_UserDefault showNotifyHUDwithtext:@"购物车添加成功" inView:self.view.window];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view.window];
        }
    }];
    
    
}

///求开团获取同款商品
-(void)qiukaituanItemsPushAction
{
    if(self.dataController.qiukaituanValue != nil)
    {
        @try {
            [_subjectView qiukaituanItemsPushAction:self.dataController.qiukaituanValue];
        } @catch (NSException *exception) {
            [_subjectView qiukaituanItemsPushAction:nil];
        } @finally {
            
        }
    }
    else
    {
        NSDictionary *dicpush = @{@"id":[NSString nullToString:_commodityid],@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
        [self.dataController requestgQiuKiaTuanItemsDataWithInView:self.view value:dicpush callback:^(NSError *error, BOOL state, NSString *describle) {
            @try {
                [_subjectView qiukaituanItemsPushAction:self.dataController.qiukaituanValue];
            } @catch (NSException *exception) {
                [_subjectView qiukaituanItemsPushAction:nil];
            } @finally {
                
            }
            
        }];
    }
    
    
}

#pragma mark - BrokeAlertViewDelegate
//- (void)brokeAlertViewDidPressEnsureBtnWithAlertView:(BrokeAlertView *)alertView{
//
//    [self.dataController requestResportDataWithInView:self.subjectView
//                                            productid:_commodityid
//                                             callback:^(NSError *error, BOOL state, NSString *describle) {
//                                                 if (self.dataController.resportStatue) {
//                                                     NJPushSetAlertView *alterView = [[NJPushSetAlertView alloc] init];
//                                                     alterView.alertTitle = @"过期举报成功！";
//                                                     alterView.alertContent = @"感谢您为没得比信息库做出的巨大贡献，特发 “卓越贡献奖“，希望再接再厉！ ";
//                                                     [alterView show];
//                                                 }
//                                             }];
//}
#pragma mark - ProductInfoJBAalterViewDelegate
///举报原因
- (void)ProductInfoJBAalterViewDelegateDidPressEnsureBtnWithAlertViewItem:(NSInteger)item
{
    NSArray *arrtitle = [NSArray arrayWithObjects:@"价格上调",@"商品售罄",@"优惠券过期",@"其他", nil];
    NSString *strfeed = @"";
    if(item<arrtitle.count)
    {
        strfeed = arrtitle[item];
    }
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:_commodityid forKey:@"id"];
    [dicpush setObject:strfeed forKey:@"feedback"];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    
    
    [self.dataController requestJuBaoHomeDataInView:_jubaoview dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            //            NJPushSetAlertView *alterView = [[NJPushSetAlertView alloc] init];
            //            alterView.alertTitle = @"举报成功！";
            //            alterView.alertContent = @"感谢您为没得比信息库做出的巨大贡献，特发 “卓越贡献奖“，希望再接再厉！ ";
            //            [alterView show];
            [_jubaoview hiddenAlert];
            [MDB_UserDefault showNotifyHUDwithtext:@"举报成功！" inView:self.subjectView];
        }
        else
        {
            
            if(describle.length>0)
            {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:_jubaoview];
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:@"举报失败" inView:_jubaoview];
            }
            
            
        }
    }];
    
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
    }
}
#pragma mark - getters and setters
- (ProductInfoDataController *)dataController{
    if (!_dataController) {
        _dataController = [[ProductInfoDataController alloc] init];
    }
    return _dataController;
}


//-(void)dealloc
//{
//    if(_s.ubjectView != nil)
//    {
//        [_subjectView removeFromSuperview];
//        _subjectView = nil;
//    }
//    _dataController = nil;
//    _subjectView = nil;
//    _viewModel = nil;
//
//}

@end
