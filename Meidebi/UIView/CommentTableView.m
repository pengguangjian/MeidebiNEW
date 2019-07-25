//
//  CommentTableView.m
//  Meidebi
//
//  Created by 杜非 on 15/2/5.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "CommentTableView.h"
#import "MDB_UserDefault.h"

#import "CommentCell.h"
#import "HTTPManager.h"
#import "CompressImage.h"

#import "QBPopupMenu.h"
#import <MJRefresh/MJRefresh.h>

@implementation CommentTableView{
    
    
    NSInteger  _p;
    float _ScrowContentOffSet;
    QBPopupMenu   *_popupMenu;
    NSInteger     butrow;
    int     butType;
}
@synthesize arrData=_arrData;
@synthesize reloading=_reloading;
@synthesize foodReloading=_foodReloading;
@synthesize type=_type;
@synthesize linkid=_linkid;
@synthesize delegate=_delegate;

-(id)initWithFrame:(CGRect)frame type:(NSInteger)type linkid:(NSInteger)linkid{
    if (self) {
        self=[super initWithFrame:frame];
    }
    _p=1;
    _type=type;
    _linkid=linkid;
    _ScrowContentOffSet=0.0f;
    _isup=NO;
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    
    NSDictionary *dica=@{@"linkid":[NSString stringWithFormat:@"%@",@(_linkid)],@"type":[NSString stringWithFormat:@"%@",@(_type)],@"p":[NSString stringWithFormat:@"%@",@(_p)]};
    
    _arrData=[[NSMutableArray alloc]init];
    
    [HTTPManager sendRequestUrlToService:URL_comlist withParametersDictionry:dica view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                NSArray *arrs=[NSMutableArray arrayWithArray:[dicAll objectForKey:@"data"]];
      
                if (arrs&&arrs.count>0) {
                    //[_arrData addObjectsFromArray:arrs];
                    
                    [self setDataArr:arrs];
                }
                _tableview.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
                    [self reloadTableViewDataSource];
                }];
                _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [self footReloadTableViewDateSource];
                }];

                [_tableview reloadData];
                
                _p=2;

            }
        }
    }];
    
    
    [self addSubview:_tableview];
    [self setPopMenu];
    return self;
    
}
-(void)setPopMenu{
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] init];
    QBPopupMenuItem *item1 = [QBPopupMenuItem itemWithTitle:@"赞一个" image:nil target:self action:@selector(reply:)];
//    item1.width = 64;
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"回复" image:nil target:self action:@selector(replyo:)];
//    item2.width = 64;
    QBPopupMenuItem *item3 = [QBPopupMenuItem itemWithTitle:@"引用" image:nil target:self action:@selector(replyt:)];
//    item3.width = 64;
    QBPopupMenuItem *item4 = [QBPopupMenuItem itemWithTitle:@"复制" image:nil target:self action:@selector(replyf:)];
