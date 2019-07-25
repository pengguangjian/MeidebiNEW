//
//  ArtTableView.m
//  Meidebi
//
//  Created by 杜非 on 15/1/9.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "ArtTableView.h"
#import "MDB_UserDefault.h"

#import "ContentCell.h"
#import "HTTPManager.h"
#import "UIImage+Extensions.h"

static NSString *CellIdentifier = @"Cell";

@implementation artcel
-(void)setwithDic:(NSDictionary *)dic{
    if (self) {
        self.imgurl=[dic objectForKey:@"imgurl"];
        self.link=[dic objectForKey:@"link"];
        self.artid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        self.title=[dic objectForKey:@"title"];
    }
}
@end

@interface ArtTableView ()

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, assign) BOOL isLoadBannerData;
@end
@implementation ArtTableView{
    int  _p;
    float  _ScrowContentOffSet;
    NSArray *photoArr;
    BOOL   isScrollPan;
    
    
}
@synthesize arrData=_arrData;
@synthesize dicPics=_dicPics;
@synthesize cats=_cats;
@synthesize isHot=_isHot;
@synthesize type=_type;
@synthesize reloading=_reloading;
@synthesize foodReloading=_foodReloading;
@synthesize delegate=_delegate;

-(id)initWithFrame:(CGRect)frame pics:(NSDictionary *)dicPics cats:(int)cats isHot:(BOOL)isHot type:(int)type siteid:(NSString *)siteid delegate:(id)delegat{
    if (self) {
        self=[super initWithFrame:frame];
    }
    _delegate=delegat;
    _dicPics=dicPics;
    _type=type;
    _isHot=isHot;
    _cats=cats;
    _siteid = siteid;
    _p=1;
    _ScrowContentOffSet=0.0f;
    isScrollPan=YES;
    if (_dicPics) {
        [HTTPManager sendRequestUrlToService:URL_showactive withParametersDictionry:nil view:self completeHandle:^(AFHTTPRequestOperation *opration, id responceObjct, NSError *error) {
            if (responceObjct==nil) {
                _dicPics=[NSDictionary dictionaryWithObject:@"ss" forKey:@"ss"];
                NSArray *arr=[MDB_UserDefault getActive];
                NSMutableArray *muarr=[[NSMutableArray alloc]init];
                for (NSDictionary *dic in arr) {
                    artcel *arrtc=[[artcel alloc]init];
                    [arrtc setwithDic:dic];
                    [muarr addObject:arrtc];
                }
                photoArr=[NSArray arrayWithArray:muarr];
                [self setTabelvViw:frame];
            }else{
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dicAll=[str JSONValue];
                
                if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]&&[[dicAll objectForKey:@"status"] intValue]) {
                    NSArray *arr=[dicAll objectForKey:@"data"];
                    if (arr&&arr.count>0) {
                        NSMutableArray *muarr=[[NSMutableArray alloc]init];
                        for (NSDictionary *dic in arr) {
                            artcel *arrtc=[[artcel alloc]init];
                            [arrtc setwithDic:dic];
                            [muarr addObject:arrtc];
                        }
                        photoArr=[NSArray arrayWithArray:muarr];
                        _isLoadBannerData = YES;
                        _dicPics=[NSDictionary dictionaryWithObject:@"ss" forKey:@"ss"];
                        [self setTabelvViw:frame];
                        [MDB_UserDefault setActive:arr];
                    }else{
                        _isLoadBannerData = YES;
                        _dicPics=[NSDictionary dictionaryWithObject:@"ss" forKey:@"ss"];
                        NSArray *arr=[MDB_UserDefault getActive];
                        NSMutableArray *muarr=[[NSMutableArray alloc]init];
                        for (NSDictionary *dic in arr) {
                            artcel *arrtc=[[artcel alloc]init];
                            [arrtc setwithDic:dic];
                            [muarr addObject:arrtc];
                        }
                        photoArr=[NSArray arrayWithArray:muarr];
                        [self setTabelvViw:frame];
                    }
                }else{
                    _isLoadBannerData = NO;
                    [self setTabelvViw:frame];
                }
            }
        }];
    }else{
        [self setTabelvViw:frame];
    }

    return self;
}
-(void)tablevietoTop{
    [_tableview scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    

}
-(void)setTabelvViw:(CGRect)frame{

    NSError *errs;
    if (!_siteid) {
        _arrData=[[MDB_UserDefault currentCoreDataManager] objectsWithforEntityForName:@"Article" fetchLimit:20 fetchOffset:0 cats:_cats type:_type ishot:_isHot error:&errs];
    }
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_tableview];
        [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableview registerClass:[ContentCell class] forCellReuseIdentifier:@"Cell"];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        
        _tableview.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [self reloadTableViewDataSource];
        }];
        _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self footReloadTableViewDateSource];
        }];

        if (_arrData.count==0) {
            [self loadData];
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableview reloadData];
        });
    }
}
-(void)loadData{
    NSDictionary *dics=[self setDicisHot:1];
    NSString *urlStr;
    if (_isHot==1) {
        urlStr=URL_allhotlist;
    }else if (_isHot==0){
        urlStr=URL_alllist;
    }
    NSArray *arr=[self setisHot:1];
    for (NSDictionary *dicC in arr) {
        urlStr=[urlStr stringByAppendingString:[NSString stringWithFormat:@"-%@-%@",[[dicC allKeys] objectAtIndex:0],[dicC objectForKey:[[dicC allKeys] objectAtIndex:0]]]];
    }
    if (_siteid) {
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&siteid=%@",_siteid]];
    }
    
    [HTTPManager sendRequestUrlToService:urlStr withParametersDictionry:dics view:self completeHandle:^(AFHTTPRequestOperation *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            NSError *errs;
            _arrData=[[MDB_UserDefault currentCoreDataManager] objectsWithforEntityForName:@"Article" fetchLimit:20 fetchOffset:0 cats:_cats type:_type ishot:_isHot error:&errs];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableview reloadData];
            });
            
        }else{
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dicAll=[str JSONValue];
                if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]){
                    
                    DFManagedObjectModel *manageModel=[MDB_UserDefault currentCoreDataManager];
                    NSArray *arrs= [manageModel insertNewObjectWithDicArr:[[dicAll objectForKey:@"data"] objectForKey:@"linklist"] forEntityForName:@"Article"];
                    _arrData=[NSArray arrayWithArray:arrs];
                    NSError *erro;
                    [manageModel saveContext:&erro];

                [_tableview reloadData];
                _p=2;
                    
            }
        }
    }];

}
-(float)getHigt{
    return self.frame.size.width*0.36;//self.frame.size.height*0.34;
}

