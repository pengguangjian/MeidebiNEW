//
//  OriginalHomeSubjectView.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sharecle.h"

@protocol OriginalHomeSubjectViewDelegate <NSObject>

@optional - (void)originalSubjectViewDidClickAvaterImageView:(NSString *)userID;
@optional - (void)originalSubjectViewDidClickFollowBtn:(NSString *)userID complete:(void(^)(BOOL state))callback;
@optional - (void)originalSubjectViewDidClickFlage:(NSString *)flage;
@optional - (void)originalSubjectViewDidSelectRow:(NSString *)originalID;
@optional - (void)originalSubjectViewSwitchOriginalDataWithHot:(BOOL)isHot;
@optional - (void)originalSubjectViewDidClickBannerElement:(NSDictionary *)element;
@optional - (void)lastPage;
@optional - (void)nextPage;

@end

@interface OriginalHomeSubjectView : UIView
@property (nonatomic, weak) id<OriginalHomeSubjectViewDelegate> delegate;
- (void)bindDataWithModel:(NSArray *)models;
- (void)bindOriginalRelevanceDataWithModel:(NSDictionary *)model;

@end
