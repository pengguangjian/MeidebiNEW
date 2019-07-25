//
//  SpecialInfoSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SpecialInfoSubjectView.h"
#import "PelsonalOperatingView.h"
#import "RichTextTableViewCell.h"
#import "RemarkHomeTableViewCell.h"
#import "ReadMoreTableViewCell.h"
#import "FlagItemCollectionViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "MDB_UserDefault.h"
#import "GMDCircleLoader.h"

static NSString * const kTableViewHeaderName = @"name";
static NSString * const kTableViewHeaderImage = @"image";
static NSString * const kCollectionCellIdentifier = @"cell";
static NSString * const kRichTextTableViewCellIdentifier = @"richTextCell";
static NSString * const kHotCommentTableViewCellIdentifier = @"hotComment";
static NSString * const kReadMoreTableViewCellIdentifier = @"readMore";
//static float const kCollectionViewCellsHorizonMargin          = 6;
//static float const kCollectionViewCellHeight                  = 21;
//static float const kCellBtnCenterToBorderMargin               = 12;
static float const kTableViewSectionHeaderHeight              = 44;

@interface SpecialInfoSubjectView ()
<
UITableViewDelegate,
UITableViewDataSource,
RemarkHomeTableViewCellDelegate,
PelsonalOperatingViewDelegate,
RichTextTableViewCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PelsonalOperatingView *pelsonalHandleView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *avaterImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) NSMutableArray *layouts;
@property (nonatomic, strong) NSArray *flags;
@property (nonatomic, strong) NSArray *tableViewHeaders;
@property (nonatomic, assign) NSInteger cellWebviewHeight;
@property (nonatomic, strong) SpecialInfoViewModel *infoViewmodel;
@end

@implementation SpecialInfoSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _cellWebviewHeight = 122;
        _layouts = [NSMutableArray array];
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
    
    _tableView = [UITableView new];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(_pelsonalHandleView.mas_top);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[RichTextTableViewCell class] forCellReuseIdentifier:kRichTextTableViewCellIdentifier];
    [_tableView registerClass:[ReadMoreTableViewCell class] forCellReuseIdentifier:kReadMoreTableViewCellIdentifier];
    [_tableView registerClass:[RemarkHomeTableViewCell class] forCellReuseIdentifier:kHotCommentTableViewCellIdentifier];
    [self setExtraCellLineHidden:_tableView];
    [self setupTableHeaderView];
    [GMDCircleLoader setOnView:self withTitle:nil animated:YES];

}

- (void)setupTableHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 0)];
    _tableView.tableHeaderView = headerView;
    _headerView = headerView;
    
    _titleNameLabel = [UILabel new];
    [headerView addSubview:_titleNameLabel];
    [_titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(22);
        make.left.equalTo(headerView.mas_left).offset(16);
        make.right.equalTo(headerView.mas_right).offset(-16);
    }];
    _titleNameLabel.numberOfLines = 0;
    _titleNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleNameLabel.font = [UIFont systemFontOfSize:18.f];
    
    _avaterImageView = [UIImageView new];
    [headerView addSubview:_avaterImageView];
    [_avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleNameLabel.mas_left);
        make.top.equalTo(_titleNameLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    _avaterImageView.userInteractionEnabled = YES;
    _avaterImageView.layer.masksToBounds = YES;
    _avaterImageView.layer.cornerRadius = 20.f;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAvaterView:)];
    [_avaterImageView addGestureRecognizer:tapGesture];
    
    _userNameLabel = [UILabel new];
    [headerView addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avaterImageView.mas_right).offset(8);
        make.bottom.equalTo(_avaterImageView.mas_centerY).offset(-4);
    }];
    _userNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _userNameLabel.font = [UIFont systemFontOfSize:16.f];
    
    _timeLabel = [UILabel new];
    [headerView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameLabel.mas_left);
        make.top.equalTo(_avaterImageView.mas_centerY).offset(4);
    }];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeLabel.font = [UIFont systemFontOfSize:12.f];
    
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:_followBtn];
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_avaterImageView.mas_centerY);
        make.right.equalTo(headerView.mas_right).offset(-25);
        make.size.mas_equalTo(CGSizeMake(50, 23));
    }];
    _followBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_followBtn setTitleColor:[UIColor colorWithHexString:@"#F27A30"] forState:UIControlStateNormal];
    [_followBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    [_followBtn addTarget:self action:@selector(respondsToFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    _followBtn.hidden = YES;
    _followBtn.layer.masksToBounds = YES;
    _followBtn.layer.cornerRadius = 4.f;
    _followBtn.layer.borderWidth = 1.f;
    _followBtn.layer.borderColor = [UIColor colorWithHexString:@"#F27A30"].CGColor;
    
    UIView *lineView = [UIView new];
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avaterImageView.mas_bottom).offset(26);
        make.left.right.equalTo(headerView);
        make.height.offset(1);

    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#DADADA"];
    
    _iconImageView = [UIImageView new];
    [headerView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(15);
        make.left.equalTo(_titleNameLabel);
        make.width.offset(kMainScreenW-32);
        make.height.equalTo(_iconImageView.mas_width).multipliedBy(0.44);
        make.bottom.equalTo(headerView.mas_bottom).offset(-10);
    }];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 4.f;
    
}


- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)bindSpcialDetailData:(SpecialInfoViewModel *)model{
    _infoViewmodel = model;
    _titleNameLabel.text = model.title;
    CGRect titleContentRect = [self calculateTextHeightWithText:_titleNameLabel.text fontSize:18.f];
    [_titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(titleContentRect.size.height);
    }];
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:model.imageLink];
    [[MDB_UserDefault defaultInstance] setViewWithImage:_avaterImageView url:model.avatarLink];
    _userNameLabel.text = model.username;
    _timeLabel.text = model.starttime;
    _followBtn.hidden = NO;
    if (model.isFollow) {
        [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        _followBtn.userInteractionEnabled = NO;
    }
    // update tableheaderview height
    [self layoutIfNeeded];
    CGFloat height = [_headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = _headerView.frame;
    frame.origin.y = 0;
    frame.size.height = height;
    _headerView.frame = frame;
    _tableView.tableHeaderView = _headerView;
    [self bindCommentData:model.comments];
    [_tableView reloadData];
    
    NSDictionary *pelsonalValueDict = @{kPelsonalLikeNumberKey:model.praisecount,
                                        kPelsonalReadNumberKey:model.browsecount,
                                        kPelsonalCollectNumberKey:model.favnum,
                                        kPelsonalCollectType:model.type
                                        };
    [_pelsonalHandleView bindViewData:pelsonalValueDict];

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

- (void)respondsToFollowBtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickAddFollowWithUserid:didComplete:)]) {
        [self.delegate detailSubjectViewDidCickAddFollowWithUserid:_infoViewmodel.userId didComplete:^(BOOL status) {
            _followBtn.userInteractionEnabled = NO;
            [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        }];
    }
}

- (void)respondsToAvaterView:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickAvaterViewWithUserid:)]) {
        [self.delegate detailSubjectViewDidCickAvaterViewWithUserid:_infoViewmodel.userId];
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if (_layouts.count > 0) {
            if (_infoViewmodel.commentcount.integerValue>3) {
                return _layouts.count + 1;
            }else{
                return _layouts.count;
            }
        }
    }else{
        return _infoViewmodel == nil ? 0 : 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RichTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRichTextTableViewCellIdentifier];
        [cell openRichTextWithLocalSource:_infoViewmodel.content];
        cell.delegate = self;
        cell.webViewLoadFinished = ^(CGFloat cellHeight){
            [GMDCircleLoader hideFromView:self animated:YES];
            if (_cellWebviewHeight != cellHeight) {
                _cellWebviewHeight = cellHeight;
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
            }
        };
        return cell;
    }if (indexPath.section == 1){
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row > _layouts.count - 1) {
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickReadMoreRemark)]) {
            [self.delegate detailSubjectViewDidCickReadMoreRemark];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return _cellWebviewHeight;
    }if (indexPath.section == 1){
        if (indexPath.row == 3) {
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
    if (indexPath.section == 1 && indexPath.row==self.layouts.count) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)];
        }
    }
    
}

#pragma mark - UITableView Delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if (_layouts.count > 0) {
            return kTableViewSectionHeaderHeight;
        }
        return 0;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kTableViewSectionHeaderHeight)];
    headerView.backgroundColor = [UIColor whiteColor];

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
    nameLabel.text = [NSString stringWithFormat:@"%@(%@)",self.tableViewHeaders[section][kTableViewHeaderName],_infoViewmodel.commentcount];
    
    return headerView;
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
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCicklikeBtn:)]) {
            [self.delegate detailSubjectViewDidCicklikeBtn:^(BOOL status) {
                 [_pelsonalHandleView updatePelsonalStatuesWithType:PelsonalUpdateViewTypeZan isMinus:status];
            }];
        }
    }else if (type == PelsonalHandleButtonTypeRead){
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickReadBtn)]) {
            [self.delegate detailSubjectViewDidCickReadBtn];
        }
    }else if (type == PelsonalHandleButtonTypeCollect){
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickCollectBtn:)]) {
            [self.delegate detailSubjectViewDidCickCollectBtn:^(BOOL status) {
                [_pelsonalHandleView updatePelsonalStatuesWithType:PelsonalUpdateViewTypeShou isMinus:status];
            }];
        }
    }
}

#pragma mark - RichTextTableViewCellDelegate
- (void)webViewDidPreseeUrlWithLink:(NSString *)link{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickWebViewUrlLink:)]) {
        [self.delegate detailSubjectViewDidCickWebViewUrlLink:link];
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

- (void)cell:(RemarkHomeTableViewCell *)cell didClickUser:(NSString *)userid{
    if ([self.delegate respondsToSelector:@selector(remarkTableViewDidClickUser:)]) {
        [self.delegate remarkTableViewDidClickUser:userid];
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
                              @{kTableViewHeaderName:@"评论",
                                kTableViewHeaderImage:[UIImage imageNamed:@"comment_ general_normal"]}];
    }
    return _tableViewHeaders;
}

@end
