//
//  SignInHeadViewCollectionReusableView.h
//  Meidebi
//
//  Created by fishmi on 2017/6/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SignInHeadModel;
@class SignInHeadDoSignModel;

@protocol SignInHeadViewCollectionReusableViewDelegate <NSObject>
-(void)signInBtnClick;
-(void)calculateSignInVHeight: (CGFloat )height;
- (void)ClickToVKLoginViewController:(UIViewController *)controller;

@end

@interface SignInHeadViewCollectionReusableView : UICollectionReusableView
@property (nonatomic ,weak) id<SignInHeadViewCollectionReusableViewDelegate> delegate;

@property (nonatomic ,strong) SignInHeadModel *model;
@property(nonatomic,strong)SignInHeadDoSignModel *doSignModel;

@end
