//
//  BannerDetailSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BannerDetailSubjectView.h"
#import "FlagItemCollectionViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "RichTextTableViewCell.h"
#import "HotRecommendTableViewCell.h"
#import "RelevanceTableViewCell.h"
#import "RemarkHomeTableViewCell.h"
#import "ReadMoreTableViewCell.h"
#import "PelsonalOperatingView.h"

static NSString * const kTableViewHeaderName = @"name";
static NSString * const kTableViewHeaderImage = @"image";
static NSString * const kCollectionCellIdentifier = @"cell";
static NSString * const kRelevanceTableViewCellIdentifier = @"relevanceCell";
static NSString * const kRichTextTableViewCellIdentifier = @"richTextCell";
static NSString * const kHotRecommendTableViewCellIdentifier = @"hotScale";
static NSString * const kHotCommentTableViewCellIdentifier = @"hotComment";
static NSString * const kReadMoreTableViewCellIdentifier = @"readMore";

static float const kCollectionViewCellsHorizonMargin          = 6;
static float const kCollectionViewCellHeight                  = 21;
static float const kCellBtnCenterToBorderMargin               = 12;
static float const kTableViewSectionHeaderHeight              = 44;
@interface BannerDetailSubjectView ()
<
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
PelsonalOperatingViewDelegate,
RemarkHomeTableViewCellDelegate,
HotRecommendTableViewCellDelegate
>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) PelsonalOperatingView *pelsonalHandleView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *titleNameLabel;
@property (nonatomic, strong) UILabel *describleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSArray *flags;
@property (nonatomic, strong) NSArray *tableViewHeaders;
@property (nonatomic, assign) CGFloat cellWebviewHeight;
@property (nonatomic, strong) NSMutableArray *layouts;

@end

@implementation BannerDetailSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _layouts = [NSMutableArray array];
        _cellWebviewHeight = 122;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _pelsonalHandleView = [PelsonalOperatingView new];
    [self addSubview:_pelsonalHandleView];
    [_pelsonalHandleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.offset(52);
    }];
    _pelsonalHandleView.delegate = self;
    [_pelsonalHandleView bindViewData:@{}];
    
    _mainTableView = [UITableView new];
    [self addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(_pelsonalHandleView.mas_top);
    }];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [_mainTableView registerClass:[RichTextTableViewCell class]
           forCellReuseIdentifier:kRichTextTableViewCellIdentifier];
    [_mainTableView registerClass:[HotRecommendTableViewCell class]
           forCellReuseIdentifier:kHotRecommendTableViewCellIdentifier];
    [_mainTableView registerClass:[RelevanceTableViewCell class]
           forCellReuseIdentifier:kRelevanceTableViewCellIdentifier];
    [_mainTableView registerClass:[RemarkHomeTableViewCell class]
           forCellReuseIdentifier:kHotCommentTableViewCellIdentifier];
    [_mainTableView registerClass:[ReadMoreTableViewCell class]
           forCellReuseIdentifier:kReadMoreTableViewCellIdentifier];
    [self setExtraCellLineHidden:_mainTableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 0)];
    _mainTableView.tableHeaderView = headerView;
    _headerView = headerView;

    _titleNameLabel = [UILabel new];
    [headerView addSubview:_titleNameLabel];
    [_titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(24);
        make.left.equalTo(headerView.mas_left).offset(16);
        make.right.equalTo(headerView.mas_right).offset(-16);
    }];
    _titleNameLabel.numberOfLines = 0;
    _titleNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleNameLabel.font = [UIFont systemFontOfSize:18.f];
    [_titleNameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    _describleLabel = [UILabel new];
    [headerView addSubview:_describleLabel];
    [_describleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleNameLabel.mas_bottom).offset(10);
        make.left.right.equalTo(_titleNameLabel);
    }];
    _describleLabel.numberOfLines = 0;
    _describleLabel.textColor = [UIColor colorWithHexString:@"#F2463A"];
    _describleLabel.font = [UIFont systemFontOfSize:18.f];

    
    UIImageView *timeImageView = [UIImageView new];
    [headerView addSubview:timeImageView];
    [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_describleLabel.mas_left);
        make.top.equalTo(_describleLabel.mas_bottom).offset(11);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    timeImageView.contentMode = UIViewContentModeScaleAspectFit;
    timeImageView.image = [UIImage imageNamed:@"banner_activity_time"];
    
    _timeLabel = [UILabel new];
    [headerView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeImageView.mas_right).offset(4);
        make.centerY.equalTo(timeImageView.mas_centerY);
    }];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeLabel.font = [UIFont systemFontOfSize:11.f];

    UICollectionView *collectionView = [self setupActivityFlagSubviews];
    [headerView addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_right).offset(20);
        make.right.equalTo(headerView.mas_right).offset(-16);
        make.centerY.equalTo(_timeLabel.mas_centerY);
        make.height.offset(25);
        make.bottom.equalTo(headerView.mas_bottom).offset(-24);
    }];
}

