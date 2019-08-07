//
//  Home644TableView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/6.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "Home644TableView.h"

#import "Home644DataController.h"

#import "ContentCell.h"
#import "MDB_UserDefault.h"
#import <MJRefresh/MJRefresh.h>
#import "GMDCircleLoader.h"

#import "JingXuanYuanChuangTableViewCell.h"

#import "Article.h"

#import "UIView+Extension.h"

#import "OriginalDetailViewController.h"
#import "ProductInfoViewController.h"

#import "QuanWangYHDetailViewController.h"

#import "QuanWangYHTableViewCell.h"
#import "VolumeContentViewController.h"

#import "JingXuanYouHuiQuanTableViewCell.h"

#import <QNMD5.h>
///KeplerApiManager
//#import <JDKeplerSDK/JDKeplerSDK.h>
#import <JDKeplerSDK/JDKeplerSDK.h>

static NSString *cellIdentifier = @"cellhome";
static NSString *cellIdentifier1 = @"cell1home";
static NSString *cellIdentifier2 = @"cell2home";
static NSString *cellIdentifier3 = @"cell3home";


@interface Home644TableView ()<UITableViewDelegate, UITableViewDataSource>
{
    float flasty;
    
    ///分页数据
    int inowpage;
    
    ///精选需要用到的 记录上次原创的
    NSString *strold_artice;
    
    BOOL isjiazai;
    
    float flastscroll;
    
    
    NSString *strpd;
    /*
    ///爆料99数据
    NSMutableArray *arrbl99list;
    ///京东
    NSMutableArray *arrjd99list;
     */
    
    BOOL isjieshu;
    
}

@property (nonatomic, strong) Home644DataController *dataController;
@property (nonatomic, strong) GMDCircleLoader *hudView;
@property (nonatomic, assign) NSInteger lastContentOffset;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *topSectionContairView;
@property (nonatomic, assign) CGFloat dynamicHight;
@property (nonatomic, assign) NSInteger scorllDownSum;
@property (nonatomic, assign) NSInteger scorllUpSum;

///列表数据
@property (nonatomic, strong) NSMutableArray *arrListData;


@end

@implementation Home644TableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setTopView:(Home644HeaderView *)topView
{
    _topView = topView;
    strpd = @"";
    
    self.dataSource = self;
    self.delegate = self;
    
    self.scrollIndicatorInsets = UIEdgeInsetsMake(self.topView.height, 0, 0, 0);
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH, self.topView.height)];
    self.tableHeaderView = tableHeaderView;
    
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
}


-(Home644TableView * )initWithFrame:(CGRect)frame andtype:(NSString *)type andjiazai:(BOOL)isjiazai
{
    self.itemtype = [NSString nullToString:type];
    _isjiazaidata = isjiazai;
    if(self = [super initWithFrame:frame])
    {
        [self drawUI];
        
    }
    return self;
}

-(void)drawUI
{
    
    if (!_dataController) {
        _dataController = [[Home644DataController alloc] init];
    }
    strold_artice = @"";
    inowpage = 1;
    
//    [self.tableView setScrollEnabled:NO];
    
//    if([_itemtype isEqualToString:@"0"])
//    {
//        [self loadListData];
//    }
//    else
//    {
//        [self loadListData];
//    }
    
//    [self loadListData];
    
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        inowpage=1;
        isjieshu = NO;
        _isjiazaidata = YES;
        strold_artice = @"";
        strpd = @"";
        [self loadListData];
        [self.scrodelegate headerRefNotifi];
        
        
    }];
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        inowpage+=1;
        _isjiazaidata = YES;
        [self loadListData];
        
        
    }];
    
}

-(void)tabviewHeaderRef
{
    if([self.mj_header isRefreshing] == NO)
    {
        
        [self.mj_header beginRefreshing];
    }
    
}

