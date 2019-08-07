//
//  PaySuccessViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/30.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PaySuccessViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#import "OrderDetaileViewController.h"

#import "DaiGouXiaDanViewController.h"

#import "HTTPManager.h"

#import "MDB_UserDefault.h"

#import "UIImage+Extensions.h"

#import "MyOrderMainViewController.h"

#import "ShareHongBaoView.h"

@interface PaySuccessViewController ()<ShareHongBaoViewDelegate>
{
    UIScrollView *scvback;
    
    NSDictionary *dicdata;
    UILabel *lbtext;
    UILabel *lbtext1;
    
    UIImageView *imgvhead;
    
    BOOL isorderdetal;
    
    NSString *strsharecouurl;
    NSString *strsharecoumaxnumber;
}
@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付成功";
    
    [self drawSubview];
    
    ////MyOrderSharePayHongBaoViewUrl
    
    NSDictionary *dicpush = @{@"orderNos":_strorderno,@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:MyOrderShareViewUrl withParametersDictionry:dicpush view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
        NSDictionary *dicAll=[str JSONValue];
        if([[dicAll objectForKey:@"status"] intValue] == 1)
        {
            if([[dicAll objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                dicdata = [dicAll objectForKey:@"data"];
//                NSLog(@"%@",dicAll);
                [self drawbottombt];
                [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhead url:[[dicdata objectForKey:@"info"] objectForKey:@"image"]];
            }
            
        }
        else
        {
//            [MDB_UserDefault showNotifyHUDwithtext:@"数据加载失败" inView:self.view];
        }
        
        
    }];
    
    
    
    [self changjianhongbao];
    
    
//    NSArray *arrtemp = [_strorderno componentsSeparatedByString:@","];
//    if(arrtemp.count>0)
//    {
//        NSDictionary *dicpush1 = @{@"orderno":arrtemp[0],@"userkey":[MDB_UserDefault defaultInstance].usertoken};
//        [HTTPManager sendGETRequestUrlToService:MyOrderSharePayHongBaoViewUrl withParametersDictionry:dicpush1 view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
//            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
//            NSDictionary *dicAll=[str JSONValue];
//            if([[dicAll objectForKey:@"status"] intValue] == 1)
//            {
//                if([[dicAll objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
//                {
//                    NSDictionary *dicdata = [dicAll objectForKey:@"data"];
//                    strsharecouurl = [NSString nullToString:[dicdata objectForKey:@"landurl"]];
//                    strsharecoumaxnumber = [NSString nullToString:[dicdata objectForKey:@"maxnumber"]];
//                    ShareHongBaoView *sview = [[ShareHongBaoView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH) andtitle:[NSString stringWithFormat:@"恭喜获得%@个红包",[NSString nullToString:[dicdata objectForKey:@"maxnumber"]]] andcontent:@"分享给小伙伴，大家一起领"];
//                    [sview setDelegate:self];
//                    [self.view addSubview:sview];
//
//                }
//
//            }
//
//
//        }];
//    }
    
    
    
    [self setNavBarBackBtn];
}