- (void)setupHeaderView{
    UIView *topLineView = [[UIView alloc] init];
    [_tableHeaderView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableHeaderView);
        make.height.offset(1);
    }];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    
    UIView *bottomLineView = [[UIView alloc] init];
    [_tableHeaderView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_tableHeaderView);
        make.top.equalTo(_tableHeaderView.mas_bottom).offset(-1);
        make.height.offset(1);
    }];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    
    NSString *outsideTitleStr = @"海淘直邮";
    NSMutableAttributedString *outsideAttributeStr = [[NSMutableAttributedString alloc] initWithString:outsideTitleStr];
    [outsideAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff6b58"] range:NSMakeRange(0, 2)];
    [outsideAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#121212"] range:NSMakeRange(2, 2)];
    UIControl *haitaoControl = [self setupFuntionControlOfTitle:outsideAttributeStr
                                                       subTitle:@"直邮就是这么爽"
                                                          image:[UIImage imageNamed:@"outside shopping"]];
    [_tableHeaderView addSubview:haitaoControl];
    haitaoControl.tag = 1;
    [haitaoControl addTarget:self action:@selector(responsControlEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *cheapTitleStr = @"白菜价";
    NSMutableAttributedString *cheapAttributeStr = [[NSMutableAttributedString alloc] initWithString:cheapTitleStr];
    [cheapAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#121212"] range:NSMakeRange(0, cheapTitleStr.length)];
    UIControl *baicaiControl = [self setupFuntionControlOfTitle:cheapAttributeStr
                                                       subTitle:@"最便宜的都在这里"
                                                          image:[UIImage imageNamed:@"cheap"]];
    [_tableHeaderView addSubview:baicaiControl];
    baicaiControl.tag = 2;
    [baicaiControl addTarget:self action:@selector(responsControlEvents:) forControlEvents:UIControlEventTouchUpInside];

    
    [haitaoControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tableHeaderView.mas_left);
        make.top.equalTo(_tableHeaderView.mas_top).offset(2);
        make.bottom.equalTo(_tableHeaderView.mas_bottom).offset(-5);
        make.width.equalTo(baicaiControl.mas_width);
    }];
    
    [baicaiControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(haitaoControl.mas_right).offset(3);
        make.top.bottom.equalTo(haitaoControl);
        make.right.equalTo(_tableHeaderView.mas_right);
        make.width.equalTo(haitaoControl.mas_width);
    }];
    
}

- (UIControl *)setupFuntionControlOfTitle:(NSAttributedString *)title
                                 subTitle:(NSString *)subTitle
                                    image:(UIImage *)image{
    UIControl *control = [[UIControl alloc] init];
    control.backgroundColor = [UIColor whiteColor];
    
    UIImageView *flagImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [control addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(control.mas_centerY);
            make.left.equalTo(control.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
        imageView.image = image;
        imageView;
    });
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [control addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flagImageView.mas_right).offset(10);
        make.bottom.equalTo(flagImageView.mas_centerY);
    }];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.attributedText = title;
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    [control addSubview:subtitleLabel];
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left);
        make.top.equalTo(flagImageView.mas_centerY).offset(3);
    }];
    subtitleLabel.font = [UIFont systemFontOfSize:12];
    subtitleLabel.text = subTitle;
    subtitleLabel.textColor = [UIColor colorWithHexString:@"#707070"];
    
    return control;
}


