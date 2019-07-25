//
//  DaiGouBannerHotView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/28.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouBannerHotView.h"

#import "MDB_UserDefault.h"

#import "ProductInfoViewController.h"

@interface DaiGouBannerHotView ()
{
    UIImageView *imgvhot;
    UIView *viewfirst;
    NSTimer *timer1;
    
    int inumber;
    
}
@end

@implementation DaiGouBannerHotView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
        inumber = 0;
    }
    return self;
}

-(void)setupSubViews
{
    imgvhot = [self drawNowHotPinDan:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:imgvhot];
    
    [self setClipsToBounds:YES];
    
    UIView *viewitem = [self drawitem:CGRectMake(0, 0, imgvhot.width, imgvhot.height) andvalue:nil];
    [imgvhot addSubview:viewitem];
    viewfirst = viewitem;
    
    timer1 = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    _timer = timer1;
    
}

-(void)timeAction
{
    [UIView animateWithDuration:0.5 animations:^{
        [viewfirst setBottom:0];
    } completion:^(BOOL finished) {
        
    }];
    
    UIView *viewitem = [self drawitem:CGRectMake(0, imgvhot.height, imgvhot.width, imgvhot.height) andvalue:nil];
    [imgvhot addSubview:viewitem];
    [UIView animateWithDuration:0.5 animations:^{
        [viewitem setTop:0];
    } completion:^(BOOL finished) {
        [viewfirst removeFromSuperview];
        viewfirst = nil;
        viewfirst = viewitem;
    }];
    
}


#pragma mark - ///当前拼单最热 daigou_banneronItem
-(UIImageView *)drawNowHotPinDan:(CGRect)rect
{
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:rect];
    [imgv setImage:[UIImage imageNamed:@"daigou_banneronItem"]];
    [imgv setContentMode:UIViewContentModeScaleAspectFit];
    [imgv setUserInteractionEnabled:YES];
    
    
    return imgv;
}

-(UIView *)drawitem:(CGRect)rect andvalue:(id)value
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    if(_arrData.count >0)
    {
        inumber++;
        
        if(inumber>_arrData.count-1)
        {
            inumber = 0;
        }
        if(_arrData.count==1)
        {
            [_timer invalidate];
        }
        NSDictionary *dictemp = _arrData[inumber];
        NSDictionary *dic = [dictemp objectForKey:@"goods"];
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, view.height-12, view.height-12)];
        [imgv setBackgroundColor:[UIColor whiteColor]];
        [imgv.layer setMasksToBounds:YES];
        [imgv.layer setCornerRadius:2];
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:[dic objectForKey:@"image"]];
        [view addSubview:imgv];
        [imgv setContentMode:UIViewContentModeScaleAspectFit];
        
        UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(imgv.right+7, imgv.top, view.width-imgv.right-25, 15)];
        [lbtitle setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
        [lbtitle setTextColor:[UIColor whiteColor]];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setFont:[UIFont systemFontOfSize:10]];
        [view addSubview:lbtitle];
        
        UILabel *lbother = [[UILabel alloc] initWithFrame:CGRectMake(lbtitle.left, lbtitle.bottom, lbtitle.width, lbtitle.height)];
        [lbother setText:[NSString stringWithFormat:@"￥%@     已拼单%@件",[dic objectForKey:@"price"],[dic objectForKey:@"purchased_nums"]]];
        [lbother setTextColor:[UIColor whiteColor]];
        [lbother setTextAlignment:NSTextAlignmentLeft];
        [lbother setFont:[UIFont systemFontOfSize:10]];
        [view addSubview:lbother];
        
        [view setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapitem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction)];
        [view addGestureRecognizer:tapitem];
        
    }
    else
    {
        return view;
    }
    
    
    
    
    
    return view;
}

-(void)itemAction
{
    NSDictionary *dictemp = _arrData[inumber];
    NSDictionary *dic = [dictemp objectForKey:@"goods"];
    
    NSLog(@"热门滚动点击");
    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
    pvc.productId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"share_id"]];
    [self.viewController.navigationController pushViewController:pvc animated:YES];
}


-(void)dealloc
{
    [_timer invalidate];
}


@end
