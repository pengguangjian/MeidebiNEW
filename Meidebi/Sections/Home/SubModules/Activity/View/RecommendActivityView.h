//
//  RecommendActivityView.h
//  Meidebi
//
//  Created by fishmi on 2017/5/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsCollectionViewCell;

@protocol RecommendActivityViewDelegate <NSObject>
@optional
- (void)subjectViewClickRecommendGoodsView :(NSString *)linkId;
- (void)subjectViewClickEnterImagePicker:(UIImagePickerController *)imagePicker;
- (void)subjectViewClickJoinInActivity;
- (void)dataRefreshByLatestBtnClick;
- (void)dataRefreshByHotBtnClick;
- (void)dataRefreshByMJRefresh;
- (void)clickToVKLoginViewController :(UIViewController *) contorller;
- (void)dataRefreshGetBackFromVKLoginViewControllerl;
- (void)detailSubjectViewDidCickWebViewUrlLink:(NSString *)link;
@end

@interface RecommendActivityView : UIView

@property (nonatomic ,strong) UICollectionView *collectionV;
@property (nonatomic ,strong)NSString *activityId;
@property (nonatomic ,strong ,readonly) UIImage *activityImage;

@property (nonatomic, weak) id<RecommendActivityViewDelegate> delegate;

- (void)bindRecommendHeadViewData:(NSDictionary *)models;
- (void)bindRecommendListData:(NSDictionary *)models;

@end
