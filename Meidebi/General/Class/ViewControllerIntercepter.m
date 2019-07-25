//
//  ViewControllerIntercepter.m
//  Meidebi
//
//  Created by mdb-losaic on 2017/12/13.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ViewControllerIntercepter.h"
#import <AspectsV1.4.2/Aspects.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <UMAnalytics/MobClick.h>
@implementation ViewControllerIntercepter

+ (void)load{
    [super load];
    [ViewControllerIntercepter shareInstance];
}

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static ViewControllerIntercepter *shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ViewControllerIntercepter alloc] init];
    });
    return shareInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self intercepter];
    }
    return self;
}

- (void)intercepter{
    @try
    {
        [UIViewController aspect_hookSelector:@selector(viewDidLayoutSubviews) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            if ([[aspectInfo instance] isKindOfClass:[UIViewController class]]) {
                [self viewWillAppear:YES viewController:[aspectInfo instance]];
            }
        } error:NULL];
    }
    @catch(NSException *exc)
    {
        
    }
    @finally
    {
        
    }
    @try
    {
        [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            if ([[aspectInfo instance] isKindOfClass:[UIViewController class]]) {
                [self viewWillDisappear:YES viewController:[aspectInfo instance]];
            }
        } error:NULL];
    }
    @catch(NSException *exc)
    {
        
    }
    @finally
    {
        
    }
    
    
    
}


- (void)viewWillDisappear:(BOOL)animated viewController:(UIViewController *)viewController{
    [MobClick endLogPageView:[self viewNameFromController:viewController]];
}

- (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController{
    [MobClick beginLogPageView:[self viewNameFromController:viewController]];
}

- (NSString *)viewNameFromController:(UIViewController *)controller{
    NSString *vcName = NSStringFromClass([controller class]);
    if ([vcName isEqualToString:@"HomeViewController"]) {
        vcName = @"首页";
    }else if ([vcName isEqualToString:@"ProductInfoViewController"]){
        vcName = @"爆料详情";
    }else if ([vcName isEqualToString:@"MainSpotViewController"]){
        vcName = @"优惠";
    }else if ([vcName isEqualToString:@"OneUserViewController"]){
        vcName = @"个人中心";
    }else if ([vcName isEqualToString:@"FindeCouponResultViewController"]){
        vcName = @"搜券列表页";
    }else if ([vcName isEqualToString:@"PersonalInfoIndexViewController"]){
        vcName = @"个人主页";
    }else if ([vcName isEqualToString:@"FilterTypeHomeViewController"]){
        vcName = @"筛选";
    }else if ([vcName isEqualToString:@"SearchHomeViewController"]){
        vcName = @"搜索";
    }else{
        if (![@""isEqualToString:[NSString nullToString:controller.title]]) {
            vcName = [NSString nullToString:controller.title];
        }
    }
    return vcName;
}

@end
