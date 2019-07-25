//
//  TKTopicSubjectView.m
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/16.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import "TKTopicSubjectView.h"
#import "TKExploreTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "MDBEmptyView.h"
static NSString * const kTabelViewCellIdentifier = @"cell";
@interface TKTopicSubjectView ()
<
UITableViewDelegate,
UITableViewDataSource,
TKExploreTableViewCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) TKTopicType type;
@property (nonatomic, strong) NSArray *topics;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *topicDescriptionLabel;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) CGFloat tableSectionHeaderHeight;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@property (nonatomic, assign) NSInteger currentSegmentIndex;
@end

@implementation TKTopicSubjectView
- (instancetype)initWithTopicType:(TKTopicType)type{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _currentSegmentIndex = 0;
        _tableSectionHeaderHeight = 0.f;
        _type = type;
        [self configurUI];
    }
    return self;
}

- (void)configurUI{
    [self addSubview:self.tableView];
//    if (_type != TKTopicTypeDaily) {
//        _bottomView = [UIView new];
//        [self addSubview:_bottomView];
//        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self);
//            make.height.offset(60);
//        }];
////        _bottomView.hidden = YES;
//        UIButton *postTopicButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_bottomView addSubview:postTopicButton];
//        [postTopicButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(_bottomView.mas_centerX);
//            make.bottom.equalTo(_bottomView.mas_bottom).offset(-10);
//            make.size.mas_equalTo(CGSizeMake(150, 41));
//        }];
//        postTopicButton.layer.masksToBounds = YES;
//        postTopicButton.layer.cornerRadius = 3.f;
//        postTopicButton.backgroundColor = RadMenuColor;
//        postTopicButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
//        [postTopicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [postTopicButton setTitle:@"我也要发帖" forState:UIControlStateNormal];
//        [postTopicButton addTarget:self action:@selector(respondsToPostTopicEvent:) forControlEvents:UIControlEventTouchUpInside];
//        UIView *lineView = [UIView new];
//        [_bottomView addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.equalTo(_bottomView);
//            make.height.offset(1);
//        }];
//        lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
//        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.equalTo(self);
//            make.bottom.equalTo(lineView.mas_top);
//        }];
//    }else{
//        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
//    }
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

- (void)bindDataWithModel:(NSArray *)models{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
//    if (_type != TKTopicTypeDaily) _bottomView.hidden = NO;
    if (models.count <= 0) {
        self.emptyView.hidden = NO;
    }else{
        self.emptyView.hidden = YES;
        _tableSectionHeaderHeight = 60;
        NSMutableArray *temps = [NSMutableArray array];
        for (TKTopicListViewModel *model in models) {
            TKTopicItemLayout *layout = [[TKTopicItemLayout alloc] initWithTopics:model];
            if (layout) {
                [temps addObject:layout];
            }
        }
        _topics = temps.mutableCopy;
        [self.tableView reloadData];
    }
    
}

- (void)topicDescription:(NSString *)posteCount commentCount:(NSString *)count{
    NSString *description = @"";
    if (![@"" isEqualToString:posteCount]) {
        description = [NSString stringWithFormat:@"共%@个帖子",posteCount];
    }
    if (![@"" isEqualToString:count]) {
        description = [description stringByAppendingString:[NSString stringWithFormat:@",%@人参与讨论",count]];
    }
    _topicDescriptionLabel.text = description;
}

- (void)respondsToSegmentEvent:(UISegmentedControl *)sender{
    _currentSegmentIndex = sender.selectedSegmentIndex;
    TopicSortStyle style = TopicSortStyleUnknown;
    if (sender.selectedSegmentIndex == 0) {
        style = TopicSortStyleTime;
    }else if (sender.selectedSegmentIndex == 1){
        style = TopicSortStyleChoiceness;
    }
    if ([self.delegate respondsToSelector:@selector(topicSubjectDidChangSort:)]) {
        [self.delegate topicSubjectDidChangSort:style];
    }
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)respondsToPostTopicEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(topicSubjectDidClickPosteTopicButton)]) {
        [self.delegate topicSubjectDidClickPosteTopicButton];
    }
}
#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKExploreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTabelViewCellIdentifier];
    [cell setLayout:_topics[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _tableSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), _tableSectionHeaderHeight)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    _headerView = headerView;
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"最新",@"精华"]];
    [headerView addSubview:segmentControl];
    [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-10);
        make.centerY.equalTo(headerView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    [segmentControl setSelectedSegmentIndex:_currentSegmentIndex];
    segmentControl.tintColor = RadMenuColor;
    segmentControl.layer.masksToBounds = YES;
    segmentControl.layer.cornerRadius = 3.f;
    segmentControl.layer.borderWidth = 1.f;
    segmentControl.layer.borderColor = RadMenuColor.CGColor;
    [segmentControl addTarget:self action:@selector(respondsToSegmentEvent:) forControlEvents:UIControlEventValueChanged];
    
    _topicDescriptionLabel = [UILabel new];
    [headerView addSubview:_topicDescriptionLabel];
    [_topicDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(10);
        make.centerY.equalTo(headerView.mas_centerY);
        make.right.equalTo(segmentControl.mas_left).offset(-15);
    }];
    _topicDescriptionLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _topicDescriptionLabel.font = [UIFont systemFontOfSize:12.f];
    [self topicDescription:_posteCount commentCount:_commentCount];

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [(TKTopicItemLayout *)_topics[indexPath.row] height];
}

