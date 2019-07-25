//
//  RecommendedAttentionView.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RecommendedAttentionView.h"
#import "AttentionCollectionViewCell.h"
static NSString * const kCollectionViewCellIdentifier = @"cell";
static CGFloat const kCollectionViewLeftMargin = 15;

@interface RecommendedAttentionView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
AttentionCollectionViewCellDelegate
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *users;
@end

@implementation RecommendedAttentionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _flowLayout.itemSize = CGSizeMake((CGRectGetWidth(self.frame)-(kCollectionViewLeftMargin*2))/4, CGRectGetHeight(_collectionView.frame));
}

- (void)setupSubviews{
    
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.text = @"推荐关注";
    
    UIView *leftLineView = [UIView new];
    [self addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(titleLabel.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(16, 1));
    }];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *rightLineView = [UIView new];
    [self addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.left.equalTo(titleLabel.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(16, 1));
    }];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLineView.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(self);
    }];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(0, kCollectionViewLeftMargin, 0, kCollectionViewLeftMargin);
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = NO;
    [_collectionView registerClass:[AttentionCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
}

- (void)bindDataWithModel:(NSArray *)models{
    if (models.count <= 0) return;
    _users = models;
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _users.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AttentionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell bindDataWithModel:_users[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(attentionViewDidSelectUserAvater:)]) {
        [self.delegate attentionViewDidSelectUserAvater:[NSString stringWithFormat:@"%@",[NSString nullToString:_users[indexPath.row][@"userid"]]]];
    }
}

#pragma mark - AttentionCollectionViewCellDelegate
- (void)collectionViewCellDidSelect:(AttentionCollectionViewCell *)cell{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(attentionViewDidSelectUser:complete:)]) {
        [self.delegate attentionViewDidSelectUser:[NSString stringWithFormat:@"%@",[NSString nullToString:_users[indexPath.row][@"userid"]]] complete:^(BOOL state) {
            if (state) {
                NSMutableArray *users = [NSMutableArray arrayWithArray:_users];
                NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithDictionary:_users[indexPath.row]];
                [userInfoDict setValue:@"1" forKey:kUserFollowState];
                [users replaceObjectAtIndex:indexPath.row withObject:userInfoDict.mutableCopy];
                _users = users.mutableCopy;
                [_collectionView reloadData];
            }
        }];
    }
}
@end
