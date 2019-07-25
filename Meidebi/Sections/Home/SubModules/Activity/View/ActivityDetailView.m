//
//  ActivityDetailView.m
//  Meidebi
//
//  Created by fishmi on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ActivityDetailView.h"
#import "ActivityConcernView.h"
#import "ActivityCommendHeadView.h"
#import "RemarkHomeTableViewCell.h"
#import "ActivityDetailModel.h"
#import <MJExtension/MJExtension.h>
#import "RemarkHomeViewController.h"
#import "PersonalInfoIndexViewController.h"

#import "MDB_UserDefault.h"
#import "HTTPManager.h"

@interface ActivityDetailView ()<UITableViewDelegate,UITableViewDataSource,ActivityDetailCommentTextFiledViewDelegate,RemarkHomeTableViewCellDelegate,ActivityCommendHeadViewDelegate>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIControl *moreCommendBtn;
@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,strong) NSMutableArray *layouts;
@property (nonatomic ,strong) ActivityCommendHeadView *activityCommendHeadV;
@property (nonatomic ,strong) UIButton *moreBtn;

@end
static NSString *const cellID = @"RemarkHomeTableViewCell";
@implementation ActivityDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _layouts = [NSMutableArray array];
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    
     UITableView *tableView = [[UITableView alloc] init];
    tableView.bounces = YES;
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
       make.bottom.equalTo(self).offset(-52);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[RemarkHomeTableViewCell class] forCellReuseIdentifier:cellID];
    self.tableView = tableView;
    UIView *view = [[UIView alloc] init];
    tableView.tableFooterView = view;

    
    ActivityDetailCommentTextFiledView *bottomV = [[ActivityDetailCommentTextFiledView alloc] init];
    
    bottomV.delegate = self;
    
    [self addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@52);
    }];
    _bottomV = bottomV;
    _bottomV.hidden = YES;
    
    ActivityCommendHeadView *activityCommendHeadV = [[ActivityCommendHeadView alloc] init];
    activityCommendHeadV.delegate = self;
    activityCommendHeadV.frame = CGRectMake(0, 0, kMainScreenW, kMainScreenH);
    _tableView.tableHeaderView = activityCommendHeadV;
    _activityCommendHeadV = activityCommendHeadV;
    _activityCommendHeadV.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RemarkHomeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    [cell setLayout:_layouts[indexPath.row]];
    cell.delegate = self;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((RemarkStatusLayout *)_layouts[indexPath.row]).height;
}

#pragma  mark - btn点击事件

- (void)respondEvent:(UIButton *)sender{
    _moreCommendBtn.alpha = 0;
    [_moreCommendBtn removeFromSuperview];
    _tableView.scrollEnabled = YES;
    
}

#pragma mark - RemarkHomeTableViewCellDelegate
///用户点击了赞
-(void)cell:(RemarkHomeTableViewCell *)cell disClickZan:(Remark *)strid
{
    
    if (![MDB_UserDefault defaultInstance].usertoken){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        return;
    }
    
    NSDictionary *pramr=@{@"id":[NSString stringWithFormat:@"%@",strid.comentid],
                          @"type":[NSString stringWithFormat:@"%@",@(1)],
                          @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    
    [HTTPManager sendRequestUrlToService:URL_commentvote withParametersDictionry:pramr view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        
        
    }];
}
- (void)cell:(RemarkHomeTableViewCell *)cell didClickUser:(NSString *)userid{
    PersonalInfoIndexViewController *personalInfoIndexVc = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    if ([self.delegate respondsToSelector:@selector(imageViewClickedtoController:)]) {
        [self.delegate imageViewClickedtoController:personalInfoIndexVc];
    }
}

#pragma mark - ActivityCommendHeadViewDelegate

- (void)detailSubjectViewDidCickAddFollowWithUserid:(NSString *)userid didComplete:(void (^)(BOOL))didComplete{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickAddFollowWithUserid:didComplete:)]) {
        [self.delegate detailSubjectViewDidCickAddFollowWithUserid:userid didComplete:^(BOOL status) {
            didComplete(status);
        }];
    }
}

