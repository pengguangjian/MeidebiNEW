//
//  ShareContViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/2/1.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "ShareContViewController.h"
#import "MDB_UserDefault.h"
#import "Constants.h"
#import "HTTPManager.h"
#import "MDBwebVIew.h"
#import "CommentViewController.h"
#import "RemarkHomeViewController.h"
#import "VKLoginViewController.h"
#import "CompressImage.h"
#import <ShareSDK/ShareSDK.h>
#import "UIImage+Extensions.h"
#import "Qqshare.h"
#import "AppraiseVIew.h"
#import "SVModalWebViewController.h"


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#define withght self.view.frame.size.width

#define webHight _isDockView?CGRectGetHeight(self.view.frame)-74.0:CGRectGetHeight(self.view.frame)-124.0
#define scrolHight _isDockView?CGRectGetHeight(self.view.frame)-64.0:CGRectGetHeight(self.view.frame)-114.0

@interface ShareContViewController ()<MDBwebDelegate>
@end
@implementation ShareContViewController{
    MDBwebVIew *_webView;
    UIView    *_dockView;
    NSMutableDictionary *ContributionUrlDic;
    NSMutableDictionary *dictData;
    Qqshare    *_qqshare;
    
    UIImageView *_productImv;
    UIImageView *_headImv;
    UILabel *_namelabel;
    UILabel *_timelabel;
    
    float hight;
    
    UILabel *contentlabel;
    UILabel *sitelabel;
    UILabel *siteNamelabel;
    UILabel *greatLabel;
    UILabel *solabel;
    
    UIView *lineOne;
    UIView *lineTwo;
    UIView *lineThree;
    
    AppraiseVIew *appOnev;
    AppraiseVIew *appTwov;
    AppraiseVIew *appThreev;
    
    UILabel    *countOnelabel;
    UILabel    *countTwolabel;
    UILabel    *countThreelabel;
}
@synthesize scrollView=_scrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"原创详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, scrolHight)];
    [self.view addSubview:_scrollView];
    
