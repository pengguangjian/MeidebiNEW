//
//  OneUserView.h
//  Meidebi
//
//  Created by fishmi on 2017/6/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OneUserHeadView;
@protocol OneUserViewDelegate <NSObject>
- (void)pushToPushSetingViewControoler :(UIViewController *)targatVc;
- (void)clickTofeedbackKit;
- (void)functionSelectbyButton: (UIButton *)btn;
- (void)clickToViewController:(UIViewController *)Vc;
@optional - (void)oneUserViewDidSelectInviteFriendCell;
@optional - (void)subjectViewShowGuideElementRects:(NSArray *)rects;
@optional - (void)subjectViewShowFansWithFollowGuideElementRects:(NSArray *)rects;
///我的奖励
-(void)subjectViewJiangLiAction;
///降价通知
-(void)jiangjiatongzhiAction;

@end

@interface OneUserView : UIView

@property (nonatomic ,weak) id<OneUserViewDelegate> delegate;
@property (nonatomic ,weak) OneUserHeadView *headV;
@property (nonatomic ,assign) NSInteger needPhone;

- (void)setUpheadViewData;
- (void)layoutViewWithlogout;
- (void)setUpImageV: (UIImage *)image;
- (void)showGuideView;
@end
