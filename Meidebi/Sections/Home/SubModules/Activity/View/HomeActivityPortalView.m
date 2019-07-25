//
//  HomeActivityPortalView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/7/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HomeActivityPortalView.h"
#import "RecommendElementViewCell.h"

static NSString * const kCollectionCellIdentifier = @"cell";
@interface HomeActivityPortalView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UICollectionView *recommendCollectionView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *recommendNameLabel;
@property (nonatomic, strong) NSArray *recommendContents;
@end

@implementation HomeActivityPortalView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview{

    // 推荐活动
    UIView *titleView = [UIView new];
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(16);
        make.top.equalTo(self.mas_top).offset(14);
    }];
    titleView.backgroundColor = [UIColor whiteColor];
    _titleView.hidden = YES;
    _titleView = titleView;
    
    UILabel *recommendNameLabel = [UILabel new];
    [titleView addSubview:recommendNameLabel];
    [recommendNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_top);
        make.centerX.equalTo(titleView.mas_centerX);
    }];
    recommendNameLabel.font = [UIFont systemFontOfSize:14.f];
    recommendNameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _recommendNameLabel = recommendNameLabel;
    
    UIView *leftLineView = [UIView new];
    [titleView addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(recommendNameLabel.mas_left).offset(-8);
        make.centerY.equalTo(recommendNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 1));
    }];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *rightLineView = [UIView new];
    [titleView addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recommendNameLabel.mas_right).offset(8);
        make.centerY.equalTo(recommendNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 1));
    }];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    [collectionView registerClass:[RecommendElementViewCell class]
       forCellWithReuseIdentifier:kCollectionCellIdentifier];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    _recommendCollectionView = collectionView;
    [self addSubview:self.recommendCollectionView];
    [self.recommendCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(titleView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom).offset(-2);
    }];
}

- (void)bindDataWithModels:(NSArray *)models{
    if (models.count <= 0) {
        [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
            make.top.equalTo(self.mas_top);
        }];
        _titleView.hidden = YES;
    }else{
        [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(16);
            make.top.equalTo(self.mas_top).offset(14);
        }];
        _titleView.hidden = NO;
        _recommendContents = models;
        [_recommendCollectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.recommendContents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecommendElementViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    [cell bindRecommendElementData:self.recommendContents[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMainScreenW, IS_IPHONE_WIDE_SCREEN ? kMainScreenW*0.45 : kMainScreenW*0.48);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(activityPortalViewDidSelectItemAtIndex:)]) {
        [self.delegate activityPortalViewDidSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - setters and getters
- (void)setActivityTitle:(NSString *)activityTitle{
    _activityTitle = activityTitle;
    _recommendNameLabel.text = activityTitle;
    _titleView.hidden = NO;
}


@end
