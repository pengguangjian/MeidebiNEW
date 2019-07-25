//
//  ActivityDetailCommentView.h
//  Meidebi
//
//  Created by fishmi on 2017/5/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentRewardsModel.h"
@class RemarkHomeViewController;

typedef NS_ENUM(NSInteger, UpdateViewType){
    UpdateViewTypeZan,
    UpdateViewTypeShou
};

@protocol ActivityDetailCommentTextFiledViewDelegate <NSObject>

- (void)clickToRemarkHomeViewController:(RemarkHomeViewController *) targetVc;
- (void)tabBarViewDidPressShouBton;
- (void)tabBarViewDidPressZanBton;
- (void)tabBarViewDidPressCommentBtonWithType:(NSString *)type linkID:(NSString *)linkID;

@end

@interface ActivityDetailCommentTextFiledView : UIView

@property (nonatomic, weak) id<ActivityDetailCommentTextFiledViewDelegate> delegate;

@property (nonatomic ,strong) UIControl *textBtn;
@property (nonatomic ,strong) UIButton *collectBtn;
@property (nonatomic ,strong) UIView *lineV;
@property (nonatomic ,strong) UIButton *watchBtn;
@property (nonatomic ,strong) NSString *linkId;
@property (nonatomic ,strong) CommentRewardsModel *model;
@property (nonatomic ,strong) NSString *collectNumberStr;
@property (nonatomic ,strong) NSString *praiseNumberStr;
@property (nonatomic ,strong) UIButton *praiseBtn;



- (void)updateTabBarStatuesWithType:(UpdateViewType)type
                            isMinus:(BOOL)minus;
@end
