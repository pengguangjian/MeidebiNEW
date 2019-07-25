//
//  ZLMultiLevelMenuTableViewCell.m
//  FilterWares
//
//  Created by mdb-admin on 2016/11/15.
//  Copyright © 2016年 losaic. All rights reserved.
//

#import "ZLMultiLevelMenuTableViewCell.h"
#import "ZLStairMenuView.h"
#import "ZLJuniorMenuView.h"
#import "ZLMenuItem.h"
@interface ZLMultiLevelMenuTableViewCell ()
<
ZLJuniorMenuViewDelegate,
ZLStairMenuViewDelegate
>
@property (nonatomic, strong) ZLStairMenuView *stairMenuView;
@property (nonatomic, strong) ZLJuniorMenuView *juniorMenuView;

@end

@implementation ZLMultiLevelMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
- (void)layoutSubviews{
    _stairMenuView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds)*0.3, CGRectGetHeight(self.bounds));
    _juniorMenuView.frame = CGRectMake(CGRectGetMaxX(_stairMenuView.frame), 0, CGRectGetWidth(self.bounds)-CGRectGetWidth(_stairMenuView.frame), CGRectGetHeight(_stairMenuView.frame));
}
- (void)setupSubViews{
    [self addSubview:self.stairMenuView];
    [self addSubview:self.juniorMenuView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - ZLJuniorMenuViewDelegate
- (void)juniorMenuView:(ZLJuniorMenuView *)menuView didSelectTypes:(NSArray *)types{
    if ([self.delegate respondsToSelector:@selector(menuTableViewCellDidSelectItems:)]) {
        [self.delegate menuTableViewCellDidSelectItems:types];
    }
}

#pragma mark - ZLStairMenuViewDelegate
- (void)stairMenuView:(ZLStairMenuView *)menuView didSelectIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row>=_menuItems.count || _menuItems.count==0)
    {
        return;
    }
    [_juniorMenuView reloadData:[_menuItems[indexPath.row] menuSubItems]
             stairMenuIndexPath:indexPath
            currentLocationPath:_currentIndexPath];
}

#pragma mark - setters and getters
- (ZLStairMenuView *)stairMenuView{
    if (!_stairMenuView) {
        _stairMenuView = [[ZLStairMenuView alloc] init];
        _stairMenuView.backgroundColor = [UIColor whiteColor];
        _stairMenuView.defaultSelected = YES;
        _stairMenuView.delegate = self;
    }
    return _stairMenuView;
}

- (ZLJuniorMenuView *)juniorMenuView{
    if (!_juniorMenuView) {
        _juniorMenuView = [[ZLJuniorMenuView alloc] init];
        _juniorMenuView.backgroundColor = [UIColor whiteColor];
        _juniorMenuView.delegate = self;
    }
    return _juniorMenuView;
}

- (void)setMenuItems:(NSArray *)menuItems{
    _menuItems = menuItems;
    _stairMenuView.currentLocationIndexPath = _currentIndexPath;
    [_stairMenuView bindMenuViewData:_menuItems];
}
@end
