//
//  LaunchAdView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/1/9.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    LaunchAdTouchTypeAD,
    LaunchAdTouchTypeSkip
} LaunchAdTouchType;

typedef void (^LaunchViewClick) (LaunchAdTouchType clickType);

@interface LaunchAdView : UIView

//倒计时总时长,默认3秒 
@property (nonatomic, assign) NSInteger adTime;

//网络图片URL
@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, copy) LaunchViewClick clickBlock;

@property (nonatomic, assign) UIViewController *vc;


- (instancetype)initWithWindow:(UIWindow *)window;
+ (void)updateAdvertisingImage:(NSString *)imageUrl;
@end