#pragma mark - UITableView Delegate methods
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - TKExploreTableViewCellDelegate
- (void)cellDidClick:(TKExploreTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *topicID = [[_topics[indexPath.row] topic] topicID];
    if ([self.delegate respondsToSelector:@selector(topicSubjectDidSelectItem:)]) {
        [self.delegate topicSubjectDidSelectItem:topicID];
    }
}

- (void)cell:(TKExploreTableViewCell *)cell didClickImageAtIndex:(NSInteger)index{
    if (!cell.statusView.layout.topic.topicID) return;
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    TKTopicListViewModel *topic = cell.statusView.layout.topic;
    NSArray *pics = topic.images;
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        if (i >= cell.statusView.picViews.count)
        {
            item.thumbView = nil;
        }
        else
        {
            UIView *imgView = cell.statusView.picViews[i];
            item.thumbView = imgView;
        }
        item.largeImageURL = [NSURL URLWithString:[NSString nullToString:pics[i]]];
        [items addObject:item];
        if (i == index) {
            UIView *imgView = cell.statusView.picViews[i];
            fromView = imgView;
        }
    }
    YYPhotoGroupView *photoGroupView = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    if ([self.delegate respondsToSelector:@selector(photoGroupView:didClickImageView:)]) {
        [self.delegate photoGroupView:photoGroupView didClickImageView:fromView];
    }
}

- (void)cell:(TKExploreTableViewCell *)cell didClickUser:(NSString *)userid{
    if ([self.delegate respondsToSelector:@selector(topicSubjectViewDidCickAvaterViewWithUserid:)]) {
        [self.delegate topicSubjectViewDidCickAvaterViewWithUserid:userid];
    }
}
#pragma mark - setters and getters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[TKExploreTableViewCell class] forCellReuseIdentifier:kTabelViewCellIdentifier];
        _tableView.separatorColor = [UIColor colorWithHexString:@"#E6E6E6"];
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if ([self.delegate respondsToSelector:@selector(lastPage)]) {
                [self.delegate lastPage];
            }
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if ([self.delegate respondsToSelector:@selector(nextPage)]) {
                [self.delegate nextPage];
            }
        }];
    }
    return _tableView;
}

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [MDBEmptyView new];
        [self addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_type != TKTopicTypeDaily) {
                make.edges.equalTo(self).insets(UIEdgeInsetsMake(60, 0, 60, 0));
            }else{
                make.edges.equalTo(self).insets(UIEdgeInsetsMake(60, 0, 0, 0));
            }
        }];
        _emptyView.remindStr = @"没发现相关帖子~";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
