//
//  Home644HeaderItemView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/20.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "Home644HeaderItemView.h"
#import "MDB_UserDefault.h"


#import <UMAnalytics/MobClick.h>

#import "SVModalWebViewController.h"
#import "ProductInfoViewController.h"
#import "OriginalDetailViewController.h"

#import "ProductInfoViewController.h"

#import "Article.h"

#import "OriginalDetailViewController.h"

@interface Home644HeaderItemView ()


///item
@property (nonatomic , retain) UIScrollView *viewItem;
@property (nonatomic , retain) NSMutableArray *arrItems;
@property (nonatomic , retain) NSMutableArray *arrItemBt;
////当前选中的item
@property (nonatomic , retain) UIButton *btselectItem;


@end

@implementation Home644HeaderItemView

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeitemNotfication:) name:@"homeitemNotfication" object:nil];
        
        _viewItem = [self drawitem:CGRectMake(0, 0, frame.size.width, 50*kScale)];
        [self addSubview:_viewItem];
        
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
        
        
    }
    return self;
}

-(void)nomoValue
{
    ///默认数据
    _arrItems = [NSMutableArray new];
    NSArray *arrtemp =  [NSMutableArray arrayWithObjects:@"精选",@"海淘",@"直邮",@"国内",@"猫实惠",@"9.9包邮", nil];
    for(int i = 0 ; i <arrtemp.count ;i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:arrtemp[i] forKey:@"name"];
        [dic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"type"];
        [_arrItems addObject:dic];
    }
}

-(UIScrollView *)drawitem:(CGRect)rect
{
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setShowsVerticalScrollIndicator:NO];
    [view setShowsHorizontalScrollIndicator:NO];
    [view setBounces:NO];
    
    _arrItemBt = [NSMutableArray new];
    NSArray *arrtitle = _arrItems;
    float fwidth = view.width/5.5;
    float fright = 0.0;
    for(int i = 0 ; i < arrtitle.count; i++)
    {
        NSDictionary *dic = arrtitle[i];
        UIButton *btitem = [[UIButton alloc] initWithFrame:CGRectMake(fwidth*i, 0, fwidth, view.height-2)];
        [btitem setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [btitem setTitleColor:RGB(60, 60, 60) forState:UIControlStateNormal];
        [btitem.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btitem setTag:i];
        [view addSubview:btitem];
        [btitem addTarget:self action:@selector(btItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [_arrItemBt addObject:btitem];
        if(i==0)
        {
            [btitem setTitleColor:RadMenuColor forState:UIControlStateNormal];
            _btselectItem = btitem;
            _inowselectitem = 0;
        }
        fright = btitem.right;
    }
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, fright, 1)];
    [viewline setBackgroundColor:RadLineColor];
    [view addSubview:viewline];
    
    UIView *viewmenuline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1.5, fwidth, 1.5)];
    [viewmenuline setBackgroundColor:RadMenuColor];
    [viewmenuline setTag:110];
    [view addSubview:viewmenuline];
    
    [view setContentSize:CGSizeMake(fright, 0)];
    
    return view;
}

-(void)btItemAction:(UIButton *)sender
{
    if(sender.tag==_btselectItem.tag)return;
    
    [_btselectItem setTitleColor:RGB(60, 60, 60) forState:UIControlStateNormal];
    _btselectItem = self.arrItemBt[sender.tag];
    [_btselectItem setTitleColor:RadMenuColor forState:UIControlStateNormal];
    UIView *viewitemLine = [_btselectItem.superview viewWithTag:110];
    [UIView animateWithDuration:0.3 animations:^{
        
        [viewitemLine setCenterX:_btselectItem.centerX];
        
    }];
    [self.delegate btNowSelectItem:_btselectItem.tag];
    _inowselectitem = _btselectItem.tag;
    
    float fcontt = _viewItem.contentOffset.x+_viewItem.width;
    
    if(_btselectItem.right>fcontt)
    {
        [_viewItem setContentOffset:CGPointMake(_btselectItem.right-_viewItem.width, 0)];
    }
    else if (_btselectItem.left<_viewItem.contentOffset.x)
    {
        [_viewItem setContentOffset:CGPointMake(_btselectItem.left, 0)];
    }
    
    
}

-(void)btselectItem:(NSInteger)item
{
    if(item>=_arrItemBt.count)return;
    if(item==_btselectItem.tag)return;
    
    [_btselectItem setTitleColor:RGB(60, 60, 60) forState:UIControlStateNormal];
    _btselectItem = self.arrItemBt[item];
    [_btselectItem setTitleColor:RadMenuColor forState:UIControlStateNormal];
    UIView *viewitemLine = [_btselectItem.superview viewWithTag:110];
    [UIView animateWithDuration:0.3 animations:^{
        
        [viewitemLine setCenterX:_btselectItem.centerX];
        
    }];
    _inowselectitem = item;
    
    //    if(_viewItem.contentOffset.x>0)
    //    {
    //
    //
    //    }
    
    float fcontt = _viewItem.contentOffset.x+_viewItem.width;
    
    if(_btselectItem.right>fcontt)
    {
        [_viewItem setContentOffset:CGPointMake(_btselectItem.right-_viewItem.width, 0)];
    }
    else if (_btselectItem.left<_viewItem.contentOffset.x)
    {
        [_viewItem setContentOffset:CGPointMake(_btselectItem.left, 0)];
    }
    
    
}


-(void)homeitemNotfication:(NSNotification *)notifi
{
    @try
    {
        NSString *strtemp = [NSString nullToString:notifi];
        int i = 0;
        for(NSDictionary *dic in _arrItems)
        {
            NSString *strtitle = [NSString nullToString:[dic objectForKey:@"name"]];
            
            if([strtemp isEqualToString:strtitle] && strtemp.length>0)
            {
                
                [self btItemAction:_arrItemBt[i]];
            }
            i++;
        }
    }
    @catch (NSException *exc)
    {
        
    }
    @finally
    {
        
    }
    
    
    
}
#pragma mark - items数据
-(void)bindItemsData:(NSArray *)arrmodels
{
    _arrItems = (NSMutableArray *)arrmodels;
    CGRect rect =  _viewItem.frame;
    [_viewItem removeFromSuperview];
    _viewItem = [self drawitem:rect];
    [self addSubview:_viewItem];
    if(arrmodels.count>0)
    {
        NSData *datatemp = [NSJSONSerialization dataWithJSONObject:arrmodels options:NSJSONWritingPrettyPrinted error:nil];
        if(datatemp!= nil)
        {
            [[NSUserDefaults standardUserDefaults] setObject:datatemp forKey:@"home_items_banner_scro"];
        }
        
    }
    
}

@end
