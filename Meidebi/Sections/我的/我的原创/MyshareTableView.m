//
//  MyshareTableView.m
//  Meidebi
//
//  Created by 杜非 on 15/2/10.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MyshareTableView.h"
#import "MDB_UserDefault.h"
#import "MyShareTableViewCell.h"
#import "HTTPManager.h"
#import "Photoscle.h"
#import "FMDBHelper.h"

//@implementation MarkedwithPhoto
//
//@end

@implementation MyshareTableView{
    int  _p;
    NSMutableArray *_mutMarkArr;
}
/*
//@synthesize arrData=_arrData;
//@synthesize reloading=_reloading;
//@synthesize foodReloading=_foodReloading;
//@synthesize delegate=_delegate;

-(id)initWithFrame:(CGRect)frame delegate:(id)delegat{
    if (self) {
        self=[super initWithFrame:frame];
    }
    _mutMarkArr=[[NSMutableArray alloc]init];
//    NSArray *makeArr=[[FMDBHelper shareInstance] findMarkTable];
//    for (Marked *mark in makeArr) {
//        NSArray * mutphotoCles= [[FMDBHelper shareInstance] findMarkPhotoWithFormat:mark.markedid];
//        Photoscle *photos;
//        if (mutphotoCles&&mutphotoCles.count>0) {
//            photos =mutphotoCles[0];
//        }
//        MarkedwithPhoto *markPhoto=[[MarkedwithPhoto alloc]init];
//        markPhoto.mark=mark;
//        markPhoto.photoData=photos.pdata;
//        [_mutMarkArr insertObject:markPhoto atIndex:0];
//    }
    
    UIView *vies=[[UIView alloc]initWithFrame:CGRectMake(0, 80, 20, 20)];
    [self addSubview:vies];
    _delegate=delegat;
    _p=1;
    _arrData=[[NSMutableArray alloc]init];
    NSDictionary *dic=@{@"userkey":[MDB_UserDefault defaultInstance].usertoken,@"page":@"1",@"limit":@"20"};
    [HTTPManager sendRequestUrlToService:URL_myshoppingexp withParametersDictionry:dic view:self completeHandle:^(AFHTTPRequestOperation *opration, id responceObjct, NSError *error) {
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                id arrdic=[dicAll objectForKey:@"data"];
                if ([arrdic isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dicmanage in arrdic) {
                        [_arrData addObject:dicmanage];
                    }
                }
            }
            if (_arrData.count>0||_mutMarkArr.count>0) {
                _p++;
                _tableview=[[UITableView alloc]init];
                [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                _tableview.delegate=self;
                _tableview.dataSource=self;
                _tableview.estimatedRowHeight = 0;
                _tableview.estimatedSectionFooterHeight = 0;
                _tableview.estimatedSectionHeaderHeight = 0;
                _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [self reloadTableViewDataSource];
                }];
                _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [self footReloadTableViewDateSource];
                }];
                [self addSubview:_tableview];
                [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self);
                }];
            }else{
                [self setTitle];
            }
        
        }
    }];
    
    
    return self;
}
-(void)setTitle{
    UILabel *las=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenW/2.0-70.0, kMainScreenH/2.0-40.0, 140.0, 20.0)];
    las.textAlignment=NSTextAlignmentCenter;
    las.text=@"当前没有原创";
    [self addSubview:las];
}

-(void)footReloadTableViewDateSource{
    _foodReloading=YES;
    NSDictionary *dic=@{@"userkey":[MDB_UserDefault defaultInstance].usertoken,@"page":[NSString stringWithFormat:@"%i",_p],@"limit":@"20"};
    [HTTPManager  sendRequestUrlToService:URL_myshoppingexp withParametersDictionry:dic view:self completeHandle:^(AFHTTPRequestOperation *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            [self doneFootLoadingTableViewData];
        }else{
            
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                _p++;
                id arrdic=[dicAll objectForKey:@"data"];
                
                if ([arrdic isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dicmanage in arrdic) {
                        BOOL   isle=YES;
                        for (NSDictionary *dill in _arrData) {
                            if ([[NSString stringWithFormat:@"%@",[dicmanage objectForKey:@"id"]]isEqualToString:[NSString stringWithFormat:@"%@",[dill objectForKey:@"id"]]]) {
                                isle=NO;
                            }
                        }
                        if (isle) {
                            [_arrData addObject:dicmanage];
                        }
                        
                    }
                }
                [self doneFootLoadingTableViewData];
            }
            
        }
    }];
    
}
- (void)reloadTableViewDataSource{
    
    [_mutMarkArr removeAllObjects];
    
    NSArray *makeArr=[[FMDBHelper shareInstance] findMarkTable];
    for (Marked *mark in makeArr) {
        NSArray * mutphotoCles= [[FMDBHelper shareInstance] findMarkPhotoWithFormat:mark.markedid];
        Photoscle *photos;
        if (mutphotoCles&&mutphotoCles.count>0) {
            photos =mutphotoCles[0];
        }
        MarkedwithPhoto *markPhoto=[[MarkedwithPhoto alloc]init];
        markPhoto.mark=mark;
        markPhoto.photoData=photos.pdata;
        [_mutMarkArr insertObject:markPhoto atIndex:0];
    }
    
    _reloading=YES;

    NSDictionary *dic=@{@"userkey":[MDB_UserDefault defaultInstance].usertoken,@"page":@"1",@"limit":@"20"};
    [HTTPManager  sendRequestUrlToService:URL_myshoppingexp withParametersDictionry:dic view:self completeHandle:^(AFHTTPRequestOperation *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
             [self doneLoadingTableViewData];
        }else{
            
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            _p=2;
            [_arrData removeAllObjects];
            
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                id arrdic=[dicAll objectForKey:@"data"];
                
                if ([arrdic isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dicmanage in arrdic) {
                        
                        [_arrData addObject:dicmanage];
                    }
                }
                [self doneLoadingTableViewData];
            }
          
        }
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int s=_mutMarkArr.count>0?1:0;
    int l=_arrData.count>0?1:0;
    return l+s;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_mutMarkArr.count>0) {
        if (section==0) {
            return _mutMarkArr.count;
        }else if (section==1){
            return _arrData.count;
        }
    }else{
            return _arrData.count;
    }
    return _arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_mutMarkArr.count>0) {
        if (indexPath.section==0) {
            MyShareTableViewCell *cell=[self setCellWithindex:indexPath tableview:tableView markPhoto:_mutMarkArr[indexPath.row]];
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section==1){
            MyShareTableViewCell *cell = [self setCellWithindexPath:indexPath tableview:tableView];
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    MyShareTableViewCell *cell = [self setCellWithindexPath:indexPath tableview:tableView];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(MyShareTableViewCell *)setCellWithindexPath:(NSIndexPath *)indexPath tableview:(UITableView *)tableView{
    NSDictionary *dict=[_arrData objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"ShareCell";
    
    MyShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MyShareTableViewCell" owner:self options:nil];
        for (id obj in nib) {
            if ([obj isKindOfClass:[MyShareTableViewCell class]]) {
                cell=(MyShareTableViewCell *)obj;
            }
        }
    }
    [[MDB_UserDefault defaultInstance] setViewWithImage:cell.headImv url:[dict objectForKey:@"pic"]];
    if (![[dict objectForKey:@"title"] isKindOfClass:[NSNull class]]) {
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
    }
    cell.timeLabel.text=[MDB_UserDefault strTimefromData:[[dict objectForKey:@"createtime"] integerValue] dataFormat:nil];
    
    cell.marketLabel.text=[[dict objectForKey:@"devicetype"] integerValue]==0?@"网站":@"手机客户端";
    
    if ([dict objectForKey:@"reason"]&&[self setisElequtoString:[dict objectForKey:@"reason"]]) {
         cell.stateLabel.text=[[dict objectForKey:@"status"] integerValue]==0?[NSString stringWithFormat:@"审核未通过(%@)",[dict objectForKey:@"reason"]]:@"正常";
    }else{
        cell.stateLabel.text=[[dict objectForKey:@"status"] integerValue]==0?@"正在审核中":@"正常";
    }
    return cell;
    
}
-(MyShareTableViewCell *)setCellWithindex:(NSIndexPath *)indexPath tableview:(UITableView *)tableView markPhoto:(MarkedwithPhoto *)markPhoto{
   // NSDictionary *dict=[_arrData objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"ShareCells";
    
    MyShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MyShareTableViewCell" owner:self options:nil];
        for (id obj in nib) {
            if ([obj isKindOfClass:[MyShareTableViewCell class]]) {
                cell=(MyShareTableViewCell *)obj;
            }
        }
    }
    if ([markPhoto.mark.count integerValue]>1) {
        cell.headImv.image=[UIImage imageWithData:markPhoto.photoData];
        cell.titleLabel.text=@"你的原创提交失败";
       // NSDate *date=[NSDate dateWithTimeIntervalSince1970:[markPhoto.mark.markedid integerValue]];
        //cell.timeLabel.text=[MDB_UserDefault strTimefromData:[markPhoto.mark.markedid integerValue] dataFormat:nil];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [formatter setTimeZone:timeZone];
        //        [formatter setDateFormat : @"M/d/yyyy h:m a"];
        NSDate *dateTime = [formatter dateFromString:markPhoto.mark.time];
        cell.timeLabel.text=[MDB_UserDefault strTimefromDatas:dateTime dataFormat:nil];
        cell.marketLabel.hidden=YES;
        cell.stateLabel.hidden=YES;
        
        cell.laiyuan.hidden=YES;
        cell.zhuangtai.hidden=YES;
        
        if (cell.viewl) {
            [cell.viewl removeFromSuperview];
        }
        cell.viewl=[[UIView alloc]initWithFrame:CGRectMake(85.0+(20.0/320.0)*self.frame.size.width, 62.0, self.frame.size.width-75.0-66.0, 28)];
        cell.viewl.tag=600+indexPath.row;
        [cell.viewl setBackgroundColor:RadLineColor];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20.0, 20.0)];
        img.image=[UIImage imageNamed:@"seperise.png"];
        [cell.viewl addSubview:img];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(30.0, 0, cell.viewl.frame.size.width-30.0, 30.0)];
        [lab setFont:[UIFont systemFontOfSize:12.0]];
        lab.textColor=RGB(68, 68, 68);
        lab.text=@"上传失败，触摸再次提交";
        [cell.viewl addSubview:lab];
        
        UIButton *butex=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-70, 1, 44, 44)];
        [butex setTitle:@"放弃" forState:UIControlStateNormal];
        butex.titleLabel.font=[UIFont systemFontOfSize:13.0];
        [butex setTitleColor:RadMenuColor forState:UIControlStateNormal];
        [butex addTarget:self action:@selector(butx:) forControlEvents:UIControlEventTouchUpInside];
        butex.tag=400+indexPath.row;
        [cell addSubview:butex];
        
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [cell.viewl addGestureRecognizer:tap];
        [cell addSubview:cell.viewl];
        
    }else{
        cell.headImv.image=[UIImage imageWithData:markPhoto.photoData];
        cell.titleLabel.text=@"原创正在上传中";
       // cell.timeLabel.text=[MDB_UserDefault strTimefromData:[markPhoto.mark.markedid integerValue] dataFormat:nil];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [formatter setTimeZone:timeZone];
//        [formatter setDateFormat : @"M/d/yyyy h:m a"];
        NSDate *dateTime = [formatter dateFromString:markPhoto.mark.time];
        cell.timeLabel.text=[MDB_UserDefault strTimefromDatas:dateTime dataFormat:nil];
        cell.marketLabel.text=@"手机客户端";
        cell.stateLabel.text=@"正在上传";

        for (UIView *vies in [cell subviews]) {
            if (vies.tag==603) {
                [vies removeFromSuperview];
            }
        }
    
    }
    return cell;
    
}
-(void)didSuccessSendShare:(BOOL)state{
    if (state) {
        [_mutMarkArr removeAllObjects];
        NSArray *makeArr=[[FMDBHelper shareInstance] findMarkTable];
        for (Marked *mark in makeArr) {
            NSArray * mutphotoCles= [[FMDBHelper shareInstance] findMarkPhotoWithFormat:mark.markedid];
            Photoscle *photos;
            if (mutphotoCles&&mutphotoCles.count>0) {
                photos =mutphotoCles[0];
            }
            MarkedwithPhoto *markPhoto=[[MarkedwithPhoto alloc]init];
            markPhoto.mark=mark;
            markPhoto.photoData=photos.pdata;
            [_mutMarkArr insertObject:markPhoto atIndex:0];
        }
        NSDictionary *dic=@{@"userkey":[MDB_UserDefault defaultInstance].usertoken,@"page":@"1",@"limit":@"20"};
        [HTTPManager sendRequestUrlToService:URL_myshoppingexp withParametersDictionry:dic view:self completeHandle:^(AFHTTPRequestOperation *opration, id responceObjct, NSError *error) {
            if (responceObjct){
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dicAll=[str JSONValue];
                if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                    [_arrData removeAllObjects];
                    id arrdic=[dicAll objectForKey:@"data"];
                    if ([arrdic isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dicmanage in arrdic) {
                            [_arrData addObject:dicmanage];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_tableview reloadData];
                    });
                    
                }
            }}];
    }else{
        [_mutMarkArr removeAllObjects];
        NSArray *makeArr=[[FMDBHelper shareInstance] findMarkTable];
        for (Marked *mark in makeArr) {
            NSArray * mutphotoCles= [[FMDBHelper shareInstance] findMarkPhotoWithFormat:mark.markedid];
            Photoscle *photos;
            if (mutphotoCles&&mutphotoCles.count>0) {
                photos =mutphotoCles[0];
            }
            MarkedwithPhoto *markPhoto=[[MarkedwithPhoto alloc]init];
            markPhoto.mark=mark;
            markPhoto.photoData=photos.pdata;
            [_mutMarkArr insertObject:markPhoto atIndex:0];
        }
        [_tableview reloadData];
    }

    

}

-(void)butx:(UIButton *)sender{
    NSInteger index = sender.tag-400;
    MarkedwithPhoto *markPhot=[_mutMarkArr objectAtIndex:index];
    if (index <= _mutMarkArr.count-1) {
        [_mutMarkArr removeObjectAtIndex:index];
    }
    [[FMDBHelper shareInstance] clearMarkeEditTableWithFormat:markPhot.mark.markedid];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableview reloadData];
    });
    if (_mutMarkArr.count+_arrData.count <= 0) {
        [self setTitle];
    }
}
-(void)tap:(UITapGestureRecognizer *)tap{
    UIView *viel=tap.view;
    if (_mutMarkArr.count>viel.tag-600) {
        MarkedwithPhoto *markPhot=[_mutMarkArr objectAtIndex:viel.tag-600];
        markPhot.mark.count=[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
        [[FMDBHelper shareInstance] updateMarkedCount:[NSString stringWithFormat:@"%@",markPhot.mark.count] markedid:markPhot.mark.markedid];
        [[NSNotificationCenter defaultCenter]postNotificationName:kShaidanUpshareImageManagerNotification object:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableview reloadData];
        });
    }
}
-(BOOL)setisElequtoString:(id)str{
    str= ![str isKindOfClass:[NSString class]]?[NSString stringWithFormat:@"%@",str]:str;
    return [str isEqualToString:@"<null>"]||[str isEqualToString:@"<NULL>"]||[str isEqualToString:@""]||[str isEqualToString:@"null"]||[str isEqualToString:@"NSNULL"] ? NO : YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_mutMarkArr.count>0) {
    if (indexPath.section==0) {
        
    }else if(indexPath.section==1){
        NSDictionary *dict=_arrData[indexPath.row];
        BOOL isright=[[dict objectForKey:@"status"] integerValue]==0?YES:NO;
        [_delegate tableViewSelecte:[[_arrData[indexPath.row] objectForKey:@"id"] integerValue] boll:isright];
    }}else{
        NSDictionary *dict=_arrData[indexPath.row];
         BOOL isright=[[dict objectForKey:@"status"] integerValue]==0?YES:NO;
        [_delegate tableViewSelecte:[[_arrData[indexPath.row] objectForKey:@"id"] integerValue] boll:isright];
    }
}
-(void)setCellWithURL:(NSString *)URL cell:(UIImageView *)imgeV boos:(BOOL)bools{
    if (bools) {
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgeV url:URL options:SDWebImageHighPriority];
    }else{
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgeV url:URL];
    }
    
}
//改变行的高度（实现主个代理方法后 rowHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 113.0f;
    
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableview reloadData];
    });
    [_tableview.mj_header endRefreshing];
}

-(void)doneFootLoadingTableViewData{
    _foodReloading=NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableview reloadData];
    });
    [_tableview.mj_footer endRefreshing];
   
}
*/
@end
