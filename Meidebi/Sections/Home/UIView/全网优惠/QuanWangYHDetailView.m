//
//  QuanWangYHDetailView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/10/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "QuanWangYHDetailView.h"

#import "MDBwebVIew.h"

#import "MDB_UserDefault.h"

#import "QuanwangYHDetailLikeTableViewCell.h"

#import "HTTPManager.h"

#import "SVModalWebViewController.h"

#import "QuanWangYHDetailViewController.h"

#import <AlibcTradeSDK/AlibcTradeSDK/AlibcTradeSDK.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "UIImage+Extensions.h"

#import "Qqshare.h"

#import "MDBEmptyView.h"

@interface QuanWangYHDetailView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *strgoodsid;
    
    UITableView *tabview;
    NSMutableArray *arrlike;
    
    UIView *viewheader;
    
//    MDBwebVIew *webview;
    
    NSString *strzhidaurl;
    
    UIImageView *imgvhead;
    
    Qqshare *share;
    
}

@property (nonatomic , retain)MDBEmptyView *emptyView;

@end

@implementation QuanWangYHDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame andid:(NSString *)strid
{
    if(self = [super initWithFrame:frame])
    {
        strgoodsid = strid;
        
        float ftopheith =  kStatusBarHeight+44;
        float fother = 60.0;
        if(ftopheith<66)
        {
            fother = 50;
        }
        
        tabview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-fother)];
        [tabview setDelegate:self];
        [tabview setDataSource:self];
        [tabview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:tabview];
        [self loadData];
        
        
        [self emptyView];
        
    }
    return self;
}
///获取数据
-(void)loadData
{
    NSDictionary *dicpush = @{@"id":strgoodsid,@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:DiscountDetailUrl withParametersDictionry:dicpush view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
       
        BOOL state = NO;
        NSDictionary *dicValue;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] ==1) {
                if ([dicAll[@"data"] isKindOfClass:[NSDictionary class]]) {
                    dicValue = dicAll[@"data"];
                    state = YES;
                }
            }
        }
        
        
        if(state)
        {
            [self drawheaderView:[dicValue objectForKey:@"details"]];
            if([[dicValue objectForKey:@"likes"] isKindOfClass:[NSArray class]])
            {
                NSArray *arrtemp = [dicValue objectForKey:@"likes"];
                arrlike = [NSMutableArray new];
                for(NSDictionary *dic in arrtemp)
                {
                    Article *model = [[Article alloc] initWithDictionary:dic];
                    [arrlike addObject:model];
                }
                
                
            }
            [tabview reloadData];
            
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
            [_emptyView setHidden:NO];
        }
        
        
    }];
    
    
    
}

