//
//  FindCouponIndexSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/7/7.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "FindCouponIndexSubjectView.h"
#import "MDB_UserDefault.h"
#import "NJFlagView.h"
#import "FindCouponCollectionViewCell.h"
#import <UMAnalytics/MobClick.h>

static NSString * const kCollectionViewCellIdentifier = @"cell";
static NSString * const kShopTypeIcon = @"icon";
static NSString * const kShopTypeTitle = @"title";
static NSString * const kShopTypeSubTitle = @"subtitle";

@interface FindCouponIndexSubjectView ()
<
NJFlagViewDelegate,
UIScrollViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UITextFieldDelegate
>
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) UILabel *findCouponSumLabel;
@property (nonatomic, strong) NJFlagView *flagView;
@property (nonatomic, strong) UICollectionView *shopCollectionView;
@property (nonatomic, strong) NSArray *shopTypes;
@property (nonatomic, strong) NSArray *hotSearchBrands;
@property (nonatomic, assign) CGFloat collectionViewCellHeight;
@end

@implementation FindCouponIndexSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    UIScrollView *mainScrollView = [UIScrollView new];
    [self addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    mainScrollView.delegate = self;
    
    _mainContainerView = [UIView new];
    [mainScrollView addSubview:_mainContainerView];
    [_mainContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.equalTo(mainScrollView);
    }];
    _mainContainerView.backgroundColor = [UIColor whiteColor];
    
    UIView *topHeaderView = [UIView new];
    [_mainContainerView addSubview:topHeaderView];
    [topHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_mainContainerView);
        make.height.offset(66);
    }];
    topHeaderView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    UIView *searchContainerView = [UIView new];
    [topHeaderView addSubview:searchContainerView];
    [searchContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topHeaderView).insets(UIEdgeInsetsMake(13, 13, 13, 13));
    }];
    searchContainerView.backgroundColor = [UIColor whiteColor];
    searchContainerView.layer.cornerRadius = 41/2.f;
    searchContainerView.layer.masksToBounds = YES;
    searchContainerView.layer.borderWidth = .8f;
    searchContainerView.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searchContainerView.mas_right).offset(-8);
        make.top.equalTo(searchContainerView.mas_top).offset(5);
        make.bottom.equalTo(searchContainerView.mas_bottom).offset(-5);
        make.width.equalTo(searchBtn.mas_height);
    }];
    [searchBtn setImage:[UIImage imageNamed:@"coupon_searchBtn"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(respondsToSearchBtnEvent:) forControlEvents:UIControlEventTouchUpInside];

    _searchTextField = [UITextField new];
    [_searchTextField setDelegate:self];
    [_searchTextField setReturnKeyType:UIReturnKeySearch];
    [searchContainerView addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchContainerView.mas_left).offset(24);
        make.right.equalTo(searchBtn.mas_left).offset(-15);
        make.top.equalTo(searchContainerView.mas_top).offset(8);
        make.bottom.equalTo(searchContainerView.mas_bottom).offset(-8);
    }];
    _searchTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _searchTextField.font = [UIFont systemFontOfSize:14.f];
    
    UIView *findeCouponSumContainerView = [UIView new];
    [_mainContainerView addSubview:findeCouponSumContainerView];
    [findeCouponSumContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topHeaderView.mas_bottom);
        make.left.right.equalTo(_mainContainerView);
        make.height.offset(40);
    }];
    findeCouponSumContainerView.backgroundColor = [UIColor colorWithHexString:@"#FA7A00"];
    
    _findCouponSumLabel = [UILabel new];
    [findeCouponSumContainerView addSubview:_findCouponSumLabel];
    [_findCouponSumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(findeCouponSumContainerView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    _findCouponSumLabel.textAlignment = NSTextAlignmentCenter;
    _findCouponSumLabel.textColor = [UIColor whiteColor];
    _findCouponSumLabel.font = [UIFont systemFontOfSize:14.f];
    _findCouponSumLabel.text = @"已为比友找到 0 张优惠券";
    
    _flagView = [NJFlagView new];
    [_mainContainerView addSubview:_flagView];
    [_flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(findeCouponSumContainerView.mas_bottom).offset(14);
        make.left.right.equalTo(_mainContainerView);
    }];
    _flagView.flagTitleName = @"—— 大家都在搜 ——";
    _flagView.titleType = FlagTitleTypeCustom;
    _flagView.delegate = self;
    __weak typeof (self) weakSelf = self;
    _flagView.callback = ^(CGFloat height) {
        [weakSelf.flagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
        }];
    };
    
    UILabel *brandTypeTitleLabel = [UILabel new];
    [_mainContainerView addSubview:brandTypeTitleLabel];
    [brandTypeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_flagView.mas_bottom).offset(15);
        make.left.equalTo(_mainContainerView.mas_left).offset(15);
        make.right.equalTo(_mainContainerView.mas_right).offset(-15);
    }];
    brandTypeTitleLabel.textAlignment = NSTextAlignmentCenter;
    brandTypeTitleLabel.textColor = [UIColor colorWithHexString:@"#959595"];
    brandTypeTitleLabel.font = [UIFont systemFontOfSize:12.f];
    brandTypeTitleLabel.text = @"—— 品牌券 触手可及 ——";
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    [collectionView registerClass:[FindCouponCollectionViewCell class]
       forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [_mainContainerView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_mainContainerView);
        make.top.equalTo(brandTypeTitleLabel.mas_bottom).offset(20);
        make.height.offset(self.collectionViewCellHeight*2+1.5);
    }];
    _shopCollectionView = collectionView;
    UIView *collectionTopLineView = [UIView new];
    [_mainContainerView addSubview:collectionTopLineView];
    [collectionTopLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_shopCollectionView.mas_top);
        make.left.right.equalTo(_shopCollectionView);
        make.height.offset(1);
    }];
    collectionTopLineView.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    
    UIView *collectionFooterLineView = [UIView new];
    [_mainContainerView addSubview:collectionFooterLineView];
    [collectionFooterLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shopCollectionView.mas_bottom);
        make.left.right.equalTo(_shopCollectionView);
        make.height.offset(1);
    }];
    collectionFooterLineView.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    

    UILabel *couponTtypeTitleLabel = [UILabel new];
    [_mainContainerView addSubview:couponTtypeTitleLabel];
    [couponTtypeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectionView.mas_bottom).offset(20);
        make.left.equalTo(_mainContainerView.mas_left).offset(15);
        make.right.equalTo(_mainContainerView.mas_right).offset(-15);
    }];
    couponTtypeTitleLabel.textAlignment = NSTextAlignmentCenter;
    couponTtypeTitleLabel.textColor = [UIColor colorWithHexString:@"#959595"];
    couponTtypeTitleLabel.font = [UIFont systemFontOfSize:12.f];
    couponTtypeTitleLabel.text = @"—— 商品券分类 ——";
    
    UIControl *lastItemControl = nil;
    for (NSInteger i = 0; i<self.shopTypes.count; i++) {
        UIControl *itemControl = [self setupShopTypeItemWithIcon:self.shopTypes[i][kShopTypeIcon] title:self.shopTypes[i][kShopTypeTitle] subTitle:self.shopTypes[i][kShopTypeSubTitle]];
        [_mainContainerView addSubview:itemControl];
        [itemControl mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0 || i==2) {
                make.left.equalTo(couponTtypeTitleLabel.mas_left);
            }else{
                make.left.equalTo(lastItemControl.mas_right).offset(11);
            }
            if (i == 0) {
                make.top.equalTo(couponTtypeTitleLabel.mas_bottom).offset(20);
            }else if (i == 2) {
                make.top.equalTo(lastItemControl.mas_bottom).offset(10);
            }else{
                make.top.equalTo(lastItemControl.mas_top);
            }
            if (i==1 || i==3) {
                make.right.equalTo(_mainContainerView.mas_right).offset(-15);
            }
            if (lastItemControl) {
                make.width.equalTo(lastItemControl.mas_width);
            }
            make.height.offset(65);
        }];
        itemControl.tag = i;
        [itemControl addTarget:self action:@selector(respondsToShopTypeItemEvent:) forControlEvents:UIControlEventTouchUpInside];
        lastItemControl = itemControl;
    }
    
    [_mainContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastItemControl.mas_bottom).offset(70);
    }];
    
    
}

