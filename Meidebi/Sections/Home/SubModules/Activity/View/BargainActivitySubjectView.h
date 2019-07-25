//
//  BargainActivitySubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/10/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPhotoGroupView.h"
#import "RemarkStatusLayout.h"
#import "BargainActivityViewModel.h"
#import "ShareHandleTableViewCell.h"
@protocol BargainActivitySubjectViewDelegate <NSObject>
@optional - (void)photoGroupView:(YYPhotoGroupView *)photoGroupView
               didClickImageView:(UIView *)fromeView;
@optional - (void)detailSubjectViewDidCickReadMoreRemark;
@optional - (void)remarkHomeSubjectClickUrl:(NSString *)urlStr;
@optional - (void)detailSubjectViewDidCickAvaterViewWithUserid:(NSString *)userid;
@optional - (void)subjectTableViewDidSelectItem:(NSString *)itemID;
@optional - (void)bargainActivitySubjectViewDidClickedShareButtonAtType:(ShareHandleType)type;
@optional - (void)detailSubjectViewDidCickInputRemarkView;
@optional - (void)detailSubjectViewDidCicklikeBtn:(void(^)(BOOL status))didComplete;
@end

@interface BargainActivitySubjectView : UIView
@property (nonatomic, weak) id<BargainActivitySubjectViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIImage *activityImage;
- (void)bindDataWithModel:(BargainActivityViewModel *)model;
@end
