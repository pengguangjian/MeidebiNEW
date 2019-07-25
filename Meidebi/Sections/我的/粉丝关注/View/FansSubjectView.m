//
//  FansSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "FansSubjectView.h"
#import "ContactTableViewCell.h"

static NSString * const kFansTableViewCellIdentifier = @"cell";

@interface FansSubjectView ()
<
ContactTableViewCellDelegate,
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *fansList;
@end

@implementation FansSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
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
    [_tableView registerClass:[ContactTableViewCell class] forCellReuseIdentifier:kFansTableViewCellIdentifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.tableFooterView = [UIView new];
}

- (void)bindDataWithModel:(NSArray *)models{
    if (models.count <= 0) return;
    _fansList = models;
    [_tableView reloadData];
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fansList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFansTableViewCellIdentifier];
    cell.type = ContactTypeFans;
    [cell bindDataWithModel:_fansList[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

#pragma mark - ContactTableViewCellDelegate
- (void)contactTableViewDidClickFollowBtnWithCell:(ContactTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ContactViewModel *model = _fansList[indexPath.row];
    if (!model.isDirection) {
        if ([self.delegate respondsToSelector:@selector(fansSubjectViewDidClickAddFollowWithFollowID:didComplete:)]) {
            [self.delegate fansSubjectViewDidClickAddFollowWithFollowID:model.uID didComplete:^{
                [model updateDirectionStatus];
                NSMutableArray *tempModels = [NSMutableArray arrayWithArray:_fansList];
                [tempModels replaceObjectAtIndex:indexPath.row withObject:model];
                _fansList = tempModels.mutableCopy;
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
    }
}

- (void)avatarImageViewClickedWithCell:(ContactTableViewCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(imageViewClickedWithUserId:)]) {
        [self.delegate imageViewClickedWithUserId:[_fansList[indexPath.row] uID]];
    }
}
@end
