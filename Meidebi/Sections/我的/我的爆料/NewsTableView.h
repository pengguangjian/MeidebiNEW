//
//  NewsTableView.h
//  Meidebi
//
//  Created by 杜非 on 15/2/9.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myBorkeNews.h"
#import <MJRefresh/MJRefresh.h>
@protocol NewsTableViewDelegate <NSObject>

@optional

-(void)tableViewSelecte:(myBorkeNews *)myBorkNews;

@end
@interface NewsTableView : UIView<UITableViewDataSource,UITableViewDelegate>{

    UITableView             *_tableview;
}
@property(nonatomic,weak)id <NewsTableViewDelegate>delegate;
@property(nonatomic,assign)BOOL reloading;
@property(nonatomic,assign)BOOL foodReloading;
@property(nonatomic,strong)NSMutableArray *arrData;

-(id)initWithFrame:(CGRect)frame  delegate:(id)delegat;


-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

@end
