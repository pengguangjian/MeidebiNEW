//
//  CouponResultSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/7/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CouponResultSubjectView.h"
#import "CouponSimpleCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>
static NSString * const kCollectionViewCellIdentifier = @"cell";

@interface CouponResultSubjectView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
CouponSimpleCollectionViewCellDelegate
>
@property (nonatomic, strong) UICollectionView *couponCollectionView;
@property (nonatomic, strong) NSArray *coupons;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UILabel *emptyAlertLabel;
@end

@implementation CouponResultSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 9;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    [collectionView registerClass:[CouponSimpleCollectionViewCell class]
       forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setContentInset:UIEdgeInsetsMake(5, 0, 5, 0)];
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([self.delegate respondsToSelector:@selector(reloadCollectionViewDataSource)]) {
            [self.delegate reloadCollectionViewDataSource];
        }
    }];
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([self.delegate respondsToSelector:@selector(footReloadCollectionViewDataSource)]) {
            [self.delegate footReloadCollectionViewDataSource];
        }
    }];
    _couponCollectionView = collectionView;
    [self setupEmpityView];
}

- (void)setupEmpityView{
   
    _emptyView = [UIView new];
    _emptyView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    [self addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _emptyView.hidden = YES;
    UILabel *emptyAlertLabel = [UILabel new];
    [_emptyView addSubview:emptyAlertLabel];
    [emptyAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_emptyView.mas_top).offset(50);
        make.left.equalTo(_emptyView.mas_left).offset(35);
        make.right.equalTo(_emptyView.mas_right).offset(-35);
    }];
    emptyAlertLabel.numberOfLines = 0;
    emptyAlertLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    emptyAlertLabel.font = [UIFont systemFontOfSize:14.f];
    emptyAlertLabel.textAlignment = NSTextAlignmentCenter;
    _emptyAlertLabel = emptyAlertLabel;
}

- (void)bindDataWithModel:(NSArray *)model{
    if (model.count <= 0) {
        _emptyView.hidden = NO;
    }else{
        _emptyView.hidden = YES;
        _coupons = model;
        [_couponCollectionView reloadData];
    }
}

- (void)updataDataWithModel:(NSArray *)model{
    [_couponCollectionView.mj_header endRefreshing];
    [_couponCollectionView.mj_footer endRefreshing];
    if (model.count <= 0) return;
    _coupons = model;
    [_couponCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _coupons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CouponSimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell bindDataWithModel:_coupons[indexPath.row]];
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kMainScreenW-10)/2, (kMainScreenW-10)/2*(IS_IPHONE_WIDE_SCREEN ? 1.645 : 1.75));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(couponSimpleCollectionViewCellDidClickDrawBtnWithCouponURL:)]) {
        [self.delegate couponSimpleCollectionViewCellDidClickDrawBtnWithCouponURL:[NSString nullToString:_coupons[indexPath.row][@"coupon_click_url"]]];
    }
}

#pragma mark - UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(couponResultCollectionViewDidScroll)]) {
        [self.delegate couponResultCollectionViewDidScroll];
    }
}

#pragma mark - CouponSimpleCollectionViewCellDelegate
- (void)couponSimpleCollectionViewCellDidClickDrawBtn:(CouponSimpleCollectionViewCell *)cell{
    NSIndexPath *path = [_couponCollectionView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(couponSimpleCollectionViewCellDidClickDrawBtnWithCouponURL:)]) {
        [self.delegate couponSimpleCollectionViewCellDidClickDrawBtnWithCouponURL:[NSString nullToString:_coupons[path.row][@"coupon_click_url"]]];
    }
}

#pragma mark - setters and getters
- (void)setSearchKey:(NSString *)searchKey{
    _searchKey = searchKey;
    _emptyAlertLabel.text = [NSString stringWithFormat:@"没找到与 \"%@\" 相关的商品哦 要不您换个关键词再找找看",_searchKey];
}
@end
