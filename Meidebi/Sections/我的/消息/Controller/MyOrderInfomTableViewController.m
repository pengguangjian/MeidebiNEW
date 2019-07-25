//
//  MyOrderInfomTableViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/11/13.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyOrderInfomTableViewController.h"
#import "MDBEmptyView.h"
#import "MyInformTableViewCell.h"
#import "MDB_UserDefault.h"
#import "HTTPManager.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "MyInformDetailViewController.h"
#import "MyInformMessageDataController.h"

static NSString *const cellID = @"MyInformTableViewCell1";

@interface MyOrderInfomTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *viewbottom;
    UIButton *btalldu;
    UIButton *btdel;
    
    UIButton* btnright;
    
}
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) BOOL isedit;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic , retain) MyInformMessageDataController *datacontrol;

@end

@implementation MyOrderInfomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    self.tableView = [[UITableView alloc] init];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    
    [self.tableView registerClass:[MyInformTableViewCell class] forCellReuseIdentifier:cellID];
    [self setExtraCellLineHidden:self.tableView];
    
    
    
    
    self.page = 1;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page=1;
        
        
//        if(_arrData.count>0)
//        {
//            [self readmessage];
//        }
//        else
//        {
//            [self loadData];
//        }
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page+=1;
        [self loadData];
    }];
    
    [self loadData];
    [self drawbottomView];
    
    [self emptyView];
}

-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
    
    btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    //    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setTitle:@"编辑" forState:UIControlStateNormal];
    [btnright setTitleColor:RGB(120, 120, 120) forState:UIControlStateNormal];
    [btnright.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnright addTarget:self action:@selector(doClickRightAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
}

-(void)doClickRightAction:(UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:@"编辑"])
    {
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        _isedit = YES;
    }
    else
    {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        _isedit = NO;
    }
    [self editAction];
}

-(void)drawbottomView
{
    viewbottom = [[UIView alloc] init];
    [viewbottom setBackgroundColor:RGB(247, 247, 247)];
    [viewbottom setHidden:YES];
    [self.view addSubview:viewbottom];
    [viewbottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
    
    
    btalldu = [[UIButton alloc] init];
    [btalldu setTitle:@"全部已读" forState:UIControlStateNormal];
    [btalldu setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    [btalldu.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [viewbottom addSubview:btalldu];
    [btalldu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(35);
        make.top.offset(10);
        make.height.offset(30);
        make.width.offset(90);
    }];
    [btalldu addTarget:self action:@selector(allduAction) forControlEvents:UIControlEventTouchUpInside];
    [btalldu.layer setMasksToBounds:YES];
    [btalldu.layer setCornerRadius:15];
    [btalldu.layer setBorderColor:RGB(236, 236, 236).CGColor];
    [btalldu.layer setBorderWidth:1];
    
    btdel = [[UIButton alloc] init];
    [btdel setTitle:@"删除" forState:UIControlStateNormal];
    [btdel setTitleColor:RGB(225, 225, 225) forState:UIControlStateNormal];
    [btdel.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [viewbottom addSubview:btdel];
    [btdel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewbottom.mas_right).offset(-25);
        make.top.equalTo(btalldu.mas_top);
        make.height.equalTo(btalldu.mas_height);
        make.width.offset(70);
    }];
    [btdel addTarget:self action:@selector(selectdelAction) forControlEvents:UIControlEventTouchUpInside];
    [btdel.layer setMasksToBounds:YES];
    [btdel.layer setCornerRadius:15];
    [btdel.layer setBorderColor:RGB(236, 236, 236).CGColor];
    [btdel.layer setBorderWidth:1];
}

-(void)doClickLeftAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    BOOL isyou = NO;
    for(MyInformMainModel *model in _arrData)
    {
        if([model.isread integerValue] == 0)
        {
            isyou=YES;
            break;
        }
        
        
    }
    if(isyou==NO)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyInformViewIsOrderRemind" object:nil];
    }
    
    
}