///头部
-(void)drawheaderView:(NSDictionary *)dicmessage
{
    ///twoinoneurl
    strzhidaurl = [NSString nullToString:[dicmessage objectForKey:@"twoinoneurl"]];
    share = [[Qqshare alloc] init];
    share.image = [NSString nullToString:[dicmessage objectForKey:@"itempic"]];
    share.qqsharecontent = [NSString nullToString:[dicmessage objectForKey:@"activeprice"]];
    
    share.qqsharetitle = [NSString stringWithFormat:@"%@%@",[dicmessage objectForKey:@"title"],[dicmessage objectForKey:@"activeprice"]];
    share.qqshareuserdefaultword = [NSString stringWithFormat:@"%@%@",[dicmessage objectForKey:@"title"],[dicmessage objectForKey:@"activeprice"]];
    share.qqweibocontent =[NSString stringWithFormat:@"%@%@",[dicmessage objectForKey:@"title"],[dicmessage objectForKey:@"activeprice"]];
    share.sinaweibocontent = [NSString stringWithFormat:@"%@%@",[dicmessage objectForKey:@"title"],[dicmessage objectForKey:@"activeprice"]];
    share.url = [NSString nullToString:[dicmessage objectForKey:@"webUrl"]];;
    
    /*
     @property(nonatomic,strong)NSString *image;
     @property(nonatomic,strong)NSString *qqsharecontent;
     @property(nonatomic,strong)NSString *qqsharetitle;
     @property(nonatomic,strong)NSString *qqshareuserdefaultword;
     @property(nonatomic,strong)NSString *qqweibocontent;
     @property(nonatomic,strong)NSString *sinaweibocontent;
     @property(nonatomic,strong)NSString *url;
     */
    
    UIButton *btzhidalianjie = [[UIButton alloc] initWithFrame:CGRectMake(0, tabview.bottom+5, 90*kScale, 40)];
    [btzhidalianjie setBackgroundColor:RadMenuColor];
    [btzhidalianjie setTitle:@"直达链接" forState:UIControlStateNormal];
    [btzhidalianjie setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btzhidalianjie.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btzhidalianjie.layer setMasksToBounds:YES];
    [btzhidalianjie.layer setCornerRadius:5];
    [btzhidalianjie addTarget:self action:@selector(zhidalianjieAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btzhidalianjie];
    [btzhidalianjie setRight:self.width-10];
    
    
    
    viewheader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tabview.width, 200)];
    [viewheader setBackgroundColor:[UIColor whiteColor]];
    
    
    
    imgvhead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, viewheader.width-20, viewheader.width*0.7)];
    [viewheader addSubview:imgvhead];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhead url:[NSString nullToString:[dicmessage objectForKey:@"itempic"]]];
    [imgvhead setContentMode:UIViewContentModeScaleAspectFit];
    
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, imgvhead.bottom, viewheader.width-20, 40)];
    [lbtitle setNumberOfLines:0];
    [lbtitle setText:[NSString nullToString:[dicmessage objectForKey:@"title"]]];
    [lbtitle setTextColor:RGB(30, 30, 30)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:16]];
    [lbtitle sizeToFit];
    if(lbtitle.height<40)
    {
        [lbtitle setHeight:40];
    }
    [viewheader addSubview:lbtitle];
    
    
    
    UILabel *lbprice =[[UILabel alloc] initWithFrame:CGRectMake(lbtitle.left, lbtitle.bottom, 100, 25)];
    [lbprice setTextColor:RGB(255, 30, 30)];
    [lbprice setTextAlignment:NSTextAlignmentLeft];
    [lbprice setFont:[UIFont systemFontOfSize:14]];
    [viewheader addSubview:lbprice];
    [lbprice setText:[NSString stringWithFormat:@"券后￥%@",[NSString nullToString:[dicmessage objectForKey:@"activeprice"]]]];
    [lbprice sizeToFit];
    [lbprice setHeight:25];
    
    
    UILabel *lboldprice =[[UILabel alloc] initWithFrame:CGRectMake(lbprice.right+5, lbprice.top, 100, 25)];
    [lboldprice setTextColor:RGB(180, 180, 180)];
    [lboldprice setTextAlignment:NSTextAlignmentLeft];
    [lboldprice setFont:[UIFont systemFontOfSize:14]];
    [viewheader addSubview:lboldprice];
    [lboldprice setText:[NSString nullToString:[dicmessage objectForKey:@"proprice"]]];
    [lboldprice sizeToFit];
    [lboldprice setHeight:25];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:lboldprice.text attributes:attribtDic];
    lboldprice.attributedText = attribtStr;
    
    
    UILabel *lbpaynumber =[[UILabel alloc] initWithFrame:CGRectMake(lbprice.left, lbprice.bottom, 200, 25)];
    [lbpaynumber setTextColor:RGB(180, 180, 180)];
    [lbpaynumber setTextAlignment:NSTextAlignmentLeft];
    [lbpaynumber setFont:[UIFont systemFontOfSize:14]];
    [viewheader addSubview:lbpaynumber];
    [lbpaynumber setText:[NSString stringWithFormat:@"已售：%@件",[NSString nullToString:[dicmessage objectForKey:@"salesnum"]]]];
    
    UIImageView *imgvhbq = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imgvhbq setImage:[[UIImage imageNamed:@"coupon_value_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]];
    [viewheader addSubview:imgvhbq];
    
    UILabel *lbhbq =[[UILabel alloc] initWithFrame:CGRectZero];
    [lbhbq setTextColor:[UIColor whiteColor]];
    [lbhbq setTextAlignment:NSTextAlignmentCenter];
    [lbhbq setFont:[UIFont systemFontOfSize:14]];
    [viewheader addSubview:lbhbq];
    [lbhbq setFrame:CGRectMake(0, lbprice.centerY, 100, 25)];
    [lbhbq setText:[NSString stringWithFormat:@"%@元券",[NSString nullToString:[dicmessage objectForKey:@"denomination"]]]];
    [lbhbq sizeToFit];
    [lbhbq setHeight:25];
    [lbhbq setWidth:lbhbq.width+20];
    [lbhbq setRight:viewheader.width-10];
    
    
    [imgvhbq setFrame:CGRectMake(lbhbq.left, lbhbq.top, lbhbq.width, lbhbq.height)];
    
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, lbpaynumber.bottom+10, viewheader.width, 8)];
    [viewline setBackgroundColor:RGB(239, 239, 239)];
    [viewheader addSubview:viewline];
    
    UILabel *lbtuijianliyou =[[UILabel alloc] initWithFrame:CGRectMake(10, viewline.bottom, 200, 30)];
    [lbtuijianliyou setTextColor:RGB(150, 150, 150)];
    [lbtuijianliyou setTextAlignment:NSTextAlignmentLeft];
    [lbtuijianliyou setFont:[UIFont systemFontOfSize:12]];
    [lbtuijianliyou setText:@"推荐理由："];
    [viewheader addSubview:lbtuijianliyou];
    
    ///remark
    UILabel *lbmessage =[[UILabel alloc] initWithFrame:CGRectMake(10, lbtuijianliyou.bottom, viewline.width-20, 20)];
    [lbmessage setTextColor:RGB(100, 100, 100)];
    [lbmessage setTextAlignment:NSTextAlignmentLeft];
    [lbmessage setFont:[UIFont systemFontOfSize:14]];
    [lbmessage setNumberOfLines:0];
    [lbmessage setText:[NSString nullToString:[dicmessage objectForKey:@"remark"]]];
    [viewheader addSubview:lbmessage];
    [lbmessage sizeToFit];
    
    
    UIView *viewlineweb = [[UIView alloc] initWithFrame:CGRectMake(0, lbmessage.bottom+8, viewline.width, 8)];
    [viewlineweb setBackgroundColor:RGB(239, 239, 239)];
    [viewheader addSubview:viewlineweb];
    
    
    UILabel *lbcnxh =[[UILabel alloc] initWithFrame:CGRectMake(10, viewlineweb.bottom, 200, 40)];
    [lbcnxh setTextColor:RGB(150, 150, 150)];
    [lbcnxh setTextAlignment:NSTextAlignmentLeft];
    [lbcnxh setFont:[UIFont systemFontOfSize:12]];
    [lbcnxh setText:@"猜你喜欢"];
    [viewheader addSubview:lbcnxh];
    [viewheader setHeight:lbcnxh.bottom];
    
    [tabview setTableHeaderView:viewheader];
    
}



