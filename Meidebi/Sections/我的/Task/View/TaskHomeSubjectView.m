//
//  TaskHomeSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 16/8/18.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "TaskHomeSubjectView.h"
#import "TaskHomeTableViewCell.h"
#import "MDB_UserDefault.h"
static NSString *cellIdentifier = @"Cell";

@interface TaskHomeSubjectView ()
<
UITableViewDelegate,
UITableViewDataSource,
TaskHomeTableViewCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIView *showcaseView;
@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation TaskHomeSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        if ([MDB_UserDefault needPhoneStatue]) {
            [self.tasks insertObject:@{@"title":@"注册有礼",
                                       @"icon":[UIImage imageNamed:@"log_gift"],
                                       @"subtitle":@"新人注册完成手机绑定，有机会获得5~300元现金券，再送300铜币。",
                                       @"copper":@"",
                                       @"type":@(0)}
                             atIndex:0];
        }
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    _tableView = [[UITableView alloc] init];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [_tableView registerClass:[TaskHomeTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self setupTableHeaderView];
    [self setupTableFooterView];
}

- (void)setupTableHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -147, CGRectGetWidth(_tableView.frame), 147)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    _tableView.tableHeaderView = headerView;
    
    _bannerImageView = [UIImageView new];
    [headerView addSubview:_bannerImageView];
    [_bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(headerView);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    _bannerImageView.image = [UIImage imageNamed:@"banner_task"];
}

- (void)setupTableFooterView{
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, -280, CGRectGetWidth(_tableView.frame), 280)];
    _footerView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    _tableView.tableFooterView = _footerView;
    
    UILabel *noteLabel = [UILabel new];
    [_footerView addSubview:noteLabel];
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_footerView.mas_top).offset(15);
        make.centerX.equalTo(_footerView.mas_centerX);
    }];
    noteLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
    noteLabel.font = [UIFont systemFontOfSize:12.f];
    noteLabel.text = @"（最终获铜币详情，请参考右上角“规则”说明）";
    
    _showcaseView = [UIView new];
    [_footerView addSubview:_showcaseView];
    [_showcaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noteLabel.mas_bottom).offset(15);
        make.left.right.equalTo(_footerView);
    }];
    _showcaseView.backgroundColor = [UIColor whiteColor];
    
    [self setupShowcaseSubviews];
}

- (void)setupShowcaseSubviews{
    UIImageView *flageImageView = [UIImageView new];
    [_showcaseView addSubview:flageImageView];
    [flageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_showcaseView.mas_left).offset(16);
        make.top.equalTo(_showcaseView.mas_top).offset(17);
        make.size.mas_equalTo(CGSizeMake(6, 18));
    }];
    flageImageView.image = [UIImage imageNamed:@"flage_gift"];
    
    UILabel *title = [UILabel new];
    [_showcaseView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(flageImageView.mas_centerY);
        make.left.equalTo(flageImageView.mas_right).offset(7);
    }];
    title.font = [UIFont systemFontOfSize:15.f];
    title.textColor = [UIColor colorWithHexString:@"#555555"];
    title.text = @"小铜币换大礼展示区";
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showcaseView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_showcaseView.mas_right).offset(-16);
        make.centerY.equalTo(title.mas_centerY);
        make.height.offset(30);
    }];
     moreBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
     moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [moreBtn setTitleColor:[UIColor colorWithHexString:@"#FD7A0E"] forState:UIControlStateNormal];
    [moreBtn setTitle:@"更多礼品兑换 +" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *cardView = [self setupCardViewWithName:@"京东100元礼品卡" iconImage:[UIImage imageNamed:@"jd_100_temp"]];
    [_showcaseView addSubview:cardView];
    
    UIView *cardView1 = [self setupCardViewWithName:@"京东300元礼品卡" iconImage:[UIImage imageNamed:@"jd_300_temp"]];
    [_showcaseView addSubview:cardView1];
    
    UIView *cardView2 = [self setupCardViewWithName:@"京东300元礼品卡" iconImage:[UIImage imageNamed:@"jd_300_temp"]];
    [_showcaseView addSubview:cardView2];
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_showcaseView.mas_left).offset(15);
        make.top.equalTo(flageImageView.mas_bottom).offset(15);
        make.width.offset((BOUNDS_WIDTH-(15*4))/3);
    }];
    
    [cardView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView.mas_right).offset(15);
        make.top.equalTo(cardView.mas_top);
        make.width.equalTo(cardView.mas_width);
    }];
    [cardView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView1.mas_right).offset(15);
        make.top.equalTo(cardView1.mas_top);
        make.width.equalTo(cardView.mas_width);
    }];
    
    [_showcaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cardView.mas_bottom).offset(17);
    }];
    
    UILabel *giftNoteLabel = [UILabel new];
    [_footerView addSubview:giftNoteLabel];
    [giftNoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_footerView.mas_centerX);
        make.top.equalTo(_showcaseView.mas_bottom).offset(15);
    }];
    giftNoteLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
    giftNoteLabel.font = [UIFont systemFontOfSize:12.f];
    giftNoteLabel.text = @"（礼品以实物为准）";

    
    [self layoutIfNeeded];
    CGRect frame = _footerView.frame;
    frame.size.height = CGRectGetMaxY(giftNoteLabel.frame)+15;
    _footerView.frame = frame;

    [self.tableView beginUpdates];
    [self.tableView setTableFooterView:_footerView];
    [self.tableView endUpdates];
}

