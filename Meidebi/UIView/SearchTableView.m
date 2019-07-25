//
//  SearchTableView.m
//  Meidebi
//
//  Created by 杜非 on 15/2/4.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "SearchTableView.h"
#import "MDB_UserDefault.h"
#import "ContentCell.h"
#import "HTTPManager.h"


@implementation SearchTableView{
    int  _p;
    float  _ScrowContentOffSet;
    NSMutableArray *_arrData;
    NSString *_search;
    
    NSMutableArray *_arrotherData;
    
    ///头部的选项
    NSInteger iheadertag;
    
    int  _firstp;
    NSMutableArray *arrfirstdata;
    NSMutableArray *arrfirstotherdata;
    float firstsc;
    
    int  _secendp;
    NSMutableArray *arrsecenddata;
    NSMutableArray *arrsecendotherdata;
    float secendsc;
    
    int  _theredp;
    NSMutableArray *arrthereddata;
    NSMutableArray *arrtheredotherdata;
    float theredsc;
    
    int  _fourthp;
    NSMutableArray *arrfourthdata;
    NSMutableArray *arrfourthotherdata;
    float fourthsc;
    
    int  _fivep;
    NSMutableArray *arrfivedata;
    NSMutableArray *arrfiveotherdata;
    float fivesc;
    
    NSString *strtype;
    
}
@synthesize reloading=_reloading;
@synthesize foodReloading=_foodReloading;
-(id)initWithFrame:(CGRect)frame search:(NSString *)searchStr  delegate:(id)delegat{
    if (self) {
        self=[super initWithFrame:frame];
    }
    
    strtype = @"0";
    
    _delegate=delegat;
    _firstp = 1;
    _p = _firstp;
    _search=searchStr;
    
//    NSDictionary *dcis=@{@"wd":[NSString nullToString:searchStr],@"p":[NSString stringWithFormat:@"%@",@(_p)],@"limit":@"20",@"t":strtype};
//    _search=searchStr;
//    [HTTPManager sendGETRequestUrlToService:URL_search_h1 withParametersDictionry:dcis view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
//
//        if (responceObjct==nil) {
//            [self setCentloview];
//        }else{
//            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
//            NSDictionary *dicAll=[str JSONValue];
//
//            if ([[dicAll objectForKey:@"info"]isEqualToString:@"EXECUTE_SUCCESS"]) {
//                id link=[[dicAll objectForKey:@"data"] objectForKey:@"results"];
//                NSMutableArray *mutDicArr=[[NSMutableArray alloc]init];
//                if ([link isKindOfClass:[NSArray class]]) {
//                    NSArray *linkarr=(NSArray *)link;
//                    for (NSDictionary * dic in linkarr) {
//                        SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
//                        [mutDicArr addObject:artl];
//                    }
//                    if(iheadertag == 0)
//                    {
//                        arrfirstdata=[NSMutableArray arrayWithArray:mutDicArr];
//                        _arrData = arrfirstdata;
//                    }
//                    else if (iheadertag == 1)
//                    {
//                        arrsecenddata=[NSMutableArray arrayWithArray:mutDicArr];
//                        _arrData = arrsecenddata;
//                    }
//
//
//                    if (_arrData.count>0) {
//
//                    }else{
//
//                        [self setCentloview];
//                    }
//                }else{
//                    [self setCentloview];
//                }
//            }else {
//                [self setCentloview];
//            }
//
//        }
//        [_tableview reloadData];
//
//
//    }];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(_tableview == nil)
    {
        menuview = [[MenuView alloc]initWithFrame:CGRectMake(0, 0, self.width, 47) titles:[NSArray arrayWithObjects:@"全部优惠",@"海淘",@"国内",@"优惠券",@"原创", nil] delegat:self];//@"用户",
        [self addSubview:menuview];
        
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, menuview.bottom, self.width, self.height-menuview.bottom)];
        [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [self reloadTableViewDataSource];
        }];
        _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if(_arrData.count>0)
            {
                [self footReloadTableViewDateSource];
            }
            else
            {
                [_tableview.mj_footer endRefreshing];
            }
            
        }];
        [self addSubview:_tableview];
    }
}
///获取数据
-(void)getdata
{
    NSDictionary *dcis=@{@"wd":[NSString nullToString:_search],@"p":[NSString stringWithFormat:@"%@",@(_p)],@"limit":@"20",@"t":strtype};
    
    [HTTPManager sendGETRequestUrlToService:URL_search_h1 withParametersDictionry:dcis view:self.window completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        
        if (responceObjct==nil) {
            [self setCentloview];
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"EXECUTE_SUCCESS"]) {
                id link=[[dicAll objectForKey:@"data"] objectForKey:@"results"];
                NSMutableArray *mutDicArr=[[NSMutableArray alloc]init];
                if ([link isKindOfClass:[NSArray class]]) {
                    NSArray *linkarr=(NSArray *)link;
                    if(linkarr.count==0)
                    {///没有搜索到数据
                        id hot=[[dicAll objectForKey:@"data"] objectForKey:@"hot"];
                        
                        if ([hot isKindOfClass:[NSArray class]]) {
                            NSArray *hotarr=(NSArray *)hot;
                            NSMutableArray *mutDicArr1=[[NSMutableArray alloc]init];
                            
                            if(iheadertag == 0)
                            {
                                for (NSDictionary * dic in hotarr) {
                                    SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
                                    [mutDicArr1 addObject:artl];
                                }
                                arrfirstotherdata=[NSMutableArray arrayWithArray:mutDicArr1];
                                _arrotherData = arrfirstotherdata;
                            }
                            else if (iheadertag == 1)
                            {
                                for (NSDictionary * dic in hotarr) {
                                    SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
                                    [mutDicArr1 addObject:artl];
                                }
                                arrsecendotherdata=[NSMutableArray arrayWithArray:mutDicArr1];
                                _arrotherData = arrsecendotherdata;
                                
                            }
                            else if (iheadertag == 2)
                            {
                                for (NSDictionary * dic in hotarr) {
                                    SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
                                    [mutDicArr1 addObject:artl];
                                }
                                arrtheredotherdata=[NSMutableArray arrayWithArray:mutDicArr1];
                                _arrotherData = arrtheredotherdata;
                                
                            }
                            else if (iheadertag == 3)
                            {
                                for (NSDictionary * dic in hotarr) {
                                    SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
                                    [mutDicArr1 addObject:artl];
                                }
                                arrfourthdata=[NSMutableArray arrayWithArray:mutDicArr1];
                                _arrotherData = arrfourthdata;
                                
                            }
                            else if (iheadertag == 4)
                            {
                                for (NSDictionary * dic in hotarr) {
                                    SearchYuanChuangModel *artl=[SearchYuanChuangModel modelWithDict:dic];
                                    [mutDicArr addObject:artl];
                                }
                                arrfivedata=[NSMutableArray arrayWithArray:mutDicArr1];
                                _arrotherData = arrfivedata;
                                
                            }
                            else if (iheadertag == 5)
                            {
                                
                                
                            }
                        }
                        
                    }
                    else
                    {///搜索到数据
                        if(iheadertag == 0)
                        {
                            for (NSDictionary * dic in linkarr) {
                                SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
                                [mutDicArr addObject:artl];
                            }
                            arrfirstdata=[NSMutableArray arrayWithArray:mutDicArr];
                            _arrData = arrfirstdata;
                        }
                        else if (iheadertag == 1)
                        {
                            for (NSDictionary * dic in linkarr) {
                                SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
                                [mutDicArr addObject:artl];
                            }
                            arrsecenddata=[NSMutableArray arrayWithArray:mutDicArr];
                            _arrData = arrsecenddata;
                        }
                        else if (iheadertag == 2)
                        {
                            for (NSDictionary * dic in linkarr) {
                                SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
                                [mutDicArr addObject:artl];
                            }
                            arrthereddata=[NSMutableArray arrayWithArray:mutDicArr];
                            _arrData = arrthereddata;
                        }
                        else if (iheadertag == 3)
                        {
                            for (NSDictionary * dic in linkarr) {
                                SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
                                [mutDicArr addObject:artl];
                            }
                            arrfourthdata=[NSMutableArray arrayWithArray:mutDicArr];
                            _arrData = arrfourthdata;
                        }
                        else if (iheadertag == 4)
                        {
                            for (NSDictionary * dic in linkarr) {
                                SearchYuanChuangModel *artl=[SearchYuanChuangModel modelWithDict:dic];
                                [mutDicArr addObject:artl];
                            }
                            arrfivedata=[NSMutableArray arrayWithArray:mutDicArr];
                            _arrData = arrfivedata;
                        }
                        else if (iheadertag == 5)
                        {
                            
//                            arrfourthdata = nil;
//                            _arrData = arrfourthdata;
                        }
                        
                    }
                    
                    
                    
                    
                }
            }
            
        }
        [self setCentloview];
        [_tableview reloadData];
        
        
    }];
    
}

