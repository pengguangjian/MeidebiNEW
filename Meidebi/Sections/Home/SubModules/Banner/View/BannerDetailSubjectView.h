//
//  BannerDetailSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPhotoGroupView.h"
#import "RemarkStatusLayout.h"

@protocol BannerDetailSubjectViewDelegate <NSObject>

@optional - (void)remarkHomeSubjectClickUrl:(NSString *)urlStr;
@optional - (void)photoGroupView:(YYPhotoGroupView *)photoGroupView
               didClickImageView:(UIView *)fromeView;
@optional - (void)detailSubjectViewDidCickReadMoreRemark;
@optional - (void)detailSubjectViewDidCickInputRemarkView;
@optional - (void)detailSubjectViewDidCickCollectBtn;
@optional - (void)detailSubjectViewDidCickReadBtn;
@optional - (void)detailSubjectViewDidCicklikeBtn;
@optional - (void)detailSubjectViewDidCickHotScaleUrlBtn:(NSString *)linke;

@end

@interface BannerDetailSubjectView : UIView

@property (nonatomic, weak) id<BannerDetailSubjectViewDelegate> delegate;

- (void)bindDetailData:(NSDictionary *)model;
- (void)bindCommentData:(NSArray *)models;
@end
