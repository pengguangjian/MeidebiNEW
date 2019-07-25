//
//  PersonalShareViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonalShareViewControllerDelegate <NSObject>

@optional - (void)personalShareVCDidClickCellWithShaiDanID:(NSString *)shaidanid;

@end

@interface PersonalShareViewController : UITableViewController

- (instancetype)initWithUserID:(NSString *)userid;

@property (nonatomic, weak) id<PersonalShareViewControllerDelegate> delegate;

@end