-(void)setCentloview{

//    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-22.0, self.frame.size.height/2.0-60, 44, 44)];
//    imageV.image=[UIImage imageNamed:@"ic_search_result_empty"];
//    [self addSubview:imageV];
//
//    UILabel *labl=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2.0, self.frame.size.width, 40)];
//    [labl setTextAlignment:NSTextAlignmentCenter];
//    labl.text=@"当前没有符合搜索条件的结果";
//    labl.font=[UIFont systemFontOfSize:12.0];
//    [labl setNumberOfLines:2];
//    [self addSubview:labl];
    
    [self drawTabviewHeader];
    
}

////上拉加载
-(void)footReloadTableViewDateSource{
    
    NSDictionary *dcis=@{@"wd":[NSString nullToString:_search],@"p":[NSString stringWithFormat:@"%@",@(_p+1)],@"limit":@"20",@"t":strtype};
    
    [HTTPManager sendGETRequestUrlToService:URL_search_h1 withParametersDictionry:dcis view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            NSLog(@"%@",error);
        }else{
            
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"EXECUTE_SUCCESS"]) {
                NSArray *linkarr=[[dicAll objectForKey:@"data"] objectForKey:@"results"];
                if ([[[dicAll objectForKey:@"data"] objectForKey:@"results"]  isKindOfClass:[NSArray class]]&&linkarr.count>0) {
                    for (NSDictionary * dic in linkarr) {
                        id artl0;
                        BOOL issimbel=NO;
                        if(iheadertag == 0 || iheadertag == 1|| iheadertag == 2|| iheadertag == 3)
                        {
                            SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
                            
                            for (SearchGoodsModel *artls in _arrData) {
                                if ([artls.strid isEqualToString:artl.strid]) {
                                    issimbel=YES;
                                }
                            }
                            artl0 = artl;
                        }
                        else if (iheadertag == 4)
                        {
                            SearchYuanChuangModel *artl=[SearchYuanChuangModel modelWithDict:dic];
                            
                            for (SearchYuanChuangModel *artls in _arrData) {
                                if ([artls.strid isEqualToString:artl.strid]) {
                                    issimbel=YES;
                                }
                            }
                            artl0 = artl;
                        }
                        else if (iheadertag == 5)
                        {
                            
                            
                        }
                        
                        
                        if (!issimbel) {
                            if(artl0 != nil)
                            {
                                [_arrData addObject:artl0];
                            }
                            
                            
                        }
                        
                    }
                    [self doneFootLoadingTableViewData];
                    _p++;
                }else{
                    [MDB_UserDefault showNotifyHUDwithtext:@"没有了" inView:self];
                     _foodReloading=NO;
                    [_tableview.mj_footer endRefreshing];
                }
            }
        }
    }];
    
}

