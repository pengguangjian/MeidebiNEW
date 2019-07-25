//
//  ZLJCollectionViewFlowLayout.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ZLJCollectionViewFlowLayout.h"

static NSString *const ZLJCollectionViewSectionColorAndTitle = @"com.ulb.ZLJCollectionElementKindSectionColorAndTitle";

@interface ZLJCollectionViewLayoutAttributes  : UICollectionViewLayoutAttributes
// 背景色
@property (nonatomic, strong) UIColor *backgroudColor;
// title
@property (nonatomic, strong) NSString *titleStr;
// title color
@property (nonatomic, strong) UIColor *titleTextColor;

@end
@implementation ZLJCollectionViewLayoutAttributes
@end

@interface ZLJCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *sectionTitlLabel;

@end


@implementation ZLJCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    ZLJCollectionViewLayoutAttributes *attr = (ZLJCollectionViewLayoutAttributes *)layoutAttributes;
    self.backgroundColor = attr.backgroudColor;
    self.sectionTitlLabel.text = attr.titleStr;
    self.sectionTitlLabel.textColor = attr.titleTextColor;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _sectionTitlLabel = [UILabel new];
    [self addSubview:_sectionTitlLabel];
    _sectionTitlLabel.frame = CGRectMake(14, 16, CGRectGetWidth([UIScreen mainScreen].bounds)-24, 14);
    _sectionTitlLabel.backgroundColor = [UIColor clearColor];
    _sectionTitlLabel.font = [UIFont systemFontOfSize:14.f];
}

@end



@interface ZLJCollectionViewFlowLayout  ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewAttrs;

@end


@implementation ZLJCollectionViewFlowLayout

- (void)prepareLayout{
    [super prepareLayout];
    NSInteger sections = [self.collectionView numberOfSections];
    id<ZLJCollectionViewFlowLayout> delegate = (id<ZLJCollectionViewFlowLayout>)self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:layout:colorForSectionAtIndex:)]) {
    }else{
        return ;
    }
    [self registerClass:[ZLJCollectionReusableView class] forDecorationViewOfKind:ZLJCollectionViewSectionColorAndTitle];
    [self.decorationViewAttrs removeAllObjects];
    for (NSInteger section =0; section < sections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        if (numberOfItems > 0) {
            UICollectionViewLayoutAttributes *firstAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            UICollectionViewLayoutAttributes *lastAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:(numberOfItems - 1) inSection:section]];
            
            UIEdgeInsets sectionInset = self.sectionInset;
            if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                UIEdgeInsets inset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
                if (!UIEdgeInsetsEqualToEdgeInsets(inset, sectionInset)) {
                    sectionInset = inset;
                }
            }
            
            
            CGRect sectionFrame = CGRectUnion(firstAttr.frame, lastAttr.frame);
            sectionFrame.origin.x -= sectionInset.left;
            sectionFrame.origin.y -= sectionInset.top;
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                sectionFrame.size.width += sectionInset.left + sectionInset.right;
                sectionFrame.size.height = self.collectionView.frame.size.height;
            }else{
                sectionFrame.size.width = self.collectionView.frame.size.width;
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom;
            }
            
            //自定义
            ZLJCollectionViewLayoutAttributes *attr = [ZLJCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:ZLJCollectionViewSectionColorAndTitle withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attr.frame = sectionFrame;
            attr.zIndex = -1;
            attr.backgroudColor = [delegate collectionView:self.collectionView layout:self colorForSectionAtIndex:section];
            attr.titleStr = [delegate collectionView:self.collectionView layout:self titleForSectionAtIndex:section];
            attr.titleTextColor = [delegate collectionView:self.collectionView layout:self titleColorForSectionAtIndex:section];
            [self.decorationViewAttrs addObject:attr];
        }else{
            continue ;
        }
    }
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray * attrs = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for (UICollectionViewLayoutAttributes *attr in self.decorationViewAttrs) {
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
    }
    return [attrs copy];
}

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)decorationViewAttrs{
    if (!_decorationViewAttrs) {
        _decorationViewAttrs = [NSMutableArray array];
    }
    return _decorationViewAttrs;
}

@end
