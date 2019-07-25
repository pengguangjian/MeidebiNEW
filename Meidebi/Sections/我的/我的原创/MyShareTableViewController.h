//
//  MyShareTableViewController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/5/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sharecle.h"
#import "Marked.h"
#import <MJRefresh/MJRefresh.h>

@interface MarkedwithPhoto : NSObject
@property(nonatomic,strong)Marked *mark;
@property(nonatomic,strong)NSData *photoData;

@end


@protocol MyShareTableViewControllerDelegate <NSObject>

@optional

-(void)tableViewSelecte:(NSInteger)shareid boll:(BOOL)isRightbut;

-(void)tableViewcaogaoSelecte:(NSString *)shareid type:(NSInteger)type;

@end

@interface MyShareTableViewController : UITableViewController

@property(nonatomic,weak)id <MyShareTableViewControllerDelegate>delegate;
@property(nonatomic,assign)BOOL reloading;
@property(nonatomic,assign)BOOL foodReloading;
@property(nonatomic,strong)NSMutableArray *arrData;

@property(nonatomic,strong) NSString *strtype;

-(void)didSuccessSendShare:(BOOL)state;
-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

@end