-(void)changjianhongbao
{
    NSArray *arrtemp = [_strorderno componentsSeparatedByString:@","];
    if(arrtemp.count>0)
    {
        NSDictionary *dicpush1 = @{@"orderno":arrtemp[0],@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
        [HTTPManager sendRequestUrlToService:MyOrderDetailPopordercouponinfoUrl withParametersDictionry:dicpush1 view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if([[dicAll objectForKey:@"status"] intValue] == 1)
            {
                if([[dicAll objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dicdata = [dicAll objectForKey:@"data"];
                    @try {
                        strsharecouurl = [NSString nullToString:[dicdata objectForKey:@"landurl"]];
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        
                    }
                    
//                    strsharecoumaxnumber = [NSString nullToString:[dicdata objectForKey:@"maxnumber"]];
                    
                    [HTTPManager sendGETRequestUrlToService:MyOrderSharePayHongBaoViewUrl withParametersDictionry:dicpush1 view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                        NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                        NSDictionary *dicAll1=[str JSONValue];
                        if([[dicAll1 objectForKey:@"status"] intValue] == 1)
                        {
                            if([[dicAll1 objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
                            {
                                NSDictionary *dicdatatemp = [dicAll1 objectForKey:@"data"];
                                @try {
                                    if([[NSString nullToString:[dicdatatemp objectForKey:@"landurl"]] length] > 5)
                                    {
                                        strsharecouurl = [NSString nullToString:[dicdatatemp objectForKey:@"landurl"]];
                                    }
//                                    if(strsharecouurl.length<10)
//                                    {
//                                        strsharecouurl = [NSString nullToString:[dicdatatemp objectForKey:@"landurl"]];
//                                    }
                                    
                                } @catch (NSException *exception) {
                                    
                                } @finally {
                                    
                                }
                                
                                strsharecoumaxnumber = [NSString nullToString:[dicdatatemp objectForKey:@"maxnumber"]];
                                ShareHongBaoView *sview = [[ShareHongBaoView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH) andtitle:[NSString stringWithFormat:@"恭喜获得%@个红包",[NSString nullToString:[dicdatatemp objectForKey:@"maxnumber"]]] andcontent:@"分享给小伙伴，大家一起领"];
                                [sview setDelegate:self];
                                [self.view addSubview:sview];
                                
                            }
                            
                        }
                        
                        
                    }];
                    
                    
//
//
//                    ShareHongBaoView *sview = [[ShareHongBaoView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH) andtitle:[NSString stringWithFormat:@"恭喜获得%@个红包",[NSString nullToString:[dicdata objectForKey:@"maxnumber"]]] andcontent:@"分享给小伙伴，大家一起领"];
//                    [sview setDelegate:self];
//                    [self.view addSubview:sview];
                    
                }
                
            }
            
            
        }];
    }
}

-(void)shareAction
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *images=[UIImage imageNamed:@"icon120.png"];
    
    NSArray* imageArray = images==nil?@[]:@[images];
    
    
    NSString *strtitle = [NSString stringWithFormat:@"你有一个红包待领取！第%@个最大！",strsharecoumaxnumber];
    
    NSString *strcontent = @"没得比一键海淘，带你淘遍世界好物~";
    
    [shareParams SSDKSetupShareParamsByText:strcontent
                                     images:imageArray
                                        url:[NSURL URLWithString:strsharecouurl]
                                      title:strtitle
                                       type:SSDKContentTypeAuto];
    
    //
    //
    //    [shareParams SSDKSetupSinaWeiboShareParamsByText:strcontent title:nil image:images url:[NSURL URLWithString:orderModel.link] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    
    //    [shareParams SSDKSetupTencentWeiboShareParamsByText:strcontent images:images latitude:0 longitude:0 type:SSDKContentTypeAuto];
    
    NSString *shareWeChatTitle = strtitle;
//    [shareParams SSDKSetupWeChatParamsByText:strcontent title:shareWeChatTitle url:[NSURL URLWithString:strsharecouurl] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    ///分享更改
    [shareParams SSDKSetupWeChatParamsByText:strcontent title:shareWeChatTitle url:[NSURL URLWithString:strsharecouurl] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    ///分享更改
    [ShareSDK showShareActionSheet:self.view customItems:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)] shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
    }];
    //2、分享
//    [ShareSDK showShareActionSheet:self.view
//                             items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)]
//                       shareParams:shareParams
//               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                   //                           [self.dataController requestShareRecordDataWithUrl:share.url callback:^(NSError *error, BOOL state, NSString *describle) {
//                   //                           }];
//                   NSLog(@"sdfasdf");
//               }];
    
}


- (void)setNavBarBackBtn{
    //    UIImage *backButtonImage = [[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.navigationController.navigationBar.backIndicatorImage = backButtonImage;
    //    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backButtonImage;
    
    
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)doClickBackAction{
    
//    NSArray *arrvcs = self.navigationController.viewControllers;
//    UIViewController *vc3 = arrvcs[arrvcs.count-3];
//    if([vc3 isKindOfClass:[DaiGouXiaDanViewController class]])
//    {
//        UIViewController *vc4 = arrvcs[arrvcs.count-4];
//        [self.navigationController popToViewController:vc4 animated:YES];
//    }
//    else
//    {
//        [self.navigationController popToViewController:vc3 animated:YES];
//    }
    
    if(isorderdetal==NO)
    {
        MyOrderMainViewController *mvc = [[MyOrderMainViewController alloc]init];
        [self.navigationController pushViewController:mvc animated:YES];
    }
    else
    {
        OrderDetaileViewController *ovc = [[OrderDetaileViewController alloc] init];
//        ovc.strid = _strorderno;
        ovc.strorderno = _strorderno;
        [self.navigationController pushViewController:ovc animated:YES];
    }
    
}


-(void)drawSubview
{
    float ftopheith =  kStatusBarHeight+44;
    float fother = 34.0;
    if(ftopheith<66)
    {
        ftopheith = 64;
        fother = 0;
    }
    scvback = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ftopheith, BOUNDS_WIDTH, BOUNDS_HEIGHT-ftopheith-fother)];
    [scvback setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scvback];
    
    imgvhead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    
    
    UIImageView *imgvsuccess = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH*0.2, BOUNDS_WIDTH*0.2)];
    [imgvsuccess setImage:[UIImage imageNamed:@"zhifu_success"]];
    [imgvsuccess setCenter:CGPointMake(scvback.width/2.0, 0)];
    [imgvsuccess setTop:30];
    [scvback addSubview:imgvsuccess];
    
    lbtext = [[UILabel alloc] initWithFrame:CGRectMake(0, imgvsuccess.bottom+15, scvback.width, 20)];
    [lbtext setText:@"支付成功"];
    [lbtext setTextColor:RGB(51,51,51)];
    [lbtext setTextAlignment:NSTextAlignmentCenter];
    [lbtext setFont:[UIFont systemFontOfSize:19]];
    [scvback addSubview:lbtext];
    
    lbtext1 = [[UILabel alloc] initWithFrame:CGRectMake(0, lbtext.bottom+15, scvback.width, 40)];
    [lbtext1 setText:@"买了个便宜货？分享给好友一起买买买吧"];
    [lbtext1 setTextColor:RGB(153,153,153)];
    [lbtext1 setTextAlignment:NSTextAlignmentCenter];
    [lbtext1 setFont:[UIFont systemFontOfSize:16]];
    [lbtext1 setNumberOfLines:2];
    [scvback addSubview:lbtext1];
    
    
    
}


