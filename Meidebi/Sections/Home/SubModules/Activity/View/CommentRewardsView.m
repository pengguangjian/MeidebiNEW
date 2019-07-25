//
//  CommentRewardsView.m
//  Meidebi
//
//  Created by fishmi on 2017/5/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CommentRewardsView.h"
#import "RemarkHomeTableViewCell.h"
#import "CommentRewardsViewHeadView.h"
#import "CommentRewardsModel.h"
#import <MJExtension/MJExtension.h>
#import "RemarkModel.h"
#import "RemarkHomeViewController.h"
#import <MJRefresh/MJRefresh.h>


@interface CommentRewardsView ()<UITableViewDataSource,UITableViewDelegate,ActivityDetailCommentTextFiledViewDelegate,RemarkHomeTableViewCellDelegate,CommentRewardsViewHeadViewDelegate>
@property (nonatomic ,strong) UITableView *tableV;
@property (nonatomic ,strong) CommentRewardsViewHeadView *headV;
@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,strong) CommentRewardsModel *model;
@property (nonatomic ,strong) NSArray *commentsArray;
@property (nonatomic, strong) NSMutableArray *layouts;
@property (nonatomic ,strong) UIButton *moreBtn;

@end

static NSString *const cellID = @"CommentRewardsViewCell";
@implementation CommentRewardsView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        _dataArray = [NSMutableArray array];
         _layouts = [NSMutableArray array];
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    UITableView *tableV = [[UITableView alloc] init];
    [self addSubview:tableV];
    [tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self).offset(-52);
    }];
    tableV.bounces = NO;
    tableV.delegate = self;
    tableV.dataSource = self;
    [tableV registerClass:[RemarkHomeTableViewCell class] forCellReuseIdentifier:cellID];
    _tableV = tableV;

    CommentRewardsViewHeadView *headV = [[CommentRewardsViewHeadView alloc] init];
    headV.frame = CGRectMake(0, 0, kMainScreenW, kMainScreenH);
    tableV.tableHeaderView = headV;
    headV.delegate = self;
    _headV = headV;
    
    ActivityDetailCommentTextFiledView *bottomV = [[ActivityDetailCommentTextFiledView alloc] init];
    bottomV.delegate = self;
    [self addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@52);
    }];
    _bottomV = bottomV;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _layouts.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RemarkHomeTableViewCell *cell = [_tableV dequeueReusableCellWithIdentifier:cellID];
    [cell setLayout:_layouts[indexPath.row]];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((RemarkStatusLayout *)_layouts[indexPath.row]).height;
}

#pragma mark - ActivityDetailCommentTextFiledViewDelegate

- (void)clickToRemarkHomeViewController:(UIViewController *)targetVc{
    if ([self.delegate respondsToSelector:@selector(clickToRemarkHomeViewController:)]) {
        [self.delegate clickToRemarkHomeViewController:targetVc];
    }
}

- (void)tabBarViewDidPressShouBton{
    
    if ([self.delegate respondsToSelector:@selector(tabBarViewdidPressShouItem)]) {
        [self.delegate tabBarViewdidPressShouItem];
    }
}

- (void)tabBarViewDidPressZanBton{
    if ([self.delegate respondsToSelector:@selector(tabBarViewdidPressZanItem)]) {
        [self.delegate tabBarViewdidPressZanItem];
    }
}

- (void)tabBarViewDidPressCommentBtonWithType:(NSString *)type linkID:(NSString *)linkID
{
    
}

#pragma mark - RemarkHomeTableViewCellDelegate

- (void)cell:(RemarkHomeTableViewCell *)cell didClickUser:(NSString *)userid{
    if ([self.delegate respondsToSelector:@selector(imageViewClickedtoControllerByUserid:)]) {
        [self.delegate imageViewClickedtoControllerByUserid:userid];
    }
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

- (void)bindCommentRewardsData:(NSDictionary *)models{
        NSMutableArray *dicArray = [NSMutableArray array];
        for (NSDictionary *dic in models) {
            if ([[NSString nullToString:dic] isEqual:@"activity"]) {
                
                NSDictionary *dicActivity =[models objectForKey:@"activity"];
                [CommentRewardsModel commentRewardsModelReplaced];
                CommentRewardsModel *dicModel = [CommentRewardsModel mj_objectWithKeyValues:dicActivity];
                [dicArray addObject:dicModel];
                
            }else if([[NSString nullToString:dic] isEqualToString:@"comments"]){
                [_layouts removeAllObjects];
                NSArray *dataArray = [models objectForKey:@"comments"];
                NSArray * remarkArray = [Remark mj_objectArrayWithKeyValuesArray:dataArray];
                for (Remark *remark in remarkArray) {
                    RemarkStatusLayout *layout = [[RemarkStatusLayout alloc] initWithStatus:remark];
                    if (layout) {
                        [_layouts addObject:layout];
                    }
                }
            }
            
        _dataArray = dicArray;
    }
    _headV.model = _dataArray[0];
    _bottomV.model = _dataArray[0];
    __weak __typeof__(self) weakself = self;
    _headV.callback = ^(CGFloat height) {
        weakself.headV.frame = CGRectMake(0, 0, kMainScreenW, height);
        weakself.tableV.tableHeaderView = weakself.headV;
    };

    [_tableV reloadData];
    [self addMoreBtn];
}


- (void)addMoreBtn{
    if (_layouts.count > 3) {
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(0, 0, kMainScreenW, 50);
        [moreBtn setTitle:@"查看更多评论>>" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithHexString:@"a6a6a6"] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [moreBtn addTarget:self action:@selector(moreBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        _tableV.tableFooterView = moreBtn;
        _moreBtn = moreBtn;
    }
}

-(void)moreBtnclick: (UIButton *)sender{
    RemarkHomeViewController *vc = [[RemarkHomeViewController alloc] init];
    vc.linkid = self.linkId;
    vc.type = RemarkTypeCommentAwards;
    if ([self.delegate respondsToSelector:@selector(clickToRemarkHomeViewController:)]) {
        [self.delegate clickToRemarkHomeViewController:vc];
    }
}


- (void)updateSubjectViewWithType:(UpdateViewType)type isMinus:(BOOL)minus{
    [_bottomV updateTabBarStatuesWithType:type isMinus:minus];
}

#pragma mark - CommentRewardsViewHeadViewDelegate
- (void)rewardsViewHeadViewWebViewDidClikUrl:(NSString *)link{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickWebViewUrlLink:)]) {
        [self.delegate detailSubjectViewDidCickWebViewUrlLink:link];
    }
}


#pragma mark - setters and getters
- (UIImage *)rewardsImage{
    return _headV.imageV.image;
}
@end
