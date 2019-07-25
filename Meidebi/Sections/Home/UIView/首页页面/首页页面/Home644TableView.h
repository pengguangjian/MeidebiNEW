//
//  Home644TableView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/6.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Home644HeaderView.h"

@protocol Home644TableViewDelegate <NSObject>

-(void)zhidingisHidden:(BOOL)ishiden;

///下拉刷新通知
-(void)headerRefNotifi;

@end

@interface Home644TableView : UITableView

@property (strong, nonatomic) Home644HeaderView *topView;

@property (nonatomic , weak) id<Home644TableViewDelegate>scrodelegate;

@property (nonatomic, retain) NSString *itemtype;
@property (nonatomic, assign) BOOL isjiazaidata;

-(Home644TableView * )initWithFrame:(CGRect)frame andtype:(NSString *)type andjiazai:(BOOL)isjiazai;

-(void)setScrollValue;

///请求数据
-(void)loadDataback:(completeCallback)callback;

-(void)tabviewHeaderRef;

@end
