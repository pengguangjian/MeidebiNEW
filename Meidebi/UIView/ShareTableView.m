//
//  ArtTableView.m
//  Meidebi
//
//  Created by 杜非 on 15/1/9.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "ShareTableView.h"
#import "MDB_UserDefault.h"
#import "HTTPManager.h"
#import "ShareSpotCell.h"
#import "UIImage+Extensions.h"
#import "FMDBHelper.h"
@implementation ShareTableView{
    int  _p;
    float  _ScrowContentOffSet;
    BOOL   isScrollPan;
}

@synthesize arrData=_arrData;


@synthesize isHot=_isHot;

@synthesize reloading=_reloading;
@synthesize foodReloading=_foodReloading;
@synthesize delegate=_delegate;

-(id)initWithFrame:(CGRect)frame isHot:(BOOL)isHot  delegate:(id)delegat{
    if (self) {
        self=[super initWithFrame:frame];
    }
    _delegate=delegat;
    
    _isHot=isHot;
    isScrollPan=YES;
    _p=1;
    _ScrowContentOffSet=0.0f;
    

    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadTableViewDataSource];
    }];
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footReloadTableViewDateSource];
    }];
    [self addSubview:_tableview];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *caches = [[FMDBHelper shareInstance] findObjectWithTabeleName:markeTableName format:[NSString stringWithFormat:@"%@",@(_isHot)]];
        [[FMDBHelper shareInstance] clearMarkeTable];
        NSMutableArray *sharecles = [NSMutableArray array];
        for (NSString *sharecleStr in caches) {
            NSDictionary *dict=[sharecleStr JSONValue];
            NSArray * datas = [[dict objectForKey:@"data"] objectForKey:@"linklist"];
            for (NSDictionary *dict in datas) {
                Sharecle *aSharecle = [[Sharecle alloc] initWithDictionary:dict];
                if (aSharecle) {
                    [sharecles addObject:aSharecle];
                }
            }
        }
        _arrData = sharecles.mutableCopy;
        if (_arrData.count != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableview reloadData];
                
            });
        }
    });
    
    [self loadData];

    
    return self;
}

- (void)loadData{
    _p=1;
    NSDictionary *arrdic=[self setDicisHot];
    NSArray *Arrsh=[self setArrisHot];
    NSString *urlStr=URL_showdanlist;
    for (NSDictionary *dicC in Arrsh) {
        urlStr=[urlStr stringByAppendingString:[NSString stringWithFormat:@"-%@-%@",[[dicC allKeys] objectAtIndex:0],[dicC objectForKey:[[dicC allKeys] objectAtIndex:0]]]];
    }
    [HTTPManager  sendRequestUrlToService:urlStr withParametersDictionry:arrdic view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                NSArray *arrs= dicAll[@"data"][@"linklist"];
                NSMutableArray *sharecles = [NSMutableArray array];
                for (NSDictionary *dict in arrs) {
                    Sharecle *aSharecle = [[Sharecle alloc] initWithDictionary:dict];
                    if (aSharecle) {
                        [sharecles addObject:aSharecle];
                    }
                }
                _arrData=sharecles.mutableCopy;
                _p=2;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableview reloadData];
                });
                
                [[FMDBHelper shareInstance] saveWithTabeleName:markeTableName objects:str type:[NSString stringWithFormat:@"%@",@(_isHot)]];
                
            }
        }
    }];
}

