//
//  PushKeywordSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 16/9/21.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "PushKeywordSubjectView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "PushKeywordCollectionViewCell.h"

static float const kCollectionViewCellsHorizonMargin          = 14;
static float const kCollectionViewCellHeight                  = 40;

static float const kCollectionViewToLeftMargin                = 14;
static float const kCollectionViewToTopMargin                 = 12;
static float const kCollectionViewToRightMargin               = 14;
static float const kCollectionViewToBottomtMargin             = 8;
static float const kCellBtnCenterToBorderMargin               = 25;

typedef void(^ISLimitWidth)(BOOL yesORNo, id data);

static NSString * const kCellIdentifier                 = @"CellIdentifier";

@interface PushKeywordSubjectView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UIView *historyContairView;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, readwrite, assign) CGFloat viewHeight;

@end

@implementation PushKeywordSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addCollectionView];
    }
    return self;
}


- (void)addCollectionView{
    
    if (_collectionView) [_collectionView removeFromSuperview];
    _collectionView = [self createCollectionView];
    [self addSubview:_collectionView];
    [_collectionView reloadData];
    
}

- (UICollectionView *)createCollectionView{
    CGRect collectionViewFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,0);
    
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame
                                                          collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[PushKeywordCollectionViewCell class]
       forCellWithReuseIdentifier:kCellIdentifier];
    collectionView.allowsMultipleSelection = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    collectionView.scrollsToTop = NO;
    collectionView.scrollEnabled = NO;
    
    return collectionView;
}


- (NSUInteger)firstRowCellCountWithArray:(NSArray *)array {
    CGFloat contentViewWidth = BOUNDS_WIDTH - kCollectionViewToLeftMargin - kCollectionViewToRightMargin;
    NSUInteger firstRowCellCount = 0;
    float currentCellWidthSum = 0;
    float currentCellSpace = 0;
    for (int i = 0; i < array.count; i++) {
        NSString *text = array[i];
        float cellWidth = [self collectionCellWidthText:text];
        if (cellWidth >= contentViewWidth) {
            return i == 0? 1 : firstRowCellCount;
        } else {
            currentCellWidthSum += cellWidth;
            if (i == 0) {
                firstRowCellCount++;
                continue;
            }
            currentCellSpace = (contentViewWidth - currentCellWidthSum) / firstRowCellCount;
            if (currentCellSpace <= kCollectionViewCellsHorizonMargin) {
                return firstRowCellCount;
            } else {
                firstRowCellCount++;
            }
        }
    }
    return firstRowCellCount;
}

- (float)collectionCellWidthText:(NSString *)text{
    float cellWidth;
    CGSize size = [text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:15]}];
    cellWidth = ceilf(size.width) + kCellBtnCenterToBorderMargin;
//    cellWidth = [self cellLimitWidth:cellWidth
//                         limitMargin:0
//                        isLimitWidth:nil];
    return cellWidth;
}

- (float)cellLimitWidth:(float)cellWidth
            limitMargin:(CGFloat)limitMargin
           isLimitWidth:(ISLimitWidth)isLimitWidth {
    float limitWidth = (CGRectGetWidth(self.collectionView.frame) - kCollectionViewToLeftMargin - kCollectionViewToRightMargin - limitMargin);
    if (cellWidth >= limitWidth) {
        cellWidth = limitWidth;
        isLimitWidth ? isLimitWidth(YES, @(cellWidth)) : nil;
        return cellWidth;
    }
    isLimitWidth ? isLimitWidth(NO, @(cellWidth)) : nil;
    return cellWidth;
}

- (void)filterHotHistorySource{
    NSInteger firstRowContentSums = [self firstRowCellCountWithArray:_dataHistorySource];
    if (firstRowContentSums < _dataHistorySource.count) {
        NSArray *tempArray = [_dataHistorySource subarrayWithRange:NSMakeRange(firstRowContentSums, _dataHistorySource.count-firstRowContentSums)];
        NSInteger secondRowContentSums = [self firstRowCellCountWithArray:tempArray];
        _dataHistorySource = [_dataHistorySource subarrayWithRange:NSMakeRange(0, firstRowContentSums+secondRowContentSums)];
    }
}


- (void)itemButtonClicked:(NJIndexPathButton *)button{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:button.row inSection:button.section];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}
#pragma mark - UICollectionViewDataSource Method

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.dataHistorySource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PushKeywordCollectionViewCell *cell =
    (PushKeywordCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier
                                                                           forIndexPath:indexPath];
    cell.button.frame = CGRectMake(0, 8, CGRectGetWidth(cell.frame)-3, CGRectGetHeight(cell.frame)-8);
    NSString *text = _dataHistorySource[indexPath.row];
    [cell.button setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
    [cell.button setTitle:text forState:UIControlStateNormal];
    [cell.button setTitle:text forState:UIControlStateSelected];
    [cell.button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
   
    cell.contentBtn.section = indexPath.section;
    cell.contentBtn.row = indexPath.row;
    [cell.contentBtn addTarget:self action:@selector(itemButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - 🔌 UICollectionViewDelegate Method

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_dataHistorySource];
    [tempArray removeObjectAtIndex:indexPath.row];
    [self setDataHistorySource:tempArray.mutableCopy];
    if ([self.delegate respondsToSelector:@selector(keywordSubjectView:didChangeKeywords:)]) {
        [self.delegate keywordSubjectView:self didChangeKeywords:_dataHistorySource];
    }
}

#pragma mark -  UICollectionViewDelegateLeftAlignedLayout Method

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = _dataHistorySource[indexPath.row];
    float cellWidth = [self collectionCellWidthText:text];
    return CGSizeMake(cellWidth, kCollectionViewCellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCollectionViewCellsHorizonMargin;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kCollectionViewToTopMargin, kCollectionViewToLeftMargin, kCollectionViewToBottomtMargin, kCollectionViewToRightMargin);
}


#pragma mark - setters and getters
- (void)setDataHistorySource:(NSArray *)dataHistorySource{
    _dataHistorySource = dataHistorySource;
    if ([self.delegate respondsToSelector:@selector(keywordSubjectView:didChangeKeywords:)]) {
        [self.delegate keywordSubjectView:self didChangeKeywords:_dataHistorySource];
    }
    [self.collectionView reloadData];
    __weak __typeof(self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.collectionView reloadData];
    } completion:^(BOOL finished) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf updateViewHeight];
        _viewHeight = CGRectGetMaxY(_collectionView.frame)+12;
        if ([self.delegate respondsToSelector:@selector(updateViewHeight:)]) {
            [self.delegate updateViewHeight:_viewHeight];
        }
    }];

}

- (void)updateViewHeight {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView.collectionViewLayout prepareLayout];
    //仅修改self.collectionView的高度,xyw值不变
    self.collectionView.frame = CGRectMake(CGRectGetMinX(self.collectionView.frame),
                                           CGRectGetMinY(self.collectionView.frame),
                                           CGRectGetWidth(self.collectionView.frame),
                                           self.collectionView.contentSize.height +
                                           kCollectionViewToTopMargin +
                                           kCollectionViewToBottomtMargin);
}


@end
