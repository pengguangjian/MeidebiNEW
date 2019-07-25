//
//  ShareTableView.h
//  Meidebi
//
//  Created by 杜非 on 15/1/23.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePlayerView.h"
#import "Sharecle.h"
#import <MJRefresh/MJRefresh.h>


@protocol ShareTableViewDelegate <NSObject>

@optional
-(void)tableViewSelecte:(Sharecle *)art;

-(void)scrollViewfrom:(float)hight isend:(BOOL)isend;
@end
@interface ShareTableView  : UIView<UITableViewDataSource,UITableViewDelegate,ImagePlayerViewDelegate>{
    
    UITableView             *_tableview;
    ImagePlayerView         *_imagePlayerView;
}
@property(nonatomic,weak)id <ShareTableViewDelegate>delegate;
@property(nonatomic,assign)BOOL reloading;
@property(nonatomic,assign)BOOL foodReloading;
@property(nonatomic,strong)NSArray *arrData;
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,assign)BOOL     isHot;//热门或者最新
@property(nonatomic,assign)int      count;//总条数



-(void)tablevietoTop;
-(id)initWithFrame:(CGRect)frame  isHot:(BOOL)isHot delegate:(id)delegat;



-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

@end