-(void)tablevietoTop{
    [_tableview scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(void)footReloadTableViewDateSource{
    
    NSDictionary *arrdic=[self setDicisHot];
    NSArray *Arrsh=[self setArrisHot];
    NSString *urlStr=URL_showdanlist;
    for (NSDictionary *dicC in Arrsh) {
        urlStr=[urlStr stringByAppendingString:[NSString stringWithFormat:@"-%@-%@",[[dicC allKeys] objectAtIndex:0],[dicC objectForKey:[[dicC allKeys] objectAtIndex:0]]]];
    }
    
    _foodReloading=YES;
    [HTTPManager  sendGETRequestUrlToService:urlStr withParametersDictionry:arrdic view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct){
            
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            
            NSDictionary *dicAll=[str JSONValue];
        
             if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
            
                 NSArray *subjects= dicAll[@"data"][@"linklist"];
                 NSMutableArray *articles = [NSMutableArray array];
                 for (NSDictionary *dict in subjects) {
                     Sharecle *aSharecle = [[Sharecle alloc] initWithDictionary:dict];
                     [articles addObject:aSharecle];
                 }
                     
                NSMutableArray *muta=[[NSMutableArray alloc]initWithArray:_arrData];
                 
                for (Sharecle *artCle in articles) {
                     NSNumber *sharecle_id = artCle.shareid;
                     NSInteger count = 0;
                     for (Sharecle *aSharecle in muta) {
                         if (![aSharecle.shareid isEqualToNumber:sharecle_id]) {
                             count += 1;
                         }
                     }
                     if (count == muta.count) {
                         [muta addObject:artCle];
                     }
                 }
                 
                _arrData=muta.mutableCopy;
                
                [self doneFootLoadingTableViewData];
                _p++;
                 
                [[FMDBHelper shareInstance] saveWithTabeleName:markeTableName objects:str type:[NSString stringWithFormat:@"%@",@(_isHot)]];

             }
        }
    }];
    
}
- (void)reloadTableViewDataSource{
    _p=1;
    NSDictionary *arrdic=[self setDicisHot];
    NSArray *Arrsh=[self setArrisHot];
    NSString *urlStr=URL_showdanlist;
    for (NSDictionary *dicC in Arrsh) {
        urlStr=[urlStr stringByAppendingString:[NSString stringWithFormat:@"-%@-%@",[[dicC allKeys] objectAtIndex:0],[dicC objectForKey:[[dicC allKeys] objectAtIndex:0]]]];
    }
    _reloading=YES;
    [HTTPManager  sendRequestUrlToService:urlStr withParametersDictionry:arrdic view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
          
             if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                 NSArray *subjects = dicAll[@"data"][@"linklist"];
                 NSMutableArray *articles = [NSMutableArray array];
                 for (NSDictionary *dict in subjects) {
                     Sharecle *aSharecle = [[Sharecle alloc] initWithDictionary:dict];
                     if (aSharecle) {
                         [articles addObject:aSharecle];
                     }
                 }
                 _arrData=[[NSArray arrayWithArray:articles] mutableCopy];
                 _p=2;
                 [self doneLoadingTableViewData];
             }
        }
    }];
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}
- (ShareSpotCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Sharecle *artiCle=[_arrData objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"ShareCell";
    
    ShareSpotCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ShareSpotCell" owner:self options:nil];
        for (id obj in nib) {
            if ([obj isKindOfClass:[ShareSpotCell class]]) {
                cell=(ShareSpotCell *)obj;
            }
        }
        cell.productImv=[[UIImageView alloc]initWithFrame:CGRectMake(16, 16, self.frame.size.width-32.0, 160)];
        [cell addSubview:cell.productImv];
        UIView *backvIEWS=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)-32.0, 35.0)];
        [backvIEWS setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3]];
        [cell.productImv addSubview:backvIEWS];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(5, 3, CGRectGetWidth(self.frame)-42.0, 28)];
        
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [cell.productImv addSubview:label];
        
        [cell.productImv.layer setMasksToBounds:YES];
        [cell.productImv.layer setCornerRadius:5.0];
        
        [cell.headeImv.layer setMasksToBounds:YES];
        [cell.headeImv.layer setCornerRadius:17.5];
        [cell.headeImv.layer setBorderWidth:1.0];
        [cell.headeImv.layer setBorderColor:RGB(200.0, 200.0, 200.0).CGColor];
        
    }
    float hight=[self getImageSizewithWight:[artiCle.width integerValue] high:[artiCle.height integerValue]];
    cell.productImv.frame=CGRectMake(16, 16, self.frame.size.width-32.0, hight);
    
    [[MDB_UserDefault defaultInstance]setViewWithImage:cell.productImv url:artiCle.cover options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            cell.productImv.image=image;
            cell.productImv.contentMode=UIViewContentModeScaleAspectFill;
        }else{
            cell.productImv.image=[UIImage imageNamed:@"punot.png"];
            [cell.productImv setContentMode:UIViewContentModeScaleAspectFit];
        }
    }];

    [self setCellWithURL:artiCle.headphoto cell:cell.headeImv ];
    
    for (UIView *views in [cell.productImv subviews]) {
        if ([views isKindOfClass:[UILabel class]]) {
            UILabel *laes=(UILabel *)views;
            laes.text=artiCle.title;
        }
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.labelContet.text=artiCle.content;
    cell.zanlabel.text=[NSString stringWithFormat:@"%@",artiCle.votesp];
    cell.pinlunlabel.text=[NSString stringWithFormat:@"%@",artiCle.commentcount];
    cell.namelabel.text=[NSString stringWithFormat:@"%@",artiCle.name];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_delegate tableViewSelecte:_arrData[indexPath.row]];
    
}
-(void)setCellWithURL:(NSString *)URL cell:(UIImageView *)imgeV{

        [[MDB_UserDefault defaultInstance]setViewWithImage:imgeV url:URL image:[UIImage imageNamed:@"share_ni_img.jpg"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            UIImage *images=[image imageByScalingProportionallyToMinimumSize:CGSizeMake(imgeV.frame.size.width*3.0, imgeV.frame.size.height*3.0)];
            imgeV.image=images;
        }];
}
-(float)getImageSizewithWight:(NSInteger)wight high:(NSInteger)hight{
    
    if ((float)wight/(float)hight>1136.0/636.0) {
        if (hight>636) {
            hight=636;
            wight=1136;
        }else{
            wight=wight>1136?1136:wight;
        }
    }else{
        if (wight>1136) {
            hight=636;
            wight=1136;
        }else{
            hight=hight>636?636:hight;
        
        }
    }
    float higt=0.0f;
    if (wight>0) {
        
         higt=(float)hight*(self.frame.size.width-32.0)/(float)wight;
    }else{
        
        return 160.0;
    }
    return higt;
}
//改变行的高度（实现主个代理方法后 rowHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Sharecle *artiCle=[_arrData objectAtIndex:indexPath.row];
    return 122.0+16.0+[self getImageSizewithWight:[artiCle.width integerValue] high:[artiCle.height integerValue]];
    
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

