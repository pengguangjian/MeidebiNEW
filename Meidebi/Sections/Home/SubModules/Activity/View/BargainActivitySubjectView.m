//
//  BargainActivitySubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/10/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BargainActivitySubjectView.h"
#import "RichTextTableViewCell.h"
#import "RemarkHomeTableViewCell.h"
#import "ReadMoreTableViewCell.h"
#import "BargainItemTableViewCell.h"
#import "BargainBottomHandleView.h"
#import "MDB_UserDefault.h"
static NSString * const kSessionName = @"name";
static NSString * const kSessionIcon = @"icon";
static NSString * const kRowName = @"rowname";
static NSString * const kRowHeight = @"rowheight";
static NSString * const kTableViewRichCellIdentifier = @"richCell";
static NSString * const kTableViewRemarkCellIdentifier = @"remarkCell";
static NSString * const kTableViewItemCellIdentifier = @"itemCell";
static NSString * const kTableViewReadMoreCellIdentifier = @"readmoreCell";
static NSString * const kTableViewShareCellIdentifier = @"shareCell";
static float const kTableViewSectionHeaderHeight     = 44;

@interface BargainActivitySubjectView ()
<
UITableViewDelegate,
UITableViewDataSource,
RichTextTableViewCellDelegate,
BargainBottomHandleViewDelegate,
RemarkHomeTableViewCellDelegate,
ShareHandleTableViewCellDelegate
>
@property (nonatomic, strong) NSArray *sessions;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tabHeaderView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *activityStateBgImageView;
@property (nonatomic, assign) CGFloat cellWebviewHeight;
@property (nonatomic, assign) CGFloat cell1WebviewHeight;
@property (nonatomic, assign) CGFloat cell2WebviewHeight;
@property (nonatomic, strong) NSArray *remarks;
@property (nonatomic, strong) NSArray *bargainItems;
@property (nonatomic, strong) NSMutableArray *cellHeights;
@property (nonatomic, strong) NSMutableDictionary *cellHeightDict;
@property (nonatomic, strong) BargainBottomHandleView *pelsonalHandleView;
@property (nonatomic, strong) BargainActivityViewModel *bargainModel;
@end

@implementation BargainActivitySubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cellWebviewHeight = 0;
        _cell1WebviewHeight = 0;
        _cell2WebviewHeight = 0;
        _cellHeights = [NSMutableArray array];
        _cellHeightDict = [NSMutableDictionary dictionary];
        [self setupSubviews];
        // 注册加载完成高度的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(webViewFinishLoadNotification:)
                                                     name:kWebviewDidFinishLoadNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubviews{
    
    _pelsonalHandleView = [BargainBottomHandleView new];
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
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [_tableView registerClass:[RichTextTableViewCell class]
       forCellReuseIdentifier:kTableViewRichCellIdentifier];
    [_tableView registerClass:[ReadMoreTableViewCell class]
           forCellReuseIdentifier:kTableViewReadMoreCellIdentifier];
    [_tableView registerClass:[RemarkHomeTableViewCell class]
       forCellReuseIdentifier:kTableViewRemarkCellIdentifier];
    [_tableView registerClass:[BargainItemTableViewCell class]
       forCellReuseIdentifier:kTableViewItemCellIdentifier];
    [_tableView registerClass:[ShareHandleTableViewCell class]
       forCellReuseIdentifier:kTableViewShareCellIdentifier];
    [self setupTableViewHeaderView];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorColor = [UIColor colorWithHexString:@"#DADADA"];
}

- (void)setupTableViewHeaderView{
    UIView *tabHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, -(kMainScreenW*0.33), kMainScreenW, (kMainScreenW*0.33))];
    _tableView.tableHeaderView = tabHeaderView;
    _tabHeaderView = tabHeaderView;
    _iconImageView = [UIImageView new];
    [tabHeaderView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(tabHeaderView);
        make.height.offset(kMainScreenW*0.33);
    }];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds = YES;
    
    _activityStateBgImageView = [UIImageView new];
    [_iconImageView addSubview:_activityStateBgImageView];
    [_activityStateBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(_iconImageView);
        make.size.mas_equalTo(CGSizeMake(53, 20));
    }];
}