- (void)responsControlEvents:(UIControl *)control{
    if ([self.delegate respondsToSelector:@selector(tableViewDidSelectHeaderBarView:)]) {
        [self.delegate tableViewDidSelectHeaderBarView:[NSString stringWithFormat:@"%@",@(control.tag)]];
    }
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dicPics==nil) {
        return _arrData.count;
    }else{
        if (_arrData.count==0) {
            return 0;
        }else{
            return _arrData.count+1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dicPics==nil) {
        ContentCell *cell = [self setCellWithBool:NO indexPath:indexPath tableview:tableView];
        return cell;
    }else{
        if (indexPath.row==0) {
            static NSString *CellIdentifier = @"Cells";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                ImagePlayerView * imagePlayerVie=[[ImagePlayerView alloc]initWithFrame:CGRectMake(0, 0, _tableview.frame.size.width, _isLoadBannerData?[self getHigt]:0)];
                [imagePlayerVie setDelagateCount:4 delegate:self];
                imagePlayerVie.tag=335;
                [imagePlayerVie addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
                [cell addSubview:imagePlayerVie];
                if (!_isLoadBannerData) imagePlayerVie.hidden = YES;
                _tableHeaderView = ({
                    UIView *view = [UIView new];
                    [cell addSubview:view];
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(imagePlayerVie.mas_bottom).offset(2);
                        make.left.right.bottom.equalTo(cell);
                    }];
                    view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
                    view;
                });
                [self setupHeaderView];
            }
            return cell;
        }else{
            ContentCell *cell = [self setCellWithBool:YES indexPath:indexPath tableview:tableView];
            return cell;
        }
    }
}
-(ContentCell *)setCellWithBool:(BOOL)boolCell indexPath:(NSIndexPath *)indexPath tableview:(UITableView *)tableView{
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 124, _tableview.frame.size.width, 1)];
    [lineView setBackgroundColor:RadLineColor];
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, CGRectGetWidth(_tableview.frame), cell.frame.size.height);
    [cell addSubview:lineView];
    
    Article *artiCle;
    if (boolCell) {
        if (_arrData.count>indexPath.row-1) {
            artiCle=[_arrData objectAtIndex:(indexPath.row-1)];
        }else{
            return cell;
        }
    }else{
        if (_arrData.count>indexPath.row) {
           artiCle=[_arrData objectAtIndex:indexPath.row];
        }else{
           return cell;
        }
    }
    [cell fetchCellData:artiCle];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger indexRow = 0;
    if (_dicPics) {
        indexRow = indexPath.row - 1;
    }else{
        indexRow = indexPath.row;
    }
    if (indexRow>_arrData.count-1) return;
    [_delegate tableViewSelecte:_arrData[indexRow]];

}
//改变行的高度（实现主个代理方法后 rowHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dicPics==nil) {
        return 125.0f;
    }else{
        if (indexPath.row==0) {
            return _isLoadBannerData?[self getHigt]+75:75; //
        }else{
            return 125.0f;
        }
    }
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
-(NSArray *)setisHot:(int)pint{
   // NSMutableDictionary *mutDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                // @"20",@"limit",[NSString stringWithFormat:@"%i",pint],@"p",nil];
    NSDictionary *dicpl=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i",pint],@"p", nil];
    
    NSMutableArray *mutArrs=[[NSMutableArray alloc]initWithObjects:dicpl,@{@"limit":@"20"},nil];
    if (_type==1) {
 
        [mutArrs addObject:@{@"type":@"hai"}];
    }else if (_type==0){
   
         [mutArrs addObject:@{@"type":@"guo"}];
    }else if (_type==64){

         [mutArrs addObject:@{@"type":@"tian"}];
    }
    
    if (_cats==-1 || _siteid) {
        
    }else{
      [mutArrs addObject:@{@"cats":[NSString stringWithFormat:@"%i",_cats]}];
    }
    return  [NSArray arrayWithArray:mutArrs];
}
-(NSDictionary *)setDicisHot:(int)pint{
    NSMutableDictionary *dicss=[NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%i",pint] forKey:@"p"];
   
    [dicss setObject:@"20" forKey:@"limit"];
    if (_type==1) {
        [dicss setObject:@"hai" forKey:@"type"];
    }else if (_type==0){
         [dicss setObject:@"guo" forKey:@"type"];
    }else if (_type==64){
         [dicss setObject:@"tian" forKey:@"type"];
    }
    if (!(self.cats==-1)) {
        [dicss setObject:[NSString stringWithFormat:@"%i",_cats] forKey:@"cats"];
    }
    return [NSDictionary dictionaryWithDictionary:dicss];
}

- (void)reloadTableViewDataSource{
    _p=1;
    NSDictionary *dics=[self setDicisHot:1];
    NSString *urlStr;
    if (_isHot==1) {
        urlStr=URL_allhotlist;
    }else if (_isHot==0){
        urlStr=URL_alllist;
    }
    NSArray *arr=[self setisHot:1];
    for (NSDictionary *dicC in arr) {
      urlStr=[urlStr stringByAppendingString:[NSString stringWithFormat:@"-%@-%@",[[dicC allKeys] objectAtIndex:0],[dicC objectForKey:[[dicC allKeys] objectAtIndex:0]]]];
    }
    if (_siteid) {
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&siteid=%@",_siteid]];
    }
    
    _reloading=YES;
    [HTTPManager sendRequestUrlToService:urlStr withParametersDictionry:dics view:nil completeHandle:^(AFHTTPRequestOperation *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            NSError *errs;
            
            _arrData=[[MDB_UserDefault currentCoreDataManager] objectsWithforEntityForName:@"Article" fetchLimit:20 fetchOffset:0 cats:_cats type:_type ishot:_isHot error:&errs];
            
            [self doneLoadingTableViewData];
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
             if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]){
            DFManagedObjectModel *manageModel=[MDB_UserDefault currentCoreDataManager];
            NSArray *arrs= [manageModel insertNewObjectWithDicArr:[[dicAll objectForKey:@"data"] objectForKey:@"linklist"] forEntityForName:@"Article"];
            
            _arrData=[NSArray arrayWithArray:arrs];
            NSError *erro;
            [manageModel saveContext:&erro];
            _p=2;
            [self doneLoadingTableViewData];
            
             }
        }
    }];
    
    
}
-(void)footReloadTableViewDateSource{
    
    NSDictionary *arrdic=[self setDicisHot:_p];
    NSString *urlStr;
    if (_isHot==1) {
        urlStr=URL_allhotlist;
        
    }else if (_isHot==0){
        urlStr=URL_alllist;
    }
    NSArray *arr=[self setisHot:_p];
    for (NSDictionary *dicC in arr) {
        urlStr=[urlStr stringByAppendingString:[NSString stringWithFormat:@"-%@-%@",[[dicC allKeys] objectAtIndex:0],[dicC objectForKey:[[dicC allKeys] objectAtIndex:0]]]];
    }
    if (_siteid) {
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&siteid=%@",_siteid]];
    }
    _foodReloading=YES;
    [HTTPManager  sendRequestUrlToService:urlStr withParametersDictionry:arrdic view:nil
                           completeHandle:^(AFHTTPRequestOperation *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            NSError *errs;
            if (_arrData.count>0) {
                NSArray *arrts=[[MDB_UserDefault currentCoreDataManager] objectsWithforEntityForName:@"Article" fetchLimit:20 fetchOffset:_arrData.count-1 cats:_cats type:_type ishot:_isHot error:&errs];
                NSMutableArray *mutss=[[NSMutableArray alloc]initWithArray:_arrData];
                for ( id juancle in _arrData) {
                    if ([juancle isKindOfClass:[Article class]]) {
                        Article *junl=(Article *)juancle;
                        if (!junl.artid) {
                            [mutss removeObject:juancle];
                        }
                        
                    }
                }
                for (Article *artCles in arrts) {
                    if (![mutss containsObject:artCles]) {
                        [mutss addObject:artCles];
                    }
                }
                _arrData=[NSArray arrayWithArray:mutss];
                
            }else {
                _arrData=[[MDB_UserDefault currentCoreDataManager] objectsWithforEntityForName:@"Article" fetchLimit:20 fetchOffset:0 cats:_cats type:_type ishot:_isHot error:&errs];
            }
            [self doneFootLoadingTableViewData];
        }else{
           
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
        
            NSDictionary *dicAll=[str JSONValue];
             if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]){
            DFManagedObjectModel *manageModel=[MDB_UserDefault currentCoreDataManager];
          
            NSArray *arrs= [manageModel insertNewObjectWithDicArr:[[dicAll objectForKey:@"data"] objectForKey:@"linklist"] forEntityForName:@"Article"];
            NSError *erro;
            [manageModel saveContext:&erro];
            NSMutableArray *muta=[[NSMutableArray alloc]initWithArray:_arrData];
                 
                 for ( id juancle in _arrData) {
                     if ([juancle isKindOfClass:[Article class]]) {
                         Article *junl=(Article *)juancle;
                         if (!junl.artid) {
                             [muta removeObject:juancle];
                         }
                         
                     }
                 }
                 
            for (Article *artCle in arrs) {
                if (![muta containsObject:artCle]) {
                    [muta addObject:artCle];
                }
            }
            _arrData=[NSArray arrayWithArray:muta];
            
            [self doneFootLoadingTableViewData];
            _p++;
             }}
    }];
    
}
- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    [_tableview.mj_header endRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^{
         [_tableview reloadData];
    });
    
}

