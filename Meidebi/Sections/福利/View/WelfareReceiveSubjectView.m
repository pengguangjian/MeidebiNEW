//
//  WelfareReceiveSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "WelfareReceiveSubjectView.h"
#import "ZLJCollectionViewFlowLayout.h"
#import "WelfareStrategyViewCell.h"
#import "WelfareReceiveCollectionHeaderView.h"
@interface WelfareReceiveCollectionFooterView : UICollectionReusableView
@end
@implementation WelfareReceiveCollectionFooterView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    }
    return self;
}
@end

static NSString *collectionCellIdentifier = @"cell";
static NSString *collectionHeaderViewIdentifier = @"headerView";
static NSString *collectionFooterViewIdentifier = @"footerView";

@interface WelfareReceiveSubjectView ()
<
ZLJCollectionViewFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource,
WelfareReceiveCollectionHeaderViewDelegate
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WelfareReceiveCollectionHeaderView *headerView;
@property (nonatomic, strong) NSArray *strategys;
@property (nonatomic, strong) NSDictionary *currentCoinDict;
@property (nonatomic, assign) NSInteger currentHeaderViewHeight;
@end

@implementation WelfareReceiveSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentHeaderViewHeight = 248;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    ZLJCollectionViewFlowLayout *flowLayout = [[ZLJCollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [collectionView registerClass:[WelfareStrategyViewCell class]
       forCellWithReuseIdentifier:collectionCellIdentifier];
    [collectionView registerClass:[WelfareReceiveCollectionHeaderView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:collectionHeaderViewIdentifier];
    [collectionView registerClass:[WelfareReceiveCollectionFooterView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:collectionFooterViewIdentifier];
    _collectionView = collectionView;

}

- (void)bindDataWithModel:(NSDictionary *)dict{
    if (!dict) return;
   _currentCoinDict = @{kAllIntegralKey:[NSString nullToString:dict[@"allIntegral"]],
                        kAllCopperKey:[NSString nullToString:dict[@"allCopper"]]};
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *runTasks = [NSMutableArray array];
    NSMutableArray *endTasks = [NSMutableArray array];
    for (NSDictionary *taskDict in dict[@"runTask"]) {
        NSDictionary *runDict = [self combinationModel:taskDict];
        [runTasks addObject:runDict];
    }
    [tempArr addObject:@{kWelfareStrategySectionTitle:[NSString stringWithFormat:@"进行中（%@）",@(runTasks.count)],
                         @"data":runTasks.mutableCopy}];
    for (NSDictionary *taskDict in dict[@"endTask"]) {
        NSDictionary *endDict = [self combinationModel:taskDict];
        [endTasks addObject:endDict];
    }
    [tempArr addObject:@{kWelfareStrategySectionTitle:[NSString stringWithFormat:@"已完成（%@）",@(endTasks.count)],
                         @"data":endTasks.mutableCopy}];
    self.strategys = tempArr.mutableCopy;
    [_collectionView reloadData];

}

- (NSDictionary *)combinationModel:(NSDictionary *)model{
    NSString *describe = @"";
    if (![[NSString stringWithFormat:@"%@",[NSString nullToString:model[@"task_copper"]]] isEqualToString:@"0"]) {
        describe = [NSString stringWithFormat:@"+%@铜币",[NSString nullToString:model[@"task_copper"]]];
    }
    if (![[NSString stringWithFormat:@"%@",[NSString nullToString:model[@"task_integral"]]] isEqualToString:@"0"]){
        if (![describe isEqualToString:@""]) {
            describe = [describe stringByAppendingString:@"，"];
        }
        describe = [describe stringByAppendingString:[NSString stringWithFormat:@"+%@积分",[NSString nullToString:model[@"task_integral"]]]];
    }
    NSDictionary *dict = @{kWelfareStrategyName:[NSString nullToString:model[@"task_name"]],
                           kWelfareStrategyDescribe:describe};
    return dict;

}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.strategys.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.strategys[section][@"data"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WelfareStrategyViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    [cell bindDataWithModel:self.strategys[indexPath.section][@"data"][indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kMainScreenW-40)/2, 67);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(CGRectGetWidth(self.frame), _currentHeaderViewHeight);
    }else{
        return CGSizeMake(0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section < self.strategys.count - 1) {
        return CGSizeMake(CGRectGetWidth(self.frame), 8);
    }else{
        return CGSizeMake(0, 0);
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionHeaderViewIdentifier forIndexPath:indexPath];
        [_headerView bindDataWithModel:_currentCoinDict];
        _headerView.delegate = self;
        return _headerView;
    }else if (kind == UICollectionElementKindSectionFooter){
        WelfareReceiveCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionFooterViewIdentifier forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.strategys.count > 0) {
        return UIEdgeInsetsMake(45, 15, 15, 15);
    }else{
        return UIEdgeInsetsZero;
    }
}

#pragma mark - ZLJCollectionViewFlowLayout
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    return  [UIColor colorWithHexString:@"#F8F8F8"];
}

- (NSString *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout titleForSectionAtIndex:(NSInteger)section{
    return self.strategys[section][kWelfareStrategySectionTitle];
}

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout titleColorForSectionAtIndex:(NSInteger)section{
    return [UIColor colorWithHexString:@"#333333"];
}

#pragma mark - WelfareReceiveCollectionHeaderViewDelegate
- (void)welfareReceiveHeaderViewDidClickConversionBtn{
    if ([self.delegate respondsToSelector:@selector(welfareReceiveSubjectViewDidClickConversionBtn)]) {
        [self.delegate welfareReceiveSubjectViewDidClickConversionBtn];
    }
}

@end