-(NSDictionary *)setDicisHot{
    if (_isHot) {
        NSDictionary *dic=@{@"hot":@"1",@"p":[NSString stringWithFormat:@"%i",_p],@"limit":@"10"};
        return dic;
    }else {
        NSDictionary *dic=@{@"hot":@"0",@"p":[NSString stringWithFormat:@"%i",_p],@"limit":@"10"};
        return dic;
    }
    
}
-(NSArray *)setArrisHot{
    if (_isHot) {
        NSArray *arr=@[@{@"hot":@"1"},@{@"p":[NSString stringWithFormat:@"%i",_p]},@{@"limit":@"10"}];
        return arr;
    }else {
        NSArray *arrS=@[@{@"hot":@"0"},@{@"p":[NSString stringWithFormat:@"%i",_p]},@{@"limit":@"10"}];
        return arrS;
    }
    
}


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
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
      _ScrowContentOffSet=scrollView.contentOffset.y;
    if ([_delegate respondsToSelector:@selector(scrollViewfrom: isend:)]){
    if (isScrollPan) {
        [_delegate scrollViewfrom:scrollView.contentOffset.y isend:NO];
    }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    isScrollPan=NO;
    _ScrowContentOffSet=scrollView.contentOffset.y;
    if ([_delegate respondsToSelector:@selector(scrollViewfrom: isend:)]){
    [_delegate scrollViewfrom:scrollView.contentOffset.y isend:YES];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    isScrollPan=YES;
}

#pragma mark ImagePlayerView ImageplayerViewDelegate

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
    
    NSString *inss=[NSString stringWithFormat:@"1-%@.jpg",@(index+1)];
    imageView.image=[UIImage imageNamed:inss];
    
}
-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index{
    
}


@end
