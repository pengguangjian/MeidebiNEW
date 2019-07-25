//
//  HistoryHotView.m
//  Meidebi
//
//  Created by mdb-admin on 16/4/11.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "HistoryHotView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "HistoryCollectionViewCell.h"
#import "HistoryCollectionFooterReusableView.h"

@interface NJHistoryCollectionView : UICollectionView

@end

@implementation NJHistoryCollectionView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    @try
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    @finally
    {
        
    }
}

@end

static float const kControllerHeaderViewHeight                = 36.f;
static float const kControllerHeaderToCollectionViewMargin    = 0;
static float const kCollectionViewCellsHorizonMargin          = 14;
static float const kCollectionViewCellHeight                  = 30;

static float const kCollectionViewToLeftMargin                = 14;
static float const kCollectionViewToTopMargin                 = 0;
static float const kCollectionViewToRightMargin               = 14;
static float const kCollectionViewToBottomtMargin             = 8;
static float const kCellBtnCenterToBorderMargin               = 19;

typedef void(^ISLimitWidth)(BOOL yesORNo, id data);

static NSString * const kCellIdentifier                 = @"CellIdentifier";
static NSString * const kFooterViewIdentifier           = @"FooterViewIdentifier";
static NSString * const kFooterViewIdentifierNO           = @"FooterViewIdentifierNO";
@interface HistoryHotView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
HistoryCollectionFooterReusableViewDelegate
>

@property (nonatomic, strong) UIView *historyContairView;
@property (nonatomic, strong) NJHistoryCollectionView  *collectionView;
@property (nonatomic, readwrite, assign) CGFloat viewHeight;
@property (nonatomic, strong) UILabel *lbtitle;
@end

@implementation HistoryHotView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.clipsToBounds = YES;
//    self.frame = CGRectZero;
    self.backgroundColor = [UIColor colorWithRed:0.9647 green:0.9647 blue:0.9647 alpha:1.0];
    UILabel *headlineLabel = ({
        UILabel *label = [UILabel new];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(12);
            make.left.equalTo(self.mas_left).offset(15);
        }];
        label.textColor = [UIColor colorWithHexString:@"#b3b3b3"];
        label.font = [UIFont systemFontOfSize:12.f];
        label;
    });
//    headlineLabel.text = @"历史搜索";
    _lbtitle = headlineLabel;
    
//    UIView *bottomLineView = [UIView new];
//    [self addSubview:bottomLineView];
//    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(self);
//        make.height.offset(1);
//    }];
//    bottomLineView.backgroundColor = [UIColor colorWithRed:0.8706 green:0.8745 blue:0.8706 alpha:1.0];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(_strtitle!=nil)
    {
        [_lbtitle setText:[NSString stringWithFormat:@"%@",_strtitle]];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    @try
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    @finally
    {
        
    }
}

- (void)addCollectionViewOfHeight:(CGFloat)height{
    
    if (_collectionView) [_collectionView removeFromSuperview];
     _collectionView = [self createCollectionViewOfHeight:height];
    [self addSubview:_collectionView];
    [_collectionView reloadData];
    __weak __typeof(self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.collectionView reloadData];
    } completion:^(BOOL finished) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf updateViewHeight];
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
    
    
    if(_isbottom)
    {
        _viewHeight = CGRectGetMaxY(self.collectionView.frame) +
        kCollectionViewToTopMargin +
        kCollectionViewToBottomtMargin;
    }
    else
    {
        _viewHeight = CGRectGetMaxY(self.collectionView.frame) +
        kCollectionViewToTopMargin;
    }
    
    if (self.callback) {
        self.callback(_viewHeight);
    }
}