//    dele=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ContributionUrlDic=[[NSMutableDictionary alloc]init];
    [self setNavigation];
    dictData=[[NSMutableDictionary alloc]init];
    
    hight=11+136.0*self.view.frame.size.height/568.0;
    _productImv=[[UIImageView alloc]initWithFrame:CGRectMake(11, 11, withght-22.0,136.0*self.view.frame.size.height/568.0)];
    
    [_scrollView addSubview:_productImv];
    
    _headImv=[[UIImageView alloc]initWithFrame:CGRectMake(6, hight-13.0-25.0, 25, 25)];
    _namelabel=[self getlabelV:CGRectMake(35, hight-15.0-16.0, (withght-22.0)/2.2, 16) font:14.0 text:@"" color:[UIColor whiteColor]];
    _timelabel=[self getlabelV:CGRectMake((withght-22.0)/1.5, hight-11-16.0, (withght-22.0)/2.5, 10) font:11.0 text:@"" color:[UIColor whiteColor]];
    
    CAGradientLayer *gradient=[CAGradientLayer layer];
    gradient.frame=CGRectMake(0,hight-11-50, _productImv.frame.size.width,55.0);//CGRectMake(0, 0, _productImv.frame.size.width,30.0);
    gradient.colors=[NSArray arrayWithObjects:(id)RGBAlpha(0, 0, 0, 0.0).CGColor,(id)RGBAlpha(20, 20, 20, 0.3).CGColor,(id)RGBAlpha(20, 20, 20, 1.0).CGColor, nil];
    [_productImv.layer insertSublayer:gradient atIndex:0];
    
    
    [_productImv addSubview:_headImv];
    [_productImv addSubview:_namelabel];
    [_productImv addSubview:_timelabel];
    hight=hight+11.0;
    contentlabel=[self getlabelV:CGRectMake(11, hight, withght-22.0, 16) font:15.0 text:@"韩国新款复古英伦系带圆头马丁鞋粗跟厚" color:RGB(68, 68, 68)];
    [_scrollView addSubview:contentlabel];
    hight=hight+25;
    
    lineOne=[self getlionView:hight];
    
    hight=hight+15;
    
    sitelabel=[self getlabelV:CGRectMake(11.0, hight, 80, 16) font:14.0 text:@"购物商城:" color:RGB(120, 120, 120)];
    
    siteNamelabel=[self getlabelV:CGRectMake(85.0, hight, 60, 15) font:14.0 text:@" " color:[UIColor whiteColor]];
    
    [siteNamelabel setBackgroundColor:RadMenuColor];
    [siteNamelabel.layer setMasksToBounds:YES];
    [siteNamelabel.layer setCornerRadius:3.0];
    
    hight=hight+35.0;
    lineTwo=[self getlionView:hight];
    hight=hight+15.0;
    [self getlabelV:CGRectMake(11, hight, 110.0, 16.0) font:14.0 text:@"商品质量满意度:" color:RGB(68,68,68)];
    appOnev=[[AppraiseVIew alloc]initWithFrame:CGRectMake(120, hight, withght/2.0-20.0,16)];
    [appOnev setIntloadWight:15.0];
    [appOnev setSelectImageIndex:2];
    countOnelabel=[self getlabelV:CGRectMake(withght-50.0, hight, 30.0, 16.0) font:13.0 text:@"一般" color:RGB(120, 120, 120)];
    
    hight=hight+20;
    [self getlabelV:CGRectMake(11, hight, 110.0, 16.0) font:14.0 text:@"配送服务满意度:" color:RGB(68,68,68)];
    appTwov=[[AppraiseVIew alloc]initWithFrame:CGRectMake(120 , hight, withght/2.0 -20.0,16)];
    [appTwov setIntloadWight:15.0];
    [appTwov setSelectImageIndex:2];
    countTwolabel=[self getlabelV:CGRectMake(withght-50.0, hight, 30.0, 16.0) font:13.0 text:@"一般" color:RGB(120, 120, 120)];
    
    hight=hight+20.0;
    [self getlabelV:CGRectMake(11, hight, 110.0, 16.0) font:14.0 text:@"客户服务满意度:" color:RGB(68,68,68)];
    appThreev=[[AppraiseVIew alloc]initWithFrame:CGRectMake(120 , hight, withght/2.0-20.0 ,16)];
    [appThreev setIntloadWight:15.0];
    [appThreev setSelectImageIndex:2];
    countThreelabel=[self getlabelV:CGRectMake(withght-50.0, hight, 30.0, 16.0) font:13.0 text:@"一般" color:RGB(120, 120, 120)];
    
    hight=hight+20;
    
    [_scrollView addSubview:appOnev];
    
    [_scrollView addSubview:appTwov];
    
    [_scrollView addSubview:appThreev];
    hight=hight+11;
    lineThree=[self getlionView:hight];
    hight=hight+15;
    
    
    if (_share||_shareid) {
        
        if (_share) {
            
            [[MDB_UserDefault defaultInstance]setViewWithImage:_productImv url:_share.cover options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                _productImv.image=image;
                
                [_productImv setContentMode:UIViewContentModeScaleAspectFill];
            }];
            _timelabel.text=[MDB_UserDefault strTimefromData:[_share.createtime intValue] dataFormat:@"yyyy-MM-dd HH:mm"];
            if (![_share.name isKindOfClass:[NSNull class]]) {
                _namelabel.text=_share.name;
            }
        }else{
            
        }
        
        [_productImv.layer setMasksToBounds:YES];
        [_productImv.layer setCornerRadius:5.0];
        
        [_headImv.layer setMasksToBounds:YES];
        [_headImv.layer setCornerRadius:12.5];
        [_headImv.layer setBorderWidth:1.0];
        [_headImv.layer setBorderColor:RGB(200.0, 200.0, 200.0).CGColor];

        NSDictionary *dicOnlink;
        
        if ([MDB_UserDefault getIsLogin]) {
            id strl=_share?_share.shareid:[NSString stringWithFormat:@"%@",@(_shareid)];
            dicOnlink=@{@"id":[NSString stringWithFormat:@"%@",strl],@"type":@"1",@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
        }else{
            id strl=!_share?[NSString stringWithFormat:@"%@",@(_shareid)]:_share.shareid;
            dicOnlink=@{@"id":[NSString stringWithFormat:@"%@",strl],@"type":@"1"};
            
        }
        [HTTPManager sendRequestUrlToService:URL_onelink withParametersDictionry:dicOnlink view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]){
                if (![[[dicAll objectForKey:@"data"] objectForKey:@"title"] isKindOfClass:[NSNull class]]) {
                    contentlabel.text=[[dicAll objectForKey:@"data"] objectForKey:@"title"];
                }
                if ([[[dicAll objectForKey:@"data"] objectForKey:@"site"] isKindOfClass:[NSDictionary class]]) {
                    siteNamelabel.text=[[[dicAll objectForKey:@"data"] objectForKey:@"site"] objectForKey:@"name"];
                }
                CGRect rect=siteNamelabel.frame;
                rect.size=[MDB_UserDefault getStrWightFont:siteNamelabel.font str:siteNamelabel.text hight:rect.size.height];
                siteNamelabel.frame=rect;
                [appOnev setSelectImageIndex:[[[dicAll objectForKey:@"data"] objectForKey:@"sdquality"] integerValue]];
                [appTwov setSelectImageIndex:[[[dicAll objectForKey:@"data"] objectForKey:@"sdship"] integerValue]];
                [appThreev setSelectImageIndex:[[[dicAll objectForKey:@"data"] objectForKey:@"sdcustom"] integerValue]];
                countOnelabel.text=[self getCount:[[dicAll objectForKey:@"data"] objectForKey:@"sdquality"]];
                countTwolabel.text=[self getCount:[[dicAll objectForKey:@"data"] objectForKey:@"sdship"]];
                countThreelabel.text=[self getCount:[[dicAll objectForKey:@"data"] objectForKey:@"sdcustom"]];
                if (_shareid) {
                    [[MDB_UserDefault defaultInstance]setViewWithImage:_productImv url:[[dicAll objectForKey:@"data"] objectForKey:@"cover"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        _productImv.image=image;
                        
                        [_productImv setContentMode:UIViewContentModeScaleAspectFill];
                    }];
                    _timelabel.text=[MDB_UserDefault strTimefromData:[[[dicAll objectForKey:@"data"] objectForKey:@"createtime"] intValue] dataFormat:@"yyyy-MM-dd HH:mm"];
                }
                if ([dicAll objectForKey:@"data"]) {
                    if (![[[dicAll objectForKey:@"data"] objectForKey:@"sharename"] isKindOfClass:[NSNull class]]) {
                        _namelabel.text=[[dicAll objectForKey:@"data"] objectForKey:@"sharename"];
                    }
                    [[MDB_UserDefault defaultInstance] setViewWithImage:_headImv url:[[dicAll objectForKey:@"data"] objectForKey:@"sharephoto"] ];
                    
                      
                    [self setDockView:[dicAll objectForKey:@"data"]];
                    if (_isDockView) {
                        _dockView.hidden=YES;
                    }
                }
                [dictData removeAllObjects];
                [dictData setDictionary:[dicAll objectForKey:@"data"]];
                if ([dictData objectForKey:@"id"]) {
                    [self loadde:[dictData objectForKey:@"id"] type:2];
                    // [[MDB_UserDefault defaultInstance] setViewWithImage:_headImv url:_share.headphoto ];
                }
                [self setWebVIew:[[dicAll objectForKey:@"data"] objectForKey:@"content"]];
                UILabel *votesp=(UILabel *)[_dockView viewWithTag:22];//收藏
                if (![[[dicAll objectForKey:@"data"] objectForKey:@"favnum"] isKindOfClass:[NSNull class]]) {
                votesp.text=[[dicAll objectForKey:@"data"] objectForKey:@"favnum"];
                }
                if ([MDB_UserDefault getIsLogin]) {
                    if ([dictData objectForKey:@"isfav"]&&[dictData objectForKey:@"isfav"]==[NSNumber numberWithInt:1]) {
                        for (UIView *vies in [_dockView subviews]) {
                            if (vies.tag==2) {
                                UIButton *buts=(UIButton *)vies;
                                [buts setImage:[UIImage imageNamed:@"shouchang_hou.png"] forState:UIControlStateNormal];
                                [buts setImage:[UIImage imageNamed:@"shouchang_hou.png"] forState:UIControlStateHighlighted];
                            }
                        }
                    }
                }
                
            }}];
        
    }
    UISwipeGestureRecognizer *right=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    right.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    UISwipeGestureRecognizer *left=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    left.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:left];
}
-(NSString *)getCount:(NSString *)sdcust{
    switch ([sdcust intValue]) {
        case 1:
            return  @"很差";
            break;
        case 2:
            return  @"差";
            break;
        case 3:
            return  @"一般";
            break;
        case 4:
            return  @"好";
            break;
        case 5:
            return  @"很好";
            break;
        default:
            return  @"未知";
            break;
    }
    return  @"未知";
    
}
-(UIView *)getlionView:(float)lionY{
    UIView *vil=[[UIView alloc]initWithFrame:CGRectMake(0, lionY, self.view.frame.size.width, 1.0)];
    [vil setBackgroundColor:RGB(225, 225, 225)];
    [_scrollView addSubview:vil];
    return vil;
}
-(UILabel *)getlabelV:(CGRect)rect font:(float )fontSize text:(NSString *)textl color:(UIColor *)color{
    UILabel *lae=[[UILabel alloc]initWithFrame:rect];
    if (![textl isKindOfClass:[NSNull class]]) {
        lae.text=[NSString stringWithFormat:@"%@",textl];
    }
    lae.font=[UIFont systemFontOfSize:fontSize];
    [lae setTextColor:color];
    [_scrollView addSubview:lae];
    return lae;
}


