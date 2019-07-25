//
//  ZLStairMenuView.m
//  FilterWares
//
//  Created by mdb-admin on 2016/11/15.
//  Copyright © 2016年 losaic. All rights reserved.
//

#import "ZLStairMenuView.h"
#import "ZLMenuItem.h"
#import "MDB_UserDefault.h"
@interface ZLStairMenuView ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *stairTableView;
@property (nonatomic, strong) NSArray *stairMenuItems;

@end

@implementation ZLStairMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)initializationConstValues{
    _lastSelectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)setupSubviews{
    [self addSubview:self.stairTableView];
}

- (void)layoutSubviews{
    self.stairTableView.frame = self.bounds;
}

- (void)bindMenuViewData:(NSArray *)items{
    self.stairMenuItems = items;
}

- (void)updateSelectRow{
    NSDictionary *pathDict = [MDB_UserDefault lastSelectMenuPaths];
    NSArray *keys = pathDict.allKeys;
    NSString *currentSection = [NSString stringWithFormat:@"%@",@(_currentLocationIndexPath.section)];
    if (keys.count > 0) {
        if ([keys containsObject:currentSection]) {
            NSInteger row = [pathDict[currentSection] integerValue];
            _lastSelectIndexPath = [NSIndexPath indexPathForRow:row inSection:_currentLocationIndexPath.section];
            if (_lastSelectIndexPath.row >5 || !_lastSelectIndexPath) {
                [self initializationConstValues];
            }
        }else{
            [self initializationConstValues];
        }
    }else{
        [self initializationConstValues];
    }
    
    [self.stairTableView selectRowAtIndexPath:_lastSelectIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    [self.stairTableView cellForRowAtIndexPath:_lastSelectIndexPath].textLabel.textColor = [UIColor colorWithHexString:@"#FD7A0F"];
    if ([self.delegate respondsToSelector:@selector(stairMenuView:didSelectIndexPath:)]) {
        [self.delegate stairMenuView:self didSelectIndexPath:_lastSelectIndexPath];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _stairMenuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [cell setSelectedBackgroundView:bgColorView];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12.f];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [NSString nullToString:[self.stairMenuItems[indexPath.row] menuItemName]];
 
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentLocationIndexPath.section == _lastSelectIndexPath.section && indexPath.row == _lastSelectIndexPath.row) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#FD7A0F"];
        cell.selected = YES;
    }

    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTableDefaultRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *paths = [NSMutableDictionary dictionaryWithDictionary:[MDB_UserDefault lastSelectMenuPaths]];
    [paths setValue:@(indexPath.row) forKey:[NSString stringWithFormat:@"%@",@(_currentLocationIndexPath.section)]];
    [MDB_UserDefault setLastSelectMenuPath:paths.mutableCopy];
    
    [tableView cellForRowAtIndexPath:indexPath].textLabel.textColor = [UIColor colorWithHexString:@"#FD7A0F"];
    if ([self.delegate respondsToSelector:@selector(stairMenuView:didSelectIndexPath:)]) {
        [self.delegate stairMenuView:self didSelectIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
}

#pragma mark - setters and getters
- (UITableView *)stairTableView{
    if (!_stairTableView) {
        _stairTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                       style:UITableViewStylePlain];
        _stairTableView.delegate = self;
        _stairTableView.dataSource = self;
        [_stairTableView registerClass:[UITableViewCell class]
                forCellReuseIdentifier:@"cell"];
        _stairTableView.tableFooterView = [UIView new];
        _stairTableView.showsVerticalScrollIndicator = NO;
        _stairTableView.scrollEnabled = NO;
        _stairTableView.separatorColor = [UIColor colorWithHexString:@"#DBDBDB"];
    }
    return _stairTableView;
}

- (void)setStairMenuItems:(NSArray *)stairMenuItems{
    _stairMenuItems = stairMenuItems;
    [self.stairTableView reloadData];
    [self updateSelectRow];
}

@end
