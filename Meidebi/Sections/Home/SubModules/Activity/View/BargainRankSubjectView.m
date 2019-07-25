//
//  BargainRankSubjectView.m
//  Meidebi
//
//  Created by leecool on 2017/10/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BargainRankSubjectView.h"
#import "BargainRankTableViewCell.h"
#import "MDBEmptyView.h"
static NSString * const kTableViewCellIdentifier = @"cell";
@interface BargainRankSubjectView ()
<
UITableViewDelegate,
UITableViewDataSource,
BargainRankTableViewCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@property (nonatomic, strong) NSArray *ranks;
@end

@implementation BargainRankSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UILabel *remindTitleLabel = [UILabel new];
    [self addSubview:remindTitleLabel];
    [remindTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(self.mas_top).offset(17);
    }];
    remindTitleLabel.text = @"温馨提示：";
    remindTitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    remindTitleLabel.font = [UIFont systemFontOfSize:12.f];
    [remindTitleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    UILabel *remindLabel = [UILabel new];
    [self addSubview:remindLabel];
    [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remindTitleLabel.mas_right);
        make.top.equalTo(self.mas_top).offset(17);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    remindLabel.numberOfLines = 0;
    remindLabel.text = @"温馨提示：排名按照助砍次数降序排列，相同助砍次数按时间先 后排序~";
    remindLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    remindLabel.font = [UIFont systemFontOfSize:12.f];
    [remindLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    _tableView = [UITableView new];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remindLabel.mas_bottom).offset(17);
        make.left.right.bottom.equalTo(self);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [_tableView registerClass:[BargainRankTableViewCell class]
       forCellReuseIdentifier:kTableViewCellIdentifier];
    _tableView.tableFooterView = [UIView new];
    
}

- (void)bindDataWithModel:(NSArray *)model{
    if (model.count > 0) {
        self.emptyView.hidden = YES;
        _ranks = model;
        [_tableView reloadData];
    }else{
        self.emptyView.hidden = NO;
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _ranks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BargainRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell bindDataWithModel:_ranks[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}

#pragma mark - BargainRankTableViewCellDelegate
- (void)tableViewCellDidCickAvaterViewWithCell:(BargainRankTableViewCell *)cell{
    NSIndexPath *indePath = [self.tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickAvaterViewWithUserid:)]) {
        [self.delegate detailSubjectViewDidCickAvaterViewWithUserid:[NSString nullToString:_ranks[indePath.row][@"user_id"]]];
    }
}
#pragma mark - getters and setters
- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH-kTopHeight)];
        _emptyView.remindStr = @"暂时没有数据哦~";
        [_tableView addSubview:_emptyView];
    }
    return _emptyView;
}
@end
