//
//  ResetPasswordSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/13.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResetPasswordSubjectView;

@protocol ResetPasswordSubjectViewDelegate <NSObject>

@optional
- (void)resetPasswordView:(ResetPasswordSubjectView *)subView
didPressSubmitBtnWithPassword:(NSString *)password;

@end

@interface ResetPasswordSubjectView : UIView

@property (nonatomic, weak) id<ResetPasswordSubjectViewDelegate> delegate;

@end
