//
//  CommentTableView.h
//  Meidebi
//
//  Created by 杜非 on 15/2/5.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CommentViewController.h"
@protocol CommentTableViewDelegate <NSObject>

@optional
-(BOOL)tableViewTouch;
-(void)comment:(int)type cellrow:(Comment *)ment;
@end

@interface CommentTableView : UIView<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView             *_tableview;
}
@property(nonatomic,weak)id<CommentTableViewDelegate>delegate;
@property(nonatomic,assign)BOOL reloading;
@property(nonatomic,assign)BOOL foodReloading;
@property(nonatomic,strong)NSMutableArray *arrData;

@property(nonatomic,assign)NSInteger type;//1、为链接（包含单品，活动，优惠卷） 2 晒单 3 券交易
@property(nonatomic,assign)NSInteger  linkid;//linkid：（必须，即单品、活动、优惠卷的ID）
@property(nonatomic,assign)BOOL      isup;

-(id)initWithFrame:(CGRect)frame type:(NSInteger)type linkid:(NSInteger)linkid;
-(void)commentZan:(Comment *)ment;

-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;
-(void)reloaddatewarr;

@end



