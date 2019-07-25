//
//  SpecialTableViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SpecialTableViewControllerDelegate <NSObject>

@optional - (void)tableViewRefreshFooter:(void(^)(NSArray *models))didComplete;
@optional - (void)tableviewDidClickCellWithSpecialID:(NSString *)specialID;
@optional - (void)tableviewDidClickCellWithTBSpecialContent:(NSString *)content;

@end

@interface SpecialTableViewController : UITableViewController

@property (nonatomic, weak) id<SpecialTableViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *specialType;

@end