//    item4.width = 64;
    popupMenu.items = [NSArray arrayWithObjects:item1, item2, item3, item4,nil];
    _popupMenu = popupMenu;
}
- (void)reply:(id)sender
{
    butType=1;
    [_delegate comment:butType cellrow:[_arrData objectAtIndex:butrow]];
}
- (void)replyo:(id)sender
{
    butType=2;
    [_delegate comment:butType cellrow:[_arrData objectAtIndex:butrow]];
}
- (void)replyt:(id)sender
{
    butType=3;
    [_delegate comment:butType cellrow:[_arrData objectAtIndex:butrow]];
}
-(void)replyf:(id)sender{
    butType=4;
    [_delegate comment:butType cellrow:[_arrData objectAtIndex:butrow]];
}
-(void)setDataArr:(NSArray *)arr{
    for (NSDictionary *dics in arr) {
        Comment *ment=[self setComment:dics];
        [_arrData addObject:ment];
    }
}
-(Comment *)setComment:(NSDictionary *)dics{
    Comment *ment=[[Comment alloc]init];
    ment.comentid=[[NSString stringWithFormat:@"%@",[self getStrNulll:[dics objectForKey:@"id"]]] integerValue];
    ment.fromid=[[NSString stringWithFormat:@"%@",[self getStrNulll:[dics objectForKey:@"fromid"]]] integerValue];
    ment.createtime=[[NSString stringWithFormat:@"%@",[self getStrNulll:[dics objectForKey:@"createtime"]]] integerValue];
    ment.userid=[[NSString stringWithFormat:@"%@",[self getStrNulll:[dics objectForKey:@"userid"]]] integerValue];
    
    ment.touserid=[[NSString stringWithFormat:@"%@",[self getStrNulll:[dics objectForKey:@"touserid"]]] integerValue];
    ment.content=[self getStrNull:[dics objectForKey:@"content"]];
    ment.status=[[NSString stringWithFormat:@"%@",[self getStrNulll:[dics objectForKey:@"status"]]] integerValue];
    ment.referto=[[NSString stringWithFormat:@"%@",[self getStrNulll:[dics objectForKey:@"referto"]]] integerValue];
    ment.tonickname=[self getStrNull:[dics objectForKey:@"tonickname"]];
    ment.photo=[self getStrNull:[dics objectForKey:@"photo"]];
    ment.refernickname=[self getStrNull:[dics objectForKey:@"refernickname"]];
    ment.nickname=[self getStrNull:[dics objectForKey:@"nickname"]];
    ment.refercontent=[self getStrNull:[dics objectForKey:@"refercontent"]];
    return ment;
}
-(NSString *)getStrNull:(NSString *)str{
    if (str==nil&&(NSNull *)str==[NSNull null]) {
        return @"lll";
    }else{
        return str;
    }

}
-(NSString *)getStrNulll:(NSString *)str{
    if (str==nil&&(NSNull *)str==[NSNull null]) {
        return @"0";
    }else{
        return str;
    }
    
}
-(void)commentZan:(Comment *)ment{
    float sss=0.0;;
    for (Comment  *dic in _arrData) {
        if (dic!=ment) {
            if (dic.status==2) {
                sss=sss+[self gethightwith:@"该评论已被屏蔽"]+[self getArtHight:dic];
            }else{
                sss=sss+[self gethightwith:dic.content]+[self getArtHight:dic];
            }
        }else{
            break;
        }
    }
    float wlfot=_tableview.contentOffset.y;
    UILabel * _labelCommend=[[UILabel alloc] init];
    _labelCommend.frame=CGRectMake(90.0, sss-wlfot+30.0, 25.0, 25.0);
    _labelCommend.text=@"+1";
    _labelCommend.alpha=0.0;
    _labelCommend.textColor=[UIColor redColor];
    [_tableview addSubview:_labelCommend];
    CAAnimation *animation =[CompressImage groupAnimation:_labelCommend];
    [_labelCommend.layer addAnimation:animation forKey:@"animation"];
 
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    _p=1;
    NSDictionary *dica=@{@"linkid":[NSString stringWithFormat:@"%@",@(_linkid)],@"type":[NSString stringWithFormat:@"%@",@(_type)],@"p":[NSString stringWithFormat:@"%@",@(_p)]};
    
    [HTTPManager  sendRequestUrlToService:URL_comlist withParametersDictionry:dica view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
           
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                NSArray *arrs=[NSMutableArray arrayWithArray:[dicAll objectForKey:@"data"]];
                if (arrs&&arrs.count>0) {
                    [_arrData removeAllObjects];
                    [self setDataArr:arrs];
                }
            }
            _p++;
            [self doneLoadingTableViewData];
            
        }
    }];
}
-(void)footReloadTableViewDateSource{
    
    NSDictionary *dica=@{@"linkid":[NSString stringWithFormat:@"%@",@(_linkid)],@"type":[NSString stringWithFormat:@"%@",@(_type)],@"p":[NSString stringWithFormat:@"%@",@(_p)]};
    _foodReloading=YES;
    [HTTPManager sendRequestUrlToService:URL_comlist withParametersDictionry:dica view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            
        }else{
            
            
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            
            NSDictionary *dicAll=[str JSONValue];
         
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                NSArray *arrs=[NSMutableArray arrayWithArray:[dicAll objectForKey:@"data"]];
                if (arrs&&arrs.count>0) {
                    
                    
                    for (NSDictionary *dics in arrs) {
                        BOOL bols=NO;
                        for (Comment *arrdic in _arrData) {
                            if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"id"]]isEqualToString:[NSString stringWithFormat:@"%@",@(arrdic.comentid)]]) {
                                bols=YES;
                            }
                        }
                        if (!bols) {
                            Comment *ment=[self setComment:dics];
                            [_arrData addObject:ment];
                        }
                    }
                }
                
                [self doneFootLoadingTableViewData];
                _p++;
            }
        }
    }];
    
}
-(void)tableTap{
    
    
    
}
-(void)reloaddatewarr{
    if (_tableview) {
        [_tableview reloadData];
    }else{
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        [self addSubview:_tableview];
        UITapGestureRecognizer *taps=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableTap)];
        taps.numberOfTapsRequired=1;
        taps.numberOfTouchesRequired=1;
        [_tableview addGestureRecognizer:taps];
        
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_arrData&&_arrData.count>0) {
        return 1;
    }else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arrData.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    CommentCell *cell = [self setCellWithBool:NO indexPath:indexPath tableview:tableView];
    return cell;
    
}
-(CommentCell *)setCellWithBool:(BOOL)boolCell indexPath:(NSIndexPath *)indexPath tableview:(UITableView *)tableView{
    
    Comment *dicS=_arrData[indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CommentCell" owner:self options:nil];
        for (id obj in nib) {
            if ([obj isKindOfClass:[CommentCell class]]) {
                cell=(CommentCell *)obj;
            }
        }
        cell.lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 119, _tableview.frame.size.width, 1)];
        
        [cell.lineView setBackgroundColor:RadLineColor];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, CGRectGetWidth(_tableview.frame), cell.frame.size.height);
        [cell.headImv.layer setMasksToBounds:YES];
        [cell.headImv.layer setCornerRadius:17.5];
        
        cell.contentLabels=[[MLEmojiLabel alloc]initWithFrame:CGRectMake(16, 55, self.frame.size.width-32.0, 21.0)];
        cell.contentLabels.numberOfLines=0;
        cell.contentLabels.font=[UIFont systemFontOfSize:14.0];
        [cell.contentLabels setTextColor:RGB(119, 119, 119)];
        cell.contentLabels.isNeedAtAndPoundSign=YES;
        cell.contentLabels.customEmojiRegex=@"\\[\\:[a-z]+\\_[\\u4e00-\\u9fa5]+\\]";
        cell.contentLabels.customEmojiPlistName=@"expression.plist";
        [cell addSubview:cell.contentLabels];
        cell.otherCv=[[OtherComV alloc]initWithFrame:CGRectMake(16.0, 55.0, self.frame.size.width-32.0, 70.0)];
        [cell addSubview:cell.otherCv];
        
        cell.otherlabel=[self setLabelFrom:CGRectMake(16.0, 55.0, 30.0, 16.0) str:@"回复" color:RadCellBiaoColor];
        [cell addSubview:cell.otherlabel];
        cell.onamelabel=[self setLabelFrom:CGRectMake(46.0, 55.0, self.frame.size.width-32.0, 16.0) str:@"" color:RadDaoBiaoColor];
        [cell addSubview:cell.onamelabel];
        [cell addSubview:cell.lineView];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [[MDB_UserDefault defaultInstance]setViewWithImage:cell.headImv url:dicS.photo] ;
    if (![dicS.nickname isKindOfClass:[NSNull class]]) {
         cell.nameLabel.text=dicS.nickname;
    }
   
    if (dicS.createtime) {

        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dicS.createtime];