- (UIView *)setupCardViewWithName:(NSString *)name iconImage:(UIImage *)icon{
    UIView *cardContairView = [UIView new];
    cardContairView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [UIImageView new];
    [cardContairView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(cardContairView);
        make.height.equalTo(iconImageView.mas_width);
    }];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.image = icon;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 5;
    iconImageView.layer.borderWidth = 0.7;
    iconImageView.layer.borderColor = [UIColor colorWithHexString:@"#E6E6E6"].CGColor;
    
    UILabel *nameLabel = [UILabel new];
    [cardContairView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconImageView.mas_centerX);
        make.top.equalTo(iconImageView.mas_bottom).offset(7);
    }];
    nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    nameLabel.font = [UIFont systemFontOfSize:12.f];
    if(name == nil)
    {
        nameLabel.text = @"";
    }
    else
    {
        nameLabel.text = name;
    }
    
    
    [cardContairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(nameLabel.mas_bottom);
    }];
    
    return cardContairView;
}

- (void)respondsToBtnEvent:(id)sender{
    if ([self.delegate respondsToSelector:@selector(taskHomeSubjectViewDidPressMoreCardBtn)]) {
        [self.delegate taskHomeSubjectViewDidPressMoreCardBtn];
    }
}

- (void)updateData{
    [_tableView reloadData];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tasks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.taskItemDict = self.tasks[indexPath.section];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 7)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}

#pragma mark - TaskHomeTableViewCellDelegate
- (void)tableViewCellDidPressHandleBtnWithHomeCell:(TaskHomeTableViewCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    HandleTaskType handleType = HandleTaskTypeUnknown;
    NSInteger section = indexPath.section;
    if (![MDB_UserDefault needPhoneStatue]) {
        section += 1;
    }
    switch (section) {
        case 0:
        {
            handleType = HandleTaskTypeLogin;
        }
            break;
        case 1:
        {
            handleType = HandleTaskTypeShare;
        }
            break;
            
        case 2:
        {
            handleType = HandleTaskTypeShaiDan;
        }
            break;
            
        case 3:
        {
            handleType = HandleTaskTypeBroke;
        }
            break;
            
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(taskHomeSubjectViewDelegate:didPressHandleTaskBtnWithType:)]) {
        [self.delegate taskHomeSubjectViewDelegate:self didPressHandleTaskBtnWithType:handleType];
    }
}

#pragma mark - setters and getters
- (NSMutableArray *)tasks{
    if (!_tasks) {
        _tasks = @[@{@"title":@"分享享双重好礼",
                     @"icon":[UIImage imageNamed:@"share_gift"],
                     @"subtitle":@"分享没得比给好友，获铜币贡献值双重奖励。",
                     @"copper":@"",
                     @"type":@(1)},
                   @{@"title":@"原创豪礼等你拿",
                     @"icon":[UIImage imageNamed:@"bask_gift"],
                     @"subtitle":@"分享购物体验，600铜币与您有约。",
                     @"copper":@"",
                     @"type":@(2)},
                   @{@"title":@"你爆料，我送礼",
                     @"icon":[UIImage imageNamed:@"broke_gift"],
                     @"subtitle":@"发现尖货，立即爆料，150铜币等你拿。",
                     @"copper":@"",
                     @"type":@(3)}].mutableCopy;
    }
    return _tasks;
}

@end
