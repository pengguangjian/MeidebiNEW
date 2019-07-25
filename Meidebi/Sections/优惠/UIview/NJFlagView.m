//
//  NJFlagView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/23.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "NJFlagView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "NJFlagItemCollectionViewCell.h"
#import "UIColor+Hex.h"

@interface ZlJTagCollectionView : UICollectionView
@end

@implementation ZlJTagCollectionView

@end

static float const kControllerHeaderViewHeight                = 20.f;
static float const kControllerHeaderToCollectionViewMargin    = 10;
static float const kCollectionViewCellsHorizonMargin          = 14;
static float const kCollectionViewCellHeight                  = 30;
static float const kCollectionViewToLeftMargin                = 16;
static float const kCollectionViewToTopMargin                 = 0;
static float const kCollectionViewToBottomtMargin             = 8;
static float const kCellBtnCenterToBorderMargin               = 19;
static NSString * const kCellIdentifier                 = @"CellIdentifier";

@interface NJFlagView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ZlJTagCollectionView *collectionView;
@property (nonatomic, readwrite, assign) CGFloat viewHeight;
@property (nonatomic, strong) NSArray *flags;
@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation NJFlagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews{
    _titleLabel.frame = CGRectMake(16, 0, CGRectGetWidth(self.bounds)-32, 14.f);
    [super layoutSubviews];
}

- (void)setupSubviews{
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:12.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#959595"];
    titleLabel.text = @"相关标签";
    titleLabel.hidden = YES;
    _titleLabel = titleLabel;
    
}

- (void)addCollectionView{
    
    if (_collectionView) [_collectionView removeFromSuperview];
    _collectionView = [self createCollectionView];
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
    
    _viewHeight = CGRectGetMaxY(self.collectionView.frame) + kCollectionViewToTopMargin + kCollectionViewToBottomtMargin;
    if (self.callback) {
        self.callback(_viewHeight);
    }    
}

- (ZlJTagCollectionView *)createCollectionView{
    CGRect collectionViewFrame = CGRectMake(kCollectionViewToLeftMargin, _titleType == FlagTitleTypeNoTitle ? 0:kControllerHeaderViewHeight + kControllerHeaderToCollectionViewMargin, [UIScreen mainScreen].bounds.size.width-kCollectionViewToLeftMargin*2,[UIScreen mainScreen].bounds.size.height);
    
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    ZlJTagCollectionView *collectionView = [[ZlJTagCollectionView alloc] initWithFrame:collectionViewFrame
                                                                        collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = self.backgroundColor;
    [collectionView registerClass:[NJFlagItemCollectionViewCell class]
       forCellWithReuseIdentifier:kCellIdentifier];
    collectionView.allowsMultipleSelection = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 0);
    collectionView.scrollsToTop = NO;
    collectionView.scrollEnabled = NO;
    
    return collectionView;
}

- (void)flag:(NSArray *)flags{
    _flags = flags;
    if (_flags.count <= 0) {
        _viewHeight = 0.00;
        if (self.callback) {
            self.callback(_viewHeight);
        }
        return;
    }
    _titleLabel.hidden = NO;
    [self addCollectionView];
//    [self layoutIfNeeded];
}

- (float)collectionCellWidthText:(NSString *)text{
    float cellWidth;
    if(text==nil || ![text isKindOfClass:[NSString class]])
    {
        text = @"";
    }
    CGSize size = [text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:12]}];
    cellWidth = ceilf(size.width) + kCellBtnCenterToBorderMargin;
    return cellWidth;
}
//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    for (NJFlagItemCollectionViewCell *cell in self.cells) {
//        CGPoint cellPoint = [self convertPoint:point toView:cell];
//        if ([cell pointInside:cellPoint withEvent:event]) {
//            return cell;
//        }
//    }
//    
////    return self.superview;
//    
//        //如果希望严谨一点，可以将上面if语句及里面代码替换成如下代码
//    //UIView *view = [_redButton hitTest: redBtnPoint withEvent: event];
//    //if (view) return view;
//    return self.superview;
//    
//}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.flags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NJFlagItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    [cell bindFlagItemData:self.flags[indexPath.row]];
    if (![self.cells containsObject:cell]) {
        [self.cells addObject:cell];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(flageViewDidClickItem:type:)]) {
        FlagType type;
        if([self.flags[indexPath.row][@"type"] isEqualToString:@"2"]){
            type = FlagTypeSite;
        }else if ([self.flags[indexPath.row][@"type"] isEqualToString:@"3"]){
            type = FlagTypeCategory;
        }else{
            type = FlagTypeNormal;
        }
        [self.delegate flageViewDidClickItem:self.flags[indexPath.row] type:type];
    }
}

#pragma mark -  UICollectionViewDelegateLeftAlignedLayout Method

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.flags.count <= 0) return CGSizeMake(0, 0);
    NSString *text = @"";
    @try
    {
       text = self.flags[indexPath.row][@"name"];
    }
    @catch (NSException *exc)
    {
        text = @"";
    }
    @finally
    {
        
    }
    
    float cellWidth = [self collectionCellWidthText:text];
    return CGSizeMake(cellWidth, kCollectionViewCellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCollectionViewCellsHorizonMargin;
}

- (float)checkCellLimitWidth:(float)cellWidth {
    float limitWidth = (self.collectionView.contentSize.width - kCollectionViewToLeftMargin);
    if (cellWidth >= limitWidth) {
        cellWidth = limitWidth - kCollectionViewCellsHorizonMargin;
        return cellWidth;
    }
    return cellWidth + 16 ;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - setters and getters

- (void)setFlagTitleName:(NSString *)flagTitleName{
    _flagTitleName = flagTitleName;
    _titleLabel.text = flagTitleName;
}

- (void)setFlagTitleFont:(UIFont *)flagTitleFont{
    _flagTitleFont = flagTitleFont;
    _titleLabel.font = _flagTitleFont;
}

- (void)setFlagTitleColor:(UIColor *)flagTitleColor{
    _flagTitleColor = flagTitleColor;
    _titleLabel.textColor = _flagTitleColor;
}

- (void)setTitleType:(FlagTitleType)titleType{
    _titleType = titleType;
    if (_titleType == FlagTitleTypeCustom) {
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }else if (_titleType == FlagTitleTypeNoTitle){
        _titleLabel.hidden = YES;
        _titleLabel.text = nil;
        _titleLabel.frame = CGRectZero;
    }
}

- (NSMutableArray *)cells{
    if (!_cells) {
        _cells = [NSMutableArray array];
    }
    return _cells;
}

@end
