//
//  ActivityDetailView.h
//  Meidebi
//
//  Created by fishmi on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailCommentTextFiledView.h"

@protocol ActivityDetailViewDelegate <NSObject>
@optional - (void)clickToRemarkHomeViewController:(RemarkHomeViewController *) targetVc;
@optional - (void)tabBarViewdidPressShouItem;
@optional - (void)tabBarViewdidPressZanItem;
@optional - (void)tabBarViewdidPressCommentItemWithType:(NSString *)type linkID:(NSString *)linkID;
@optional - (void)detailSubjectViewDidCickAddFollowWithUserid:(NSString *)userid
                                                  didComplete:(void (^)(BOOL status))didComplete;
@optional - (void)imageViewClickedtoController:(UIViewController *)targetVc;
@optional - (void)detailSubjectViewDidCickWebViewUrlLink:(NSString *)link;
@end

@interface ActivityDetailView : UIView
@property (nonatomic, weak) id<ActivityDetailViewDelegate> delegate;
@property (nonatomic ,strong) NSString *linkId;
@property (nonatomic ,strong) ActivityDetailCommentTextFiledView *bottomV;
@property (nonatomic, strong, readonly) UIImage *participationImage;
- (void)bindActivityDetailData:(NSDictionary *)models;
- (void)updateSubjectViewWithType:(UpdateViewType)type isMinus:(BOOL)minus;
@end
