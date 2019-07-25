//
//  ArtTableView.m
//  Meidebi
//
//  Created by 杜非 on 15/1/9.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "JuanTableView.h"
#import "MDB_UserDefault.h"
#import "HTTPManager.h"
#import "JuanCell.h"
#import "UIImage+Extensions.h"
#import "FMDBHelper.h"
@implementation JuanTableView{
    int  _p;
    float  _ScrowContentOffSet;
    BOOL   isScrollPan;
}

@synthesize arrData=_arrData;


@synthesize reloading=_reloading;
@synthesize foodReloading=_foodReloading;
@synthesize delegate=_delegate;

-(id)initWithFrame:(CGRect)frame  delegate:(id)delegat{
    if (self) {
        self=[super initWithFrame:frame];
    }
    _delegate=delegat;
    
    _p=1;
    _ScrowContentOffSet=0.0f;
    isScrollPan=YES;

    NSArray *caches = [[FMDBHelper shareInstance] findObjectWithTabeleName:volumeTableName format:@""];
    [[FMDBHelper shareInstance] clearVolumeTable];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *sharecles = [NSMutableArray array];
        for (NSString *sharecleStr in caches) {
            NSDictionary *dict=[sharecleStr JSONValue];
            NSArray * datas = [[dict objectForKey:@"data"] objectForKey:@"linklist"];
            for (NSDictionary *dict in datas) {
                Juancle *aJuancle = [[Juancle alloc] initWithDictionary:dict];
                if (aJuancle) {
                    [sharecles addObject:aJuancle];
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

    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self reloadTableViewDataSource];
    }];
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footReloadTableViewDateSource];
    }];
    [self addSubview:_tableview];
    
    NSDictionary *parameterdic=@{@"hot":@"2",@"limit":@"20",@"p":[NSString stringWithFormat:@"%i",_p]};
    NSString *urlStr=URL_quanlist;
    [HTTPManager sendGETRequestUrlToService:urlStr withParametersDictionry:parameterdic view:_tableview completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                NSArray *arrs= dicAll[@"data"][@"linklist"];
                NSMutableArray *sharecles = [NSMutableArray array];
                for (NSDictionary *dict in arrs) {
                    Juancle *aJuancle = [[Juancle alloc] initWithDictionary:dict];
                    if (aJuancle) {
                        [sharecles addObject:aJuancle];
                    }
                }
                _arrData=sharecles.mutableCopy;
                _p=2;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableview reloadData];
                });
            }
        }
    }];

    
    
    return self;
}
-(void)tablevietoTop{
    [_tableview scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}


-(void)footReloadTableViewDateSource{
    _p++;
    NSDictionary *parameterdic=@{@"hot":@"2",@"limit":@"20",@"p":[NSString stringWithFormat:@"%i",_p]};
    NSString *urlStr=URL_quanlist;

    _foodReloading=YES;
    [HTTPManager  sendRequestUrlToService:urlStr withParametersDictionry:parameterdic view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct){
            
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            NSMutableArray *muta=[[NSMutableArray alloc]initWithArray:_arrData];

            NSArray *subjects= dicAll[@"data"][@"linklist"];
            NSMutableArray *articles = [NSMutableArray array];
            for (NSDictionary *dict in subjects) {
                Juancle *aJuancle = [[Juancle alloc] initWithDictionary:dict];
                [articles addObject:aJuancle];
            }
            for (Juancle *artCle in articles) {
                NSNumber *juan_id = artCle.juanid;
                NSInteger count = 0;
                for (Juancle *aJuancle in muta) {
                    if (![aJuancle.juanid isEqualToNumber:juan_id]) {
                        count += 1;
                    }
                }
                if (count == muta.count) {
                    [muta addObject:artCle];
                }
            }
            _arrData=[NSArray arrayWithArray:muta];
            
            [self doneFootLoadingTableViewData];
            
            [[FMDBHelper shareInstance] saveWithTabeleName:volumeTableName objects:str type:@""];
        }
    }];
    
}
- (void)reloadTableViewDataSource{
    _p=1;
    NSDictionary *parameterdic=@{@"hot":@"2",@"limit":@"20",@"p":[NSString stringWithFormat:@"%i",_p]};
    NSString *urlStr=URL_quanlist;
    _reloading=YES;
    [HTTPManager sendGETRequestUrlToService:urlStr withParametersDictionry:parameterdic view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                 NSArray *subjects = dicAll[@"data"][@"linklist"];
                 NSMutableArray *articles = [NSMutableArray array];
                 for (NSDictionary *dict in subjects) {
                     Juancle *aJuancle = [[Juancle alloc] initWithDictionary:dict];
                     if (aJuancle) {
                         [articles addObject:aJuancle];
                     }
                 }
                 _arrData=[[NSArray arrayWithArray:articles] mutableCopy];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JuanCell *cell = [self setCellWithindexPath:indexPath tableview:tableView];
    return cell;
    
}
-(JuanCell *)setCellWithindexPath:(NSIndexPath *)indexPath tableview:(UITableView *)tableView{
    Juancle *artiCle;
    
    artiCle=[_arrData objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"JuanCell";
    
    JuanCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"JuanCell" owner:self options:nil];
        for (id obj in nib) {
            if ([obj isKindOfClass:[JuanCell class]]) {
                cell=(JuanCell *)obj;
            }
        }
    }

    [self setCellWithURL:artiCle.imgurl cell:cell.headImv];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.backView.layer setMasksToBounds:YES];
    [cell.backView.layer setBorderWidth:1.0];
    [cell.backView.layer setBorderColor:RGB(225.0, 225.0, 225.0).CGColor];
    [cell.backView.layer setCornerRadius:3.0];
    cell.priceLabel.text=[NSString stringWithFormat:@"%@",artiCle.jian];
    cell.manLabel.text=[NSString stringWithFormat:@"满%@减%@",artiCle.man,artiCle.jian];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_delegate tableViewSelecte:_arrData[indexPath.row]];
    
}
-(void)setCellWithURL:(NSString *)URL cell:(UIImageView *)imgeV {
        [[MDB_UserDefault defaultInstance]setViewWithImage:imgeV url:URL image:[UIImage imageNamed:@"Juancle.jpg"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                imgeV.image=image;
                [imgeV setContentMode:UIViewContentModeScaleAspectFit];
            }else{
                imgeV.image=[UIImage imageNamed:@"punot.png"];
                [imgeV setContentMode:UIViewContentModeScaleAspectFit];
            }
            
        }];
    
}
//改变行的高度（实现主个代理方法后 rowHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100.0f;
    
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