-(void)drawbottombt
{
    BOOL ishoushare = NO;
    float fbottom = lbtext1.bottom+50;
    if([[NSString nullToString:dicdata[@"needshare"]] integerValue] == 1)
    {///需要分享
        isorderdetal = YES;
        ishoushare = YES;
        NSDictionary *dicinfo = [dicdata objectForKey:@"info"];
        
        if([[NSString nullToString:dicinfo[@"pindan_id"]] length] > 0)
        {///这是拼单
            if([[NSString nullToString:dicinfo[@"remain_pindannum"]] intValue] > 0)
            {///还差人
                [lbtext1 setText:[NSString stringWithFormat:@"还差%@件成团，邀请志同道合的朋友一起买买买，拼团成功率高很多噢！",[NSString nullToString:dicinfo[@"remain_pindannum"]]]];
                
                
            }
            else
            {
                [lbtext1 setText:@"买手会尽快为您代购，请耐心等待"];
                ishoushare = NO;
            }
            
            if([[NSString nullToString:dicinfo[@"colonel"]] intValue] == 1)
            {
                if([[NSString nullToString:dicinfo[@"remain_pindannum"]] intValue] > 0)
                {
                    [lbtext setText:[NSString stringWithFormat:@"成功开团，还差%@件成团",[NSString nullToString:dicinfo[@"remain_pindannum"]]]];
                    [lbtext1 setText:@"邀请志同道合的朋友一起买买买，拼团成功率高很多噢！订单完成后得￥5.00奖励金"];
                }
                else
                {
                    //                [lbtext setText:@"成功开团"];
                    [lbtext1 setText:@"买手会尽快为您代购，请耐心等待"];
                }
                
                
            }
            
        }
        else
        {
            [lbtext1 setText:@"买了个便宜货？分享给好友一起买买买吧"];
        }
    }
    else
    {
        isorderdetal = NO;
        [lbtext1 setText:@"买手会尽快为您代购，请耐心等待"];
        
        if(_ismoreorders)
        {
            UIView *viewback = [[UIView alloc] initWithFrame:CGRectMake(15, lbtext1.bottom+10, scvback.width-30, 70)];
            [viewback setBackgroundColor:RGB(242, 242, 242)];
            [viewback.layer setMasksToBounds:YES];
            [viewback.layer setCornerRadius:5];
            [scvback addSubview:viewback];
            
            UILabel *lbtext2 = [[UILabel alloc] initWithFrame:CGRectMake(30, lbtext1.bottom+15, scvback.width-60, 60)];
            [lbtext2 setText:@"因您的订单同时包含直接下单、拼单商品，或多个拼单商品，需要进行拆单处理，请前往订单列表查看对应状态。"];
            [lbtext2 setTextColor:RGB(153,153,153)];
            [lbtext2 setTextAlignment:NSTextAlignmentLeft];
            [lbtext2 setNumberOfLines:0];
            [lbtext2 setFont:[UIFont systemFontOfSize:14]];
            [scvback addSubview:lbtext2];
            [lbtext2 setBackgroundColor:RGB(242, 242, 242)];
            fbottom = lbtext2.bottom+30;
        }
        else
        {
            isorderdetal = YES;
        }
        
    }
    
    
    UIButton *btshare = [[UIButton alloc] initWithFrame:CGRectMake(38, fbottom, scvback.width-76, 50)];
    [btshare.layer setMasksToBounds:YES ];
    [btshare.layer setCornerRadius:btshare.height/2.0];
    [btshare.layer setBorderColor:RGB(253,122,14).CGColor];
    [btshare.layer setBorderWidth:1];
    [btshare setTitle:@"分享给好友" forState:UIControlStateNormal];
    [btshare setTitleColor:RGB(253,122,14) forState:UIControlStateNormal];
    [btshare.titleLabel setFont:[UIFont systemFontOfSize:19]];
    [btshare setTag:0];
    [btshare addTarget:self action:@selector(myAction:) forControlEvents:UIControlEventTouchUpInside];
    [scvback addSubview:btshare];
    if(ishoushare==NO)
    {
        [btshare setHidden:YES];
        [btshare setHeight:1];
    }
    
    UIButton *btorder = [[UIButton alloc] initWithFrame:CGRectMake(btshare.left, btshare.bottom+28, btshare.width, 50)];
    [btorder.layer setMasksToBounds:YES ];
    [btorder.layer setCornerRadius:btshare.height/2.0];
    [btorder.layer setBorderColor:RGB(253,122,14).CGColor];
    [btorder.layer setBorderWidth:1];
    [btorder setTitle:@"查看订单" forState:UIControlStateNormal];
    [btorder setTitleColor:RGB(253,122,14) forState:UIControlStateNormal];
    [btorder.titleLabel setFont:[UIFont systemFontOfSize:19]];
    [btorder setTag:1];
    [btorder addTarget:self action:@selector(myAction:) forControlEvents:UIControlEventTouchUpInside];
    [scvback addSubview:btorder];
    if(isorderdetal==NO)
    {
        [btorder setTitle:@"前往查看" forState:UIControlStateNormal];
    }
    
}


