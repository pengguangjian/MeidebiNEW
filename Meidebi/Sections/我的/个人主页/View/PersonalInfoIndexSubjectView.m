//
//  PersonalInfoSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalInfoIndexSubjectView.h"
#import "SMPagerTabView.h"
#import "PersonalBrokeNewsViewController.h"
#import "PersonalShareViewController.h"
#import "MDB_UserDefault.h"
#import "PelsonalHandleButton.h"

#import "FansViewController.h"
#import "FollowViewController.h"

static CGFloat const standardScale = 375.00;

@interface PersonalInfoIndexSubjectView ()
<
SMPagerTabViewDelegate,
PersonalBrokeNewsViewControllerDelegate,
PersonalShareViewControllerDelegate
>
@property (nonatomic, strong) UIImageView *personalBgImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *livelBgImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *livelLabel;
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *followerLabel;
@property (nonatomic, strong) SMPagerTabView *segmentView;
@property (nonatomic, strong) NSArray *allVC;
@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) UIButton *btbottom;

@end

@implementation PersonalInfoIndexSubjectView

- (instancetype)initWithUserID:(NSString *)userid{
    _userID = userid;
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _personalBgImageView = [UIImageView new];
    [self addSubview:_personalBgImageView];
    [_personalBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (IS_IPHONE_X_SCREEN) {
//            make.top.equalTo(self.mas_top).offset(kTopHeight);
//            make.left.right.equalTo(self);
//        }else{
//        }
        make.top.left.right.equalTo(self);
        make.height.equalTo(self.mas_width).multipliedBy(0.61);
    }];
    _personalBgImageView.image = [UIImage imageNamed:@"personal_homepage_bg"];
    [_personalBgImageView setUserInteractionEnabled:YES];
    
    _avatarImageView = [UIImageView new];
    [_personalBgImageView addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_personalBgImageView.mas_top).offset((35/standardScale)*kMainScreenW);
        make.centerX.equalTo(_personalBgImageView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake((100/standardScale)*kMainScreenW, (100/standardScale)*kMainScreenW));
    }];
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = (100/standardScale)*kMainScreenW/2;
    
    _nicknameLabel = [UILabel new];
    [_personalBgImageView addSubview:_nicknameLabel];
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_avatarImageView.mas_centerX);
        make.top.equalTo(_avatarImageView.mas_bottom).offset(15);
    }];
    _nicknameLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _nicknameLabel.font = [UIFont systemFontOfSize:16.f];
    
    UIImageView *livelBgImageView = [UIImageView new];
    [_personalBgImageView addSubview:livelBgImageView];
    [livelBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nicknameLabel.mas_right).offset(3);
        make.centerY.equalTo(_nicknameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    livelBgImageView.image = [UIImage imageNamed:@"dengji.jpg"];
    livelBgImageView.hidden = YES;
    _livelBgImageView = livelBgImageView;
    
    _livelLabel = [UILabel new];
    [livelBgImageView addSubview:_livelLabel];
    [_livelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(livelBgImageView.mas_right).offset(-0.5);
        make.bottom.equalTo(livelBgImageView.mas_bottom).offset(-1);
    }];
    _livelLabel.textColor = [UIColor whiteColor];
    _livelLabel.font = [UIFont systemFontOfSize:7.0];
    _livelLabel.textAlignment = NSTextAlignmentRight;
    
    UIView *lineView = [UIView new];
    [_personalBgImageView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_personalBgImageView.mas_centerX);
        make.top.equalTo(_nicknameLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(1, 13));
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    lineView.hidden = YES;
    _lineView = lineView;

    _fansLabel = [UILabel new];
    [_personalBgImageView addSubview:_fansLabel];
    [_fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView.mas_centerY);
        make.right.equalTo(lineView.mas_left).offset(-10);
        make.width.offset(150);
        make.height.offset(30);
    }];
    _fansLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _fansLabel.font = [UIFont systemFontOfSize:14.f];
    _fansLabel.textAlignment = NSTextAlignmentRight;
    [_fansLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapfes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fesAction)];
    [_fansLabel addGestureRecognizer:tapfes];
    
    
    _followerLabel = [UILabel new];
    [_personalBgImageView addSubview:_followerLabel];
    [_followerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView.mas_centerY);
        make.left.equalTo(lineView.mas_right).offset(10);
        make.width.offset(150);
        make.height.offset(30);
    }];
    _followerLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _followerLabel.font = [UIFont systemFontOfSize:14.f];
    [_followerLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapfollower = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followerAction)];
    [_followerLabel addGestureRecognizer:tapfollower];
    
    
    PersonalBrokeNewsViewController *brokenewsVc=[[PersonalBrokeNewsViewController alloc] initWithUserID:_userID];
    brokenewsVc.title = @"爆料";
    brokenewsVc.delegate = self;
    PersonalShareViewController *shareVc=[[PersonalShareViewController alloc] initWithUserID:_userID];
    shareVc.title = @"原创";
    shareVc.delegate = self;
    self.allVC = @[brokenewsVc,shareVc];
    self.segmentView = [[SMPagerTabView alloc]initWithFrame:CGRectMake(0, kMainScreenW*0.61, kMainScreenW, kMainScreenH-50-(kMainScreenW*0.61))];
    [self addSubview:self.segmentView];
    self.segmentView.delegate = self;
    [self.segmentView setTabFrameHeight:84];
    [self.segmentView buildUI];
    [self.segmentView selectTabWithIndex:0 animate:NO];
}

