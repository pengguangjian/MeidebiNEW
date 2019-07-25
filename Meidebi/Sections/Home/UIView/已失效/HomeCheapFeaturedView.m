//
//  HomeCheapFeaturedView.m
//  Meidebi
//  暂未使用
//  Created by ZlJ_losaic on 2017/8/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HomeCheapFeaturedView.h"
#import "CheapFeaturedViewCell.h"
static NSString * const kCollectionViewCellIndentifier = @"cell";
static CGFloat const kCollectionViewCellHeight = 64.f;
static CGFloat const kCollectionViewLeftMargin = 10.f;

@interface HomeCheapFeaturedView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *cheaps;
@property (nonatomic, strong) UIView *titleView;
@end

@implementation HomeCheapFeaturedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    UIView *titleView = [UIView new];
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(16);
        make.top.equalTo(self.mas_top).offset(20);
    }];
    _titleView = titleView;
    
    UILabel *titleLabel = [UILabel new];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titleView);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.text = @"白菜精选";
    
    UIView *leftLineView = [UIView new];
    [titleView addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(titleLabel.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(16, 1));
    }];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *rightLineView = [UIView new];
    [titleView addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.left.equalTo(titleLabel.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(16, 1));
    }];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = kCollectionViewLeftMargin;
//    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    [collectionView registerClass:[CheapFeaturedViewCell class]
       forCellWithReuseIdentifier:kCollectionViewCellIndentifier];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setContentInset:UIEdgeInsetsMake(0, kCollectionViewLeftMargin, 0, kCollectionViewLeftMargin)];
    _collectionView = collectionView;
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(titleView.mas_bottom).offset(20);
        make.height.offset(kCollectionViewCellHeight * 2);
    }];
    [self layoutIfNeeded];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(CGRectGetMaxY(_collectionView.frame)+65);
    }];
}

- (void)bindDataWithModel:(NSArray *)model{
    if (model.count <= 0) {
        [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
            make.top.equalTo(self.mas_top);
        }];
        _titleView.hidden = YES;
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleView.mas_bottom);
            make.height.offset(0);
        }];
        [self layoutIfNeeded];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }else{
        [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(16);
            make.top.equalTo(self.mas_top).offset(20);
        }];
        _titleView.hidden = NO;
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleView.mas_bottom).offset(20);
            make.height.offset(kCollectionViewCellHeight * (model.count/2)+kCollectionViewLeftMargin);
        }];
        [self layoutIfNeeded];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(CGRectGetMaxY(_collectionView.frame)+15);
        }];
        
        _cheaps = model;
        [_collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _cheaps.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CheapFeaturedViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIndentifier forIndexPath:indexPath];
    [cell bindDataWithModel:_cheaps[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kMainScreenW-kCollectionViewLeftMargin*3)/2, kCollectionViewCellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(cheapFeaturedViewDidSelectFeature:)]) {
        [self.delegate cheapFeaturedViewDidSelectFeature:[(HomeCheapViewModel *)_cheaps[indexPath.row] commodityID]];
    }
}




@end
