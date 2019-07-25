//
//  RemarkTableViewController.m
//  Meidebi
//
//  Created by mdb-admin on 16/6/20.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "RemarkTableViewController.h"
#import "RemarkDataController.h"
#import "MDB_UserDefault.h"
#import <FCUUID/FCUUID.h>
#import <MJRefresh/MJRefresh.h>
#import "HTTPManager.h"
static NSString *cellidentifier = @"cell";
static NSString *myRemarkCellIdentifier = @"myremarkcell";
@interface RemarkTableViewController ()
<
UITextViewDelegate,
RemarkTableViewMyRemarkCellDelegate
>
@property (nonatomic, strong) RemarkDataController *dataController;

@end

@implementation RemarkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MDB_UserDefault setComment:NO];
    [self.tableView registerClass:[RemarkTableViewMyRemarkCell class] forCellReuseIdentifier:myRemarkCellIdentifier];
     _dataController = [[RemarkDataController alloc] init];
    [self setExtraCellLineHidden:self.tableView];
    [self fetchSubjectData];
    [self tableViewAddRefersh];
    if (_remarkType == RemarkMenuTypeReply) {
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//        lpgr.minimumPressDuration = .5;
        [self.tableView addGestureRecognizer:lpgr];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableViewAddRefersh{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadTableViewDataSource];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footReloadTableViewDateSource];
    }];
    
}

- (void)fetchSubjectData{
    
    RemarkDataType dataType;
    if (_remarkType == RemarkMenuTypeComment) {
        dataType = RemarkDataTypeNormal;
    }else {
        dataType = RemarkDataTypeReply;
    }
    [_dataController requestSubjectDataWithType:dataType
                                         InView:self.view
                                       callback:^(NSError *error, BOOL state, NSString *describle) {
        if (!error) {
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyInformViewIsRemind" object:nil];
        }
    }];
}

- (void)reloadTableViewDataSource{
    [self.dataController lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (!error) {
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)footReloadTableViewDateSource{
    [self.dataController nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (!error) {
            [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer  //长按响应函数
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint p = [gestureRecognizer locationInView:self.tableView ];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];//获取响应的长按的indexpath
        if (self.dataController.requestResults.count-1>=indexPath.row) {
            PersonalRemark *_aRemark = [(PersonalRemarkLayout *)self.dataController.requestResults[indexPath.row] status];
            if ([self.delegate respondsToSelector:@selector(remarkTableViewVc:didClickReply:)]) {
                [self.delegate remarkTableViewVc:self didClickReply:_aRemark];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataController.requestResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RemarkTableViewMyRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:myRemarkCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell setLayout:self.dataController.requestResults[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((PersonalRemarkLayout *)_dataController.requestResults[indexPath.row]).height;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.delegate respondsToSelector:@selector(remarkTableViewVc:didSelectRowWithProductId:remarkType:)]) {
//        [self.delegate remarkTableViewVc:self didSelectRowWithProductId:self.dataController.requestResults[indexPath.row][@"fromid"] remarkType:self.dataController.requestResults[indexPath.row][@"fromtype"]] ;
//    }
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(remarkTableViewVcScrollViewDidDragging)]) {
        [self.delegate remarkTableViewVcScrollViewDidDragging];
    }
}


#pragma mark - RemarkHomeTableViewCellDelegate
- (void)cellDidClick:(RemarkTableViewMyRemarkCell *)cell{
    if ([self.delegate respondsToSelector:@selector(remarkTableViewVc:didSelectRowWithProductId:remarkType:)]) {
        [self.delegate remarkTableViewVc:self didSelectRowWithProductId:cell.statusView.layout.status.fromid remarkType:cell.statusView.layout.status.fromtype] ;
    }
}

- (void)cell:(RemarkTableViewMyRemarkCell *)cell didClickImageAtIndex:(NSUInteger)index{
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    PersonalRemark *status = cell.statusView.layout.status;
    NSArray *pics = status.pics;
    
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        UIView *imgView = cell.statusView.picViews[i];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = [NSURL URLWithString:[NSString nullToString:pics[i][@"orgin"]]];
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

- (void)cell:(RemarkTableViewMyRemarkCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange{
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;
    if (info[kWBLinkURLName]) {
        NSString *url = info[kWBLinkURLName];
        if ([self.delegate respondsToSelector:@selector(remarkTableViewVc:didSelectRowWithProductId:remarkType:)]) {
            [self.delegate remarkTableViewVc:self didClickUrl:url];
        }
    }
}

@end