///请求数据
-(void)loadDataback:(completeCallback)callback
{
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    NSString *strurl = @"";
    
    [dicpush setObject:[NSString stringWithFormat:@"%d",inowpage] forKey:@"page"];
    if(isjiazai == NO && inowpage == 1)
    {
        isjiazai = YES;
        if([_itemtype isEqualToString:@"0"])
        {
            [dicpush setObject:[NSString stringWithFormat:@"%d",20] forKey:@"pagesize"];
        }
        else
        {
            [dicpush setObject:[NSString stringWithFormat:@"%d",20] forKey:@"pagesize"];
        }
        
        
    }
    else
    {
        [dicpush setObject:[NSString stringWithFormat:@"%d",20] forKey:@"pagesize"];
    }
    
    UIView *viewtemp = nil;
    if(_itemtype==nil|| ![_itemtype isKindOfClass:[NSString class]])
    {
        _itemtype = @"";
    }
    if([_itemtype isEqualToString:@"0"])
    {///精选
        
        [dicpush setObject:strold_artice forKey:@"old_artice"];
        strurl = Home_JingXuan_URL;
        
        if(_arrListData.count<1)
        {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"V2-Main-choiceness"];
            
            NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            _arrListData = [NSMutableArray new];
            ///数据处理
            if([[dicAll objectForKey:@"linklist"] isKindOfClass:[NSArray class]])
            {
                NSArray *arrtemp = [dicAll objectForKey:@"linklist"];
                for(NSDictionary *dictemp in arrtemp)
                {
                    
                    Article *model = [[Article alloc] initWithDictionary:dictemp];
                    [_arrListData addObject:model];
                }
            }
            
            
            [self reloadData];
        }
        
        
        if(_arrListData.count<1)
        {
            viewtemp = self;
        }
        else
        {
            viewtemp = nil;
        }
    }
    else
    {
        if([_itemtype isEqualToString:@"8"])
        {
            
            strurl = Home_OtherSharejdItem_URL;
            
            viewtemp = self;
        }
        else if([_itemtype isEqualToString:@"7"])
        {
            
            strurl = Home_OtherQWYHItem_URL;
            
            viewtemp = self;
        }
        else
        {
            [dicpush setObject:[NSString stringWithFormat:@"%@",_itemtype] forKey:@"type"];
            
            strurl = Home_OtherItem_URL;
            
            viewtemp = self;
        }
        
        
        
    }
    
    if(_isjiazaidata==NO)
    {
        [self refendreflist];
        return;
    }
    if([_itemtype isEqualToString:@"8"])
    {
        [dicpush setObject:[NSString stringWithFormat:@"%d",inowpage] forKey:@"p"];
        [self.dataController requestHomeItemsJDDataInView:viewtemp url:strurl parter:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
            callback(error,state,describle);
            if(state)
            {
                if(inowpage == 1)
                {
                    _arrListData = [NSMutableArray new];
                }
                if(self.dataController.resultJDDict != nil)
                {
                    strpd = [NSString nullToString:[self.dataController.resultJDDict objectForKey:@"pageData"]];
                }
                for(NSDictionary *dictemp in self.dataController.resultJDListDict)
                {
                    
                    Article *model = [[Article alloc] initWithJDDictionary:dictemp];
                    [_arrListData addObject:model];
                }
                if(self.mj_header.refreshing||self.mj_footer.refreshing)
                {
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(refendreflist) userInfo:nil repeats:NO];
                }
                else
                {
                    if(inowpage == 1)
                    {
                        float ftime = _itemtype.floatValue;
                        if(ftime>2.5)
                        {
                            ftime = 2.5;
                        }
                        if(ftime==0)
                        {
                            ftime = 0.5;
                        }
                        [NSTimer scheduledTimerWithTimeInterval:ftime target:self selector:@selector(refendreflist) userInfo:nil repeats:NO];
                        
                    }
                    else
                    {
                        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(refendreflist) userInfo:nil repeats:NO];
                    }
                    
                }
            }
            else
            {
                if(inowpage==1)
                {
                    [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
                }
                if(self.mj_footer.refreshing)
                {
                    [self.mj_footer endRefreshing];
                }
                if(self.mj_header.refreshing)
                {
                    [self.mj_header endRefreshing];
                }
                
            }
            
        }];
        
    }
    else if([_itemtype isEqualToString:@"7"])
    {
        [dicpush setObject:[NSString stringWithFormat:@"%d",inowpage] forKey:@"p"];
        [self.dataController requestHomeItemsQWYHDataInView:viewtemp url:strurl parter:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
            callback(error,state,describle);
            if(state)
            {
                if(inowpage == 1)
                {
                    _arrListData = [NSMutableArray new];
                }
                
                for(NSDictionary *dictemp in self.dataController.arrListqwyh)
                {
                    
                    Article *model = [[Article alloc] initWithDictionary:dictemp];
                    [_arrListData addObject:model];
                }
                
                [self refendreflist];
                
            }
            else
            {
                if(inowpage==1)
                {
                    [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
                }
                if(self.mj_footer.refreshing)
                {
                    [self.mj_footer endRefreshing];
                }
                if(self.mj_header.refreshing)
                {
                    [self.mj_header endRefreshing];
                }
                
            }
            
        }];
    }
    else
    {
        [self.dataController requestHomeItemsDataInView:viewtemp url:strurl parter:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
            callback(error,state,describle);
            if(state)
            {
                if(inowpage == 1)
                {
                    _arrListData = [NSMutableArray new];
                }
                
                
                @try
                {
                    if(_itemtype==nil|| ![_itemtype isKindOfClass:[NSString class]])
                    {
                        _itemtype = @"";
                    }
                    if([_itemtype isEqualToString:@"0"])
                    {///精选
                        
                        if([[dicpush objectForKey:@"page"] intValue] == 1)
                        {
                            
                            if(self.dataController.resultListDict)
                            {
                                
                                [[NSUserDefaults standardUserDefaults] setObject:[NSJSONSerialization dataWithJSONObject:self.dataController.resultListDict options:NSJSONWritingPrettyPrinted error:nil] forKey:@"V2-Main-choiceness"];
                            }
                        }
                        
                        strold_artice = [NSString nullToString:[self.dataController.resultListDict objectForKey:@"old_artice"]];
                        
                    }
                }
                @catch(NSException *exc)
                {
                    
                }
                @finally
                {
                    
                }
                
                ///数据处理
                if([[self.dataController.resultListDict objectForKey:@"linklist"] isKindOfClass:[NSArray class]])
                {
                    NSArray *arrtemp = [self.dataController.resultListDict objectForKey:@"linklist"];
                    for(NSDictionary *dictemp in arrtemp)
                    {
                        
                        Article *model = [[Article alloc] initWithDictionary:dictemp];
                        [_arrListData addObject:model];
                    }
                }
                
                
                
                [self refendreflist];
                
            }
            else
            {
                if(inowpage==1)
                {
                    [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
                }
                if(self.mj_footer.refreshing)
                {
                    [self.mj_footer endRefreshing];
                }
                if(self.mj_header.refreshing)
                {
                    [self.mj_header endRefreshing];
                }
                
            }
            
        }];
    }
}

