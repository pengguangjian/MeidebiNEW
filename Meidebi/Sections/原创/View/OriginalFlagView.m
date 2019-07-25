//
//  OriginalFlagView.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OriginalFlagView.h"
#import "OriginalFlagCollectionViewCell.h"
static CGFloat const kCollectionViewLeftMargin = 16;
static CGFloat const kCollectionViewTopMargin = 16;
static CGFloat const kCollectionViewItemSpanMargin = 14;
static NSString * const kCollectionViewCellIdentifier = @"cell";

@interface OriginalFlagView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *flags;
@end

@implementation OriginalFlagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#E3E3E3"];
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _flowLayout.itemSize = CGSizeMake((CGRectGetWidth(self.frame)-(kCollectionViewLeftMargin*2)-(kCollectionViewItemSpanMargin*3))/4, CGRectGetHeight(_collectionView.frame));
}

- (void)setupSubviews{
    UIView *topLineView = [UIView new];
    [self addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.offset(1);
    }];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"#E3E3E3"];
    
    UIView *bottomLineView = [UIView new];
    [self addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.offset(1);
    }];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#E3E3E3"];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    _flowLayout = flowLayout;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kCollectionViewTopMargin);
        make.bottom.equalTo(self.mas_bottom).offset(-kCollectionViewTopMargin);
        make.left.right.equalTo(self);
    }];
    _collectionView.contentInset = UIEdgeInsetsMake(0, kCollectionViewLeftMargin, 0, kCollectionViewLeftMargin);
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[OriginalFlagCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.flags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OriginalFlagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell bindDataWithModel:self.flags[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(flageCollectionViewDidSelectRow:)]) {
        [self.delegate flageCollectionViewDidSelectRow:self.flags[indexPath.row][kFlageName]];
    }
}

#pragma mark - setters and getters
- (NSArray *)flags{
    if (!_flags) {
        _flags = @[@{kFlageName:@"美妆个护",
                     kFlageImage:[UIImage imageNamed:@"original_cosmetic"]},
                   @{kFlageName:@"家居用品",
                     kFlageImage:[UIImage imageNamed:@"orignial_live_goods"]},
                   @{kFlageName:@"美食旅游",
                     kFlageImage:[UIImage imageNamed:@"original_foo_travel"]},
                   @{kFlageName:@"鞋包服饰",
                     kFlageImage:[UIImage imageNamed:@"original_costume"]}];
    }
    return _flags;
}

@end
