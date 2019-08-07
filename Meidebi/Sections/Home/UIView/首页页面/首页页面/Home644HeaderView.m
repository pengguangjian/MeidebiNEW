//
//  Home644HeaderView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/6.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "Home644HeaderView.h"
#import "MDB_UserDefault.h"

#import "ImagePlayerView.h"

#import <UMAnalytics/MobClick.h>

#import "SVModalWebViewController.h"
#import "ProductInfoViewController.h"
#import "OriginalDetailViewController.h"

#import "ProductInfoViewController.h"

#import "Article.h"

#import "OriginalDetailViewController.h"

#import "JiangJiaZhiBoViewController.h"

#import "DaiGouFenLeiTableViewController.h"

#import "DaShangViewController.h"

@interface Home644HeaderView ()<ImagePlayerViewDelegate>
{
    float fmovelast;
}
///banner
@property (nonatomic , retain) ImagePlayerView *imgvhead;
@property (nonatomic , retain) NSArray *bannerImages;


@end


@implementation Home644HeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:RGB(245, 245, 245)];
        ///banner
        _imgvhead=[[ImagePlayerView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenW,kMainScreenW*0.45)];
        [self addSubview:_imgvhead];
        _imgvhead.backgroundColor = [UIColor grayColor];
        
        
        UIView *viewitem0 = [self drawzhiboitem:CGRectMake(0, _imgvhead.bottom, kMainScreenW/2.0-1, frame.size.height-_imgvhead.bottom-10) andtitle:@"降价直播" andcont:@"降价再买更划算" andimage:@"shouye_jiangjiazhibo"];
        [self addSubview:viewitem0];
        [viewitem0 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapitem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jiangjiaAction)];
        [viewitem0 addGestureRecognizer:tapitem];
        
        UIView *viewitem1 = [self drawzhiboitem:CGRectMake(viewitem0.right+1, viewitem0.top, viewitem0.width, viewitem0.height) andtitle:@"海淘现货" andcont:@"秒发不用等" andimage:@"shouye_haitaoxianhuo"];
        [self addSubview:viewitem1];
        [viewitem1 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapitem1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(haitaoAction)];
        [viewitem1 addGestureRecognizer:tapitem1];
        
        
        
        _fbouttonHeight = 50*kScale;
        
        UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pangesture];
        
        
    }
    return self;
}

-(UIView *)drawzhiboitem:(CGRect)rect andtitle:(NSString *)strtitle andcont:(NSString *)strcontent andimage:(NSString *)strimage
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.height-30, view.height-30)];
    [imgv setCenter:CGPointMake(0, view.height/2.0)];
    [imgv setRight:view.width-10];
    [imgv setContentMode:UIViewContentModeScaleAspectFit];
    [imgv setImage:[UIImage imageNamed:strimage]];
    [view addSubview:imgv];
    
    
    UILabel *lbcont = [[UILabel alloc] initWithFrame:CGRectMake(15, view.height/2.0-10, imgv.left-15, 20)];
    [lbcont setText:strcontent];
    [lbcont setTextColor:RGB(200, 200, 200)];
    [lbcont setTextAlignment:NSTextAlignmentLeft];
    [lbcont setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lbcont];
    
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(lbcont.left, 10, lbcont.width, lbcont.top-10)];
    [lbtitle setText:strtitle];
    [lbtitle setTextColor:RGB(20, 20, 20)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtitle];
    
    
    
    UILabel *lbgo = [[UILabel alloc] initWithFrame:CGRectMake(lbcont.left, lbcont.bottom+5, 35, 18)];
    [lbgo setText:@"GO>"];
    [lbgo setTextColor:[UIColor whiteColor]];
    [lbgo setTextAlignment:NSTextAlignmentCenter];
    [lbgo setFont:[UIFont systemFontOfSize:13]];
    [lbgo setBackgroundColor:RadMenuColor];
    [lbgo.layer setMasksToBounds:YES];
    [lbgo.layer setCornerRadius:2];
    [view addSubview:lbgo];
    
    
    return view;
}


#pragma mark - 降价直播点击
-(void)jiangjiaAction
{
    JiangJiaZhiBoViewController *jvc = [[JiangJiaZhiBoViewController alloc] init];
    [self.viewController.navigationController pushViewController:jvc animated:YES];
    
//    DaShangViewController *jvc = [[DaShangViewController alloc] init];
//    [self.viewController.navigationController pushViewController:jvc animated:YES];
    
}

-(void)haitaoAction
{
    [MobClick event:@"dgxianhuoqu" label:@"代购现货区-更多"];
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    DaiGouFenLeiTableViewController *dvc = [[DaiGouFenLeiTableViewController alloc] init];
    dvc.strtitle = @"现货";
    dvc.ishiddenxianhuo = YES;
    dvc.strurl = DaiGouXianHuoListUrl;
    dvc.ipost = 2;
    dvc.dicpush = dicpush;
    [self.viewController.navigationController pushViewController:dvc animated:YES];
}




#pragma mark - 拖动
-(void)panAction:(UIPanGestureRecognizer *)gesture
{
//    [gesture.view.superview bringSubviewToFront:gesture.view];
    CGPoint translation = [gesture translationInView:self.superview];
    
    float fy = translation.y;
    
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        fmovelast = 0.0;
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
        if(self.delegate != nil)
        {
            [self.delegate Home644HeaderViewPanMove:fmovelast-fy isend:NO];
        }
//        NSLog(@"++++=%lf",fy);
        fmovelast = fy;
    }
    else
    {
        
        if(self.delegate != nil)
        {
            [self.delegate Home644HeaderViewPanMove:fmovelast-fy isend:YES];
        }
        fmovelast = 0.0;
    }
}

#pragma mark - bananer 数据
-(void)bindBanarData:(NSArray *)arrmodels
{
    _bannerImages = arrmodels;
    [_imgvhead setDelagateCount:arrmodels.count delegate:self];
    
}

#pragma mark - banaer 设置
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    if (_bannerImages.count>index) {
        [[MDB_UserDefault defaultInstance]setViewImageWithURL:[NSURL URLWithString:[NSString nullToString:_bannerImages[index][@"imgUrl"]]] placeholder:[UIImage imageNamed:@"Active.jpg"] UIimageview:imageView];
    }
}
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    [MobClick event:@"zhuye_banner"];
    NSDictionary *bannerInfoDict = _bannerImages[index];
    if ([[NSString nullToString:bannerInfoDict[@"linkType"]] isEqualToString:@"0"]) {
        SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:[NSString nullToString:bannerInfoDict[@"link"]]];
        svweb.modalTransitionStyle=UIModalTransitionStylePartialCurl;
        [self.viewController presentViewController:svweb animated:NO completion:nil];
    }else if([[NSString nullToString:bannerInfoDict[@"linkType"]] isEqualToString:@"1"]){
        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
        productInfoVc.productId = [NSString nullToString:bannerInfoDict[@"linkId"]];
        [self.viewController.navigationController pushViewController:productInfoVc animated:YES];
    }else if([[NSString nullToString:bannerInfoDict[@"linkType"]] isEqualToString:@"2"]){
        OriginalDetailViewController *shareContVc = [[OriginalDetailViewController alloc] initWithOriginalID:[NSString stringWithFormat:@"%@",bannerInfoDict[@"linkId"]]];
        [self.viewController.navigationController pushViewController:shareContVc animated:YES];
    }
}


@end
