//
//  BaiCaiView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/22.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "BaiCaiView.h"
#import "CheapFeaturedViewCell.h"
static NSString * const kCollectionViewCellIndentifier = @"cell";
static CGFloat const kCollectionViewCellHeight = 64.f;
static CGFloat const kCollectionViewLeftMargin = 10.f;

@interface BaiCaiView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *cheaps;
@property (nonatomic, strong) UIView *titleView;
@end


@implementation BaiCaiView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.width, 16)];
    [self addSubview:titleView];
    _titleView = titleView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleView.width, titleView.height)];
    [titleView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.text = @"白菜精选";
    [titleLabel sizeToFit];
    [titleLabel setCenter:CGPointMake(titleView.width/2.0, titleView.height/2.0)];
    [titleLabel setHeight:titleView.height];
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.left-16, titleLabel.center.y, 16, 1)];
    [titleView addSubview:leftLineView];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.center.y, 16, 1)];
    [titleView addSubview:rightLineView];
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
    [_collectionView setFrame:CGRectMake(0, titleView.bottom+10, self.width, kCollectionViewCellHeight*2)];
    [self layoutIfNeeded];
    
}

- (float)bindDataWithModel:(NSArray *)model{
    if (model.count <= 0) {
        _titleView.hidden = YES;
        [self layoutIfNeeded];
        return 0.1;
    }else{
        _titleView.hidden = NO;
        [_collectionView setHeight:kCollectionViewCellHeight * (model.count/2)+kCollectionViewLeftMargin];
        [self layoutIfNeeded];
        
        _cheaps = model;
        [_collectionView reloadData];
        
        return _collectionView.height+46+10;
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
    
//    if ([self.delegate respondsToSelector:@selector(cheapFeaturedViewDidSelectFeature:)]) {
//        [self.delegate cheapFeaturedViewDidSelectFeature:[(HomeCheapViewModel *)_cheaps[indexPath.row] commodityID]];
//    }
    [self.delegate baiCaiDidClichkCurrentHotWithItem:(HomeCheapViewModel *)_cheaps[indexPath.row]];

}
@end