- (void)setupBottomToolBarViewWithFollow:(BOOL)follow{
    UIView *containerView = [UIView new];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(50);
    }];
    containerView.backgroundColor = [UIColor whiteColor];
    
    UIView *topLineView = [UIView new];
    [containerView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(containerView);
        make.height.offset(1);
    }];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    
//    UIView *lineView = [UIView new];
//    [containerView addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(containerView);
//        make.centerX.equalTo(containerView.mas_centerX);
//        make.width.offset(1);
//    }];
//    lineView.backgroundColor = topLineView.backgroundColor;
    
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [containerView addSubview:followBtn];
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(containerView);
        make.top.equalTo(topLineView.mas_bottom);
        make.right.equalTo(containerView);
    }];
    followBtn.tag = 1000;
    followBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [followBtn setTitleColor:[UIColor colorWithHexString:@"#6D6D6D"] forState:UIControlStateNormal];
    if (follow) {
        [followBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [followBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    }
    [followBtn addTarget:self action:@selector(respondsToBtnEvents:) forControlEvents:UIControlEventTouchUpInside];
    _btbottom = followBtn;
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [containerView addSubview:shareBtn];
//    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.bottom.equalTo(containerView);
//        make.top.equalTo(topLineView.mas_bottom);
//        make.left.equalTo(lineView.mas_right);
//    }];
//    shareBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
//    [shareBtn setTitleColor:[UIColor colorWithHexString:@"#6D6D6D"] forState:UIControlStateNormal];
//    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
//    [shareBtn setImage:[UIImage imageNamed:@"personal_page_share"] forState:UIControlStateNormal];
//    [shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    [shareBtn addTarget:self action:@selector(respondsToBtnEvents:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)bindDataWithModel:(PersonalInfoIndexViewModel *)model{
    if (!model) return;
    _livelBgImageView.hidden = NO;
    _lineView.hidden = NO;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_avatarImageView url:model.avatarLink];
    _nicknameLabel.text = model.nickname;
    _livelLabel.text = model.totalLevel;
    _followerLabel.text = model.followNum;
    _fansLabel.text = model.fansNum;
    
    if([_userID isEqualToString:@""])
    {
        
    }
    else
    {
        [self setupBottomToolBarViewWithFollow:model.isFollow];
    }
    
}

- (void)respondsToBtnEvents:(UIButton *)sender{
    if (sender.tag == 1000) {
        if ([self.delegate respondsToSelector:@selector(personalInfoSubjectViewDidClickFollowBtn)]) {
            [self.delegate personalInfoSubjectViewDidClickFollowBtn];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(personalInfoSubjectViewDidClickShareBtn:)]) {
            [self.delegate personalInfoSubjectViewDidClickShareBtn:_nicknameLabel.text];
        }
    }
}
///粉丝点击
-(void)fesAction
{
    if([_userID isEqualToString:@""] && [MDB_UserDefault getIsLogin])
    {
        FansViewController *fansVC = [[FansViewController alloc] init];
        [self.viewController.navigationController pushViewController:fansVC animated:YES];
    }
    
}

///关注点击
-(void)followerAction
{
    
    if([_userID isEqualToString:@""] && [MDB_UserDefault getIsLogin])
    {
        FollowViewController *followVC = [[FollowViewController alloc] init];
        [self.viewController.navigationController pushViewController:followVC animated:YES];
    }
}

#pragma mark - PersonalBrokeNewsViewControllerDelegate
- (void)personalBrokeNewsVCDidClickCellWithBrokeID:(NSString *)brokeid{
    if ([self.delegate respondsToSelector:@selector(personalInfoSubjectViewDidSelectBroke:)]) {
        [self.delegate personalInfoSubjectViewDidSelectBroke:brokeid];
    }
}
#pragma mark - PersonalShareViewControllerDelegate
- (void)personalShareVCDidClickCellWithShaiDanID:(NSString *)shaidanid{
    if ([self.delegate respondsToSelector:@selector(personalInfoSubjectViewDidSelectShaidan:)]) {
        [self.delegate personalInfoSubjectViewDidSelectShaidan:shaidanid];
    }
}

#pragma mark - DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    return [self.allVC count];
}

- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    return self.allVC[number];
}

///更改关注按钮标题
-(void)bottomTitleAction
{
    [_btbottom setTitle:@"已关注" forState:UIControlStateNormal];
    [_btbottom setUserInteractionEnabled:NO];
    
}

@end
