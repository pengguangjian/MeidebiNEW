//
//  WareTableViewController.h
//  Meidebi
//
//  Created by mdb-admin on 16/5/30.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WareDataController.h"

@class Article;
@class WareTableViewController;
@protocol WaresTableViewDelegate <NSObject>

@optional
- (void)tableViewScrollDirectionUp;
- (void)tableViewScrollDirectionDown;
- (void)bannerViewDidSelectWithUrl:(NSString *)urlStr
                             title:(NSString *)title;
- (void)tableViewDidSelectHeaderBarView:(NSString *)type;
- (void)tableViewSelecte:(Article *)art withTableVc:(WareTableViewController *)vc;
- (void)tableViewSelecte:(Article *)art;
- (void)tableviewDidLoadDataFailure:(WareTableViewController *)vc;
///商城标签信息数据
-(void)tabviewShopData:(NSDictionary *)value;

@end


@interface WareTableViewController : UITableViewController

@property (nonatomic, strong) NSString *siteid;
@property (nonatomic, strong) NSString *cates;
@property (nonatomic, assign) WareType wareType;
@property (nonatomic, assign) WaresTableVcType tableVcType;
@property (nonatomic, assign) WareRequestType requestType;
@property (nonatomic, weak) id<WaresTableViewDelegate> delegate;
- (void)updateData;
- (void)scrollTop;
@end