- (UICollectionView *)setupActivityFlagSubviews{
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 6;
    flowLayout.minimumInteritemSpacing = 0;
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:[FlagItemCollectionViewCell class]
       forCellWithReuseIdentifier:kCollectionCellIdentifier];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    return collectionView;
}

- (float)collectionCellWidthText:(NSString *)text{
    float cellWidth;
    CGSize size = [text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:10]}];
    cellWidth = ceilf(size.width) + kCellBtnCenterToBorderMargin;

    return cellWidth;
}

- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)bindDetailData:(NSDictionary *)model{
    _titleNameLabel.text = @"折1.7元/双！RRVF 男女夏季透气薄款隐形 袜10双 16.9元（买一送一+用券）";
    _describleLabel.text = @"满200-100";
    _timeLabel.text = @"47分钟前推荐";
    CGRect titleContentRect = [self calculateTextHeightWithText:_titleNameLabel.text fontSize:18.f];
    [_titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(titleContentRect.size.height);
    }];
    
    CGRect contentRect = [self calculateTextHeightWithText:_describleLabel.text fontSize:18.f];
    [_describleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(contentRect.size.height);
    }];
    
    // update tableheaderview height
    [self layoutIfNeeded];
    CGFloat height = [_headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = _headerView.frame;
    frame.origin.y = 0;
    frame.size.height = height;
    _headerView.frame = frame;
    _mainTableView.tableHeaderView = _headerView;
}

- (CGRect)calculateTextHeightWithText:(NSString *)text
                             fontSize:(CGFloat)size{
    CGSize maxSize = CGSizeMake(kMainScreenW-32, MAXFLOAT);
    CGRect contentRect = [text boundingRectWithSize:maxSize
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}
                                                            context:nil];
    return contentRect;
}

- (void)bindCommentData:(NSArray *)models{
    if (models.count<=0) return;
    [_layouts removeAllObjects];
    for (NSDictionary *dict in models) {
        Remark *aRemark = [Remark modelWithDictionary:dict];
        RemarkStatusLayout *layout = [[RemarkStatusLayout alloc] initWithStatus:aRemark];
        if (layout) {
            [_layouts addObject:layout];
        }
    }
    [_mainTableView reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }if (section == 3) {
        if (_layouts.count>0) {
            return _layouts.count + 1;
        }
        return 0;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RichTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRichTextTableViewCellIdentifier];
//        [cell openRichTextWithUrl:@"http://www.oschina.net"];
        cell.webViewLoadFinished = ^(CGFloat cellHeight){
            if (_cellWebviewHeight != cellHeight) {
                _cellWebviewHeight = cellHeight;
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
            }
        };
        return cell;
    }if (indexPath.section == 1) {
        HotRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotRecommendTableViewCellIdentifier];
        [cell bindHotRecommendData:@{}];
        cell.delegate = self;
        return cell;
    }if (indexPath.section == 2) {
        RelevanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRelevanceTableViewCellIdentifier];
//        [cell bindHotRecommendData:@{}];
        return cell;
    }if (indexPath.section == 3){
        if(indexPath.row > _layouts.count - 1){
            ReadMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReadMoreTableViewCellIdentifier];
            return cell;
        }else{
            RemarkHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotCommentTableViewCellIdentifier];
            [cell setLayout:_layouts[indexPath.row]];
            cell.delegate = self;
            return cell;
        }
       
    }else{
        static NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        return cell;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return _cellWebviewHeight;
    }if (indexPath.section == 3){
        if (indexPath.row > _layouts.count - 1) {
            return 50;
        }else{
            return ((RemarkStatusLayout *)_layouts[indexPath.row]).height;
        }
    }else{
        return 122;
    }
    
}

// 移除tableviewcell最后一行的Separator
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && indexPath.row==self.layouts.count) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)];
        }
    }
    
}

///**
// *  布局视图
// */
//-(void)viewDidLayoutSubviews
//{
//    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
//    }
//    
//    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
//    }
//}

