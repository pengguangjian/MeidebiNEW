//
//  RemarkHomeSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/2/6.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RemarkHomeSubjectView.h"
#import "RemarkHomeTableViewCell.h"
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import "QBPopupMenu.h"
#import "CompressImage.h"
#import "MDB_UserDefault.h"

static NSString * const kToolBarBgColor = @"#FAFAFA";
static NSString * const kToolBarBottomLineColor = @"#999999";
static NSString * const kToolBarTopLineColor = @"#DEDEDE";
static NSString * const kToolBarInputDefaultText = @"我来说两句......";
static NSString * const kCellReuseIdentifier = @"cell";
static CGFloat const kToolBarInputTextFontSize = 15.f;

@interface RemarkHomeSubjectView ()
<
UITableViewDelegate,
UITableViewDataSource,
RemarkHomeTableViewCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *layouts;
@property (nonatomic, strong) NSMutableArray *remarks;
@property (nonatomic, strong) QBPopupMenu *popupMenu;
@property (nonatomic, strong) NSIndexPath *selectPath;
@property (nonatomic, strong) UIControl *toolBarControl;
@property (nonatomic, strong) Remark *uploadRemark;

@end

@implementation RemarkHomeSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _layouts = [NSMutableArray new];
        _remarks = [NSMutableArray array];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self setupToolBarView];
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[RemarkHomeTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    _tableView.tableFooterView = [UIView new];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-50);
    }];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([self.delegate respondsToSelector:@selector(remarklastPage)]) {
            [self.delegate remarklastPage];
        }
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([self.delegate respondsToSelector:@selector(remarkNextPage)]) {
            [self.delegate remarkNextPage];
        }
    }];
}

- (void)setupToolBarView{
    UIControl *toolBarControl = [UIControl new];
    [self addSubview:toolBarControl];
    [toolBarControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(50);
    }];
    toolBarControl.backgroundColor = [UIColor colorWithHexString:kToolBarBgColor];
    [toolBarControl addTarget:self action:@selector(respondsToolBarEvent:) forControlEvents:UIControlEventTouchUpInside];
    _toolBarControl = toolBarControl;
    
    UIView *topLineView = [UIView new];
    [toolBarControl addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(toolBarControl);
        make.height.offset(1);
    }];
    topLineView.backgroundColor = [UIColor colorWithHexString:kToolBarTopLineColor];
    
    UIView *bottomLineView = [UIView new];
    [toolBarControl addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toolBarControl.mas_left).offset(18);
        make.right.equalTo(toolBarControl.mas_right).offset(-18);
        make.bottom.equalTo(toolBarControl.mas_bottom).offset(-7);
        make.height.offset(1);
    }];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:kToolBarBottomLineColor];
    
    UIImageView *iconImageView = [UIImageView new];
    [toolBarControl addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toolBarControl.mas_left).offset(35);
        make.top.equalTo(toolBarControl.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.image = [UIImage imageNamed:@"reamrk_input_icon"];
    
    UILabel *defaultTextLabel = [UILabel new];
    [toolBarControl addSubview:defaultTextLabel];
    [defaultTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImageView.mas_centerY);
        make.left.equalTo(iconImageView.mas_right).offset(10);
        make.right.equalTo(toolBarControl.mas_right).offset(-10);
    }];
    defaultTextLabel.textColor = [UIColor colorWithHexString:kToolBarBottomLineColor];
    defaultTextLabel.font = [UIFont systemFontOfSize:kToolBarInputTextFontSize];
    defaultTextLabel.text = kToolBarInputDefaultText;
}

- (void)respondsToolBarEvent:(id)sender{
    if ([self.delegate respondsToSelector:@selector(remarkHomeSubjectViewDidClickToolBar)]) {
        [self.delegate remarkHomeSubjectViewDidClickToolBar];
    }
}

- (void)bindDataWithModel:(NSArray *)models{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    if (models.count<=0) return;
    [_layouts removeAllObjects];
    [_remarks removeAllObjects];
    for (NSDictionary *dict in models) {
        Remark *aRemark = [Remark modelWithDictionary:dict];
        aRemark.content = [NSString stringWithFormat:@"%@ ",aRemark.content];
        
        if (aRemark) {
            [_remarks addObject:aRemark];
        }
        RemarkStatusLayout *layout = [[RemarkStatusLayout alloc] initWithStatus:aRemark];
        if (layout) {
            [_layouts addObject:layout];
        }
    }
    if (_uploadRemark) {
        [_remarks insertObject:_uploadRemark atIndex:0];
        RemarkStatusLayout *layout = [[RemarkStatusLayout alloc] initWithStatus:_uploadRemark];
        if (layout) {
            [_layouts insertObject:layout atIndex:0];
        };
    }
    [_tableView reloadData];
}

