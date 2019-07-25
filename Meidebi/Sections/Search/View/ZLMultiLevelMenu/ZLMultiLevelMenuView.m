//
//  ZLMultiLevelMenuView.m
//  FilterWares
//
//  Created by mdb-admin on 2016/11/15.
//  Copyright © 2016年 losaic. All rights reserved.
//

#import "ZLMultiLevelMenuView.h"
#import "ZLStairMenuView.h"
#import "ZLJuniorMenuView.h"
#import "ZLMultiLevelMenuTableViewCell.h"
#import "MDB_UserDefault.h"
NSString * const kCellIdentifier = @"kCellIdentifier";
NSInteger const kTableStandardRowZoom = 8;

@interface ZLMultiLevelMenuView ()
<
UITableViewDelegate,
UITableViewDataSource,
ZLMultiLevelMenuTableViewCellDelegate
>
@property (nonatomic, strong) UITableView *topLevelTableView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) NSInteger selctSection;
@property (nonatomic, assign) NSInteger tableSections;
@property (nonatomic, strong) NSArray *headerViewContents;
@property (nonatomic, strong) NSString *moreTitleStr;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, strong) ZLMultiLevelMenuViewModel *menuViewModel;
@end

@implementation ZLMultiLevelMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initVariable];
        [self setupSubViews];
    }
    return self;
}

- (void)initVariable{
    _isOpen = NO;
    _moreTitleStr = @"展开更多分类";
    _rotation = 0.00;
}

- (void)setupSubViews{
    [self addSubview:self.topLevelTableView];
}

- (void)layoutSubviews{
    [self.topLevelTableView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}

- (void)dealloc{
    [MDB_UserDefault setLastSelectMenuPath:@{}];
    [MDB_UserDefault setFilterProductTypes:nil];
}

- (void)expansionMoreType:(id)sender{
    _isOpen = !_isOpen;
    if (_isOpen) {
        _moreTitleStr = @"收起更多分类";
        _rotation = M_PI;
    }else{
        _moreTitleStr = @"展开更多分类";
        _rotation = 0.00;
    }
    _selctSection = [(UIControl *)sender tag];
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:_selctSection];
    [self.topLevelTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"lessMoreTypeNotification" object:nil];
}

- (void)bindDataWithViewModel:(ZLMultiLevelMenuViewModel *)viewModel{
    _menuViewModel = viewModel;
    _tableSections = _menuViewModel.tableSections;
    [self.topLevelTableView reloadData];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tableSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZLMultiLevelMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.currentIndexPath = indexPath;
    cell.menuItems = _menuViewModel.tableContents[indexPath.section];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 35)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
   
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(headerView.frame)-0.7, CGRectGetWidth(headerView.frame), 0.7)];
    [headerView addSubview:bottomLine];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#DBDBDB"];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, CGRectGetMidY(headerView.frame)-6, 13, 12)];
    [headerView addSubview:iconImageView];
    iconImageView.image = self.headerViewContents[section][@"image"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+4, CGRectGetMinY(iconImageView.frame), CGRectGetWidth(headerView.frame)-40, 12)];
    [headerView addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    titleLabel.font = [UIFont systemFontOfSize:12.f];
    titleLabel.text = self.headerViewContents[section][@"name"];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([_menuViewModel.tableContents[section] count] >kTableStandardRowZoom) {
        return 35;
    }
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([_menuViewModel.tableContents[section] count] >kTableStandardRowZoom) {
        UIControl *footerControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 35)];
        footerControl.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
        [footerControl addTarget:self
                          action:@selector(expansionMoreType:)
                forControlEvents:UIControlEventTouchUpInside];
        [footerControl setTag:section];

        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(footerControl.frame)-1, CGRectGetWidth(footerControl.frame), 0.7)];
        [footerControl addSubview:bottomLine];
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(footerControl.frame), 0.7)];
        [footerControl addSubview:topLine];
        topLine.backgroundColor = bottomLine.backgroundColor;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 77, 12)];
        [footerControl addSubview:titleLabel];
        titleLabel.center = footerControl.center;
        titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        titleLabel.font = [UIFont systemFontOfSize:12.f];
        titleLabel.text = _moreTitleStr;
        
        UIImageView *handleFlagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), CGRectGetMidY(titleLabel.frame)-3, 10, 6)];
        handleFlagImageView.image = [UIImage imageNamed:@"icon_open_list"];
        [footerControl addSubview:handleFlagImageView];
        handleFlagImageView.transform = CGAffineTransformMakeRotation(_rotation);
        
        return footerControl;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isOpen && _selctSection ==indexPath.section) {
        return [_menuViewModel.tableContents[indexPath.section] count]*kTableDefaultRowHeight-1/*1 hide separator color*/;
    }else{
        if ([_menuViewModel.tableContents[indexPath.section] count] >kTableStandardRowZoom) {
            return kTableStandardRowZoom*kTableDefaultRowHeight-1/*1 hide separator color*/;
        }else{
            NSInteger residue = [[_menuViewModel.tableContents[indexPath.section] firstObject] menuSubItems].count%3;
            return ((([[_menuViewModel.tableContents[indexPath.section] firstObject] menuSubItems].count/3) + (residue>0?1:0))*((CGRectGetWidth(self.bounds)-CGRectGetWidth(self.bounds)*0.3)/3))+24;
        }
    }
}

#pragma mark - ZLMultiLevelMenuTableViewCellDelegate
- (void)menuTableViewCellDidSelectItems:(NSArray *)items{
    if ([self.delegate respondsToSelector:@selector(multiLevelMenuView:didSeleteTypes:)]) {
        [self.delegate multiLevelMenuView:self didSeleteTypes:items];
    }
}

#pragma mark - setters and getters
- (UITableView *)topLevelTableView{
    if (!_topLevelTableView) {
        _topLevelTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStyleGrouped];
        _topLevelTableView.delegate = self;
        _topLevelTableView.dataSource = self;
        [_topLevelTableView registerClass:[ZLMultiLevelMenuTableViewCell class]
                   forCellReuseIdentifier:kCellIdentifier];
        _topLevelTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _topLevelTableView.backgroundColor = [UIColor clearColor];
    }
    return _topLevelTableView;
}

- (NSArray *)headerViewContents{
    if (!_headerViewContents) {
        _headerViewContents = @[@{@"image":[UIImage imageNamed:@"waresType"],
                                  @"name":@"商城分类"},
                                @{@"image":[UIImage imageNamed:@"hotSite"],
                                  @"name":@"热门商城"}];
    }
    return _headerViewContents;
}

@end
