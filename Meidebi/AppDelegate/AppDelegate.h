//
//  AppDelegate.h
//  mdb
//
//  Created by 杜非 on 14/11/28.
//  Copyright (c) 2014年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDB_UserDefault.h"
#import "NJAssessmentGuideView.h"

#import "WXApi.h"

//#import <JDKeplerSDK/KeplerApiManager.h>
#import <JDKeplerSDK/JDKeplerSDK.h>

@interface phtoClas : NSObject

@end

@interface AppDelegate : UIResponder
<
UIApplicationDelegate,
NJAssessmentGuideViewDelegate,
WXApiDelegate
>
{
    MDB_UserDefault *user;
    BOOL isLastPage;
}
@property (strong, nonatomic) UIWindow *window;
@property (assign,nonatomic)CGSize  BoundSize;
@property(retain,nonatomic) NSString *sitename_toshare;
@property(retain,nonatomic) NSString *youhuo_toshare;
//@property(retain,nonatomic) UINavigationController *navVc;
-(void)guideload;


@end

