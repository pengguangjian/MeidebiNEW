//
//  MallView.h
//  Meidebi
//
//  Created by 杜非 on 15/4/27.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MallObjct;
@protocol MallViewDelegate <NSObject>

@required

-(void)mallViewSelegate:(MallObjct *)mallObj;
-(void)mallviewData:(NSArray *)arrl;
-(void)mallViewScrp;
@end


@interface MallView : UIView<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{

    NSMutableDictionary *sectionDic;
    NSMutableDictionary *phoneDic;
    NSMutableDictionary *contactDic;
   
    UITableView *_tableView;
}
-(id)initWithFrame:(CGRect)frame isbroad:(NSString *)isbroad delegate:(id)delegate;
@property(nonatomic,weak)id<MallViewDelegate>delegate;


@end