- (void)updateDataWithModel:(Remark *)aRemark{
    if (!aRemark) return;
    _uploadRemark = aRemark;
    [_remarks insertObject:aRemark atIndex:0];
    RemarkStatusLayout *layout = [[RemarkStatusLayout alloc] initWithStatus:aRemark];
    if (!layout) return;
    [_layouts insertObject:layout atIndex:0];
    [_tableView insertRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)refreshUploadingRemakInfo:(BOOL)state{
    if (state) {
        [MDB_UserDefault setRemarkImages:nil];
        _uploadRemark = nil;
    }else{
        if (_uploadRemark) {
            _uploadRemark.createtime = @"发送失败";
            _uploadRemark.submitState = YES;
            [_remarks replaceObjectAtIndex:0 withObject:_uploadRemark];
            RemarkStatusLayout *layout = [[RemarkStatusLayout alloc] initWithStatus:_uploadRemark];
            if (layout) {
                [_layouts replaceObjectAtIndex:0 withObject:layout];
            }
            [_tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)popupMenuPraise:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(popupMenuDidHandle:targetObject:)]) {
        [self.delegate popupMenuDidHandle:PopupMenuHandleTypePraise targetObject:_remarks[_selectPath.row]];
    }
}
- (void)popupMenuReply:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(popupMenuDidHandle:targetObject:)]) {
        [self.delegate popupMenuDidHandle:PopupMenuHandleTypeReply targetObject:_remarks[_selectPath.row]];
    }
}
- (void)popupMenuQuote:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(popupMenuDidHandle:targetObject:)]) {
        [self.delegate popupMenuDidHandle:PopupMenuHandleTypeQuote targetObject:_remarks[_selectPath.row]];
    }
}
-(void)popupMenuCopy:(id)sender{
    if ([self.delegate respondsToSelector:@selector(popupMenuDidHandle:targetObject:)]) {
        [self.delegate popupMenuDidHandle:PopupMenuHandleTypeCopy targetObject:_remarks[_selectPath.row]];
    }
}

- (void)successPrise{
    CGRect rect = [_tableView rectForRowAtIndexPath:_selectPath];
    CGPoint high=[_tableView contentOffset];
    CGRect temp = rect;
    temp.origin.y -= high.y;
    UILabel * _labelCommend=[[UILabel alloc] init];
    _labelCommend.frame=CGRectMake(90.0, temp.origin.y+30.0, 25.0, 25.0);
    _labelCommend.text=@"+1";
    _labelCommend.alpha=0.0;
    _labelCommend.textColor=[UIColor redColor];
    [_tableView addSubview:_labelCommend];
    CAAnimation *animation =[CompressImage groupAnimation:_labelCommend];
    [_labelCommend.layer addAnimation:animation forKey:@"animation"];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RemarkHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    cell.delegate = self;
    [cell setLayout:_layouts[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((RemarkStatusLayout *)_layouts[indexPath.row]).height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - RemarkHomeTableViewCellDelegate
///用户点击了赞
-(void)cell:(RemarkHomeTableViewCell *)cell disClickZan:(Remark *)strid;
{
    if ([self.delegate respondsToSelector:@selector(popupMenuDidHandle:targetObject:)]) {
        [self.delegate popupMenuDidHandle:PopupMenuHandleTypePraise targetObject:strid];
    }
    
}

- (void)cellDidClick:(RemarkHomeTableViewCell *)cell{
    if (!cell.statusView.layout.status.comentid) return;
    [self.popupMenu dismissAnimated:YES];
    _selectPath = [_tableView indexPathForCell:cell];
    CGRect rect = [_tableView rectForRowAtIndexPath:_selectPath];
    CGPoint high=[_tableView contentOffset];
    CGRect temp = rect;
    temp.origin.y -= high.y;
    [self.popupMenu showInView:_tableView targetRect:temp animated:YES];
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

- (void)cell:(RemarkHomeTableViewCell *)cell didClickInAgainBtn:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(remarkTableViewDidAgainUploadRemark)]) {
        [self.delegate remarkTableViewDidAgainUploadRemark];
    }
    if (_uploadRemark) {
        _uploadRemark.createtime = @"发送中...";
        _uploadRemark.submitState = NO;
        [_remarks replaceObjectAtIndex:0 withObject:_uploadRemark];
        RemarkStatusLayout *layout = [[RemarkStatusLayout alloc] initWithStatus:_uploadRemark];
        if (layout) {
            [_layouts replaceObjectAtIndex:0 withObject:layout];
        }
        [_tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)cell:(RemarkHomeTableViewCell *)cell didClickInAbandonBtn:(UIButton *)button{
    if (_uploadRemark) {
        [_layouts removeFirstObject];
        [_remarks removeFirstObject];
        _uploadRemark = nil;
        [_tableView deleteRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)cell:(RemarkHomeTableViewCell *)cell didClickUser:(NSString *)userid{
    if ([self.delegate respondsToSelector:@selector(remarkTableViewDidClickUser:)]) {
        [self.delegate remarkTableViewDidClickUser:userid];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(remarkTableViewDidDrage)]) {
        [self.delegate remarkTableViewDidDrage];
    }
}

#pragma mark - setters and getters
- (QBPopupMenu *)popupMenu{
    if (!_popupMenu) {
//        QBPopupMenuItem *item = [QBPopupMenuItem itemWithTitle:@"赞一个" target:self action:@selector(popupMenuPraise:)];
        QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"回复" target:self action:@selector(popupMenuReply:)];
        QBPopupMenuItem *item3 = [QBPopupMenuItem itemWithTitle:@"引用" target:self action:@selector(popupMenuQuote:)];
        QBPopupMenuItem *item4 = [QBPopupMenuItem itemWithTitle:@"复制" target:self action:@selector(popupMenuCopy:)];
//        NSArray *items = @[item, item2, item3, item4];
        NSArray *items = @[item2, item3, item4];
        _popupMenu = [[QBPopupMenu alloc] initWithItems:items];
        _popupMenu.highlightedColor = [[UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0] colorWithAlphaComponent:0.8];
    }
    return _popupMenu;
}

@end