////下拉刷新
- (void)reloadTableViewDataSource{
    if(iheadertag == 0)
    {
        _firstp = 1;
        _p=_firstp;
    }
    else if (iheadertag == 1)
    {
        _secendp = 1;
        _p=_secendp;
    }
    else if (iheadertag == 2)
    {
        _theredp = 1;
        _p=_theredp;
    }
    else if (iheadertag == 3)
    {
        _fourthp = 1;
        _p=_fourthp;
    }
    else if (iheadertag == 4)
    {
        _fivep = 1;
        _p=_fivep;
    }
    
    NSDictionary *dcis=@{@"wd":[NSString nullToString:_search],@"p":[NSString stringWithFormat:@"%@",@(_p)],@"limit":@"20",@"t":strtype};
    
    [HTTPManager sendGETRequestUrlToService:URL_search_h1 withParametersDictionry:dcis view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            [self setCentloview];
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"EXECUTE_SUCCESS"]) {
                id link=[[dicAll objectForKey:@"data"] objectForKey:@"results"];
                NSMutableArray *mutDicArr=[[NSMutableArray alloc]init];
                if ([link isKindOfClass:[NSArray class]]) {
                    NSArray *linkarr=(NSArray *)link;
                    
                    if(iheadertag == 0)
                    {
                        for (NSDictionary * dic in linkarr) {
                            SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
                            [mutDicArr addObject:artl];
                        }
                        arrfirstdata=[NSMutableArray arrayWithArray:mutDicArr];
                        _arrData = arrfirstdata;
                    }
                    else if (iheadertag == 1)
                    {
                        for (NSDictionary * dic in linkarr) {
                            SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
                            [mutDicArr addObject:artl];
                        }
                        arrsecenddata=[NSMutableArray arrayWithArray:mutDicArr];
                        _arrData = arrsecenddata;
                    }
                    else if (iheadertag == 2)
                    {
                        for (NSDictionary * dic in linkarr) {
                            SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
                            [mutDicArr addObject:artl];
                        }
                        arrthereddata=[NSMutableArray arrayWithArray:mutDicArr];
                        _arrData = arrthereddata;
                    }
                    else if (iheadertag == 3)
                    {
                        for (NSDictionary * dic in linkarr) {
                            SearchGoodsModel *artl=[SearchGoodsModel modelWithDict:dic];
                            [mutDicArr addObject:artl];
                        }
                        arrfourthdata=[NSMutableArray arrayWithArray:mutDicArr];
                        _arrData = arrfourthdata;
                        
                    }
                    else if (iheadertag == 4)
                    {
                        for (NSDictionary * dic in linkarr) {
                            SearchYuanChuangModel *artl=[SearchYuanChuangModel modelWithDict:dic];
                            [mutDicArr addObject:artl];
                        }
                        arrfivedata=[NSMutableArray arrayWithArray:mutDicArr];
                        _arrData = arrfivedata;
                        
                    }
                    [self setCentloview];
                    
                }else{
                    [self setCentloview];
                }
            }else {
                [self setCentloview];
            }
            
        }
        [self doneLoadingTableViewData];
        [_tableview reloadData];
        
    }];
    
    
}

