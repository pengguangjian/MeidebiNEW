//
//  WelfareDynamicViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/26.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RootViewController.h"

@protocol WelfareDynamicViewControllerDelegate <NSObject>

@optional - (void)welfareDynamicViewControllerDidClickAvater:(NSString *)userid;
@optional - (void)welfareDynamicViewControllerDidClickAd:(NSDictionary *)adInfo;

@end


@interface WelfareDynamicViewController : RootViewController

@property (nonatomic, weak) id<WelfareDynamicViewControllerDelegate> delegate;
@end
