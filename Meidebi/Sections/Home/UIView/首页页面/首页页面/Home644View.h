//
//  Home644View.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/6/27.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Home644HeaderView.h"

@protocol Home644ViewDelegate <NSObject>

////精选下拉刷新
-(void)jingXuanheaderRef;

@end

@interface Home644View : UIView

@property (nonatomic , weak)id<Home644ViewDelegate>delegate;

@property (nonatomic, strong, readonly) UIScrollView *scvMainBack;

@property (assign, nonatomic) CGPoint printPoint;

@property (nonatomic , retain) Home644HeaderView *headerView;

-(void)bindBanarData:(NSArray *)arrmodels;

-(void)bindItemsData:(NSArray *)arrmodels;

@end