-(void)loadData
{
    NSDictionary *dica=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                         @"p":[NSString stringWithFormat:@"%ld",(long)self.page],
                         @"limit":@"20"
                         };
    
    [HTTPManager sendGETRequestUrlToService:URL_myOrdermessage withParametersDictionry:dica view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:[dicAll objectForKey:@"status"]] isEqualToString:@"1"]) {
                id arrs=[dicAll objectForKey:@"data"];
                if(self.page==1)
                {
                    _arrData = [NSMutableArray new];
                }
                if ([arrs isKindOfClass:[NSArray class]]){
                    for(NSDictionary *dic in arrs)
                    {
                        [_arrData addObject:[MyInformMainModel dicvalueChange:dic]];
                    }
                }
                
            }
            
        }
        [self.tableView reloadData];
        if(_arrData.count==0)
        {
            [self.emptyView setHidden:NO];
        }
        else
        {
            [self.emptyView setHidden:YES];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)editAction
{
    for(MyInformMainModel *model in _arrData)
    {
        model.isselect = NO;
    }
    [self.tableView reloadData];
    [btdel setTitleColor:RGB(225, 225, 225) forState:UIControlStateNormal];
    [btalldu setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    
    if(_isedit)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-50);
            }];
        } completion:^(BOOL finished) {
            
        }];
        
        [viewbottom setHidden:NO];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom);
            }];
        } completion:^(BOOL finished) {
            
        }];
        
        [viewbottom setHidden:YES];
    }
    
    
}

///判断在编辑状态下是否有选中的
-(BOOL)isselectitem
{
    if(_isedit==NO)return NO;
    
    BOOL isyouselect = NO;
    for(MyInformMainModel *model in _arrData)
    {
        if(model.isselect)
        {
            isyouselect = YES;
            break;
        }
    }
    return isyouselect;
}
#pragma mark - 全部已读
-(void)allduAction
{
    if([self isselectitem])
    {
        return;
    }
    if(_datacontrol == nil)
    {
        _datacontrol = [MyInformMessageDataController new];
    }
    NSString *strtoken = [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
    NSDictionary *parameters=@{@"userkey":strtoken,@"id":@"all",@"msg_type":@"order"};
    
    [_datacontrol requestMyInformReadMessageInView:self.view dicpush:parameters Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            for(MyInformMainModel *model in _arrData)
            {
                model.isread = @"1";
            }
            [self.tableView reloadData];
            _isedit = NO;
            [btnright setTitle:@"编辑" forState:UIControlStateNormal];
            [self editAction];
            
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
        
    }];
    
    
    
}
#pragma mark - 删除选中
-(void)selectdelAction
{
    if([self isselectitem] == NO)
    {
        return;
    }
    
    if([self isselectitem] == NO)
    {
        return;
    }
    NSString *strtemp = @"";
    NSMutableArray *arrtemp = [NSMutableArray new];
    for(MyInformMainModel *model in _arrData)
    {
        if(model.isselect)
        {
            if(strtemp.length <1)
            {
                strtemp = [NSString stringWithFormat:@"%@",model.did];
            }
            else
            {
                strtemp = [NSString stringWithFormat:@"%@,%@",strtemp,model.did];
            }
            [arrtemp addObject:model];
            
        }
    }
    if(_datacontrol == nil)
    {
        _datacontrol = [MyInformMessageDataController new];
    }
    
    
    NSDictionary *parameters = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"id" : strtemp};
    [_datacontrol requestMyInformDelMessageInView:self.view dicpush:parameters Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [_arrData removeObjectsInArray:arrtemp];
            [_tableView reloadData];
            
            _isedit = NO;
            [btnright setTitle:@"编辑" forState:UIControlStateNormal];
            [self editAction];
            
            if(_arrData.count<20)
            {
                self.page+=1;
                [self loadData];
            }
            
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
        
    }];

    
    
    
}

