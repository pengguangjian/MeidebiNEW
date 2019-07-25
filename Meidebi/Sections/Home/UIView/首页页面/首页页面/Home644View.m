//
//  Home644View.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/6/27.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "Home644View.h"

//#import "Home644TableViewController.h"

#import "MDB_UserDefault.h"

#import "ImagePlayerView.h"

#import <UMAnalytics/MobClick.h>

#import "SVModalWebViewController.h"
#import "ProductInfoViewController.h"
#import "OriginalDetailViewController.h"

#import "ProductInfoViewController.h"

#import "Article.h"

#import "OriginalDetailViewController.h"

#import <MJRefresh.h>

#import "Home644TableView.h"
#import "Home644HeaderItemView.h"


@interface Home644View ()<UIScrollViewDelegate,Home644HeaderViewDelegate,Home644TableViewDelegate,Home644HeaderViewScrollDelegate>
{
    
    float iscrolloffset0;
    float iscrolloffset1;
    float iscrolloffset2;
    float iscrolloffset3;
    float iscrolloffset4;
    float iscrolloffset5;
    
    float flastss;
    
    BOOL isscrolljilu;
    
    float fisfooterRef;
    
    NSMutableArray *arrloadlist;
    
}
@property (nonatomic, strong) UIScrollView *scvback;

@property (nonatomic , strong) UIScrollView *scvItemView;

@property (nonatomic , retain )Home644HeaderItemView *headeritemView;
///item
@property (nonatomic , retain) UIView *viewItem;
@property (nonatomic , retain) NSMutableArray *arrItems;
@property (nonatomic , retain) NSMutableArray *arrItemBt;
////当前选中的item
@property (nonatomic , retain) UIButton *btselectItem;


///所有的列表
@property (nonatomic , retain) NSMutableArray *arrtableView;

///banner
@property (nonatomic , retain) ImagePlayerView *imgvhead;
@property (nonatomic , retain) NSArray *bannerImages;

///当前的type
@property (nonatomic , retain) NSString *strnowtype;

@property (nonatomic , retain) UIButton *btzhiding;

@end

@implementation Home644View

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        iscrolloffset0 = kMainScreenW*0.45-kTopHeight;
        iscrolloffset1 = kMainScreenW*0.45-kTopHeight;
        iscrolloffset2 = kMainScreenW*0.45-kTopHeight;
        iscrolloffset3 = kMainScreenW*0.45-kTopHeight;
        iscrolloffset4 = kMainScreenW*0.45-kTopHeight;
        iscrolloffset5 = kMainScreenW*0.45-kTopHeight;
        [self drawUI];
        flastss = 0.0;
        fisfooterRef = 0.0;
        _btzhiding = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50*kScale, 50*kScale)];
        [_btzhiding.layer setMasksToBounds:YES];
        [_btzhiding.layer setCornerRadius:_btzhiding.height/2.0];
        [_btzhiding setRight:BOUNDS_WIDTH-10];
        [_btzhiding setBottom:frame.size.height-50];
        [_btzhiding setImage:[UIImage imageNamed:@"zhiding_list"] forState:UIControlStateNormal];
        [_btzhiding setBackgroundColor:RGB(248, 248, 248)];
        [self addSubview:_btzhiding];
        [_btzhiding addTarget:self action:@selector(topScrollAction) forControlEvents:UIControlEventTouchUpInside];
        [_btzhiding setHidden:YES];
        
    }
    return self;
}


-(void)drawUI
{
    
    
    
    
    _scvItemView = [[UIScrollView alloc] init];//CGRectMake(0, 0, kMainScreenW, self.height)
    [_scvItemView setTag:100];
    [self addSubview:_scvItemView];
    [_scvItemView setDelegate:self];
    [_scvItemView setPagingEnabled:YES];
    [_scvItemView setShowsHorizontalScrollIndicator:NO];
    [_scvItemView setShowsVerticalScrollIndicator:NO];
    [_scvItemView setContentSize:CGSizeMake(kMainScreenW*_arrItems.count, 0)];
    [_scvItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    float fjjh = 90*kScale;
    if(kMainScreenW<330)
    {
        fjjh = 95;
    }
    _headerView = [[Home644HeaderView alloc] initWithFrame:CGRectMake(0, 50*kScale, kMainScreenW, kMainScreenW*0.45+fjjh)];
    [_headerView setDelegate:self];
    [self addSubview:_headerView];
    
    _headeritemView = [[Home644HeaderItemView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 50*kScale)];
    [_headeritemView setDelegate:self];
    [self addSubview:_headeritemView];
    
    
    NSData *datatemp = [[NSUserDefaults standardUserDefaults] objectForKey:@"home_items_banner_scro"];
    if(datatemp!= nil)
    {
        NSArray *arrtemp = [NSJSONSerialization JSONObjectWithData:datatemp options:NSJSONReadingMutableContainers error:nil];
        if(arrtemp.count>0)
        {
            _arrItems = [NSMutableArray new];
            [_arrItems addObjectsFromArray:arrtemp];
        }
        else
        {
            [self nomoValue];
        }
    }
    else
    {
        [self nomoValue];
    }
    [_headeritemView bindItemsData:_arrItems];
    [self listTabviewItem:NO];
}
-(void)nomoValue
{
    ///默认数据
    _arrItems = [NSMutableArray new];
    NSArray *arrtemp =  [NSMutableArray arrayWithObjects:@"精选",@"海淘",@"直邮",@"国内",@"猫实惠",@"京选",@"9.9包邮", nil];
    for(int i = 0 ; i <arrtemp.count ;i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:arrtemp[i] forKey:@"name"];
        [dic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"type"];
        [_arrItems addObject:dic];
    }
}