- (void)bindDataWithModel:(BargainActivityViewModel *)model{
    if(!model) return;
    _bargainModel = model;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:model.imageLink options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        _activityImage = image;
    }];
    
    if ([@"0" isEqualToString:model.state]) {
        _activityStateBgImageView.image = [UIImage imageNamed:@"avtivity_no_star"];
    }else if ([@"-1" isEqualToString:model.state]){
        _activityStateBgImageView.image = [UIImage imageNamed:@"avtivity_end"];
    }else if ([@"1" isEqualToString:model.state]){
        _activityStateBgImageView.image = [UIImage imageNamed:@"avtivity_ing"];
    }
     _bargainItems = model.commoditys;
    [_tableView reloadData];
    [self bindCommentData:model.comments];
    
    NSDictionary *pelsonalValueDict = @{kBargainBottomLikeNumberKey:model.praisecount,
                                        kBargainBottomRemarkNumberKey:model.commentcount
                                        };
    [_pelsonalHandleView bindViewData:pelsonalValueDict];
}

- (void)bindCommentData:(NSArray *)models{
    if ([models isKindOfClass:[NSArray class]]){
        if (models.count<=0) return;
        NSMutableArray *remark = [NSMutableArray array];
        for (NSDictionary *dict in models) {
            Remark *aRemark = [Remark modelWithDictionary:dict];
            RemarkStatusLayout *layout = [[RemarkStatusLayout alloc] initWithStatus:aRemark];
            if (layout) {
                [remark addObject:layout];
            }
        }
        _remarks = remark.mutableCopy;
        [_tableView reloadSection:4 withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sessions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if ([@"" isEqualToString:[NSString nullToString:_bargainModel.content]]) {
                return 0;
            }else{
                return 1;
            }
            break;
        case 1:
            if ([@"" isEqualToString:[NSString nullToString:_bargainModel.endtime]]) {
                return 0;
            }else{
                return 1;
            }
            break;
        case 2:
            if ([@"" isEqualToString:[NSString nullToString:_bargainModel.explain]]) {
                return 0;
            }else{
                return 1;
            }
            break;
        case 3:
            if (_bargainItems.count > 0) {
                return _bargainItems.count + 1;
            }else{
                return 0;
            }
            break;
        case 4:
            if (_remarks.count > 0) {
                if (_bargainModel.commentcount.integerValue > 3) {
                    return _remarks.count + 1;
                }else{
                    return _remarks.count;
                }
            }else{
                return 0;
            }
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
//        RichTextTableViewCell *cell = [[RichTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewRichCellIdentifier];
        RichTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewRichCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        cell.tag = indexPath.section;
        if (indexPath.section == 0 && ![@"" isEqualToString:_bargainModel.content]) {
            [cell openRichTextWithLocalSource:_bargainModel.content];
        }else if (indexPath.section == 1 && ![@"" isEqualToString:_bargainModel.starttime]) {
            [cell openRichTextWithLocalSource:_bargainModel.activitytime];
        }else if (indexPath.section == 2 && ![@"" isEqualToString:_bargainModel.explain]) {
            [cell openRichTextWithLocalSource:_bargainModel.explain];
        }
        return cell;
    }else if (indexPath.section == 3){
        if(indexPath.row > _bargainItems.count-1){
            ShareHandleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewShareCellIdentifier];
            cell.delegate = self;
            return cell;
        }else{
            BargainItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewItemCellIdentifier];
            [cell bindDataWithModel:_bargainItems[indexPath.row]];
            return cell;
        }
    }else if (indexPath.section == 4){
        if(indexPath.row > _remarks.count - 1){
            ReadMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewReadMoreCellIdentifier];
            return cell;
        }else{
            RemarkHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewRemarkCellIdentifier];
            [cell setLayout:_remarks[indexPath.row]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 || indexPath.section == 1 || indexPath.section == 2) {
        return [[_cellHeightDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]] floatValue];;
    }else if (indexPath.section == 3){
        if (indexPath.row  > _bargainItems.count - 1) {
            return 131;
        }else{
            return 157;
        }
    }else if (indexPath.section == 4){
        if (indexPath.row > _remarks.count - 1) {
            return 50;
        }else{
            return ((RemarkStatusLayout *)_remarks[indexPath.row]).height;
        }
    }else{
        return 122;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    switch (section) {
        case 0:
            if ([@"" isEqualToString:[NSString nullToString:_bargainModel.content]]) {
                return 0;
            }else{
                return kTableViewSectionHeaderHeight;
            }
            break;
        case 1:
            if ([@"" isEqualToString:[NSString nullToString:_bargainModel.endtime]]) {
                return 0;
            }else{
                return kTableViewSectionHeaderHeight;
            }
            break;
        case 2:
            if ([@"" isEqualToString:[NSString nullToString:_bargainModel.explain]]) {
                return 0;
            }else{
                return kTableViewSectionHeaderHeight;
            }
            break;
        case 3:
            if (_bargainItems.count > 0) {
                return kTableViewSectionHeaderHeight;
            }else{
                return 0;
            }
            break;
        case 4:
            if (_remarks.count > 0) {
                return kTableViewSectionHeaderHeight;
            }else{
                return 0;
            }
            break;
        default:
            return 0;
            break;
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
    iconImageView.image = self.sessions[section][kSessionIcon];

    UILabel *nameLabel = [UILabel new];
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(5);
        make.centerY.equalTo(iconImageView.mas_centerY);
    }];
    nameLabel.textColor = [UIColor colorWithHexString:@"#F77210"];
    nameLabel.font = [UIFont systemFontOfSize:14.f];

    if (section == 4) {
        nameLabel.text = [NSString stringWithFormat:@"%@(%@)",self.sessions[section][kSessionName],_bargainModel.commentcount];
    }else{
        nameLabel.text = self.sessions[section][kSessionName];
    }
    return headerView;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 调整Separator位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    // 移除tableviewcell最后一行的Separator
    if (indexPath.section == 4 && indexPath.row==_remarks.count) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)];
        }
    }
    
}

