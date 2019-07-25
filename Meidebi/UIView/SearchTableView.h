//
//  SearchTableView.h
//  Meidebi
//
//  Created by 杜非 on 15/2/4.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "Articlel.h"
#import <MJRefresh/MJRefresh.h>
#import "MenuView.h"

#import "SearchGoodsTableViewCell.h"

#import "SearchYuanChuangTableViewCell.h"

#import "SearchUserTableViewCell.h"

@protocol SearchTableViewDelegate <NSObject>

@optional
-(void)tableViewSelecte:(Articlel *)art;

-(void)tabViewSelectItem:(id)model andheadertag:(NSInteger)tag;

-(void)tabViewBeginDragging;

@end
@interface SearchTableView : UIView<UITableViewDataSource,UITableViewDelegate,MenuDelegate>{
    
    UITableView             *_tableview;
    
    MenuView  *menuview;
    
}

@property(nonatomic,weak)id <SearchTableViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame search:(NSString *)searchStr  delegate:(id)delegat;
@property(nonatomic,assign)BOOL reloading;
@property(nonatomic,assign)BOOL foodReloading;


-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

////更新搜索的词
-(void)loadSearchKeywords:(NSString *)searchKW;


@end
