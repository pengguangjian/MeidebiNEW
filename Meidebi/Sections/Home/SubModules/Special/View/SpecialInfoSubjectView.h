//
//  SpecialInfoSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPhotoGroupView.h"
#import "RemarkStatusLayout.h"
#import "SpecialInfoViewModel.h"
@protocol SpecialInfoSubjectViewDelegate <NSObject>

@optional - (void)remarkHomeSubjectClickUrl:(NSString *)urlStr;
@optional - (void)remarkTableViewDidClickUser:(NSString *)userid;
@optional - (void)photoGroupView:(YYPhotoGroupView *)photoGroupView
               didClickImageView:(UIView *)fromeView;
@optional - (void)detailSubjectViewDidCickReadMoreRemark;
@optional - (void)detailSubjectViewDidCickInputRemarkView;
@optional - (void)detailSubjectViewDidCickCollectBtn:(void(^)(BOOL status))didComplete;
@optional - (void)detailSubjectViewDidCicklikeBtn:(void(^)(BOOL status))didComplete;
@optional - (void)detailSubjectViewDidCickReadBtn;
@optional - (void)detailSubjectViewDidCickWebViewUrlLink:(NSString *)link;
@optional - (void)detailSubjectViewDidCickAddFollowWithUserid:(NSString *)userid
                                                  didComplete:(void (^)(BOOL status))didComplete;
@optional - (void)detailSubjectViewDidCickAvaterViewWithUserid:(NSString *)userid;



@end

@interface SpecialInfoSubjectView : UIView
@property (nonatomic, weak) id<SpecialInfoSubjectViewDelegate> delegate;
- (void)bindSpcialDetailData:(SpecialInfoViewModel *)model;
- (void)bindCommentData:(NSArray *)models;

@end
