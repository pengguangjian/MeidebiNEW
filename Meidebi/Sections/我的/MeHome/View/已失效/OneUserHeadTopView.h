//
//  OneUserHeadTopView.h
//  Meidebi
//
//  Created by fishmi on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OneUserHeadTopViewDelegate <NSObject>

- (void)clickToViewController:(UIViewController *)targetVc;



@end


@interface OneUserHeadTopView : UIView
@property (nonatomic ,weak) id <OneUserHeadTopViewDelegate> delegate;

@property (nonatomic ,strong) UIView *view;
@property (nonatomic ,strong) UIImageView *picV;
@property (nonatomic ,strong) UIImageView *levImgeV;
@property (nonatomic ,strong) UILabel *copperLabel;
@property (nonatomic ,strong) UILabel *integralLabel;
@property (nonatomic ,strong) UILabel *contributionLabel;
@property (nonatomic ,strong) UIButton *fansBtn;
@property (nonatomic ,strong) UIButton *concernBtn;
@property (nonatomic ,strong) UIButton *signBtn;
@property (nonatomic ,strong) UIButton *exchangeBtn;
@property (nonatomic ,strong) UIImageView *photoV;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *levNumLabel;
@property (nonatomic ,strong) UIButton *levelNickButton;
@property (nonatomic ,strong) UIButton *personalHomeButton;
@property (nonatomic ,strong) UIButton *loginBtn;
@property (nonatomic ,strong) UIButton *chouJiangBtn;
@property (nonatomic ,strong) UIButton *userinfoBtn;

- (void)setUpheadViewData;

@end
