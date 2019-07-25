//
//  HomeActivityPortalView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/7/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RecommendType) {
    RecommendTypeAccumulate,       // 积赞
    RecommendTypeComment,          // 评论有奖
    RecommendTypeBargain           // 砍价
};


@protocol HomeActivityPortalViewDelegate <NSObject>

@optional - (void)activityPortalViewDidSelectItemAtIndex:(NSInteger)index;

@end

@interface HomeActivityPortalView : UIView
@property (nonatomic, weak) id<HomeActivityPortalViewDelegate> delegate;
@property (nonatomic, strong) NSString *activityTitle;
- (void)bindDataWithModels:(NSArray *)models;
@end