//    cell.timeLabel.text=[MDB_UserDefault strTimefromData:dicS.createtime dataFormat:nil];
        cell.timeLabel.text=[NSString stringWithTimelineDate:date];

    }
    NSString *conts;
    if (dicS.status==2) {
        conts=@"该评论被屏蔽";
    }else{
        conts=dicS.content;
    }
    
    
    float otherHight=[self getArtHight:dicS];
    if (otherHight==24.0) {
        cell.otherCv.hidden=YES;
        cell.otherlabel.hidden=NO;
        cell.onamelabel.hidden=NO;
        if (![dicS.tonickname isKindOfClass:[NSNull class]]) {
            cell.onamelabel.text=[NSString stringWithFormat:@"%@:",dicS.tonickname];
        }
        
    }else if(otherHight==0){
        cell.otherCv.hidden=YES;
        cell.otherlabel.hidden=YES;
        cell.onamelabel.hidden=YES;
    }else{
        cell.otherCv.hidden=NO;
        cell.otherlabel.hidden=YES;
        cell.onamelabel.hidden=YES;
        cell.otherCv.frame=CGRectMake(cell.otherCv.frame.origin.x, 55.0, cell.otherCv.frame.size.width, otherHight);
        [cell.otherCv setWithDic:dicS];
    }
    
    CGSize size=[MDB_UserDefault getStrhightFont:[UIFont systemFontOfSize:14.0] str:[NSString stringWithFormat:@"你是%@",conts] wight:CGRectGetWidth(self.frame)-32.0];
    [cell.contentLabels setEmojiText:conts];
    [cell.contentLabels setFrame:CGRectMake(16.0, 57.0+otherHight, self.frame.size.width-32.0, size.height)];
    [cell.contentLabels sizeToFit];

    [cell.lineView setFrame:CGRectMake(0, 69.0+otherHight+size.height, _tableview.frame.size.width, 1.0)];
    
    return cell;
}

