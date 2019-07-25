//
//  GuideViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/3/3.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

#import "DingYueYuXuanViewController.h"
#import "HTTPManager.h"

@interface GuideViewController ()<UIScrollViewDelegate,DingYueYuXuanViewControllerDelegate>

@end

@implementation GuideViewController
{
    UIPageControl *_control;
    UIScrollView *_scrollView;
    AppDelegate *dele;
    NSInteger _lastPageNumber;
    
    BOOL ispush;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    dele=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self setupSubViews];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupSubViews{
    UIScrollView *uiScrollview = [[UIScrollView alloc] init];
    uiScrollview.frame = self.view.bounds;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    _scrollView = uiScrollview;
    uiScrollview.showsHorizontalScrollIndicator = NO;
    uiScrollview.contentSize = CGSizeMake(5*width, height);
    uiScrollview.pagingEnabled = YES;
    uiScrollview.backgroundColor =[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    uiScrollview.delegate = self;
//    uiScrollview.bounces = NO;
    [self.view addSubview:uiScrollview];
    
    UIImageView *guideFirstImageView = [UIImageView new];
    [uiScrollview addSubview:guideFirstImageView];
    guideFirstImageView.frame = CGRectMake(0, 0, width, height);
    guideFirstImageView.image = [UIImage imageNamed:@"guide_0.jpg"];
    guideFirstImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIImageView *guideSecondImageView = [UIImageView new];
    [uiScrollview addSubview:guideSecondImageView];
    guideSecondImageView.frame = CGRectMake(width, 0, width, height);
    guideSecondImageView.image = [UIImage imageNamed:@"guide_1.jpg"];
    guideSecondImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImageView *guideThirdImageView = [UIImageView new];
    [uiScrollview addSubview:guideThirdImageView];
    guideThirdImageView.frame = CGRectMake(width*2, 0, width, height);
    guideThirdImageView.image = [UIImage imageNamed:@"guide_2.jpg"];
    guideThirdImageView.contentMode = UIViewContentModeScaleAspectFit;
    guideThirdImageView.userInteractionEnabled = YES;
    
    UIImageView *guideFourImageView = [UIImageView new];
    [uiScrollview addSubview:guideFourImageView];
    guideFourImageView.frame = CGRectMake(width*3, 0, width, height);
    guideFourImageView.image = [UIImage imageNamed:@"guide_3.jpg"];
    guideFourImageView.contentMode = UIViewContentModeScaleAspectFit;
    guideFourImageView.userInteractionEnabled = YES;

    
    UIImageView *guideFiveImageView = [UIImageView new];
    [uiScrollview addSubview:guideFiveImageView];
    guideFiveImageView.frame = CGRectMake(width*4, 0, width, height);
    guideFiveImageView.image = [UIImage imageNamed:@"guide_4.jpg"];
    guideFiveImageView.contentMode = UIViewContentModeScaleAspectFit;
    guideFiveImageView.userInteractionEnabled = YES;

    
//    UILabel *lbkaiqi = [[UILabel alloc] initWithFrame:CGRectMake(width*0.16, height*0.75, width*0.68, width*0.15)];
//    [lbkaiqi.layer setMasksToBounds:YES];
//    [lbkaiqi.layer setCornerRadius:lbkaiqi.height/2.0];
//    [lbkaiqi.layer setBorderColor:RGB(255,99,11).CGColor];
//    [lbkaiqi.layer setBorderWidth:1];
//    [lbkaiqi setText:@"立即开启"];
//    [lbkaiqi setTextColor:RGB(255,99,11)];
//    [lbkaiqi setTextAlignment:NSTextAlignmentCenter];
//    [lbkaiqi setFont:[UIFont systemFontOfSize:15]];
//    [guideFourImageView addSubview:lbkaiqi];
    
    UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(butSelect)];
    [guideFiveImageView addGestureRecognizer:tapGesture];
    
    
    
      
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [guideThirdImageView addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(guideThirdImageView.mas_bottom).offset(-45);
//        make.centerX.equalTo(guideThirdImageView.mas_centerX);
//        make.left.equalTo(guideThirdImageView.mas_left).offset(30);
//        make.right.equalTo(guideThirdImageView.mas_right).offset(-30);
//        make.height.offset(50);
////        make.size.mas_equalTo(CGSizeMake(150, 40));
//    }];
//     button.backgroundColor = [UIColor whiteColor];
//    [button.layer setMasksToBounds:YES];
//    [button.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
////    [button.layer setBorderWidth:1.0]; //边框宽度
////    [button.layer setBorderColor:[UIColor clearColor].CGColor];//边框颜色
//    [button setTitle:@"点击进入 >>" forState:UIControlStateNormal];
//    [button setTitleColor:RadMenuColor forState:UIControlStateNormal];
////    [button setImage:[UIImage imageNamed:@"guid_btn"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(butSelect) forControlEvents:UIControlEventTouchUpInside];
    
    
        UIPageControl *control = [[UIPageControl alloc] init];
        [self.view addSubview:control];
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(uiScrollview.mas_bottom).offset(-30);
            make.centerX.equalTo(uiScrollview.mas_centerX);
        }];
        [control setCurrentPageIndicatorTintColor:RadMenuColor];
        [control setPageIndicatorTintColor:[UIColor colorWithRed:219.2/255.0 green:218.0/255.0 blue:220.4/255.0 alpha:0.8]];
        control.numberOfPages = 5;
        control.currentPage = 0;
        _control = control;

}

-(void)butSelect{
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"tuijiandingyuefirst"] integerValue] !=1)
    {
        ispush = YES;
        [self getAllKeys];
    }
    else
    {
        ispush = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self dismissViewControllerAnimated:NO completion:nil];
        [dele guideload];

    }
    
}

-(void)getAllKeys
{
    [HTTPManager sendGETRequestUrlToService:URL_GetPushconfigRecSubscribe withParametersDictionry:nil view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        
        NSArray *arrallkeys ;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"] intValue] == 1) {
                if ([[dicAll objectForKey:@"data"]isKindOfClass:[NSArray class]]) {
                    NSArray *arrkeys=[dicAll objectForKey:@"data"];
                    //                    [_subjectView bindHotKeys:arrkeys];
                    arrallkeys = arrkeys;
                }
            }
        }
        
        if(arrallkeys.count>0)
        {
            ispush = YES;
            DingYueYuXuanViewController *dvc = [[DingYueYuXuanViewController alloc] init];
            dvc.arrallkey = arrallkeys;
            [dvc setDelegate:self];
//            [self.view.window addSubview:dvc.view];
//            [self.view.window bringSubviewToFront:dvc.view];
            [self presentViewController:dvc animated:YES completion:nil];
        }
        else
        {
            ispush = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [self dismissViewControllerAnimated:NO completion:nil];
            [dele guideload];

        }
    }];
    
}

-(void)dimisview
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
    [dele guideload];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(scrollView.contentOffset.x>scrollView.width*4+30 && ispush == NO)
    {
        [self butSelect];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSInteger pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
//    if (pageNum == 2) {
//        _lastPageNumber ++;
//        if (_lastPageNumber>=2) {
//            [self butSelect];
//        }
//    }else{
//        _lastPageNumber = 0;
//    }
    NSInteger pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
    [_control setCurrentPage:pageNum];
    
}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    NSInteger pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
//    [_control setCurrentPage:pageNum];
//
//
//}

@end
