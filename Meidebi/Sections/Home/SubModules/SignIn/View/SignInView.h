//
//  SignInView.h
//  Meidebi
//
//  Created by fishmi on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignInViewDelegate <NSObject>

- (void)signInBtnClick;
-(void)ClickToVKLoginViewController: (UIViewController *) controller;
-(void)clicktoProductInfoViewController: (UIViewController *) targetVc;
@end

@interface SignInView : UIView

@property (nonatomic ,weak) id<SignInViewDelegate> delegate;

- (void)bindSignInHeadInfoData:(NSDictionary *)models;
- (void)bindSignInListData:(NSDictionary*)models;
//- (void)bindSignInHeadDoSignData:(NSDictionary*)models;
@end
