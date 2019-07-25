//
//  HomeSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/9.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewModel.h"
#import "HomeActivityPortalView.h"
typedef NS_ENUM(NSInteger, HandleElementType) {
    HandleElementTypeLowPrice = 0, // 9.9包邮
    HandleElementTypeCoupon,   // 优惠券
    HandleElementTypeHaitao,   // 海淘直邮
    HandleElementTypeDistribute,   // 晒单
    HandleElementTypeLotto, // 抽奖
    HandleElementTypeTrend, // 排行榜
    HandleElementTypeJHS, // 聚划算
    HandleElementTypeFJSL, // 逢节送礼
    HandleElementTypeTopic, // 话题
    HandleElementTypeSignIn // 签到
};



@protocol HomeSubjectViewDelegate <NSObject>

@optional - (void)subjectViewClickHandleViewElementWith:(HandleElementType)type;
@optional - (void)subjectViewClickRecommendElementWithType:(RecommendType)type activityID:(NSString *)actiID;
@optional - (void)subjectViewClickBannerElement:(NSDictionary *)bannerInfoDict;
@optional - (void)subjectViewRefreshHeader;
@optional - (void)subjectViewClickSpcialElementID:(NSString *)spcialID;
@optional - (void)subjectViewClickTBSpecialElement:(NSString *)content;
@optional - (void)subjectViewClickMoreSpcialButton;
@optional - (void)subjectViewClickHotDiscountRecommendElement:(NSString *)recommendID;
@optional - (void)subjectViewClickHotOriginalRecommendElement:(NSString *)recommendID;
@optional - (void)subjectViewClickHotSpecailRecommendElement:(NSString *)recommendID;
@optional - (void)subjectViewClickCurrentHotWithHotID:(NSString *)hotID
                                                title:(NSString *)title
                                                 link:(NSString *)link
                                             linkType:(NSString *)type;
@optional - (void)subjectViewClickCheapFeatured:(NSString *)featureID;
@optional - (void)subjectViewShowGuideElementRects:(NSArray *)rects;

@end

@interface HomeSubjectView : UIView

@property (nonatomic, weak) id<HomeSubjectViewDelegate> delegate;

- (void)bindBannerData:(NSArray *)models;
- (void)bindDataWithViewModel:(HomeViewModel *)model;
- (void)updateDataWithViewModel:(HomeViewModel *)model;
- (void)beginImageAnimation;

@end
