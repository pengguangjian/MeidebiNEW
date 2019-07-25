//
//  MyCouponsTableView.h
//  Meidebi
//
//  Created by 杜非 on 15/2/12.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Juancle.h"
#import <MJRefresh/MJRefresh.h>
@protocol MyCouponsTableViewDelegate <NSObject>

@optional
-(void)tableViewSelecte:(Juancle *)share;

@end

@interface MyCouponsTableView : UIView<UITableViewDataSource,UITableViewDelegate>{

    UITableView             *_tableview;
}
@property(nonatomic,weak)id<MyCouponsTableViewDelegate>delegate;
@property(nonatomic,assign)BOOL reloading;
@property(nonatomic,assign)BOOL foodReloading;
@property(nonatomic,strong)NSMutableArray *arrData;

-(id)initWithFrame:(CGRect)frame delegate:(id)delegate istimeOut:(BOOL)tbool;

-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;
@end