#pragma mark -
-(void)myAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {///分享
            //1、创建分享参数（必要）
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//            UIImage *images=[UIImage imageNamed:@"zhifu_success"];
            UIImage *images=[imgvhead.image imageByScalingProportionallyToSize:CGSizeMake(120.0, 120.0)];
            if(images==nil)
            {
                images=[UIImage imageNamed:@"pucdNot.png"];
            }
            NSArray* imageArray = images==nil?@[]:@[images];
            NSDictionary *dicinfo = [dicdata objectForKey:@"info"];
            NSString *strtitle = [NSString nullToString:dicinfo[@"title"]];
            
            NSString *strprice = [NSString stringWithFormat:@"%.2lf",[[NSString nullToString:dicinfo[@"price"]] floatValue]];
            
            strtitle = [NSString stringWithFormat:@"￥%@！%@",strprice,strtitle];
            
            NSString *strcontent = [NSString nullToString:[NSString stringWithFormat:@"代购价格￥%@", strprice]];
            if([[NSString nullToString:dicinfo[@"remain_pindannum"]] intValue] > 0)
            {
                strcontent = [NSString nullToString:[NSString stringWithFormat:@"还差%@件成团，拼单价格￥%@", [NSString nullToString:dicinfo[@"remain_pindannum"]],strprice]];
            }
            
            [shareParams SSDKSetupShareParamsByText:strcontent
                                             images:imageArray
                                                url:[NSURL URLWithString:[NSString nullToString:dicinfo[@"link"]]]
                                              title:strtitle
                                               type:SSDKContentTypeAuto];
            NSString *strimageurl =[NSString nullToString:[dicinfo objectForKey:@"image"]];
            if(strimageurl.length>6)
            {
//                [shareParams SSDKSetupSinaWeiboShareParamsByText:strcontent title:nil image:strimageurl url:[NSURL URLWithString:[NSString nullToString:dicinfo[@"link"]]] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
                ///分享更改
                [shareParams SSDKSetupSinaWeiboShareParamsByText:strcontent title:nil images:strimageurl video:nil url:[NSURL URLWithString:[NSString nullToString:dicinfo[@"link"]]] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
            }
            else
            {
//                [shareParams SSDKSetupSinaWeiboShareParamsByText:strcontent title:nil image:images url:[NSURL URLWithString:[NSString nullToString:dicinfo[@"link"]]] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
                
                ///分享更改
                [shareParams SSDKSetupSinaWeiboShareParamsByText:strcontent title:nil images:images video:strimageurl url:[NSURL URLWithString:[NSString nullToString:dicinfo[@"link"]]] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
            }
            
            
//            [shareParams SSDKSetupWeChatParamsByText:strcontent title:strtitle url:[NSURL URLWithString:[NSString nullToString:dicinfo[@"link"]]] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            ///分享更改
            [shareParams SSDKSetupWeChatParamsByText:strcontent title:strtitle url:[NSURL URLWithString:[NSString nullToString:dicinfo[@"link"]]] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            
            
            
            NSString *strwxxcxurl =[NSString nullToString:[dicinfo objectForKey:@"applet_url"]];
            
            if(strwxxcxurl.length>6)
            {
                
                if([[MDB_UserDefault defaultInstance] imagediskImageExistsForURL:[dicinfo objectForKey:@"image"]])
                {
                    images = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dicinfo objectForKey:@"image"]]]];
                }
                else
                {
                    images = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dicinfo objectForKey:@"image"]]]];
                    [[MDB_UserDefault defaultInstance] setSaveImageToCache:images forURL:[NSURL URLWithString:[dicinfo objectForKey:@"image"]]];
                }
                
                images=[images imageByScalingProportionallyToSize:CGSizeMake(images.size.width, images.size.width/4*3)];//
                if(UIImagePNGRepresentation(images).length>36720)
                {
                    images=[images imageByScalingProportionallyToSize:CGSizeMake(images.size.width*0.8, images.size.height*0.8)];
                }
                
                ////小程序分享  需要判断是否需要分享小程序
