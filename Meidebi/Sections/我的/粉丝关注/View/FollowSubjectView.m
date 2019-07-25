//
//  FollowSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "FollowSubjectView.h"
#import "ContactTableViewCell.h"

static NSString * const kTableViewCellIdentifier = @"cell";

@interface FollowSubjectView ()
<
ContactTableViewCellDelegate,
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *followList;
@property (nonatomic, strong) NSIndexPath *clickIndexPath;
@property (nonatomic, strong) ContactViewModel *selectModel;
@end

@implementation FollowSubjectView

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
    [_tableView registerClass:[ContactTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.tableFooterView = [UIView new];
}

- (void)bindDataWithModel:(NSArray *)models{
    if (models.count <= 0) return;
    _followList = models;
    [_tableView reloadData];
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _followList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    cell.type = ContactTypeFollow;
    [cell bindDataWithModel:_followList[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(followSubjectViewDidClickCancelFollowWithFollowID:didComplete:)]) {
            [self.delegate followSubjectViewDidClickCancelFollowWithFollowID:_selectModel.attentionID
                                                                 didComplete:^{
                [self refreshTableViewWithModel:_selectModel indexPath:_clickIndexPath];
            }];
        }
    }
}

#pragma mark - ContactTableViewCellDelegate
- (void)contactTableViewDidClickFollowBtnWithCell:(ContactTableViewCell *)cell{
    _clickIndexPath = [self.tableView indexPathForCell:cell];
    _selectModel = _followList[_clickIndexPath.row];
    if (_selectModel.isFollow) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定不再关注此人？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        if ([self.delegate respondsToSelector:@selector(followSubjectViewDidClickAddFollowWithFollowID:didComplete:)]) {
            [self.delegate followSubjectViewDidClickAddFollowWithFollowID:_selectModel.attentionID
                                                              didComplete:^{
                [self refreshTableViewWithModel:_selectModel indexPath:_clickIndexPath];
            }];
        }
    }
}

- (void)avatarImageViewClickedWithCell:(ContactTableViewCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(imageViewClickedWithUserId:)]) {
        [self.delegate imageViewClickedWithUserId:[_followList[indexPath.row] attentionID]];
    }
}


- (void)refreshTableViewWithModel:(ContactViewModel *)model indexPath:(NSIndexPath *)path{
    [model updateFollowStatus];
    NSMutableArray *tempModels = [NSMutableArray arrayWithArray:_followList];
    [tempModels replaceObjectAtIndex:path.row withObject:model];
    _followList = tempModels.mutableCopy;
    [_tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

@end