- (void)respondsToSearchBtnEvent:(UIButton *)sender{
    if (_searchTextField.text.length<=0) {
        [MDB_UserDefault showNotifyHUDwithtext:@"搜索内容不能为空！" inView:self];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(subjectViewDidSearchCouponWithKeyWord:)]) {
        [self.delegate subjectViewDidSearchCouponWithKeyWord:_searchTextField.text];
    }
    [_searchTextField resignFirstResponder];
    _searchTextField.text = nil;
}

- (void)respondsToShopTypeItemEvent:(UIControl *)sender{
    NSString *keyword = self.shopTypes[sender.tag][kShopTypeTitle];
    if ([self.delegate respondsToSelector:@selector(subjectViewDidSearchCouponWithKeyWord:)]) {
        [MobClick event:@"souquan_fenlei" attributes:@{@"name":[NSString nullToString:keyword]}];
        [self.delegate subjectViewDidSearchCouponWithKeyWord:keyword];
    }
}

- (UIControl *)setupShopTypeItemWithIcon:(UIImage *)icon
                                   title:(NSString *)title
                                subTitle:(NSString *)sub{
    UIControl *itemControl = [UIControl new];
    itemControl.backgroundColor = [UIColor whiteColor];
    itemControl.layer.masksToBounds = YES;
    itemControl.layer.cornerRadius = 4.f;
    itemControl.layer.borderWidth = 0.8;
    itemControl.layer.borderColor = [UIColor colorWithHexString:@"#DCDCDC"].CGColor;
    
    UIImageView *iconImageView = [UIImageView new];
    [itemControl addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemControl.mas_top).offset(6);
        make.left.equalTo(itemControl.mas_left).offset(6);
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.image = icon;
    
    UILabel *titleLabel = [UILabel new];
    [itemControl addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(6);
        make.bottom.equalTo(iconImageView.mas_centerY).offset(-3);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.text = title;
    
    UILabel *subTitleLabel = [UILabel new];
    [itemControl addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(6);
        make.right.equalTo(itemControl.mas_right).offset(-3);
        make.top.equalTo(iconImageView.mas_centerY).offset(3);
    }];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.font = [UIFont systemFontOfSize:11.f];
    subTitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    subTitleLabel.text = sub;
    
    return itemControl;
}