//                [shareParams SSDKSetupWeChatParamsByTitle:strtitle description:strcontent webpageUrl:[NSURL URLWithString:[NSString nullToString:dicinfo[@"link"]]] path:strwxxcxurl thumbImage:images userName:WXXiaoChengXuID forPlatformSubType:SSDKPlatformSubTypeWechatSession];
                ///分享更改
                [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:strtitle description:strcontent webpageUrl:[NSURL URLWithString:[NSString nullToString:dicinfo[@"link"]]] path:strwxxcxurl thumbImage:images hdThumbImage:nil userName:WXXiaoChengXuID withShareTicket:NO miniProgramType:0 forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            }
            
            NSArray *arritems = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)];
            ///分享更改
            [ShareSDK showShareActionSheet:self.view customItems:arritems shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                
            }];
//            //2、分享
//            [ShareSDK showShareActionSheet:self.view
//                                     items:nil
//                               shareParams:shareParams
//                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
////                           [self.dataController requestShareRecordDataWithUrl:share.url callback:^(NSError *error, BOOL state, NSString *describle) {
////                           }];
//                           NSLog(@"sdfasdf");
//                       }];
        }
            break;
        case 1:
        {///查看订单
            if(isorderdetal==NO)
            {
                MyOrderMainViewController *mvc = [[MyOrderMainViewController alloc] init];
                [self.navigationController pushViewController:mvc animated:YES];
            }
            else
            {
                OrderDetaileViewController *ovc = [[OrderDetaileViewController alloc] init];
//                ovc.strid = _strorderno;
                ovc.strorderno = _strorderno;
                [self.navigationController pushViewController:ovc animated:YES];
            }
            
            
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
