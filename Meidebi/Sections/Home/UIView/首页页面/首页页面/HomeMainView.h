//
//  HomeMainView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/21.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeViewModel.h"

@protocol HomeMainViewDelegate <NSObject>
///banaer点击
-(void)HomeMainViewBanaerSelect:(NSInteger)index;
///分类点击
-(void)HomeMainViewItemSelect:(NSInteger)index;
///比比活动点击
-(void)HomeMainViewBiBiSelect:(NSInteger)index;
/// 热门推荐点击
- (void)HomeMainViewXuanHotViewDidClichkCurrentHotWithItem:(HomeHotSticksViewModel *)item;
///白菜精选点击
- (void)HomeMainViewjingXuanbaiCaiDidClichkCurrentHotWithItem:(HomeCheapViewModel *)item;
///热门专题
- (void)HomeMainViewjingXuansepcialProtalTableViewDidSelectSpecial:(NSString *)specialID;
///更多
- (void)HomeMainViewjingXuanhomeSepcialProtalViewDidClickMoreBtn;
///精选列表点击
-(void)HomeMainViewjingxuanListCellSelectAction:(Commodity *)item;
///下拉刷新
-(void)HomeMainViewjingxuanHeaderRefAction;

@end


@interface HomeMainView : UIView

@property (nonatomic , weak) id<HomeMainViewDelegate>delegate;

///精选
- (void)bindJinXuanData:(NSDictionary *)dicmodels;
-(void)bindBanarData:(NSArray *)arrmodels;

///精选下拉刷新数据
- (void)bindJinXuanRefData:(NSDictionary *)dicmodels;


@end
