//
//  JiangJiaZhiBoTableViewController.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/25.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JiangJiaZhiBoTableViewDelegate <NSObject>

-(void)selectItem:(NSString *)strid;

@end

@interface JiangJiaZhiBoTableViewController : UITableViewController
///是否是最优惠
@property (nonatomic , assign) BOOL isvery;
@property (nonatomic ,weak)id<JiangJiaZhiBoTableViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
