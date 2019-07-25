//
//  SpecialTableViewController.m
//  Meidebi
//  热门专题更多列表页面
//  Created by mdb-admin on 2017/5/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SpecialTableViewController.h"
#import "SpecialTableViewCell.h"
#import "SpecialDataController.h"
#import <MJRefresh/MJRefresh.h>
#import "MDBEmptyView.h"
static NSString * const kTableViewCellIdentifier = @"cell";
@interface SpecialTableViewController ()

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) CGFloat tableContentMaxSetOff;
@property (nonatomic, assign) CGFloat lastContentOffSet;
@property (nonatomic, assign) NSInteger scorllDownSum;
@property (nonatomic, assign) NSInteger scorllUpSum;
@property (nonatomic, strong) NSArray *specials;
@property (nonatomic, assign) CGFloat kSpecialTableCellRowHeight;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@property (nonatomic, strong) SpecialDataController *datacontroller;
@end

@implementation SpecialTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _kSpecialTableCellRowHeight = IS_IPHONE_WIDE_SCREEN ? (kMainScreenW*.61) : (kMainScreenW*.63);
    [self.tableView registerClass:[SpecialTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
     self.tableView.separatorColor = [UIColor colorWithHexString:@"#E7E7E7"];
     self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self refreshFooter];
    }];
    [self setExtraCellLineHidden:self.tableView];
     self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)loadData{
    [self.datacontroller requestSpecialListInView:self.view
                                             type:_specialType
                                         callback:^(NSError *error, BOOL state, NSString *describle) {
                                             if (self.datacontroller.requestResults.count > 0) {
                                                 self.emptyView.hidden = YES;
                                                 [self bindData];
                                             }else{
                                                 self.emptyView.hidden = NO;
                                             }
    }];
}

- (void)refreshFooter{
    [self.datacontroller nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        [self.tableView.mj_footer endRefreshing];
        if (state) {
            [self bindData];
        }
    }];
   
}

- (void)bindData{
    NSMutableArray *specails = [NSMutableArray array];
    for (NSDictionary *dict in self.datacontroller.requestResults) {
        SpecialViewModel *viewModel = [SpecialViewModel viewModelWithSubject:dict];
        if (viewModel) {
            [specails addObject:viewModel];
        }
    }
     _specials = specails.mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _specials.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell bindSpeicalWithModel:_specials[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _kSpecialTableCellRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([(SpecialViewModel *)_specials[indexPath.row] style] == SpecialSourceStyleInner) {
        if ([self.delegate respondsToSelector:@selector(tableviewDidClickCellWithSpecialID:)]) {
            [self.delegate tableviewDidClickCellWithSpecialID:[_specials[indexPath.row] specialID]];
        }
    }else if ([(SpecialViewModel *)_specials[indexPath.row] style] == SpecialSourceStyleTaobao) {
        if ([self.delegate respondsToSelector:@selector(tableviewDidClickCellWithTBSpecialContent:)]) {
            [self.delegate tableviewDidClickCellWithTBSpecialContent:[_specials[indexPath.row] tbContent]];
        }
    }
    
}

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



#pragma mark - setters and getters
- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH-kTopHeight)];
        [self.view addSubview:_emptyView];
        _emptyView.remindStr = @"没有查到相关热门专题";
    }
    return _emptyView;
}

- (SpecialDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[SpecialDataController alloc] init];
    }
    return _datacontroller;
}

- (void)setSpecialType:(NSString *)specialType{
    _specialType = specialType;
    _specials= nil;
    [self.tableView reloadData];
    [self loadData];
}

@end