//- (void)reloadTableViewDataSource{
//    
//    inowpage = 1;
//    [self loadListData];
//    
//}
//
//- (void)footReloadTableViewDateSource{
//    
//    inowpage++;
//    [self loadListData];
//}

-(void)loadListData
{
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    NSString *strurl = @"";
    
    ////还需要修改 
    NSString *strlastid = @"";
    if(inowpage>1)
    {
        if(_arrListData.count>0)
        {
            NSMutableArray *arrtempdd = [NSMutableArray arrayWithArray:_arrListData];
            Article *model = arrtempdd.lastObject;
            while(model.state.intValue == 1 ||model.state.intValue == 2 ||model.state.intValue == 3)
            {
                [arrtempdd removeLastObject];
                model = nil;
                if(arrtempdd.count>0)
                {
                    model = arrtempdd.lastObject;
                }
            }
            if(model != nil)
            {
                
                if([_itemtype isEqualToString:@"7"])
                {
                    strlastid = [NSString nullToString:model.itemid];
                }
                else
                {
                    strlastid = [NSString nullToString:model.artid];
                }
                
            }
        }
    }
    [dicpush setObject:[NSString stringWithFormat:@"%@",strlastid] forKey:@"lastid"];
    /////
    
    
    [dicpush setObject:[NSString stringWithFormat:@"%d",inowpage] forKey:@"page"];
    if(isjiazai == NO && inowpage == 1)
    {
        isjiazai = YES;
        if([_itemtype isEqualToString:@"0"])
        {
            [dicpush setObject:[NSString stringWithFormat:@"%d",10] forKey:@"pagesize"];
        }
        else
        {
            [dicpush setObject:[NSString stringWithFormat:@"%d",6] forKey:@"pagesize"];
        }
        
        
    }
    else
    {
        [dicpush setObject:[NSString stringWithFormat:@"%d",20] forKey:@"pagesize"];
    }
    
    UIView *viewtemp = nil;
    if(_itemtype==nil|| ![_itemtype isKindOfClass:[NSString class]])
    {
        _itemtype = @"";
    }
    if([_itemtype isEqualToString:@"0"])
    {///精选
        
        [dicpush setObject:strold_artice forKey:@"old_artice"];
        strurl = Home_JingXuan_URL;
        
        if(_arrListData.count<1)
        {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"V2-Main-choiceness"];
            
            NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            _arrListData = [NSMutableArray new];
            ///数据处理
            if([[dicAll objectForKey:@"linklist"] isKindOfClass:[NSArray class]])
            {
                NSArray *arrtemp = [dicAll objectForKey:@"linklist"];
                for(NSDictionary *dictemp in arrtemp)
                {
                    
                    Article *model = [[Article alloc] initWithDictionary:dictemp];
                    [_arrListData addObject:model];
                }
            }
            
            
//            [self reloadData];
        }
        
        
        
        if(_arrListData.count<1)
        {
            viewtemp = self.superview.viewController.view;
        }
        else
        {
            viewtemp = nil;
        }
    }
    else
    {
        if([_itemtype isEqualToString:@"8"])
        {
            
            strurl = Home_OtherSharejdItem_URL;
            
            viewtemp = self;
        }
        else if([_itemtype isEqualToString:@"7"])
        {
            
            strurl = Home_OtherQWYHItem_URL;
            
            viewtemp = self.superview.viewController.view;
        }
        else
        {
            [dicpush setObject:[NSString stringWithFormat:@"%@",_itemtype] forKey:@"type"];
            
            strurl = Home_OtherItem_URL;
            
            viewtemp = self.superview.viewController.view;
        }
        
        
        
    }
    
    if(_isjiazaidata==NO)
    {
        [self reloadData];
        if(self.mj_footer.refreshing)
        {
            [self.mj_footer endRefreshing];
        }
        if(self.mj_header.refreshing)
        {
            [self.mj_header endRefreshing];
        }
        return;
    }
    
     if([_itemtype isEqualToString:@"8"])
     {
         [dicpush setObject:[NSString nullToString:strpd] forKey:@"pd"];
         
         if(isjieshu)
         {
             [self refendreflist];
             [MDB_UserDefault showNotifyHUDwithtext:@"没有更多的数据" inView:self.window];
             return;
         }
         
         [self.dataController requestHomeItemsJDDataInView:viewtemp url:strurl parter:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
             if(state)
             {
                 if(inowpage == 1)
                 {
                     _arrListData = [NSMutableArray new];
                 }
                 if(self.dataController.resultJDDict != nil)
                 {
                     strpd = [NSString nullToString:[self.dataController.resultJDDict objectForKey:@"pageData"]];
                 }
                 for(NSDictionary *dictemp in self.dataController.resultJDListDict)
                 {
                     
                     Article *model = [[Article alloc] initWithJDDictionary:dictemp];
                     [_arrListData addObject:model];
                 }
                 if(self.dataController.resultJDListDict.count<15)
                 {
                     isjieshu = YES;
                 }
                 
                 if(self.mj_header.refreshing||self.mj_footer.refreshing)
                 {
                     [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(refendreflist) userInfo:nil repeats:NO];
                 }
                 else
                 {
                     if(inowpage == 1)
                     {
                         float ftime = _itemtype.floatValue;
                         if(ftime>2.5)
                         {
                             ftime = 2.5;
                         }
                         if(ftime==0)
                         {
                             ftime = 0.5;
                         }
                         [NSTimer scheduledTimerWithTimeInterval:ftime target:self selector:@selector(refendreflist) userInfo:nil repeats:NO];
                         
                     }
                     else
                     {
                         [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(refendreflist) userInfo:nil repeats:NO];
                     }
                     
                 }
             }
             else
             {
                 if(inowpage==1)
                 {
                     [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
                 }
                 if(self.mj_footer.refreshing)
                 {
                     [self.mj_footer endRefreshing];
                 }
                 if(self.mj_header.refreshing)
                 {
                     [self.mj_header endRefreshing];
                 }
                 
             }
             
         }];
         
     }
    else if([_itemtype isEqualToString:@"7"])
    {
        [dicpush setObject:[NSString stringWithFormat:@"%d",inowpage] forKey:@"p"];
        [self.dataController requestHomeItemsQWYHDataInView:viewtemp url:strurl parter:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
            
            if(state)
            {
                if(inowpage == 1)
                {
                    _arrListData = [NSMutableArray new];
                }
                
                for(NSDictionary *dictemp in self.dataController.arrListqwyh)
                {
                    
                    Article *model = [[Article alloc] initWithDictionary:dictemp];
                    [_arrListData addObject:model];
                }
                
                if(self.mj_header.refreshing||self.mj_footer.refreshing)
                {
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(refendreflist) userInfo:nil repeats:NO];
                }
                else
                {
                    if(inowpage == 1)
                    {
                        float ftime = _itemtype.floatValue;
                        if(ftime>2.5)
                        {
                            ftime = 2.5;
                        }
                        if(ftime==0)
                        {
                            ftime = 0.5;
                        }
                        [NSTimer scheduledTimerWithTimeInterval:ftime target:self selector:@selector(refendreflist) userInfo:nil repeats:NO];
                        
                    }
                    else
                    {
                        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(refendreflist) userInfo:nil repeats:NO];
                    }
                    
                }
            }
            else
            {
                if(inowpage==1)
                {
                    [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
                }
                if(self.mj_footer.refreshing)
                {
                    [self.mj_footer endRefreshing];
                }
                if(self.mj_header.refreshing)
                {
                    [self.mj_header endRefreshing];
                }
                
            }
            
        }];
    }
    else
    {
        
        [self.dataController requestHomeItemsDataInView:viewtemp url:strurl parter:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
            if(self.mj_footer.refreshing)
            {
                [self.mj_footer endRefreshing];
            }
            if(self.mj_header.refreshing)
            {
                [self.mj_header endRefreshing];
            }
            if(state)
            {
                
                if(inowpage == 1)
                {
                    _arrListData = [NSMutableArray new];
                }
                
                
                @try
                {
                    if(_itemtype==nil|| ![_itemtype isKindOfClass:[NSString class]])
                    {
                        _itemtype = @"";
                    }
                    if([_itemtype isEqualToString:@"0"])
                    {///精选
                        
                        if([[dicpush objectForKey:@"page"] intValue] == 1)
                        {
                            
                            if(self.dataController.resultListDict.count>0)
                            {
                                
                                [[NSUserDefaults standardUserDefaults] setObject:[NSJSONSerialization dataWithJSONObject:self.dataController.resultListDict options:NSJSONWritingPrettyPrinted error:nil] forKey:@"V2-Main-choiceness"];
                            }
                        }
                        
                        strold_artice = [NSString nullToString:[self.dataController.resultListDict objectForKey:@"old_artice"]];
                        
                    }
                }
                @catch(NSException *exc)
                {
                    
                }
                @finally
                {
                    
                }
                ///数据处理
                if([[self.dataController.resultListDict objectForKey:@"linklist"] isKindOfClass:[NSArray class]])
                {
                    NSArray *arrtemp = [self.dataController.resultListDict objectForKey:@"linklist"];
                    for(NSDictionary *dictemp in arrtemp)
                    {
                        
                        Article *model = [[Article alloc] initWithDictionary:dictemp];
                        [_arrListData addObject:model];
                    }
                }
                
                if(self.mj_header.refreshing||self.mj_footer.refreshing)
                {
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(refendreflist) userInfo:nil repeats:NO];
                }
                else
                {
                    if(inowpage == 1)
                    {
                        float ftime = _itemtype.floatValue;
                        if(ftime>2.5)
                        {
                            ftime = 2.5;
                        }
                        if(ftime==0)
                        {
                            ftime = 0.5;
                        }
                        [NSTimer scheduledTimerWithTimeInterval:ftime target:self selector:@selector(refendreflist) userInfo:nil repeats:NO];
                        
                    }
                    else
                    {
                        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(refendreflist) userInfo:nil repeats:NO];
                    }
                    
                }
                
            }
            else
            {
                if(inowpage==1)
                {
                    [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
                }
                
            }
            
        }];
    }
}
/*
-(void)loadJD99ListData
{
    /////拼接
    NSString *strparam_json = [NSString stringWithFormat:@"{\"unionSearchParam\":{\"sortType\":\"desc\",\"pageIndex\":%d,\"pageSize\":10,\"eliteId\":\"10\"}}",inowpage];
    NSString *strpush = [NSString stringWithFormat:@"method=jd.kpl.open.union.search.byelited&access_token=%@&app_key=%@&timestamp=%@&format=json&v=1.0&sign_method=md5&param_json=%@",@"45cee77441b64ff8be0350382b36a9e98",jd_app_key,[MDB_UserDefault strTimefromDatas:[NSDate date] dataFormat:@"yyyy-MM-dd HH:mm:ss"],strparam_json];
    NSString *strtemp = [NSString stringWithFormat:@"appSecret=%@&%@&appSecret=%@",jd_app_secret,strpush,jd_app_secret];
    NSString *strsign = [QNMD5 MD5:strtemp];

    strpush = [NSString stringWithFormat:@"%@&sign=%@",strpush,strsign];

    [self.dataController requestHomeItemsJDDataInView:self url:[NSString stringWithFormat:@"https://router.jd.com/api?%@",strpush] parter:nil Callback:^(NSError *error, BOOL state, NSString *describle) {
        arrjd99list = [NSMutableArray new];
        if(state)
        {
            
            for(NSDictionary *dictemp in self.dataController.resultJDListDict)
            {
                Article *model = [[Article alloc] initWithJDDictionary:dictemp];
                [arrjd99list addObject:model];
            }
        }
        [self jingdongPinGouDataList];
        [self refendreflist];
    }];
    
}

-(void)jingdongPinGouDataList
{
    
    NSDate *strlsatdate;
    if(arrbl99list.count>0)
    {
        Article *model = arrbl99list[0];
        strlsatdate = model.createtime;
    }
    else
    {
        if(_arrListData.count>0)
        {
            Article *model = _arrListData.lastObject;
            strlsatdate = model.createtime;
        }
        else
        {
            strlsatdate = [NSDate date];
        }
    }
    int icount = 1;
    for(Article *model in arrjd99list)
    {
        
        int i = arc4random()%3;
        icount+=i;
        if(icount>arrbl99list.count-1)
        {
            if(arrbl99list.count>0)
            {
                Article *modeltemp = arrbl99list.lastObject;
                strlsatdate = modeltemp.createtime;
            }
            
            [arrbl99list addObject:model];
            
        }
        else
        {
            Article *modeltemp = arrbl99list[icount];
            strlsatdate = modeltemp.createtime;
            
            [arrbl99list insertObject:model atIndex:icount];
        }
        model.createtime = strlsatdate;
        icount+=1;
    }
    
    
    [_arrListData addObjectsFromArray:arrbl99list];
    
    
}
*/


