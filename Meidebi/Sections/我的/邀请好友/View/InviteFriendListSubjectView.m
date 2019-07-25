//
//  InviteFriendListSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "InviteFriendListSubjectView.h"
#import "InviteFriendListTableViewCell.h"

#import "MDBEmptyView.h"

static NSString * const kTableViewCellIdentifier = @"cell";
@interface InviteFriendListSubjectView ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, assign) NSInteger clickNumber;

@property (nonatomic , retain)MDBEmptyView *emptyView;

@end

@implementation InviteFriendListSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _clickNumber = 1;
        [self setupSubviews];
        
        [self emptyView];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:[self setupTableHeadeToolBarView]];
    _tableView = [UITableView new];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(56, 0, 0, 0));
    }];
    [_tableView registerClass:[InviteFriendListTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
}

- (UIView *)setupTableHeadeToolBarView{
    UIView *toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 56.f)];
    toolBarView.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    
    UIControl *timeControl = [UIControl new];
    [toolBarView addSubview:timeControl];
    [timeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(toolBarView);
        make.width.equalTo(toolBarView.mas_width).multipliedBy(0.333);
    }];
    [timeControl addTarget:self action:@selector(handleHightLightContol:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [UILabel new];
    [timeControl addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(timeControl);
    }];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"时间";
    label.textColor = [UIColor colorWithHexString:@"#666666"];
    label.font = [UIFont systemFontOfSize:14.f];
    
    UIImageView *priceRiseImageView = [UIImageView new];
    [timeControl addSubview:priceRiseImageView];
    [priceRiseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(2);
        make.bottom.equalTo(label.mas_centerY).offset(-1);
        make.size.mas_equalTo(CGSizeMake(7, 5));
    }];
    priceRiseImageView.tag = 10001;
    priceRiseImageView.contentMode = UIViewContentModeScaleAspectFit;
    priceRiseImageView.image = [UIImage imageNamed:@"shengxu_hightlighted"];
    
    UIImageView *priceDeclineImageView = [UIImageView new];
    [timeControl addSubview:priceDeclineImageView];
    [priceDeclineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(2);
        make.top.equalTo(label.mas_centerY).offset(1);
        make.size.mas_equalTo(CGSizeMake(7, 5));
    }];
    priceDeclineImageView.tag = 10002;
    priceDeclineImageView.contentMode = UIViewContentModeScaleAspectFit;
    priceDeclineImageView.image = [UIImage imageNamed:@"jiangxu_default"];
    
    UILabel *fridentLabel = [UILabel new];
    [toolBarView addSubview:fridentLabel];
    [fridentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(toolBarView);
    }];
    fridentLabel.textAlignment = NSTextAlignmentCenter;
    fridentLabel.text = @"好友";
    fridentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    fridentLabel.font = [UIFont systemFontOfSize:14.f];

    UILabel *statusLabel = [UILabel new];
    [toolBarView addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(toolBarView);
        make.width.equalTo(toolBarView.mas_width).multipliedBy(0.333);
    }];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.text = @"状态";
    statusLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    statusLabel.font = [UIFont systemFontOfSize:14.f];
    
    return toolBarView;
}

- (void)handleHightLightContol:(UIControl *)control{
    UIImageView *imageView = [control viewWithTag:10001];
    UIImageView *imageView1 = [control viewWithTag:10002];
    if (_clickNumber == 0) {
        imageView.image = [UIImage imageNamed:@"shengxu_hightlighted"];
        imageView1.image = [UIImage imageNamed:@"jiangxu_default"];
        _clickNumber = 1;
        if ([self.delegate respondsToSelector:@selector(inviteFriendListSubjectViewAscendingReveal)]) {
            [self.delegate inviteFriendListSubjectViewAscendingReveal];
        }
    }else{
        imageView.image = [UIImage imageNamed:@"shengxu_default"];
        imageView1.image = [UIImage imageNamed:@"jiangxu2_hightlighted"];
        _clickNumber = 0;
        if ([self.delegate respondsToSelector:@selector(inviteFriendListSubjectViewDescendingReveal)]) {
            [self.delegate inviteFriendListSubjectViewDescendingReveal];
        }
    }
}

- (void)bindDataWithModels:(NSArray *)models{
    if (models.count<=0)
    {
        [_emptyView setHidden:NO];
        return;
    }
    [_emptyView setHidden:YES];
    _friends = models;
    [_tableView reloadData];
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InviteFriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell bindDataWithModel:_friends[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56.f;
}

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 60, kMainScreenW, kMainScreenH-110)];
        [self addSubview:_emptyView];
        
        _emptyView.remindStr = @"暂无相关数据哦～";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