#pragma maek - 搜索数据为空时头部展示
-(void)drawTabviewHeader
{
    
    if(_arrData.count > 0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableview.width, 0.1)];
        [_tableview setTableHeaderView:view];
    }
    else
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableview.width, 150)];
        [view setBackgroundColor:[UIColor whiteColor]];
        UILabel *lbmessage = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height)];
        [lbmessage setText:@"ops！没有找到相关数据呢！"];
        [lbmessage setTextColor:RGB(30, 30, 30)];
        [lbmessage setTextAlignment:NSTextAlignmentCenter];
        [lbmessage setFont:[UIFont systemFontOfSize:14]];
        [view addSubview:lbmessage];
        UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, view.width, 1)];
        [viewline setBackgroundColor:RGBAlpha(239, 239, 239, 1)];
        [view addSubview:viewline];
        [_tableview setTableHeaderView:view];
    }
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_tableview reloadData];
    [_tableview.mj_header endRefreshing];
}

-(void)doneFootLoadingTableViewData{
    _foodReloading=NO;
    [_tableview reloadData];
    [_tableview.mj_footer endRefreshing];
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
      _ScrowContentOffSet=scrollView.contentOffset.y;
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _ScrowContentOffSet=scrollView.contentOffset.y;
    
    if(iheadertag == 0)
    {
        firstsc =scrollView.contentOffset.y;
    }
    else if (iheadertag == 1)
    {
        secendsc =scrollView.contentOffset.y;
    }
    else if (iheadertag == 2)
    {
        theredsc =scrollView.contentOffset.y;
    }
    else if (iheadertag == 3)
    {
        fourthsc =scrollView.contentOffset.y;
    }
    else if (iheadertag == 4)
    {
        fivesc =scrollView.contentOffset.y;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.delegate tabViewBeginDragging];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_arrotherData.count > 0)
    {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_arrotherData.count > 0)
    {
        if(section == 0)
        {
            return _arrData.count;
        }
        else
        {
            return _arrotherData.count;
        }
    }
    else
    {
        return _arrData.count;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0)
    {
        if(iheadertag == 0 || iheadertag == 1|| iheadertag == 2|| iheadertag == 3)
        {
            static NSString *strcell = @"SearchGoodsTableViewCell";
            SearchGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
            if(!cell)
            {
                cell = [[SearchGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
            }
            cell.model = _arrData[indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
        else if (iheadertag == 4)
        {
            
            static NSString *strcell = @"SearchYuanChuangTableViewCell";
            SearchYuanChuangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
            if(!cell)
            {
                cell = [[SearchYuanChuangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
            }
            
            cell.model = _arrData[indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
            
        }
        else if (iheadertag == 5)
        {
            
            static NSString *strcell = @"SearchUserTableViewCell";
            SearchUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
            if(!cell)
            {
                cell = [[SearchUserTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
            }
            
            cell.model = _arrData[indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
    }
    else
    {
        static NSString *strcell = @"SearchGoodsTableViewCell";
        SearchGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
        if(!cell)
        {
            cell = [[SearchGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
        }
        cell.model = _arrotherData[indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    ////6.2.1搜索结果cell
    ContentCell *cell = [self setCellWithBool:YES indexPath:indexPath tableview:tableView];
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(ContentCell *)setCellWithBool:(BOOL)boolCell indexPath:(NSIndexPath *)indexPath tableview:(UITableView *)tableView{
   
    if (_arrData.count>indexPath.row) {
        
    
    Articlel *artiCle=[_arrData objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 119, _tableview.frame.size.width, 1)];
        [lineView setBackgroundColor:RadLineColor];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, CGRectGetWidth(_tableview.frame), cell.frame.size.height);
        [cell addSubview:lineView];
    }
    if (indexPath.row<3) {
        [self setCellWithArt:artiCle cell:cell boos:YES];
    }else{
        [self setCellWithArt:artiCle cell:cell boos:NO];
    }
    
    
    return cell;
    }else{
        static NSString *CellIdentifier = @"Cell";
        
        ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try
    {
        if(indexPath.section == 0)
        {
            //        [_delegate tableViewSelecte:_arrData[indexPath.row]];
            [_delegate tabViewSelectItem:_arrData[indexPath.row] andheadertag:iheadertag];
            if(iheadertag == 0 || iheadertag == 1|| iheadertag == 2|| iheadertag == 3)
            {
                SearchGoodsModel *model = _arrData[indexPath.row];
                model.isSelect = YES;
            }
            else if (iheadertag == 4)
            {
                SearchYuanChuangModel *model = _arrData[indexPath.row];
                model.isSelect = YES;
            }
            else if (iheadertag == 5)
            {
                SearchUserModel *model = _arrData[indexPath.row];
                model.isSelect = YES;
            }
            
            [tableView reloadData];
        }
        else
        {
            //        [_delegate tableViewSelecte:_arrotherData[indexPath.row]];
            [_delegate tabViewSelectItem:_arrotherData[indexPath.row] andheadertag:0];
            SearchGoodsModel *model = _arrotherData[indexPath.row];
            model.isSelect = YES;
            [tableView reloadData];
        }
    }
    @catch (NSException *exc)
    {
        
    }
    @finally
    {
        
        
    }
     
}
-(void)setCellWithArt:(Articlel *)artiCle cell:(ContentCell *)cell boos:(BOOL)bools{
    [cell fetchSearchCellData:artiCle isOption:bools];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_arrotherData.count > 0)
    {
        if(section==0)
        {
            if(_arrData.count > 0)
            {
                return 45;
            }
            else
            {
                return 0.5;
            }
            
        }
        else
        {
             return 45;
        }
    }
    else
    {
        if(section == 0)
        {
            return 45;
        }
        else
        {
            return 0.5;
        }
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 0.5)];
    [view setBackgroundColor:[UIColor whiteColor]];
    if(_arrotherData.count > 0)
    {
        if(section==0)
        {
            if(_arrData.count > 0)
            {
                [view setHeight:45];
                UILabel *lbmessage = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, view.width, view.height)];
                [lbmessage setText:[NSString stringWithFormat:@"关于%@的商品",_search]];
                [lbmessage setTextColor:RGB(30, 30, 30)];
                [lbmessage setTextAlignment:NSTextAlignmentLeft];
                [lbmessage setFont:[UIFont systemFontOfSize:14]];
                [view addSubview:lbmessage];
                return view;
                
            }
            else
            {
                [view setHeight:0.5];
                
                
                return view;
            }
            
        }
        else
        {
            [view setHeight:45];
            UILabel *lbmessage = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, view.width, view.height)];
            [lbmessage setText:@"大家都在买的商品"];
            [lbmessage setTextColor:RGB(30, 30, 30)];
            [lbmessage setTextAlignment:NSTextAlignmentLeft];
            [lbmessage setFont:[UIFont systemFontOfSize:14]];
            [view addSubview:lbmessage];
            
            return view;
        }
    }
    else
    {
        if(section == 0)
        {
            [view setHeight:45];
            NSString *strname = @"商品";
            if(iheadertag == 1)
            {
                strname = @"海淘";
            }
            else if (iheadertag == 2)
            {
                strname = @"国内";
            }
            else if (iheadertag == 3)
            {
                strname = @"优惠券";
            }
            else if (iheadertag == 4)
            {
                strname = @"原创";
            }
            UILabel *lbmessage = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, view.width, view.height)];
            [lbmessage setText:[NSString stringWithFormat:@"关于%@的%@",_search,strname]];
            [lbmessage setTextColor:RGB(30, 30, 30)];
            [lbmessage setTextAlignment:NSTextAlignmentLeft];
            [lbmessage setFont:[UIFont systemFontOfSize:14]];
            [view addSubview:lbmessage];
            return view;
        }
        else
        {
            [view setHeight:0.5];
            
            
            return view;
        }
        
    }
}

//改变行的高度（实现主个代理方法后 rowHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120.0f;
}

#pragma mark - MenuViewDegelate
-(void)MenuSelect:(MenuView *)menu index:(NSInteger)selectIndex title:(NSString *)title
{
    iheadertag = selectIndex;
    if(selectIndex == 0)
    {///全部
        strtype = @"0";
        if(arrfirstdata.count < 1)
        {
            [_tableview setContentOffset:CGPointMake(0, 0)];
            _firstp = 1;
            _p = _firstp;
            _arrData = nil;
            _arrotherData = nil;
            [_tableview reloadData];
            
            [self getdata];
            
        }
        else
        {
            _p = _firstp;
            _arrData = arrfirstdata;
            _arrotherData = arrfirstotherdata;
            [_tableview.tableHeaderView removeFromSuperview];
            _tableview.tableHeaderView = nil;
            [_tableview reloadData];
            [_tableview beginUpdates];
            [_tableview setContentOffset:CGPointMake(0, firstsc) animated:NO];
            [_tableview endUpdates];
            
            
        }
    }
    else if (selectIndex == 1)
    {///海淘
        strtype = @"1";
        if(arrsecenddata.count < 1)
        {
            [_tableview setContentOffset:CGPointMake(0, 0)];
            _secendp = 1;
            _p = _secendp;
            _arrData = nil;
            _arrotherData = nil;
            [_tableview reloadData];
            [self getdata];
        }
        else
        {
            _p = _secendp;
            _arrData = arrsecenddata;
            _arrotherData = arrsecendotherdata;
            [_tableview.tableHeaderView removeFromSuperview];
            _tableview.tableHeaderView = nil;
            [_tableview reloadData];
            
             [_tableview beginUpdates];
            [_tableview setContentOffset:CGPointMake(0, secendsc) animated:NO];
            [_tableview endUpdates];
        }
    }
    else if (selectIndex == 2)
    {///国内
        strtype = @"2";
        if(arrthereddata.count < 1)
        {
            [_tableview setContentOffset:CGPointMake(0, 0)];
            _theredp = 1;
            _p = _theredp;
            _arrData = nil;
            _arrotherData = nil;
            [_tableview reloadData];
            [self getdata];
        }
        else
        {
            _p = _theredp;
            _arrData = arrthereddata;
            _arrotherData = arrtheredotherdata;
            [_tableview.tableHeaderView removeFromSuperview];
            _tableview.tableHeaderView = nil;
            [_tableview reloadData];
            [_tableview beginUpdates];
            [_tableview setContentOffset:CGPointMake(0, theredsc) animated:NO];
            [_tableview endUpdates];
        }
    }
    
    else if (selectIndex == 3)
    {//优惠券
        strtype = @"3";
        if(arrfourthdata.count < 1)
        {
            [_tableview setContentOffset:CGPointMake(0, 0)];
            _fourthp = 1;
            _p = _fourthp;
            _arrData = nil;
            _arrotherData = nil;
            [_tableview reloadData];
            [self getdata];
        }
        else
        {
           _p = _fourthp;
            _arrData = arrfourthdata;
            _arrotherData = arrfourthotherdata;
            [_tableview.tableHeaderView removeFromSuperview];
            _tableview.tableHeaderView = nil;
            [_tableview reloadData];
            [_tableview beginUpdates];
            [_tableview setContentOffset:CGPointMake(0, fourthsc) animated:NO];
            [_tableview endUpdates];
        }
    }
    else if (selectIndex == 4)
    {//原创
        strtype = @"4";
        if(arrfivedata.count < 1)
        {
            [_tableview setContentOffset:CGPointMake(0, 0)];
            _fivep = 1;
            _p = _fivep;
            _arrData = nil;
            _arrotherData = nil;
            [_tableview reloadData];
            [self getdata];
        }
        else
        {
            _p = _fivep;
            _arrData = arrfivedata;
            _arrotherData = arrfiveotherdata;
            [_tableview.tableHeaderView removeFromSuperview];
            _tableview.tableHeaderView = nil;
            [_tableview reloadData];
            [_tableview beginUpdates];
            [_tableview setContentOffset:CGPointMake(0, fivesc) animated:NO];
            [_tableview endUpdates];
        }
    }
    
}


#pragma mark -////更新搜索的词
-(void)loadSearchKeywords:(NSString *)searchKW
{
    
    _search = searchKW;
    
    arrfirstdata = nil;
    arrsecenddata = nil;
    arrthereddata = nil;
    arrfourthdata = nil;
    [_tableview reloadData];
    [self reloadTableViewDataSource];
    
}

@end