-(void)loadde:(NSString *)pid type:(int)type{
//    NSString *url=[NSString stringWithFormat:@"%@?id=%@&type=2",URL_getshare,pid];
    NSDictionary *dicr=@{@"id":pid,
                         @"type":@"2",
                         @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_getshare withParametersDictionry:dicr view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictr=[str JSONValue];
            
            NSString* info = [NSString stringWithFormat:@"%@",[dictr objectForKey:@"info"]];
            if (info && [info isEqualToString:@"GET_DATA_SUCCESS"]) {
                if ([dictr objectForKey:@"data"]&&[[dictr objectForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *ss=[dictr objectForKey:@"data"];
                    [ContributionUrlDic setObject:[ss objectForKey:@"url"] forKey:@"ContributionUrl"];
                    _qqshare=[[Qqshare alloc]initWithdic:ss];
                }
            }else{
                [ContributionUrlDic setObject:[NSString stringWithFormat:@"%@?id=%@",URL_getshare,pid] forKey:@"ContributionUrl"];
            }
            
        }else{
            [ContributionUrlDic setObject:[NSString stringWithFormat:@"%@?id=%@",URL_getshare,pid] forKey:@"ContributionUrl"];
        }
    }];
    
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
    
    if (!_isRightBut) {
        UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
        btnright.frame = CGRectMake(0,0,44,44);
        [btnright setImage:[UIImage imageNamed:@"fengxiang.png"] forState:UIControlStateNormal];
        [btnright setImage:[UIImage imageNamed:@"fengxiang_click.png"] forState:UIControlStateHighlighted];
        [btnright addTarget:self action:@selector(doShareAction) forControlEvents:UIControlEventTouchUpInside];
        [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
}
-(void)doClickLeftAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)doShareAction{
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *images=[_productImv.image imageByScalingProportionallyToMinimumSize:CGSizeMake(120.0, 120.0)];
    if (!images) return;
    NSArray* imageArray = @[images];
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
-(void)webViewDidFinishLoad:(float)h webview:(MDBwebVIew *)webView{
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, hight+h)];
}

