//
//  FollowSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactViewModel.h"

@protocol FollowSubjectViewDelegate <NSObject>

@optional - (void)followSubjectViewDidClickAddFollowWithFollowID:(NSString *)userID didComplete:(void(^)(void))complete;
@optional - (void)followSubjectViewDidClickCancelFollowWithFollowID:(NSString *)userID didComplete:(void(^)(void))complete;
@optional - (void)imageViewClickedWithUserId:(NSString *)userid;
@end

@interface FollowSubjectView : UIView

@property (nonatomic, weak) id<FollowSubjectViewDelegate> delegate;
- (void)bindDataWithModel:(NSArray *)models;

@end