//
//#pragma mark - MDBwebDelegate
//-(void)webViewDidFinishLoad:(float)h webview:(MDBwebVIew *)webView
//{
//    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(h);
//    }];
//
//
//    ///更新viewheader的高度
//    CGFloat height = [viewheader systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    CGRect frame = viewheader.frame;
//    frame.size.height = height;
//    viewheader.frame =frame;
//    tabview.tableHeaderView = viewheader;
//
//}
//-(void)webViewDidPreseeUrlWithLink:(NSString *)link webview:(MDBwebVIew *)webView
//{
//    SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:urlLink];
//    svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:svweb animated:NO completion:nil];
//}
//

-(void)zhidalianjieAction
{
    
    id<AlibcTradePage> page = [AlibcTradePageFactory page:strzhidaurl];
    [self callTaobaoWith:page taokeParam:nil];
    

}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrlike.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strcell = @"QuanwangYHDetailLikeTableViewCell";
    QuanwangYHDetailLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[QuanwangYHDetailLikeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = arrlike[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *model = arrlike[indexPath.row];
    model.isSelected = YES;
    
    [tableView reloadData];
    
    
    
    QuanWangYHDetailViewController *qvc = [[QuanWangYHDetailViewController alloc] init];
    qvc.strid = model.itemid;
    [self.viewController.navigationController pushViewController:qvc animated:YES];
    
}

- (void)callTaobaoWith:(id<AlibcTradePage>)page taokeParam:(AlibcTradeTaokeParams *)taokeParams{
    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    showParams.openType = AlibcOpenTypeNative;
    //    showParams.backUrl = @"";
    showParams.linkKey = @"taobao";
    [service show:self.viewController
             page:page
       showParams:showParams
      taoKeParams:taokeParams
       trackParam:nil
tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
} tradeProcessFailedCallback:^(NSError * _Nullable error) {
}];
}

-(void)shareAction
{
    
    
    if (share) {
        //1、创建分享参数（必要）
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        UIImage *images=[imgvhead.image imageByScalingProportionallyToSize:CGSizeMake(120.0, 120.0)];
        
        
        NSArray* imageArray = images==nil?@[]:@[images];
        [shareParams SSDKSetupShareParamsByText:share.qqsharecontent
                                         images:imageArray
                                            url:[NSURL URLWithString:share.url]
                                          title:share.qqsharetitle
                                           type:SSDKContentTypeAuto];
        
//        [shareParams SSDKSetupSinaWeiboShareParamsByText:share.sinaweibocontent title:nil image:share.image url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        ///分享更改
        [shareParams SSDKSetupSinaWeiboShareParamsByText:share.sinaweibocontent title:nil images:share.image video:nil url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupTencentWeiboShareParamsByText:share.qqweibocontent images:images latitude:0 longitude:0 type:SSDKContentTypeAuto];
        
        NSString *shareWeChatTitle = share.qqsharetitle;
        
//        [shareParams SSDKSetupWeChatParamsByText:share.qqsharecontent title:shareWeChatTitle url:[NSURL URLWithString:share.url] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        ///分享更改
        [shareParams SSDKSetupWeChatParamsByText:share.qqsharecontent title:shareWeChatTitle url:[NSURL URLWithString:share.url] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        
        NSArray *arritems = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)];
        ///分享更改
        [ShareSDK showShareActionSheet:self customItems:arritems shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
        }];
        
        //2、分享
//        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:self items:nil
//                                                                   shareParams:shareParams
//                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//
//
//                                                           }];
        
        
    }else{
        ///分享数据错误
        
        
    }
}


- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH-50)];
        [self addSubview:_emptyView];
        _emptyView.remindStr = @"迷路了～";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
