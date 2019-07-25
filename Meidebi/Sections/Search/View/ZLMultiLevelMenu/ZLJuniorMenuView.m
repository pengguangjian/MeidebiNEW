//
//  ZLJuniorMenuView.m
//  FilterWares
//
//  Created by mdb-admin on 2016/11/15.
//  Copyright © 2016年 losaic. All rights reserved.
//

#import "ZLJuniorMenuView.h"
#import "ZLJuniorMenuCollectionViewCell.h"
#import "MDB_UserDefault.h"
#import "ZLMenuItem.h"
#define kSelectColor [UIColor colorWithHexString:@"#ff752a"]

@interface ZLJuniorMenuView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UICollectionView *juniorCollectionView;
@property (nonatomic, strong) NSMutableArray *selectJuniors;
@property (nonatomic, assign) NSInteger dependentPathRow;
@property (nonatomic, assign) NSInteger dependentPathSection;
@property (nonatomic, strong) NSArray *juniorItems;
@end

@implementation ZLJuniorMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _dependentPathRow = 0;
        _dependentPathSection = 0;
        [self setupSubViews];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubViews{
    [self addSubview:self.juniorCollectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:@"lessMoreTypeNotification" object:nil];
}

- (void)update:(NSNotification*)notification
{
    self.selectJuniors = [NSMutableArray arrayWithArray:[MDB_UserDefault filterProductTypes]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.juniorCollectionView reloadData];
    });
}

- (void)layoutSubviews{
    self.juniorCollectionView.frame = self.bounds;
}

- (void)reloadData:(NSArray *)datas
stairMenuIndexPath:(NSIndexPath *)path
currentLocationPath:(NSIndexPath *)locationPath{
    _juniorItems = datas;
    _dependentPathRow = path.row;
    _dependentPathSection = locationPath.section;
    if (!_dependentPathRow) {
        _dependentPathRow = 0;
    }
    if (!_dependentPathSection) {
        _dependentPathSection = 0;
    }
    self.selectJuniors = [NSMutableArray arrayWithArray:[MDB_UserDefault filterProductTypes]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.juniorCollectionView reloadData];
    });
}
- (void)filterArray{
    NSMutableArray *handelArray = [NSMutableArray array];
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableArray *temp1Array = [NSMutableArray array];
    [self.selectJuniors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *currentDict = (NSDictionary *)obj;
        if ([currentDict[@"dependentPathSection"] integerValue] == 0 ) {
            [tempArray addObject:obj];
        }else if ([currentDict[@"dependentPathSection"] integerValue] == 1){
            [temp1Array addObject:obj];
        }
    }];
    if (tempArray.firstObject) [handelArray addObject:tempArray.firstObject];
    if (temp1Array.firstObject) [handelArray addObject:temp1Array.firstObject];
    
    self.selectJuniors = [NSMutableArray arrayWithArray:handelArray.mutableCopy];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _juniorItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZLJuniorMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row<_juniorItems.count) {
        cell.juniorItem = _juniorItems[indexPath.row];
    }
    cell.layer.borderWidth = 0.4;
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.isSelect = YES;
    if (!_dependentPathRow) {
        _dependentPathRow = 0;
    }
    if (!_dependentPathSection) {
        _dependentPathSection = 0;
    }
    [self.selectJuniors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"path"] integerValue] == indexPath.row && [obj[@"dependentPathSection"] integerValue] == _dependentPathSection && [obj[@"dependentPathRow"] integerValue] == _dependentPathRow) {
            cell.layer.borderColor = kSelectColor.CGColor;
            cell.isSelect = NO;
        }
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((CGRectGetWidth(self.bounds)-5)/3, (CGRectGetWidth(self.bounds)-5)/3);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *currentPathDict = @{@"dependentPathRow":@(_dependentPathRow),
                                      @"dependentPathSection":@(_dependentPathSection),
                                      @"path":@(indexPath.row),
                                      @"itemID":[NSString nullToString:[self.juniorItems[indexPath.row] itemID]],
                                      @"itemName":[NSString nullToString:[self.juniorItems[indexPath.row] itemName]]};
    self.selectJuniors = [MDB_UserDefault filterProductTypes].mutableCopy;
    if (self.selectJuniors.count == 0) {
        [self.selectJuniors addObject:currentPathDict];
    }else{
        if (!_dependentPathRow) {
            _dependentPathRow = 0;
        }
        if (!_dependentPathSection) {
            _dependentPathSection = 0;
        }
        NSMutableArray *handleArray = [NSMutableArray arrayWithArray:self.selectJuniors.mutableCopy];
        [handleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *lastPathDict = (NSDictionary *)obj;
            if ([lastPathDict[@"dependentPathSection"] integerValue] == _dependentPathSection) {
                if ([lastPathDict[@"dependentPathRow"] integerValue] == _dependentPathRow) {
                    if ([lastPathDict[@"path"] integerValue] == indexPath.row) {
                        [self.selectJuniors removeObject:lastPathDict];
                    }else{
                        [self.selectJuniors removeObject:lastPathDict];
                        [self.selectJuniors addObject:currentPathDict];
                    }
                }else{
                    [self.selectJuniors removeObject:lastPathDict];
                    [self.selectJuniors addObject:currentPathDict];
                }
            }else{
                [self.selectJuniors addObject:currentPathDict];
            }
        }];
    }
    [self filterArray];
    [collectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(juniorMenuView:didSelectTypes:)]) {
        [self.delegate juniorMenuView:self didSelectTypes:self.selectJuniors.mutableCopy];
    }
    [MDB_UserDefault setFilterProductTypes:self.selectJuniors.mutableCopy];
}

#pragma mark - setters and getters
- (UICollectionView *)juniorCollectionView{
    if (!_juniorCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 1;
        _juniorCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                   collectionViewLayout:layout];
        _juniorCollectionView.delegate = self;
        _juniorCollectionView.dataSource = self;
        [_juniorCollectionView registerClass:[ZLJuniorMenuCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _juniorCollectionView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
        _juniorCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 1);
        _juniorCollectionView.showsVerticalScrollIndicator = NO;
        
    }
    return _juniorCollectionView;
}

- (NSMutableArray *)selectJuniors{
    if (!_selectJuniors) {
        _selectJuniors = [NSMutableArray array];
    }
    return _selectJuniors;
}
@end