-(void)listTabviewItem:(BOOL)isjiazai
{
    [_scvItemView removeAllSubviews];

    _arrtableView = [NSMutableArray new];
    arrloadlist = [NSMutableArray new];
    for(int i = 0 ; i < _arrItems.count;i++)
    {
        NSDictionary *dic = _arrItems[i];
        float fheight = kMainScreenH-kTabBarHeight-kTopHeight-50*kScale;///_scvItemView.height-_headeritemView.bottom
        Home644TableView *tabview = [[Home644TableView alloc] initWithFrame:CGRectMake(kMainScreenW*i, _headeritemView.bottom, kMainScreenW, fheight) andtype:[NSString nullToString:[dic objectForKey:@"type"]] andjiazai:isjiazai];
        [tabview setTag:i];
        [tabview setIsjiazaidata:isjiazai];
        tabview.itemtype = [NSString nullToString:[dic objectForKey:@"type"]];
        tabview.topView = _headerView;
        [tabview setScrodelegate:self];
        [_scvItemView addSubview:tabview];
        [_arrtableView addObject:tabview];
        [arrloadlist addObject:tabview];
        if(isjiazai==NO && i==0)
        {
            [tabview loadDataback:^(NSError *error, BOOL state, NSString *describle) {
                
            }];
        }
    }
    [_scvItemView setContentSize:CGSizeMake(_scvItemView.width*_arrItems.count, 0)];
    
    if(isjiazai)
    {
        [self loadlistAction];
    }
    
}

-(void)loadlistAction
{
    if(arrloadlist.count>0)
    {
        Home644TableView *tabview = arrloadlist[0];
        [tabview loadDataback:^(NSError *error, BOOL state, NSString *describle) {
            @try {
                if(arrloadlist.count>0)
                {
                    [arrloadlist removeObjectAtIndex:0];
                }
                
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(arrloadlist.count>0)
                {
                    [self loadlistAction];
                }
            });
        }];
    }
}


-(void)topScrollAction
{
    if(_headeritemView.inowselectitem<_arrtableView.count)
    {
        Home644TableView *tabview = _arrtableView[_headeritemView.inowselectitem];
        [tabview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - Home644HeaderViewScrollDelegate
-(void)Home644HeaderViewPanMove:(float)fvalue isend:(BOOL)isend
{
    Home644TableView *tabview = _arrtableView[_headeritemView.inowselectitem];
    
    float ftemp = tabview.contentOffset.y;
    if(isend)
    {
        if(ftemp+fvalue<-60)
        {
            [tabview tabviewHeaderRef];
        }
        else
        {
            if(ftemp+fvalue<0)
            {
                [tabview setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            else
            {
                [tabview setContentOffset:CGPointMake(0, ftemp+fvalue) animated:NO];
            }
            
        }
    }
    else
    {
        if(ftemp+fvalue<-60)
        {
            if(fvalue<0)
            {
                [tabview setContentOffset:CGPointMake(0, ftemp-1) animated:NO];
            }
            else
            {
                [tabview setContentOffset:CGPointMake(0, ftemp+fvalue) animated:NO];
            }
        }
        else
        {
             [tabview setContentOffset:CGPointMake(0, ftemp+fvalue) animated:NO];
        }
        
    }
    
}

#pragma mark - bananer 数据
-(void)bindBanarData:(NSArray *)arrmodels
{
    [_headerView bindBanarData:arrmodels];
}

#pragma mark - items数据
-(void)bindItemsData:(NSArray *)arrmodels
{
    if([arrmodels isKindOfClass:[NSArray class]])
    {
        if(arrmodels.count > 0)
        {
            
            [_headeritemView bindItemsData:arrmodels];
            _arrItems = (NSMutableArray *)arrmodels;
        }
    }
    
    [self listTabviewItem:YES];
    
    
    
}

-(void)btNowSelectItem:(NSInteger)item
{
    [_scvItemView setContentOffset:CGPointMake(_scvItemView.width*item, 0)];
    
    for( Home644TableView *tabview in _arrtableView)
    {
        [tabview setScrollValue];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = ceilf(scrollView.contentOffset.x / _scvItemView.width);
    [_headeritemView btselectItem:index];
    for( Home644TableView *tabview in _arrtableView)
    {
        [tabview setScrollValue];
    }
}

-(void)zhidingisHidden:(BOOL)ishiden
{
    [_btzhiding setHidden:ishiden];
}
///下拉刷新通知
-(void)headerRefNotifi
{
    [self.delegate jingXuanheaderRef];
}

@end