#pragma mark - UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        if ([self.delegate respondsToSelector:@selector(subjectTableViewDidSelectItem:)]) {
            [self.delegate subjectTableViewDidSelectItem:[_bargainItems[indexPath.row] itemID]];
        }
    }
    if (indexPath.section == 4 && indexPath.row == _remarks.count) {
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickReadMoreRemark)]) {
            [self.delegate detailSubjectViewDidCickReadMoreRemark];
        }
    }
}

#pragma mark - RichTextTableViewCellDelegate
- (void)webViewDidPreseeUrlWithLink:(NSString *)link{
    if ([self.delegate respondsToSelector:@selector(remarkHomeSubjectClickUrl:)]) {
        [self.delegate remarkHomeSubjectClickUrl:link];
    }
}

#pragma mark - ShareHandleTableViewCellDelegate
- (void)shareHandleTableViewCellDidClickedShareButtonAtType:(ShareHandleType)type{
    if ([self.delegate respondsToSelector:@selector(bargainActivitySubjectViewDidClickedShareButtonAtType:)]) {
        [self.delegate bargainActivitySubjectViewDidClickedShareButtonAtType:type];
    }
}

#pragma mark - RemarkHomeTableViewCellDelegate
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
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickAvaterViewWithUserid:)]) {
        [self.delegate detailSubjectViewDidCickAvaterViewWithUserid:userid];
    }
}


#pragma mark - Notification
- (void)webViewFinishLoadNotification:(NSNotification *)sender
{
    RichTextTableViewCell *cell = [sender object];
    if (![_cellHeightDict objectForKey:[NSString stringWithFormat:@"%ld",(long)cell.tag]] && [[_cellHeightDict objectForKey:[NSString stringWithFormat:@"%ld",(long)cell.tag]] floatValue] != cell.cellHeight)
    {
        [_cellHeightDict setObject:[NSNumber numberWithFloat:cell.cellHeight] forKey:[NSString stringWithFormat:@"%ld",(long)cell.tag]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:cell.tag]] withRowAnimation:UITableViewRowAnimationNone];
    }
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

#pragma mark - BargainBottomHandleViewDelegate
- (void)operatingViewDidClickInputView{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickInputRemarkView)]) {
        [self.delegate detailSubjectViewDidCickInputRemarkView];
    }
}

- (void)operatingViewDidClickHandleButtonWithType:(BargainBottomHandleButtonType)type{
    if (type == BargainBottomHandleButtonTypeLike) {
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCicklikeBtn:)]) {
            [self.delegate detailSubjectViewDidCicklikeBtn:^(BOOL status) {
                [_pelsonalHandleView updatePelsonalStatuesWithType:BargainBottomUpdateViewTypeZan isMinus:status];
            }];
        }
    }else if (type == BargainBottomHandleButtonTypeRemark){
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickInputRemarkView)]) {
            [self.delegate detailSubjectViewDidCickInputRemarkView];
        }
    }
}

#pragma mark - setters and getters
- (NSArray *)sessions{
    if (!_sessions) {
        _sessions = @[@{kSessionName:@"活动介绍",
                        kSessionIcon:[UIImage imageNamed:@"introduce_ general_normal"]},
                      @{kSessionName:@"活动时间",
                        kSessionIcon:[UIImage imageNamed:@"introduce_ general_normal"]},
                      @{kSessionName:@"补充说明",
                        kSessionIcon:[UIImage imageNamed:@"introduce_ general_normal"]},
                      @{kSessionName:@"活动商品",
                        kSessionIcon:[UIImage imageNamed:@"introduce_ general_normal"]},
                      @{kSessionName:@"评论",
                        kSessionIcon:[UIImage imageNamed:@"comment_ general_normal"]}];
    }
    return _sessions;
}
@end
