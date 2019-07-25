//
//  PersonalInfoSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalInfoIndexViewModel.h"

@protocol PersonalInfoSubjectViewDelegate <NSObject>

@optional - (void)personalInfoSubjectViewDidSelectBroke:(NSString *)brokeid;
@optional - (void)personalInfoSubjectViewDidSelectShaidan:(NSString *)shaidanid;
@optional - (void)personalInfoSubjectViewDidClickFollowBtn;
@optional - (void)personalInfoSubjectViewDidClickShareBtn:(NSString *)username;

@end

@interface PersonalInfoIndexSubjectView : UIView

- (instancetype)initWithUserID:(NSString *)userid;
@property (nonatomic, weak) id<PersonalInfoSubjectViewDelegate> delegate;
- (void)bindDataWithModel:(PersonalInfoIndexViewModel *)model;

-(void)bottomTitleAction;

@end
