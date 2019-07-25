//
//  Home644TableViewController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/6/27.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WareDataController.h"
#import "Home644DataController.h"

#import "Home644HeaderView.h"

@class Article;

@protocol Home644TableViewControllerDelegate <NSObject>

-(void)tabViewHeightChangeViewTag:(NSInteger)tag andvalue:(float)fvalue;

- (void)tableViewSelecte:(Article *)art;


-(void)tabViewScrollValue:(float)fvalue;

///刷新结束
-(void)refHeaderEndAction;
-(void)refFooterEndAction;


@end


@interface Home644TableViewController : UITableViewController

@property (nonatomic, weak) id<Home644TableViewControllerDelegate>delegate;
@property (nonatomic, strong) NSString *siteid;
@property (nonatomic, strong) NSString *cates;
//@property (nonatomic, assign) WareType wareType;
//@property (nonatomic, assign) WaresTableVcType tableVcType;
//@property (nonatomic, assign) WareRequestType requestType;
@property (nonatomic, assign) float fviewheight;

@property (strong, nonatomic) Home644HeaderView *topView;

@property (nonatomic, assign) NSString *itemtype;

- (void)reloadTableViewDataSource;

- (void)footReloadTableViewDateSource;


-(void)loadFirstListData;

-(void)scrollDidScrollValue:(float)fvalue;


@end
