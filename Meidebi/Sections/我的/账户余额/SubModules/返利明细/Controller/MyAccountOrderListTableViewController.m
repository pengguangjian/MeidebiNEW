//
//  MyAccountOrderListTableViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/10.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountOrderListTableViewController.h"
#import <MJRefresh.h>
#import "MDB_UserDefault.h"

#import "MyAccountOrderListTableViewCell.h"

#import "MDBEmptyView.h"

@interface MyAccountOrderListTableViewController ()
{
    int ipage;
    
    
}

@property (nonatomic, strong) MDBEmptyView *emptyView;

@end

@implementation MyAccountOrderListTableViewController

-(id)initWithStyle:(UITableViewStyle)style
{
    if(self = [super initWithStyle:UITableViewStyleGrouped])
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        ipage = 1;
//        [self loadData];
//    }];
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        ipage++;
//        [self loadData];
//    }];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
}

-(void)loadData
{
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strcell = @"MyAccountOrderListTableViewCell";
    MyAccountOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[MyAccountOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 90;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 20)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 80)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbgjname = [[UILabel alloc] init];
    [lbgjname setText:@"国际运费金额"];
    [lbgjname setTextAlignment:NSTextAlignmentLeft];
    [lbgjname setTextColor:RGB(150, 150, 150)];
    [lbgjname setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbgjname];
    [lbgjname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(10);
        make.size.sizeOffset(CGSizeMake(150, 15));
    }];
    
    UILabel *lbgjmoney = [[UILabel alloc] init];
    [lbgjmoney setText:@"￥100.00"];
    [lbgjmoney setTextAlignment:NSTextAlignmentLeft];
    [lbgjmoney setTextColor:RGB(0, 0, 0)];
    [lbgjmoney setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:lbgjmoney];
    [lbgjmoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbgjname);
        make.top.equalTo(lbgjname.mas_bottom);
        make.size.sizeOffset(CGSizeMake(150, 30));
    }];
    
    UILabel *lbtime = [[UILabel alloc] init];
    [lbtime setText:@"2019.07.10 18:00:00"];
    [lbtime setTextAlignment:NSTextAlignmentLeft];
    [lbtime setTextColor:RGB(150, 150, 150)];
    [lbtime setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbtime];
    [lbtime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbgjname);
        make.top.equalTo(lbgjmoney.mas_bottom);
        make.size.sizeOffset(CGSizeMake(150, 15));
    }];
    
    UILabel *lbyuguname = [[UILabel alloc] init];
    [lbyuguname setText:@"预估收入"];///实际收入
    [lbyuguname setTextAlignment:NSTextAlignmentLeft];
    [lbyuguname setTextColor:RGB(150, 150, 150)];
    [lbyuguname setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbyuguname];
    [lbyuguname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_centerX);
        make.top.offset(10);
        make.size.sizeOffset(CGSizeMake(150, 15));
    }];
    UILabel *lbyugumoney = [[UILabel alloc] init];
    [lbyugumoney setText:@"￥10.00"];
    [lbyugumoney setTextAlignment:NSTextAlignmentLeft];
    [lbyugumoney setTextColor:RGB(255, 20, 20)];
    [lbyugumoney setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:lbyugumoney];
    [lbyugumoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbyuguname);
        make.top.equalTo(lbyuguname.mas_bottom);
        make.size.sizeOffset(CGSizeMake(150, 30));
    }];
    
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(223, 223, 223)];
    [view addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.offset(1);
    }];
    return view;
}

#pragma mark - getter / setter

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH-50)];
        [self.tableView addSubview:_emptyView];
        _emptyView.remindStr = @"暂无数据哦，快去分享好友吧";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
