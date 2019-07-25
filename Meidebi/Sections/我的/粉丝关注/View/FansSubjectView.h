//
//  FansSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactViewModel.h"

@protocol FansSubjectViewDelegate <NSObject>

@optional - (void)fansSubjectViewDidClickAddFollowWithFollowID:(NSString *)userID didComplete:(void(^)(void))complete;
@optional - (void)imageViewClickedWithUserId:(NSString *)userid;
@end

@interface FansSubjectView : UIView

@property (nonatomic, weak) id<FansSubjectViewDelegate> delegate;
- (void)bindDataWithModel:(NSArray *)models;

@end