-(void)imageViewClickedtoController:(UIViewController *)targetVc{
    if ([self.delegate respondsToSelector:@selector(imageViewClickedtoController:)]) {
        [self.delegate imageViewClickedtoController:targetVc];
    }
}

- (void)webViewDidPreseeUrlWithLink:(NSString *)link{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickWebViewUrlLink:)]) {
        [self.delegate detailSubjectViewDidCickWebViewUrlLink:link];
    }
}
#pragma  mark - ActivityDetailCommentTextFiledViewDelegate

- (void)clickToRemarkHomeViewController:(RemarkHomeViewController *)targetVc{
    targetVc.type = RemarkTypeAccumulate;
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

- (void)tabBarViewDidPressCommentBtonWithType:(NSString *)type linkID:(NSString *)linkID{
    if ([self.delegate respondsToSelector:@selector(tabBarViewdidPressCommentItemWithType:linkID:)]) {
        [self.delegate tabBarViewdidPressCommentItemWithType:type linkID:linkID];
    }
}

- (void)updateSubjectViewWithType:(UpdateViewType)type isMinus:(BOOL)minus{
    [_bottomV updateTabBarStatuesWithType:type isMinus:minus];
}

- (void)bindActivityDetailData:(NSDictionary *)models{
    NSMutableArray *dicArray = [NSMutableArray array];
    for (NSDictionary *dic in models) {
        if ([[NSString nullToString:dic] isEqual:@"activityjoin"]) {
            NSDictionary *dicActivity =[models objectForKey:@"activityjoin"];
            [ActivityDetailModel activityKeyReplace];
            ActivityDetailModel *dicModel = [ActivityDetailModel mj_objectWithKeyValues:dicActivity];
            [dicArray addObject:dicModel];
        }else if([[NSString nullToString:dic] isEqualToString:@"comments"]){
            [_layouts removeAllObjects];
            NSArray *dataArray = [models objectForKey:@"comments"];
            NSArray * remarkArray = [Remark mj_objectArrayWithKeyValuesArray:dataArray];
            for (Remark *remark in remarkArray) {
                remark.content = [remark.content stringByAppendingString:@" "];
                RemarkStatusLayout *layout = [[RemarkStatusLayout alloc] initWithStatus:remark];
                if (layout) {
                    [_layouts addObject:layout];
                }
            }
        }
    }
    _activityCommendHeadV.hidden = NO;
    _bottomV.hidden = NO;
    _dataArray = dicArray;
    if(_dataArray.count>0)
    {
        _activityCommendHeadV.model = _dataArray[0];
        _bottomV.model = _dataArray[0];
    }
    __weak __typeof__(self) weakself = self;
    _activityCommendHeadV.callback = ^(CGFloat height) {
        weakself.activityCommendHeadV.frame = CGRectMake(0, 0, kMainScreenW, height);
        weakself.tableView.tableHeaderView = weakself.activityCommendHeadV;
    };
    _activityCommendHeadV.imageDownload = ^(UIImage *image) {
        _participationImage = image;
    };
    [_tableView reloadData];
    [self addMoreBtn];
}

- (void)addMoreBtn{
    if(_dataArray.count>0)
    {
        if ([(ActivityDetailModel *)_dataArray.firstObject commentcount].integerValue > 3) {
            UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            moreBtn.frame = CGRectMake(0, 0, kMainScreenW, 50);
            [moreBtn setTitle:@"查看更多评论>>" forState:UIControlStateNormal];
            [moreBtn setTitleColor:[UIColor colorWithHexString:@"a6a6a6"] forState:UIControlStateNormal];
            moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [moreBtn addTarget:self action:@selector(moreBtnclick:) forControlEvents:UIControlEventTouchUpInside];
            _tableView.tableFooterView = moreBtn;
            _moreBtn = moreBtn;
        }
    }
    
}

-(void)moreBtnclick: (UIButton *)sender{
    RemarkHomeViewController *vc = [[RemarkHomeViewController alloc] init];
    vc.linkid = self.linkId;
    vc.type = RemarkTypeNormal;
    if ([self.delegate respondsToSelector:@selector(clickToRemarkHomeViewController:)]) {
        [self.delegate clickToRemarkHomeViewController:vc];
    }
}


@end