-(void)doneFootLoadingTableViewData{
    _foodReloading=NO;
    [_tableview.mj_footer endRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableview reloadData];
    });

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
    if ([_delegate respondsToSelector:@selector(scrollViewfrom: isend:)]) {
        [_delegate scrollViewfrom:scrollView.contentOffset.y isend:YES];
    }
    
   
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    isScrollPan=YES;
}

#pragma mark ImagePlayerView ImageplayerViewDelegate

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
    if (photoArr.count>index) {
        artcel *ars=[photoArr objectAtIndex:index];
        
        [[MDB_UserDefault defaultInstance]setViewImageWithURL:[NSURL URLWithString:ars.imgurl] placeholder:[UIImage imageNamed:@"Active.jpg"] UIimageview:imageView];
    }
    
    
}
-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index{
    
}

-(void)handleTapGesture:(UIGestureRecognizer *)sender{
    ImagePlayerView *imagePlayer=(ImagePlayerView *)[sender view];
   
        if ([imagePlayer isKindOfClass:[ImagePlayerView class]]) {
           // ImagePlayerView *imagePlayer=(ImagePlayerView *)vies;
            int   tage=imagePlayer.pagei;
    
            artcel *ars=[photoArr objectAtIndex:tage];
            
            [_delegate tablePhotoSelecte:ars.link title:ars.title];
        }
    
   
}
@end
