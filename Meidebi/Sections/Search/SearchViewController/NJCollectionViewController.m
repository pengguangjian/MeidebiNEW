//
//  NJCollectionViewController.m
//  Meidebi
//
//  Created by mdb-admin on 16/4/11.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "NJCollectionViewController.h"
#import "CategoryCollectionViewCell.h"
#import "CollectionHeaderReusableView.h"

@interface NJCollectionViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UICollectionView *mallCollectionView;

@end

@implementation NJCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mallCollectionView];
    [self.mallCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegateFlowLayout && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_collectionType == CollectionVcTypeCategory) {
        return 1;
    }else if(_collectionType == CollectionVcTypeHot){
        return 2;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_collectionType == CollectionVcTypeCategory) {
        return _dataSource.count+(_dataSource.count%3);
    }else if(_collectionType == CollectionVcTypeHot){
        return 12;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (_collectionType == CollectionVcTypeCategory) {
        if (indexPath.row>=_dataSource.count){
            cell.iconImageLink = @"";
            cell.name = @"";
            return cell;
        }
        cell.iconImageLink = _dataSource[indexPath.row][@"imageUrl"];
        cell.name = _dataSource[indexPath.row][@"name"];
        cell.cellType = CollectionCellTypeCategory;
    }else if(_collectionType == CollectionVcTypeHot){
        if (indexPath.row>=[_dataSource[indexPath.section] count]){
            cell.iconImageLink = @"";
            cell.name = @"";
            return cell;
        }
         cell.iconImageLink = _dataSource[indexPath.section][indexPath.row][@"iosicon"];
         cell.name = _dataSource[indexPath.section][indexPath.row][@"name"];
         cell.cellType = CollectionCellTypeHot;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (_collectionType == CollectionVcTypeCategory) {
        return CGSizeMake((CGRectGetWidth(self.view.frame)-2)/3, (CGRectGetWidth(self.view.frame)-2)/3);
    }else{
        return CGSizeMake((CGRectGetWidth(self.view.frame)-3)/4, ((CGRectGetWidth(self.view.frame)-3)/4)*0.64);
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_collectionType == CollectionVcTypeCategory) {
        if (indexPath.row>=_dataSource.count) return;
        if ([self.delegate respondsToSelector:@selector(NJCollectionViewController:categoryDidPressCellOfContent:)]) {
            [self.delegate NJCollectionViewController:self categoryDidPressCellOfContent:_dataSource[indexPath.row]];
        }
    }else if(_collectionType == CollectionVcTypeHot){
        if (indexPath.row>=[_dataSource[indexPath.section] count]) return;
        if ([self.delegate respondsToSelector:@selector(NJCollectionViewController:categoryDidPressCellOfContent:)]) {
            [self.delegate NJCollectionViewController:self categoryDidPressCellOfContent:_dataSource[indexPath.section][indexPath.row]];
        }
    }

    
}

//设置标题头的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (_collectionType == CollectionVcTypeHot) {
        return CGSizeMake(50, 40);
    }
    return CGSizeZero;
}

//自定义标题头或标题尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //标题头
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        if (indexPath.section != 0) {
            view.isShowTopLineView = YES;
            view.categoryStr = @"国内";
        }else{
            view.isShowTopLineView = NO;
            view.categoryStr = @"海淘";
        }
        return view;
    }
    return nil;
}


#pragma mark - getters and setters
- (UICollectionView *)mallCollectionView{
    if (!_mallCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 0.8;
        flowLayout.minimumInteritemSpacing = 0.8;
        _mallCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                 collectionViewLayout:flowLayout];
        _mallCollectionView.delegate = self;
        _mallCollectionView.dataSource = self;
        _mallCollectionView.backgroundColor = [UIColor colorWithRed:0.8706 green:0.8745 blue:0.8706 alpha:1.0];
        [_mallCollectionView registerClass:[CategoryCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_mallCollectionView registerClass:[CollectionHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
        _mallCollectionView.allowsMultipleSelection = YES;
        _mallCollectionView.showsHorizontalScrollIndicator = NO;
        _mallCollectionView.showsVerticalScrollIndicator = NO;
        _mallCollectionView.scrollsToTop = NO;
        _mallCollectionView.scrollEnabled = NO;
        _mallCollectionView.contentInset = UIEdgeInsetsMake(1, 0, 0, 0);
    }
    return _mallCollectionView;
}

- (CGFloat)allHeight{
    
    if (_collectionType == CollectionVcTypeCategory) {
        if (self.dataSource.count%3==0) {
            return self.dataSource.count/3 * (CGRectGetWidth(self.view.frame)-2)/3 + 78/*tabBar高度*/;
        }else{
            return (self.dataSource.count/3 * (CGRectGetWidth(self.view.frame)-2)/3) + (CGRectGetWidth(self.view.frame)-2)/3 + 78/*tabBar高度*/;
        }
    }else{
        return 6*(((CGRectGetWidth(self.view.frame)-3)/4)*0.64)/*cell高度*/+2*40/*collectionView标题头高度*/ + 78/*tabBar高度*/;
    }
    
}

- (void)setDataSource:(NSArray *)dataSource{
     _dataSource = dataSource;
    [self.mallCollectionView reloadData];
}


@end
