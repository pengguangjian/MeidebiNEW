//
//  OriginalSearchResultViewController.m
//  Meidebi
//  相关标签搜索页面
//  Created by mdb-admin on 2017/9/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OriginalSearchResultViewController.h"
#import "OriginalTableViewCell.h"
#import "MDB_UserDefault.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <MJRefresh/MJRefresh.h>
#import "OriginalDetailViewController.h"
#import "OriginalDatacontroller.h"
#import "ProductInfoDataController.h"
#import "PersonalInfoIndexViewController.h"
#import "MDBEmptyView.h"
static NSString * const kTableViewCellIdentifier = @"cell";
@interface OriginalSearchResultViewController ()
<
OriginalTableViewCellDelegate
>
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, strong) NSArray *originals;
@property (nonatomic, strong) OriginalDatacontroller *datacontroller;
@property (nonatomic, strong) ProductInfoDataController *productDataController;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@end

@implementation OriginalSearchResultViewController
- (instancetype)initWithTagName:(NSString *)tagname{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _tagName = tagname;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _tagName;
    [self.tableView registerClass:[OriginalTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    __weak __typeof__(self) weakself = self;
    weakself.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof__(weakself) strongSelf = weakself;
        [strongSelf lastPage];
    }];
    weakself.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong __typeof__(weakself) strongSelf = weakself;
        [strongSelf nextPage];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData{
    self.tableView.scrollEnabled = NO;
    [self.datacontroller requestOriginalListWithTagName:_tagName
                                             targetView:self.view
                                               callback:^(NSError *error, BOOL state, NSString *describle) {
                                                   self.tableView.scrollEnabled = YES;
                                                   if (self.datacontroller.results.count <= 0) {
                                                       self.emptyView.hidden = NO;
                                                   }else{
                                                       [self renderSubjectView];
                                                   }
    }];
}

- (void)lastPage{
    self.tableView.scrollEnabled = NO;
    [self.datacontroller lastOriginalPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.scrollEnabled = YES;
        if (state) {
            [self renderSubjectView];
        }
    }];
}

- (void)nextPage{
    self.tableView.scrollEnabled = NO;
    [self.datacontroller nextOriginalPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.scrollEnabled = YES;
        if (state) {
            [self renderSubjectView];
        }
    }];
}

- (void)renderSubjectView{
    NSMutableArray *original = [NSMutableArray array];
    for (NSDictionary *dict in self.datacontroller.results) {
        Sharecle *aSharecle = [[Sharecle alloc] initWithDictionary:dict];
        [original addObject:aSharecle];
    }
    _originals = original.mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _originals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OriginalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    cell.delegate = self;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(OriginalTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    [cell bindDataWithModel:_originals[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:kTableViewCellIdentifier cacheByIndexPath:indexPath configuration:^(OriginalTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:[NSString stringWithFormat:@"%@",[(Sharecle *)_originals[indexPath.row] shareid]]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - OriginalTableViewCellDelegate
- (void)tableViewCellDidClickFollowBtn:(OriginalTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.productDataController requestAddFollwDataWithInView:self.view userid:[NSString stringWithFormat:@"%@",[(Sharecle *)_originals[indexPath.row] userid]] callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            NSMutableArray *orginials = [NSMutableArray arrayWithArray:_originals];
            Sharecle *aSharecle = _originals[indexPath.row];
            aSharecle.isFllow = YES;
            [orginials replaceObjectAtIndex:indexPath.row withObject:aSharecle];
            _originals = orginials.mutableCopy;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
    }];
}

- (void)tableViewCellDidClickAvaterImageView:(OriginalTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PersonalInfoIndexViewController *vc = [[PersonalInfoIndexViewController alloc] initWithUserID:[NSString stringWithFormat:@"%@",[(Sharecle *)_originals[indexPath.row] userid]]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewCellDidClickFlageWithItem:(NSDictionary *)item{
    OriginalSearchResultViewController *vc = [[OriginalSearchResultViewController alloc] initWithTagName:item[@"name"]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setters and getters
- (OriginalDatacontroller *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[OriginalDatacontroller alloc] init];
    }
    return _datacontroller;
}

- (ProductInfoDataController *)productDataController{
    if (!_productDataController) {
        _productDataController = [[ProductInfoDataController alloc] init];
    }
    return _productDataController;
}
- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, CGRectGetHeight(self.view.frame))];
        _emptyView.remindStr = @"未查到相符的原创";
        [self.view addSubview:_emptyView];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
@end
