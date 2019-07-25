//
//  MyhouseTableView.h
//  Meidebi
//
//  Created by 杜非 on 15/2/10.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sharecle.h"
#import "Article.h"
#import "Juancle.h"

#import "myhousejuancel.h"


@protocol MyhouseTableViewDelegate <NSObject>

@optional

-(void)tableViewSelecte:(myhousejuancel *)share ftype:(NSInteger)ftype;

@end
@interface MyhouseTableView : UIView<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView             *_tableview;
    
}
@property(nonatomic,weak)id <MyhouseTableViewDelegate>delegate;
@property(nonatomic,assign)BOOL reloading;
@property(nonatomic,assign)BOOL foodReloading;
@property(nonatomic,strong)NSMutableArray *arrData;
@property(nonatomic,assign)NSInteger ftype;


-(id)initWithFrame:(CGRect)frame delegate:(id)delegat ftype:(NSInteger)ftype;


-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

@end