- (NJHistoryCollectionView *)createCollectionViewOfHeight:(CGFloat)height{
    CGRect collectionViewFrame = CGRectMake(0, kControllerHeaderViewHeight + kControllerHeaderToCollectionViewMargin, [UIScreen mainScreen].bounds.size.width,height);
    
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    NJHistoryCollectionView *collectionView = [[NJHistoryCollectionView alloc] initWithFrame:collectionViewFrame
                                         collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[HistoryCollectionViewCell class]
        forCellWithReuseIdentifier:kCellIdentifier];
    
    [collectionView registerClass:[HistoryCollectionFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentifier];
    
     [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentifierNO];
    
    collectionView.allowsMultipleSelection = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    collectionView.scrollsToTop = NO;
    collectionView.scrollEnabled = NO;
    
    return collectionView;
}

- (NSUInteger)firstRowCellCountWithArray:(NSArray *)array {
    CGFloat contentViewWidth = CGRectGetWidth(self.collectionView.frame) - kCollectionViewToLeftMargin - kCollectionViewToRightMargin;
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
                         [UIFont systemFontOfSize:16]}];
    cellWidth = ceilf(size.width) + kCellBtnCenterToBorderMargin;
    cellWidth = [self cellLimitWidth:cellWidth
                         limitMargin:0
                        isLimitWidth:nil];
    return cellWidth;
}

- (float)cellLimitWidth:(float)cellWidth
            limitMargin:(CGFloat)limitMargin
           isLimitWidth:(ISLimitWidth)isLimitWidth {
    float limitWidth = (BOUNDS_WIDTH - kCollectionViewToLeftMargin - kCollectionViewToRightMargin - limitMargin);
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
    HistoryCollectionViewCell *cell =
    (HistoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier
                                                                           forIndexPath:indexPath];
    cell.button.frame = CGRectMake(0, 0, CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame));
    NSString *text = _dataHistorySource[indexPath.row];
    [cell.button setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
    [cell.button setTitle:text forState:UIControlStateNormal];
    [cell.button setTitle:text forState:UIControlStateSelected];
    [cell.button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [cell.button addTarget:self action:@selector(itemButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    cell.button.section = indexPath.section;
    cell.button.row = indexPath.row;
    return cell;
}

#pragma mark - 🔌 UICollectionViewDelegate Method

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(historyHotView:didPressSimpleHistoryStr:)]) {
        [self.delegate historyHotView:self didPressSimpleHistoryStr:_dataHistorySource[indexPath.row]];
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if(_isbottom)
    {
        return CGSizeMake(50, 70);
    }
    else
    {
        return CGSizeMake(50, 1);
    }
}


//自定义标题头或标题尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //标题头
    if(_isbottom)
    {
        if (kind == UICollectionElementKindSectionFooter) {
            HistoryCollectionFooterReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kFooterViewIdentifier forIndexPath:indexPath];
            view.backgroundColor = [UIColor whiteColor];
            view.delegate = self;
            return view;
        }
    }
    else
    {
        if (kind == UICollectionElementKindSectionFooter) {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kFooterViewIdentifierNO forIndexPath:indexPath];
            view.backgroundColor = [UIColor whiteColor];
            return view;
        }
        
    }
    return nil;
}

#pragma mark - HistoryCollectionFooterReusableViewDelegate
- (void)deleteHistory{
    if ([self.delegate respondsToSelector:@selector(historyHotViewDidPressDeleateBtn)]) {
        [self.delegate historyHotViewDidPressDeleateBtn];
    }
}


#pragma mark - setters and getters
- (void)setDataHistorySource:(NSArray *)dataHistorySource{
    _dataHistorySource = dataHistorySource;
//    [self filterHotHistorySource];
    CGFloat collectionViewHeight = 0.00;
    if (_dataHistorySource.count <= 0) {
        _viewHeight = collectionViewHeight;
        return;
    }
//    if ([self firstRowCellCountWithArray:_dataHistorySource] < _dataHistorySource.count) {
//        collectionViewHeight = 88.0+42/*footer height*/;
//    }else{
//        collectionViewHeight = 44.0+42/*footer height*/;
//    }
    [self addCollectionViewOfHeight:collectionViewHeight];
    [self layoutIfNeeded];
}


@end