-(float)getArtHight:(Comment *)dic{
    if (dic.touserid>0) {
        return 24.0;
    }else if (dic.referto>0){
    //24*+6;
        if (dic.refernickname&&(NSNull *)dic.refernickname!=[NSNull null]) {
            CGSize size=[MDB_UserDefault getStrhightFont:[UIFont systemFontOfSize:14.0] str:dic.refernickname wight:CGRectGetWidth(self.frame)-32.0-12.0];
            return size.height+30.0;
        }else{
            CGSize size=[MDB_UserDefault getStrhightFont:[UIFont systemFontOfSize:14.0] str:@"nill" wight:CGRectGetWidth(self.frame)-32.0-12.0];
            return size.height+30.0;
        }
        
    }else{
        return 0;
    }
}

-(UILabel *)setLabelFrom:(CGRect)rect  str:(NSString *)text color:(UIColor *)color{
    UILabel *labely=[[UILabel alloc]initWithFrame:rect];
    labely.font=[UIFont systemFontOfSize:14.0];
    if (![text isKindOfClass:[NSNull class]]) {
        labely.text=[NSString stringWithFormat:@"%@",text];
    }
    
    labely.textColor=color;
    return labely;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isup) {
        [_delegate tableViewTouch];
        _isup=NO;
        return;
    }
//    CommentCell *cell=(CommentCell *)[tableView cellForRowAtIndexPath:indexPath];
    butrow=indexPath.row;
    
//    CGPoint high=[tableView contentOffset];
//    if (cell.frame.origin.y-high.y<50.0) {
//        [_popupMenu showInView:tableView atPoint:CGPointMake(cell.center.x, 60.0)];
//    }else{
//        [_popupMenu showInView:tableView atPoint:CGPointMake(cell.center.x, cell.frame.origin.y-high.y+25.0)];
//    }


}

//改变行的高度（实现主个代理方法后 rowHeight 设定的高度无效）
-(float)gethightwith:(NSString *)comstr{
    CGSize size=[MDB_UserDefault getStrhightFont:[UIFont systemFontOfSize:14.0] str:[NSString stringWithFormat:@"你是%@",comstr] wight:CGRectGetWidth(self.frame)-32.0];
    
   return  70.0+size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Comment *dcis=_arrData[indexPath.row];
    NSString *conts;
    if (dcis.status==2) {
        conts=@"该评论被屏蔽";
    }else{
       conts =dcis.content;
    }
    float high=[self getArtHight:dcis];
    return [self gethightwith:conts]+high;
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_tableview.mj_header endRefreshing];
    [_tableview reloadData];

}

-(void)doneFootLoadingTableViewData{
    _foodReloading=NO;
    [_tableview.mj_footer endRefreshing];
    [_tableview reloadData];
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_isup) {
        BOOL bools=[_delegate tableViewTouch];
        _isup=bools;
    }

    _ScrowContentOffSet=scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    _ScrowContentOffSet=scrollView.contentOffset.y;
    
}
@end
