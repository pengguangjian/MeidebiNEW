//
//  MyGoodsCouponTableViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/24.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyGoodsCouponTableViewController.h"
#import <MJRefresh.h>
#import "MDBEmptyView.h"
#import "MyGoodsCouponTableViewCell.h"
#import "MDB_UserDefault.h"
#import "MyGoodsCouponDataController.h"

@interface MyGoodsCouponTableViewController ()
{
    NSMutableArray *arrdata;
    int ipage;
    
    MyGoodsCouponDataController *datacontrol;
    
}
@property (nonatomic, strong) MDBEmptyView *emptyView;
@end

@implementation MyGoodsCouponTableViewController
-(id)initWithStyle:(UITableViewStyle)style
{
    if(self = [super initWithStyle:UITableViewStyleGrouped])
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ipage = 1;
    
    [self.tableView setBackgroundColor:RGB(249, 249, 249)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ipage = 1;
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ipage++;
        [self loadData];
    }];
    datacontrol = [MyGoodsCouponDataController new];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self emptyView];
    
    [self loadData];
    
}

-(void)loadData
{
    
    NSDictionary *dicpush = @{@"page":[NSString stringWithFormat:@"%d",ipage],@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"listtype":_specialType};
    
    [datacontrol requestmyyouhuiListInView:self.view dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if(ipage==1)
        {
            arrdata = [NSMutableArray new];
        }
        if(state)
        {
            
            for(NSDictionary *dic in datacontrol.arrList)
            {
                MyGoodsCouponModel *model = [MyGoodsCouponModel dicValueChangeModelValue:dic];
                model.state = _specialType;
                [arrdata addObject:model];
            }
            
        }
        [_emptyView setHidden:YES];
        if(arrdata.count==0)
        {
            [_emptyView setHidden:NO];
        }
        [self.tableView reloadData];
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strcell = @"MyGoodsCouponTableViewCell";
    MyGoodsCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[MyGoodsCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = arrdata[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


#pragma mark - getter / setter

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH-50)];
        [self.tableView addSubview:_emptyView];
        _emptyView.remindStr = @"暂时还没有数据哦～";
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
