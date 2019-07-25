//
//  TKExploreSubjectView.h
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/12.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKExploreViewModel.h"
#import "YYPhotoGroupView.h"
#import "TKTopicModuleConstant.h"
@protocol TKExploreSubjectViewDelegate <NSObject>
@optional - (void)originalSubjectViewDidClickAvaterImageView:(NSString *)userID;
@optional - (void)originalSubjectViewDidClickFollowBtn:(NSString *)userID complete:(void(^)(BOOL state))callback;
@optional - (void)exploreSubjectViewDidSelectTopicType:(TKTopicType)type;
@optional - (void)exploreSubjectViewDidClickBannerWithItem:(NSDictionary *)item;
@optional - (void)exploreSubjectViewDidSelectItemID:(NSString *)itemID;
@optional - (void)exploreSubjectViewDidCickAvaterViewWithUserid:(NSString *)userid;
@optional - (void)photoGroupView:(YYPhotoGroupView *)photoGroupView
               didClickImageView:(UIView *)fromeView;
@optional - (void)lastPage;
@optional - (void)nextPage;
@optional - (void)scrollRollView;
@optional - (void)originalSubjectViewpushYuanChuangAction;///发布原创

@end

@interface TKExploreSubjectView : UIView
@property (nonatomic, weak) id<TKExploreSubjectViewDelegate> delegate;
- (void)bindeTopicData:(NSArray *)topics;
- (void)bindOriginalRelevanceDataWithModel:(NSDictionary *)model;

@end
