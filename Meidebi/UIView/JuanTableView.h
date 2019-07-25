//
//  JuanTableView.h
//  Meidebi
//
//  Created by 杜非 on 15/1/26.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePlayerView.h"
#import "Juancle.h"
#import <MJRefresh/MJRefresh.h>
@protocol JuanTableViewDelegate <NSObject>

@optional
-(void)tableViewSelecte:(Juancle *)art;
-(void)scrollViewfrom:(float)hight isend:(BOOL)isend;
@end
@interface JuanTableView  : UIView<UITableViewDataSource,UITableViewDelegate,ImagePlayerViewDelegate>{

    UITableView             *_tableview;
    ImagePlayerView         *_imagePlayerView;
}
@property(nonatomic,weak)id <JuanTableViewDelegate>delegate;
@property(nonatomic,assign)BOOL reloading;
@property(nonatomic,assign)BOOL foodReloading;
@property(nonatomic,strong)NSArray *arrData;
@property(nonatomic,strong)NSDictionary *dicPics;
@property(nonatomic,strong)NSString *urlStr;

@property(nonatomic,assign)int      count;//总条数


-(void)tablevietoTop;

-(id)initWithFrame:(CGRect)frame  delegate:(id)delegat;



-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

@end