//
//  OriginalDetailSubjectView.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OriginalDetailViewModel.h"
#import "YYPhotoGroupView.h"
#import "RemarkStatusLayout.h"

@protocol OriginalDetailSubjectViewDelegate <NSObject>
@optional - (void)originalDetailSubjectViewDidClickAvaterWithUserID:(NSString *)userID;
@optional - (void)originalDetailSubjectViewDidClickFollowBtn:(NSString *)userID
                                                    complete:(void(^)(BOOL state))callback;
@optional - (void)originalDetailSubjectViewDidClickTage:(NSString *)tage;
@optional - (void)originalDetailSubjectViewDidPressNonstopItemWithOutUrlStr:(NSString *)urlLink;
@optional - (void)originalDetailSubjectViewDidCickRewardButton;
@optional - (void)originalDetailSubjectViewDidCickRewardInfo;
@optional - (void)originalDetailSubjectViewDidSelectTableViewCellWithID:(NSString *)originalID;
@optional - (void)originalDetailSubjectViewDidCickReadMoreRemark;
@optional - (void)originalDetailSubjectViewDidPressLikeBtnComplete:(void (^)(void))didComplete;
@optional - (void)originalDetailSubjectViewDidPressCollectBtnDidComplete:(void (^)(BOOL state))didComplete;
@optional - (void)originalDetailSubjectViewDidPressRemarkBtn;
@optional - (void)originalDetailSubjectViewOtherWorkCellDidCilckLikeBtn:(NSString *)relevanceID
                                                            didComplete:(void (^)(void))didComplete;
@optional - (void)originalDetailSubjectViewDidPressCommentItemWithToUserID:(NSString *)userid;

// remark
@optional - (void)remarkHomeSubjectClickUrl:(NSString *)urlStr;
@optional - (void)photoGroupView:(YYPhotoGroupView *)photoGroupView
               didClickImageView:(UIView *)fromeView;
@end

@interface OriginalDetailSubjectView : UIView
@property (nonatomic, weak) id<OriginalDetailSubjectViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIImage *originalImage;
- (void)bindDataWithModel:(OriginalDetailViewModel *)model;

-(void)backNavAction;

@end
