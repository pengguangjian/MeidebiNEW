//
//  PlusButtonSubclass.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/25.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "PlusButtonSubclass.h"
#import <CYLTabBarController/CYLTabBarController.h>
#import "BrokeHomeViewController.h"
#import "UpShareViewController.h"
#import "VKLoginViewController.h"
#import "MDB_UserDefault.h"
#import "FindCouponIndexViewController.h"

PostHandleView *NJPostHandeleView = nil;
BOOL NJPlusBtnisSelect = NO;

@interface PlusButtonSubclass ()<UIAlertViewDelegate> {
    CGFloat _buttonImageHeight;
}
@end

@implementation PlusButtonSubclass

#pragma mark -
#pragma mark - Life Cycle

+ (void)load {
//    [super registerPlusButton];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
//        NJPostHandeleView = [[PostHandleView alloc] init];
//        NJPostHandeleView.didClickPublishBtn = ^(PulishType type) {
//            [self publishBtnEvent:type];
//        };
    }
    return self;
}

//上下结构的 button
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 控件大小,间距大小
    // 注意：一定要根据项目中的图片去调整下面的0.7和0.9，Demo之所以这么设置，因为demo中的 plusButton 的 icon 不是正方形。
    CGFloat const imageViewEdgeWidth   = self.bounds.size.width * 0.7;
    CGFloat const imageViewEdgeHeight  = imageViewEdgeWidth * 0.9;
    
    CGFloat const centerOfView    = self.bounds.size.width * 0.5;
    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
    CGFloat const verticalMarginT = self.bounds.size.height - labelLineHeight - imageViewEdgeWidth;
    CGFloat const verticalMargin  = verticalMarginT / 2;
    
    // imageView 和 titleLabel 中心的 Y 值
    CGFloat const centerOfImageView  = verticalMargin + imageViewEdgeWidth * 0.5;
    CGFloat const centerOfTitleLabel = imageViewEdgeWidth  + verticalMargin * 2 + labelLineHeight * 0.5 + 5;
    
    //imageView position 位置
    self.imageView.bounds = CGRectMake(0, 0, imageViewEdgeWidth, imageViewEdgeHeight);
    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);
    
    //title position 位置
    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
}

+ (void)resetPlusButtonState{
    if (NJPlusBtnisSelect) {
        [CYLExternPlusButton setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
//        [NJPostHandeleView removeAnimation];
        [NJPostHandeleView removeFromSuperview];
        NJPlusBtnisSelect = !NJPlusBtnisSelect;
    }
}

#pragma mark -
#pragma mark - CYLPlusButtonSubclassing Methods

/*
 *
 Create a custom UIButton without title and add it to the center of our tab bar
 *
 */
+ (id)plusButton
{
    UIImage *buttonImage = [UIImage imageNamed:@"search_coupon_ico"];
    PlusButtonSubclass* button = [PlusButtonSubclass buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    [button sizeToFit];
//    [button addTarget:button action:@selector(clickPublish:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark -
#pragma mark - Event Response

//- (void)clickPublish:(id)sender {
//
//    CYLTabBarController *tabBarController = [self cyl_tabBarController];
//    UIViewController *viewController = tabBarController.selectedViewController;
//    
//    if (NJPlusBtnisSelect) {
//        [CYLExternPlusButton setBackgroundImage:[UIImage imageNamed:@"search_coupon_ico"] forState:UIControlStateNormal];
////        [NJPostHandeleView removeAnimation];
//        [NJPostHandeleView removeFromSuperview];
//    }else{
//        [CYLExternPlusButton setBackgroundImage:[UIImage imageNamed:@"search_coupon_ico"] forState:UIControlStateNormal];
//        [viewController.view addSubview:NJPostHandeleView];
//        [NJPostHandeleView beginAnimate];
//    }
//    NJPlusBtnisSelect = !NJPlusBtnisSelect;
//
//}
//
//- (void)publishBtnEvent:(PulishType)type{
//    CYLTabBarController *tabBarController = [self cyl_tabBarController];
//    UINavigationController *viewController = tabBarController.selectedViewController;
//    if (type == PulishTypeExperience) {
//        if ([MDB_UserDefault defaultInstance].usertoken) {
//            UIStoryboard *mainStroy=[UIStoryboard storyboardWithName:@"Share" bundle:nil];
//            UpShareViewController *ductViewC=[mainStroy instantiateViewControllerWithIdentifier:@"com.mdb.UpShareViewC"];
//            [viewController pushViewController:ductViewC animated:YES];
//        }else{
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                message:@"请登录后再试"
//                                                               delegate:self
//                                                      cancelButtonTitle:nil
//                                                      otherButtonTitles:@"登录",@"取消", nil];
//            [alertView setTag:111];
//            [alertView show];
//        }
//    }else if (type == PulishTypeBroke){
//        BrokeHomeViewController *brokeHomeVc = [[BrokeHomeViewController alloc] init];
//        [viewController pushViewController:brokeHomeVc animated:YES];
//    }
//    [PlusButtonSubclass resetPlusButtonState];
//}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if(alertView.tag==111||alertView.tag==110){
//        if (buttonIndex==0) {
//            CYLTabBarController *tabBarController = [self cyl_tabBarController];
//            UINavigationController *viewController = tabBarController.selectedViewController;
//            VKLoginViewController*theViewController= [[VKLoginViewController alloc] init];
//            [viewController pushViewController:theViewController animated:YES ];
//        }
//    }
//}

#pragma mark - CYLPlusButtonSubclassing

+ (UIViewController *)plusChildViewController {
    FindCouponIndexViewController *postHandleVc = [[FindCouponIndexViewController alloc] init];
    UIViewController *plusChildNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:postHandleVc];
    return plusChildNavigationController;
}

+ (NSUInteger)indexOfPlusButtonInTabBar {
    return 2;
}

//+ (BOOL)shouldSelectPlusChildViewController {
//    return YES;
//}

+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight {
    // 0.37
    return  0.5;
}

+ (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight {
    return  0;
}

@end
