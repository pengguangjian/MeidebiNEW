//
//  ArtTableView.h
//  Meidebi
//
//  Created by 杜非 on 15/1/9.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePlayerView.h"
#import "Article.h"
#import <MJRefresh/MJRefresh.h>

@protocol ArtTableViewDelegate <NSObject>

@optional
-(void)tableViewSelecte:(Article *)art;
-(void)tablePhotoSelecte:(NSString *)urlStr title:(NSString *)titl;
-(void)scrollViewfrom:(float)hight isend:(BOOL)isend;
-(void)tableViewDidSelectHeaderBarView:(NSString *)type;
@end

@interface artcel : NSObject
@property(nonatomic,strong)NSString * imgurl;
@property(nonatomic,strong)NSString * link;
@property(nonatomic,strong)NSString * artid;
@property(nonatomic,strong)NSString * title;
-(void)setwithDic:(NSDictionary *)dic;

@end

@interface ArtTableView : UIView
<
UITableViewDataSource,
UITableViewDelegate,
ImagePlayerViewDelegate
>
{
    UITableView             *_tableview;
    ImagePlayerView         *_imagePlayerView;
}
@property(nonatomic,weak)id <ArtTableViewDelegate>delegate;

@property(nonatomic,assign)BOOL reloading;
@property(nonatomic,assign)BOOL foodReloading;
@property(nonatomic,strong)NSArray *arrData;
@property(nonatomic,strong)NSDictionary *dicPics;
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,assign)int      cats;//分类ID
@property(nonatomic,assign)BOOL     isHot;//热门或者最新
@property(nonatomic,assign)int      type;//频道
@property(nonatomic,assign)int      count;//总条数
@property (nonatomic, strong) NSString *siteid;

-(void)tablevietoTop;

-(id)initWithFrame:(CGRect)frame
              pics:(NSDictionary *)dicPics
              cats:(int)cats
             isHot:(BOOL)isHot
              type:(int)type
            siteid:(NSString *)siteid
          delegate:(id)delegat;

-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

@end




