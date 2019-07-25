//
//  RewardCommentView.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/5.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RewardCommentView.h"
#import "RewardCommentTableViewCell.h"

static NSString * const kTableViewCellIdentifier = @"cell";
@interface RewardCommentView ()
<
UITableViewDelegate,
UITableViewDataSource,
RewardCommentTableViewCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat tableViewRowHeight;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSMutableArray *selctedCells;
@end

@implementation RewardCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _tableView = [UITableView new];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[RewardCommentTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
}

- (void)bindDataWithComments:(NSArray *)comments{
    if (comments.count <= 0) return;
     _comments = comments;
    [self.selctedCells addObject:@(0)];
    [_tableView reloadData];
    if (_didSelctComment) {
        _didSelctComment(_comments.firstObject);
    }
}

- (void)updateDataWithcomments:(NSArray *)comments{
    if (comments.count <= 0) return;
    _comments = comments;
    [self.selctedCells replaceObjectAtIndex:0 withObject:@(_comments.count-1)];
    [_tableView reloadData];
    if (_didSelctComment) {
        _didSelctComment(_comments.lastObject);
    }
}
#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RewardCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    cell.delegate = self;
    if ([self.selctedCells containsObject:@(indexPath.row)]) {
        [cell bindDataWithModel:_comments[indexPath.row] withRowSelect:YES];
    }else{
        [cell bindDataWithModel:_comments[indexPath.row] withRowSelect:NO];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableViewRowHeight;
}

#pragma mark - RewardCommentTableViewCellDelegate
- (void)commentButtonDidClickWithTableViewCell:(RewardCommentTableViewCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSString *selctStr = @"";
    if ([self.selctedCells containsObject:@(indexPath.row)]) {
        [self.selctedCells removeObject:@(indexPath.row)];
    }else{
        if (self.selctedCells.count>0) {
            [self.selctedCells replaceObjectAtIndex:0 withObject:@(indexPath.row)];
        }else{
            [self.selctedCells addObject:@(indexPath.row)];
        }
        selctStr = _comments[indexPath.row];
    }
    [_tableView reloadData];
    if (_didSelctComment) {
        _didSelctComment(selctStr);
    }
    
}


#pragma mark - setters and getters
- (CGFloat)tableViewRowHeight{
    if (!_tableViewRowHeight) {
        _tableViewRowHeight = 43;
    }
    return _tableViewRowHeight;
}

- (NSMutableArray *)selctedCells{
    if (!_selctedCells) {
        _selctedCells = [NSMutableArray array];
    }
    return _selctedCells;
}

@end
