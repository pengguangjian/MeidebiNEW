//
//  MyInformTableView.h
//  Meidebi
//
//  Created by 杜非 on 15/2/11.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyInformMainModel;
@protocol MyInformTableViewDelegate <NSObject>
@optional - (void)tableViewClickZan;
@optional - (void)tableViewClickRemark;
@optional - (void)tableViewClickCallMe;
@optional - (void)tableViewClickOrder;
@optional - (void)clickToMyInformDetailViewControllerWithDataDic: (MyInformMainModel *)model;
@optional - (void)touchWithId: (NSString *)Id;
@optional - (void)tableViewDidDeleteRowWithNewsID:(NSString *)newsid didComplete:(void(^)(BOOL state))callback;
////改变已读为未读
- (void)iseditchange;

@end

@interface MyInformTableView : UIView<UITableViewDataSource,UITableViewDelegate>{

    UITableView             *_tableview;
    
}
@property(nonatomic,weak)id<MyInformTableViewDelegate>delegate;
@property(nonatomic,assign)BOOL reloading;
@property(nonatomic,assign)BOOL foodReloading;
@property(nonatomic,strong)NSMutableArray *arrData;
///是否是编辑状态
@property(nonatomic,assign)BOOL isedit;


-(id)initWithFrame:(CGRect)frame;
- (void)remindVIsShow: (BOOL) isRemind;
- (void)zanRemindVIsShow: (BOOL) isRemind;
- (void)orderRemindVIsShow: (BOOL) isRemind;
-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

-(void)editAction;

@end