#pragma mark - Table view data source
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    MyInformTableViewCell *cell = [self setCellWithBool:NO indexPath:indexPath tableview:tableView];
    MyInformTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.isedit = _isedit;
    cell.model = _arrData[indexPath.row];
    
    return cell;
    
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
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isedit)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        NSMutableArray *arrayOfRows = [NSMutableArray arrayWithArray:_arrData];
        if (indexPath.row<[arrayOfRows count]) {
            __weak __typeof__(self) weakself = self;
            MyInformMainModel *model = _arrData[indexPath.row];
            NSDictionary *parameters = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                         @"id" : [NSString nullToString:model.did]};
            [HTTPManager sendRequestUrlToService:URL_DelMessage withParametersDictionry:parameters view:self.view.window completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                BOOL state = NO;
                NSString *describle = @"";
                if (responceObjct==nil) {
                    describle = @"网络错误";
                }else{
                    NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                    NSDictionary *dicAll=[str JSONValue];
                    if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                        state = YES;
                    }
                    describle = [dicAll objectForKey:@"info"];
                }
                
                
                if (state) {
                    __strong __typeof__(weakself) strongself = weakself;
                    [arrayOfRows removeObjectAtIndex:indexPath.row];
                    strongself.arrData = arrayOfRows.mutableCopy;
                    @try
                    {
                        if(arrayOfRows.count>0)
                        {
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        }
                        else
                        {
                            [tableView reloadData];
                            [self loadData];
                        }
                        
                    }
                    @catch(NSException *exc)
                    {
                        
                    }
                    @finally
                    {
                        
                    }
                    
                }else{
                    @try
                    {
                        if(arrayOfRows.count>0)
                        {
                            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
                        }
                        else
                        {
                            [tableView reloadData];
                        }
                        
                    }
                    @catch(NSException *exc)
                    {
                        
                    }
                    @finally
                    {
                        
                    }
                    
                }
                
                if(_arrData.count==0)
                {
                    [self.emptyView setHidden:NO];
                }
                else
                {
                    [self.emptyView setHidden:YES];
                }
                
            }];
            
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInformMainModel *model = _arrData[indexPath.row];
    if(_isedit)
    {
        if(model.isselect)
        {
            model.isselect = NO;
        }
        else
        {
            model.isselect = YES;
        }
        BOOL isyou = [self isselectitem];
        if(isyou)
        {
            [btalldu setTitleColor:RGB(225, 225, 225) forState:UIControlStateNormal];
            [btdel setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
        }
        else
        {
            [btdel setTitleColor:RGB(225, 225, 225) forState:UIControlStateNormal];
            [btalldu setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
        }
        [tableView reloadData];
    }
    else
    {
        
        MyInformTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textL.textColor = [UIColor colorWithHexString:@"#666666"];
        model.isread = @"1";
        MyInformDetailViewController *myInformDetailVc = [[MyInformDetailViewController alloc] init];
        myInformDetailVc.dataDic = model.dicall;
        [self.navigationController pushViewController:myInformDetailVc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106 *kScale;
}

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, kTopHeight, kMainScreenW, kMainScreenH-kTopHeight)];
        _emptyView.remindStr = @"暂时没有数据哦～";
        [self.view addSubview:_emptyView];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
/*
-(void)readmessage{
    NSString *strl = @"";
    for (NSDictionary *dic in _arrData) {
        if ([dic[@"isread"] isEqualToString:@"0"]) {
            strl=[strl stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"id"]]];
        }
    }
    if (strl) {
        NSString *strtoken = [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
        NSDictionary *dica=@{@"userkey":strtoken,@"id":strl};
        [HTTPManager sendRequestUrlToService:URL_readmessage withParametersDictionry:dica view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            if (responceObjct==nil) {
                
            }else{
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dicAll=[str JSONValue];
                if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                    [MDB_UserDefault setMessage:NO];
                    
                }
            }
            [self loadData];
        }];
        
    }
}
*/

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