- (void)webViewDidPreseeUrlWithLink:(NSString *)link webview:(MDBwebVIew *)webView{
    SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:link];
    svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:svweb animated:NO completion:nil];
}

-(void)setWebVIew:(NSString *)content{
    if (!_webView) {
        _webView=[[MDBwebVIew alloc]initWithFrame:CGRectMake(0, hight, CGRectGetWidth(self.view.frame), webHight)];
        _webView.htmlStr = content;
        _webView.delegate=self;
        [_scrollView addSubview:_webView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDockView:(NSDictionary *)dic{
    _dockView=[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame)-50, self.view.frame.size.width, 50)];
    _dockView.backgroundColor=[UIColor  whiteColor];
    //_dockView.layer.cornerRadius=2.0f;
    _dockView.layer.masksToBounds = YES;
    _dockView.layer.shadowPath =[UIBezierPath bezierPathWithRect:_dockView.bounds].CGPath;
    _dockView.clipsToBounds = NO;
    _dockView.layer.shadowColor = [[UIColor grayColor] CGColor];
    _dockView.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
    _dockView.layer.shadowOpacity = .5f;
    _dockView.layer.shadowRadius = .2f;
    _dockView.layer.shadowRadius=1;
    
    float wight=CGRectGetWidth(self.view.frame)/2.0;
    
    
    UIButton *zanBtn=[[UIButton alloc]initWithFrame:CGRectMake(wight-120.0, 3,  44, 44)];
    //[UIButton buttonWithType:UIButtonTypeCustom];
    [zanBtn setTag:1];
    [zanBtn setImage:[UIImage imageNamed:@"zhan.png"] forState:UIControlStateNormal];
    [zanBtn setImage:[UIImage imageNamed:@"zan_click.png"] forState:UIControlStateHighlighted];
    //[zanBtn setFrame:CGRectMake(5, 3,  60, 44)];
    [zanBtn addTarget:self action:@selector(zanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *ruoBtn=[[UIButton alloc]initWithFrame:CGRectMake(wight-40.0, 4,  44, 44)];
    
    
    //[UIButton buttonWithType:UIButtonTypeCustom];
    [ruoBtn setTag:2];
    [ruoBtn setImage:[UIImage imageNamed:@"shouchang.png"] forState:UIControlStateNormal];
    [ruoBtn setImage:[UIImage imageNamed:@"shouchang_click.png"] forState:UIControlStateHighlighted];
    // [ruoBtn setFrame:CGRectMake(60+5, 3,  60, 44)];
    [ruoBtn addTarget:self action:@selector(ShouBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *comBtn=[[UIButton alloc]initWithFrame:CGRectMake(wight+40.0, 3,  44, 44)];
    //[UIButton buttonWithType:UIButtonTypeCustom];
    [comBtn setTag:3];
    [comBtn setImage:[UIImage imageNamed:@"pinglun.png"] forState:UIControlStateNormal];
    [comBtn setImage:[UIImage imageNamed:@"pinglun_click.png"] forState:UIControlStateHighlighted];
    //[comBtn setFrame:CGRectMake(120+5, 3,  60, 44)];
    [comBtn addTarget:self action:@selector(comBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_dockView addSubview:zanBtn];
    [_dockView addSubview:ruoBtn];
    [_dockView addSubview:comBtn];
    
    //5
    UILabel *votesp=[[UILabel alloc] initWithFrame:CGRectMake(wight-120.0+44.0, 3, 34, 44)];
    votesp.tag=11;
    votesp.backgroundColor=[UIColor clearColor];
    //votesp.text=[NSString stringWithFormat:@"%@",_share.votesp];
    if (![[dic objectForKey:@"votesp"] isKindOfClass:[NSNull class]]) {
        votesp.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"votesp"]];
    }
    [votesp setTextColor:RadshuziColor];
    [_dockView addSubview:votesp];
    
    
    
    //65
    UILabel *votesm=[[UILabel alloc] initWithFrame:CGRectMake(wight-40.0+44, 3, 34, 44)];
    votesm.tag=22;
    votesm.backgroundColor=[UIColor clearColor];
    votesm.text=@"0";
    [votesm setTextColor:RadshuziColor];
    [_dockView addSubview:votesm];
    
    
    //125
    UILabel *commentcount_lab=[[UILabel alloc] initWithFrame:CGRectMake(wight+40.0+44, 3, 34, 44)];
    commentcount_lab.tag=33;
    commentcount_lab.backgroundColor=[UIColor clearColor];
    // commentcount_lab.text=[NSString stringWithFormat:@"%@",_share.commentcount];
    if (![[dic objectForKey:@"commentcount"] isKindOfClass:[NSNull class]]) {
        commentcount_lab.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"commentcount"]];
    }
    [commentcount_lab setTextColor:RadshuziColor];
    [_dockView addSubview:commentcount_lab];
    
    [votesm setFont:[UIFont systemFontOfSize:13]];
    [votesp setFont:[UIFont systemFontOfSize:13]];
    [commentcount_lab setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:_dockView];
}
-(void)comBtnClicked:(UIButton *)buts{
    
    RemarkHomeViewController *remarkHomeVc = [[RemarkHomeViewController alloc] init];
    remarkHomeVc.type = RemarkTypeShare;
    if (_share.shareid) {
        remarkHomeVc.linkid = [NSString stringWithFormat:@"%@",_share.shareid];
    }else{
        remarkHomeVc.linkid = [NSString stringWithFormat:@"%@",@(_shareid)];
    }
    [self.navigationController pushViewController:remarkHomeVc animated:YES];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==111||alertView.tag==110){
        if (buttonIndex==0) {
            VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
            [self.navigationController pushViewController:theViewController animated:YES ];
        }
    }
    
}

-(void)zanBtnClicked:(id)sender{
    if ([MDB_UserDefault getIsLogin]) {
        UILabel *votesp=(UILabel *)[_dockView viewWithTag:11];//赞
        NSString *zanStl=_shareid?[NSString stringWithFormat:@"%@",@(_shareid)]:[NSString stringWithFormat:@"%@",_share.shareid];
        
        NSString *userkey=[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
        NSDictionary *dicURL=@{@"id":zanStl,@"votes":@"1",@"userid":userkey,@"type":@"3"};
        NSString *urlStrr=URL_prace;
        [HTTPManager  sendRequestUrlToService:urlStrr withParametersDictionry:dicURL view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            if (responceObjct) {
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dic=[str JSONValue];
                if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"VOTES_SUCCESS"]&&[[dic objectForKey:@"status"] integerValue]) {
                    votesp.text=[NSString stringWithFormat:@"%@",@([votesp.text integerValue]+1)];;
                    
                    float h=CGRectGetWidth(self.view.frame)/2.0;
                    UILabel * _labelCommend=[[UILabel alloc] init];
                    _labelCommend.frame=CGRectMake(h-120.0+15.0, 3.0, 25.0, 25.0);
                    _labelCommend.text=@"+1";
                    _labelCommend.alpha=0.0;
                    _labelCommend.textColor=[UIColor redColor];
                    [_dockView addSubview:_labelCommend];
                    
                    CAAnimation *animation =[CompressImage groupAnimation:_labelCommend];
                    [_labelCommend.layer addAnimation:animation forKey:@"animation"];
                    [MDB_UserDefault showNotifyHUDwithtext:@"投票成功" inView:self.view];
                    
                }else if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"YOUR_ARE_VOTEED"]){
                    
                    [MDB_UserDefault showNotifyHUDwithtext:@"你已经投过票了" inView:self.view];
                }
            }
            
        }];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:110];
        [alertView show];
        
    }
    
    
}

