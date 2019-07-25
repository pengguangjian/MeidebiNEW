//
//  CommentRewardsViewHeadView.h
//  Meidebi
//
//  Created by fishmi on 2017/5/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentRewardsModel.h"

@protocol CommentRewardsViewHeadViewDelegate <NSObject>

@optional - (void)rewardsViewHeadViewWebViewDidClikUrl:(NSString *)link;

@end

@interface CommentRewardsViewHeadView : UIView
@property (nonatomic ,strong) UIImageView *imageV;
@property (nonatomic ,weak) id<CommentRewardsViewHeadViewDelegate>delegate;
@property (nonatomic ,assign) CGFloat headVHeight;
@property (nonatomic ,strong) CommentRewardsModel *model;
@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,copy) void (^callback) (CGFloat height);

- (void)calculateSubViewHeight;

@end