#pragma mark - UITableView Delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kTableViewSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kTableViewSectionHeaderHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [UIView new];
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(headerView);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#DADADA"];
    
    UIImageView *iconImageView = [UIImageView new];
    [headerView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(20);
        make.left.equalTo(headerView.mas_left).offset(16);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.image = self.tableViewHeaders[section][kTableViewHeaderImage];
    
    UILabel *nameLabel = [UILabel new];
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(5);
        make.centerY.equalTo(iconImageView.mas_centerY);
    }];
    nameLabel.textColor = [UIColor colorWithHexString:@"#F77210"];
    nameLabel.font = [UIFont systemFontOfSize:14.f];
    nameLabel.text = self.tableViewHeaders[section][kTableViewHeaderName];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row > _layouts.count - 1) {
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickReadMoreRemark)]) {
            [self.delegate detailSubjectViewDidCickReadMoreRemark];
        }
    }
}

#pragma mark - RemarkHomeTableViewCellDelegate
- (void)cellDidClick:(RemarkHomeTableViewCell *)cell{
    if (!cell.statusView.layout.status.comentid) return;
    
}

- (void)cell:(RemarkHomeTableViewCell *)cell didClickImageAtIndex:(NSUInteger)index{
    if (!cell.statusView.layout.status.comentid) return;
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    Remark *status = cell.statusView.layout.status;
    NSArray *pics = status.pics;
    
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        UIView *imgView = cell.statusView.picViews[i];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = [NSURL URLWithString:[NSString nullToString:pics[i][@"orgin"]]];
        //        item.largeImageSize = CGSizeMake(meta.width, meta.height);
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    if ([self.delegate respondsToSelector:@selector(photoGroupView:didClickImageView:)]) {
        [self.delegate photoGroupView:v didClickImageView:fromView];
    }
    
}

- (void)cell:(RemarkHomeTableViewCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange{
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;
    if (info[kWBLinkURLName]) {
        NSString *url = info[kWBLinkURLName];
        if ([self.delegate respondsToSelector:@selector(remarkHomeSubjectClickUrl:)]) {
            [self.delegate remarkHomeSubjectClickUrl:url];
        }
    }
}


#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.flags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FlagItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    [cell bindFlagItemData:@{@"name":self.flags[indexPath.row]}];
    return cell;
}

#pragma mark -  UICollectionViewDelegateLeftAlignedLayout Method

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.flags[indexPath.row];
    float cellWidth = [self collectionCellWidthText:text];
    return CGSizeMake(cellWidth, kCollectionViewCellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCollectionViewCellsHorizonMargin;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        //固定头部视图
        if (scrollView.contentOffset.y<=kTableViewSectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=kTableViewSectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-kTableViewSectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - PelsonalOperatingViewDelegate
- (void)operatingViewDidClickInputView{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickInputRemarkView)]) {
        [self.delegate detailSubjectViewDidCickInputRemarkView];
    }
}

- (void)operatingViewDidClickHandleButtonWithType:(PelsonalHandleButtonType)type{
    if (type == PelsonalHandleButtonTypeLike) {
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCicklikeBtn)]) {
            [self.delegate detailSubjectViewDidCicklikeBtn];
        }
    }else if (type == PelsonalHandleButtonTypeRead){
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickReadBtn)]) {
            [self.delegate detailSubjectViewDidCickReadBtn];
        }
    }else if (type == PelsonalHandleButtonTypeCollect){
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickCollectBtn)]) {
            [self.delegate detailSubjectViewDidCickCollectBtn];
        }
    }
}

#pragma mark - HotRecommendTableViewCellDelegate
- (void)tableViewCellDidClickOpenUrlBtn:(NSString *)openUrl{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickHotScaleUrlBtn:)]) {
        [self.delegate detailSubjectViewDidCickHotScaleUrlBtn:openUrl];
    }
}

#pragma mark - setters and getters
- (NSArray *)flags{
    if (!_flags) {
        _flags = @[@"白菜价",
                   @"9.9包邮",
                   @"标签",
                   @"亚马逊自营"];
    }
    return _flags;
}

- (NSArray *)tableViewHeaders{
    if (!_tableViewHeaders) {
        _tableViewHeaders = @[@{kTableViewHeaderName:@"活动介绍",
                                kTableViewHeaderImage:[UIImage imageNamed:@"introduce_ general_normal"]},
                              @{kTableViewHeaderName:@"热卖推荐",
                                kTableViewHeaderImage:[UIImage imageNamed:@"introduce_ general_normal"]},
                              @{kTableViewHeaderName:@"猜你喜欢",
                                kTableViewHeaderImage:[UIImage imageNamed:@"introduce_ general_normal"]},
                              @{kTableViewHeaderName:@"评论(16)",
                                kTableViewHeaderImage:[UIImage imageNamed:@"comment_ general_normal"]}];
    }
    return _tableViewHeaders;
}
@end
