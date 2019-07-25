//
//  SignInView.m
//  Meidebi
//
//  Created by fishmi on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SignInView.h"
#import "HomeHotCollectionViewCell.h"
#import "SignInHeadViewCollectionReusableView.h"
#import "SignInHeadModel.h"
#import "SignInHeadDoSignModel.h"
#import <MJExtension/MJExtension.h>
#import "ProductInfoViewController.h"

@interface SignInView ()<UICollectionViewDelegate,UICollectionViewDataSource,SignInHeadViewCollectionReusableViewDelegate>

@property (nonatomic ,strong) NSArray *listArray;
@property (nonatomic ,weak) UICollectionView *collectionV;
@property (nonatomic ,weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic ,weak) SignInHeadViewCollectionReusableView *headV;
@property (nonatomic ,strong) NSArray *headInfoArray;
@end



@implementation SignInView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FCF4F1"];
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 9;
    flowLayout.minimumInteritemSpacing = 7;
    flowLayout.itemSize = CGSizeMake((kMainScreenW-9)/2, (kMainScreenW-9)/2*1.35);
    SignInHeadViewCollectionReusableView *headV = [[SignInHeadViewCollectionReusableView alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(kMainScreenW, headV.height);
    _flowLayout = flowLayout;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.bounces = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[HomeHotCollectionViewCell class]
       forCellWithReuseIdentifier:@"cell"];
    [collectionView registerClass:[SignInHeadViewCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell"];
    //    [collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    
    [self addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    collectionView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    _collectionV = collectionView;
//    [self collectionViewAddRefersh];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _listArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeHotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell bindDataWithModel:_listArray[indexPath.row]];
//    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    SignInHeadViewCollectionReusableView *headReusableView = [[SignInHeadViewCollectionReusableView alloc] init];;
    if (kind == UICollectionElementKindSectionHeader) {
        
        headReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell" forIndexPath:indexPath];
        headReusableView.delegate = self;
        _headV = headReusableView;
    }
    
    return headReusableView;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     Commodity *model = _listArray[indexPath.row];
     ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
     productInfoVc.productId = model.commodityid;
    if ([self.delegate respondsToSelector:@selector(clicktoProductInfoViewController:)]) {
        [self.delegate clicktoProductInfoViewController:productInfoVc];
    }
    
}

- (void)signInBtnClick{
    if ([self.delegate respondsToSelector:@selector(signInBtnClick)]) {
        [self.delegate signInBtnClick];
    }
}

- (void)calculateSignInVHeight:(CGFloat)height{
    self.flowLayout.headerReferenceSize = CGSizeMake(kMainScreenW, height);
}

- (void)bindSignInHeadInfoData:(NSDictionary*)models{
    NSMutableArray *dicArray = [NSMutableArray array];
    _headInfoArray = [NSArray array];
    SignInHeadModel *dicModel = [SignInHeadModel mj_objectWithKeyValues:models];
    [dicArray addObject:dicModel];
    _headInfoArray = dicArray;
    _headV.model = dicArray[0];
}

//- (void)bindSignInHeadDoSignData:(NSDictionary*)models{
//    NSMutableArray *dicArray = [NSMutableArray array];
//    _headInfoArray = [NSArray array];
//    SignInHeadDoSignModel *dicModel = [SignInHeadDoSignModel mj_objectWithKeyValues:models];
//    [dicArray addObject:dicModel];
//    _headInfoArray = dicArray;
//    _headV.doSignModel = dicArray[0];
//}

- (void)bindSignInListData:(NSDictionary*)models{
    NSMutableArray *dicArray = [NSMutableArray array];
    _headInfoArray = [NSArray array];
    for (NSDictionary *dict in models) {
        Commodity *aCommodity = [Commodity mj_objectWithKeyValues:dict];
        if (aCommodity) {
            [dicArray addObject:aCommodity];
        }
    }    
    _listArray = dicArray;
    [_collectionV reloadData];
    
}

- (void)ClickToVKLoginViewController:(UIViewController *)controller{
    if ([self.delegate respondsToSelector:@selector(ClickToVKLoginViewController:)]) {
        [self.delegate ClickToVKLoginViewController:controller];
    }
}



@end