-(void)refendreflist
{
    [self reloadData];
    if(self.mj_footer.refreshing)
    {
        [self.mj_footer endRefreshing];
    }
    if(self.mj_header.refreshing)
    {
        [self.mj_header endRefreshing];
    }
}


- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrListData.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        Article *model = _arrListData[indexPath.row];
        if([model.state intValue] == 1)
        {///:原创数据
            return 125;
        }
        else if([model.state intValue] == 2||[model.state intValue] == 3)
        {///优惠券
            return 125;
        }
        if(_itemtype.intValue == 7)
        {
            return 125;
        }
    } @catch (NSException *exception) {
        return 0;
    } @finally {
        
    }
    
    ////全网优惠的高度在110
    
    
    return 125;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Article *model;
    @try {
        if(indexPath.row<_arrListData.count)
        {
            model = _arrListData[indexPath.row];
        }
    } @catch (NSException *exception) {
        return nil;
    } @finally {
        
    }
    
    if([model.state intValue] == 1)
    {///:原创数据
        JingXuanYuanChuangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        
        if(!cell)
        {
            cell = [[JingXuanYuanChuangTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = model;
        
        return cell;
    }
    else if([model.state intValue] == 2||[model.state intValue] == 3)
    {///优惠券
        
        JingXuanYouHuiQuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        if(!cell)
        {
            cell = [[JingXuanYouHuiQuanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell fetchCellData:model];
        
        return cell;
        
        
    }
    else
    {
     
        if(_itemtype.intValue == 7)
        {
            QuanWangYHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            
            if(!cell)
            {
                cell = [[QuanWangYHTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.model = model;
            return cell;
        }
        else
        {
            ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell)
            {
                cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell fetchCellData:model];
            
            return cell;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>_arrListData.count-1) return;
    Article *model = _arrListData[indexPath.row];
    model.isSelected = YES;
    @try
    {
        NSMutableArray *arrbldj = [[NSUserDefaults standardUserDefaults] objectForKey:@"baoliaoyidianji"];
        NSMutableArray *arrtemp = [NSMutableArray new];
        [arrtemp addObjectsFromArray:arrbldj];
        if(_itemtype.intValue == 7)
        {
            BOOL isbool = [arrtemp containsObject: [NSString stringWithFormat:@"%@", model.itemid]];
            if(isbool==NO)
            {
                if(arrtemp.count>=200)
                {
                    [arrtemp removeLastObject];
                }
                
                [arrtemp insertObject:[NSString stringWithFormat:@"%@",model.itemid] atIndex:0];
                
            }
        }
        else if([model.state intValue] == 2||[model.state intValue] == 3)
        {///优惠券
            
            BOOL isbool = [arrtemp containsObject: [NSString stringWithFormat:@"%@", model.main_id]];
            if(isbool==NO)
            {
                if(arrtemp.count>=200)
                {
                    [arrtemp removeLastObject];
                }
                
                [arrtemp insertObject:[NSString stringWithFormat:@"%@",model.main_id] atIndex:0];
                
            }
            
            
        }
        else
        {
            BOOL isbool = [arrtemp containsObject: [NSString stringWithFormat:@"%@", model.artid]];
            if(isbool==NO)
            {
                if(arrtemp.count>=200)
                {
                    [arrtemp removeLastObject];
                }
                
                [arrtemp insertObject:[NSString stringWithFormat:@"%@",model.artid] atIndex:0];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:arrtemp forKey:@"baoliaoyidianji"];
    }
    @catch (NSException *exc)
    {
        
    }
    @finally
    {
        
    }
    
    if(model.isJDZhiLian == YES)
    {
        ///url跳转
        KeplerApiManager *kmanager = [KeplerApiManager sharedKPService];
        kmanager.openJDTimeout = 15;
        kmanager.isOpenByH5 = NO;
        kmanager.JDappBackTagID = jd_app_keplerID;
        //    kmanager.actId = @"没得比";
        //    kmanager.ext = @"没得比";
        NSDictionary *dicinfo = @{@"keplerCustomerInfo":@"没得比"};
        [kmanager openItemDetailWithSKU:[NSString stringWithFormat:@"%@",model.artid] sourceController:self.viewController jumpType:2 userInfo:dicinfo];
    }
    else
    {
        if(model.state.intValue == 1)
        {///原创
            OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:[NSString stringWithFormat:@"%@", model.artid]];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
        else if([model.state intValue] == 2||[model.state intValue] == 3)
        {///优惠券
            
            VolumeContentViewController *vvc = [[VolumeContentViewController alloc] init];
            vvc.present_type = model.changetype.intValue;////？？？？
            if(model.state.integerValue == 2)
            {
                vvc.type = waresTypeMaterial;
                vvc.haveto = @"address";
            }
            else
            {
                vvc.type = waresTypeCoupon;
            }
            
            vvc.juancleid = model.main_id.integerValue;
            [self.viewController.navigationController pushViewController:vvc animated:YES];
            
            
        }
        else
        {
            if(_itemtype.intValue == 7)
            {
                QuanWangYHDetailViewController *qvc = [[QuanWangYHDetailViewController alloc] init];
                qvc.strid = model.itemid;
                [self.viewController.navigationController pushViewController:qvc animated:YES];
                
            }
            else
            {
                ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
                pvc.theObject = model;
                [self.viewController.navigationController pushViewController:pvc animated:YES];
            }
            
            
        }
    }
    
    [tableView reloadData];
}


#pragma mark - firstTableView的代理方法scrollViewDidScroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y<flastscroll)
    {

        [self.scrodelegate zhidingisHidden:NO];
    }
    else
    {
        [self.scrodelegate zhidingisHidden:YES];

    }
    flastscroll = scrollView.contentOffset.y;
    
    
    flasty = scrollView.contentOffset.y;
    
    CGFloat placeHolderHeight = self.topView.height+self.topView.fbouttonHeight;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    if (offsetY >= 0 && offsetY <= placeHolderHeight) {
        self.topView.y = -offsetY+self.topView.fbouttonHeight;
        self.topView.isHiddennav = NO;
    }
    else if (offsetY > placeHolderHeight) {
        self.topView.y = - placeHolderHeight;
        self.topView.isHiddennav = YES;
        
    }
    else if (offsetY <0) {
        self.topView.y =  - offsetY+self.topView.fbouttonHeight;
    }
    
}

-(void)setScrollValue
{
    
    CGFloat placeHolderHeight = self.topView.height;
    if(flasty<placeHolderHeight)
    {
        [self setContentOffset:CGPointMake(0, placeHolderHeight+2)];
    }
     
    
}



@end