-(void)ShouBtnClicked:(id)sender{
    if ([MDB_UserDefault getIsLogin]) {
        UILabel *votesp=(UILabel *)[_dockView viewWithTag:22];//赞
        
        NSString *userkey=[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
        NSString *shareidl=_shareid?[NSString stringWithFormat:@"%@",@(_shareid)]:[NSString stringWithFormat:@"%@",_share.shareid];
        NSDictionary *dicURL=@{@"id":shareidl,@"fetype":@"4",@"userkey":userkey};
        [HTTPManager  sendRequestUrlToService:URL_favorite withParametersDictionry:dicURL view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            if (responceObjct) {
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dic=[str JSONValue];
                if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"GET_DATA_SUCCESS"]&&[[dic objectForKey:@"status"] integerValue]) {
                    if ([[dic objectForKey:@"data"]isEqualToString:@"取消收藏成功！"]) {
                        votesp.text=[NSString stringWithFormat:@"%@",@([votesp.text integerValue]-1)];
                        float h=CGRectGetWidth(self.view.frame)/2.0;
                        UILabel * _labelCommend=[[UILabel alloc] init];
                        _labelCommend.frame=CGRectMake(h-40.0+15.0, 3.0, 25.0, 25.0);
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
                        UILabel * _labelCommend=[[UILabel alloc] init];
                        _labelCommend.frame=CGRectMake(h-40.0+15.0, 3.0, 25.0, 25.0);
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


@end
