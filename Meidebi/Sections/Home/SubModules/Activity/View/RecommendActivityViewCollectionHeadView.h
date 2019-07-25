//
//  RecommendActivityViewCollectionHeadView.h
//  Meidebi
//
//  Created by fishmi on 2017/5/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendActivityHeadViewModel.h"

@protocol RecommendActivityHeadViewDelegate <NSObject>

@optional - (void)dataRefreshByHotBtnClick;
@optional - (void)dataRefreshByLatestBtnClick;
@optional - (void)webViewDidPreseeUrlWithLink:(NSString *)link;
@end

@interface RecommendActivityViewCollectionHeadView : UICollectionReusableView

@property (nonatomic ,weak) id<RecommendActivityHeadViewDelegate> delegate;
@property (nonatomic ,strong) UIImageView *subImageV;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) CGRect reFrame;
@property (nonatomic, strong) RecommendActivityHeadViewModel *model;
@property (nonatomic, copy) void (^callback) (CGFloat height);

- (void)calculateHeadViewHeight;
- (void)showHidenSideView;
@end