- (void)bindeDataWithModel:(NSDictionary *)dict{
    if (!dict) return;
    _findCouponSumLabel.text = [NSString stringWithFormat:@"已为比友找到 %@ 张优惠券",[NSString nullToString:dict[@"count"]]];
    _hotSearchBrands = dict[@"hotSearchBrand"];
    NSMutableArray *tags = [NSMutableArray array];
    if ([dict[@"hotSearchWord"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *tagDict in dict[@"hotSearchWord"]) {
            if (![[NSString nullToString:tagDict[@"word"]] isEqualToString:@""]) {
                [tags addObject:@{@"name":[NSString nullToString:tagDict[@"word"]],
                                  @"type":@"1"}];
            }
        }
    }
   
    [_flagView flag:tags.mutableCopy];
    if (_hotSearchBrands.count>0) {
        _shopCollectionView.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
        [_shopCollectionView reloadData];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        if (_searchTextField.text.length<=0) {
            [MDB_UserDefault showNotifyHUDwithtext:@"搜索内容不能为空！" inView:self];
            return NO;
        }
        if ([self.delegate respondsToSelector:@selector(subjectViewDidSearchCouponWithKeyWord:)]) {
            [self.delegate subjectViewDidSearchCouponWithKeyWord:_searchTextField.text];
        }
        [_searchTextField resignFirstResponder];
        _searchTextField.text = nil;
        return NO;
    }
    
    return YES;
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _hotSearchBrands.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FindCouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    if(indexPath.row>=_hotSearchBrands.count)
    {
        [cell bindDataWithModel:_hotSearchBrands[_hotSearchBrands.count-1]];
    }
    else
    {
        [cell bindDataWithModel:_hotSearchBrands[indexPath.row]];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kMainScreenW-3)/4, self.collectionViewCellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(subjectViewDidSearchCouponWithKeyWord:)]) {
        NSString *keyword = [NSString nullToString:_hotSearchBrands[indexPath.row][@"word"]];
        [MobClick event:@"souquan_pinpai" attributes:@{@"name":keyword}];
        [self.delegate subjectViewDidSearchCouponWithKeyWord:keyword];
    }
}

#pragma mark - NJFlagViewDelegate
- (void)flageViewDidClickItem:(NSDictionary *)item type:(FlagType)type{
    NSString *keyword = item[@"name"];
    if ([self.delegate respondsToSelector:@selector(subjectViewDidSearchCouponWithKeyWord:)]) {
        [MobClick event:@"souquan_reci" attributes:@{@"name":[NSString nullToString:keyword]}];
        [self.delegate subjectViewDidSearchCouponWithKeyWord:keyword];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchTextField resignFirstResponder];
}

#pragma mark - setters and getters
- (NSArray *)shopTypes{
    if (!_shopTypes) {
        _shopTypes = @[@{kShopTypeIcon:[UIImage imageNamed:@"shop_type_home"],
                         kShopTypeTitle:@"家居日用",
                         kShopTypeSubTitle:@"会屯会生活"},
                       @{kShopTypeIcon:[UIImage imageNamed:@"shop_type_household"],
                         kShopTypeTitle:@"数码家电",
                         kShopTypeSubTitle:@"简化你的生活"},
                       @{kShopTypeIcon:[UIImage imageNamed:@"shop_type_cosmetic"],
                         kShopTypeTitle:@"美妆个护",
                         kShopTypeSubTitle:@"每天都要美美哒"},
                       @{kShopTypeIcon:[UIImage imageNamed:@"shop_type_shoe"],
                         kShopTypeTitle:@"鞋包配饰",
                         kShopTypeSubTitle:@"潮人靠搭配"}];
    }
    return _shopTypes;
}

- (CGFloat)collectionViewCellHeight{
    if (!_collectionViewCellHeight) {
        _collectionViewCellHeight = ((kMainScreenW-3)/4)*0.643;
    }
    return _collectionViewCellHeight;
}

@end
