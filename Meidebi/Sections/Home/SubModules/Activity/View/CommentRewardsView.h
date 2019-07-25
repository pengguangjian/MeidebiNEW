//
//  CommentRewardsView.h
//  Meidebi
//
//  Created by fishmi on 2017/5/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPhotoGroupView.h"
#import "RemarkStatusLayout.h"
#import "ActivityDetailCommentTextFiledView.h"
@protocol CommentRewardsViewDelegate <NSObject>
@optional - (void)photoGroupView:(YYPhotoGroupView *)photoGroupView
               didClickImageView:(UIView *)fromeView;
@optional - (void)remarkHomeSubjectClickUrl:(NSString *)urlStr;
@optional - (void)clickToRemarkHomeViewController:(UIViewController *) targetVc;
@optional - (void)imageViewClickedtoControllerByUserid:(NSString *) userid;
@optional - (void)tabBarViewdidPressShouItem;
@optional - (void)tabBarViewdidPressZanItem;
@optional - (void)detailSubjectViewDidCickWebViewUrlLink:(NSString *)link;

@end

@interface CommentRewardsView : UIView

@property (nonatomic, weak) id<CommentRewardsViewDelegate> delegate;
@property (nonatomic ,strong) NSString *linkId;
@property (nonatomic ,weak) ActivityDetailCommentTextFiledView *bottomV;
@property (nonatomic, strong, readonly) UIImage *rewardsImage;
- (void)bindCommentRewardsData:(NSDictionary *)models;


-(void)updateSubjectViewWithType:(UpdateViewType)type isMinus:(BOOL)minus;

@end

