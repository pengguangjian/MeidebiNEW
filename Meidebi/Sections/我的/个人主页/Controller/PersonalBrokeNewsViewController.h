//
//  PersonalBrokeNewsViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonalBrokeNewsViewControllerDelegate <NSObject>

@optional - (void)personalBrokeNewsVCDidClickCellWithBrokeID:(NSString *)brokeid;

@end

@interface PersonalBrokeNewsViewController : UITableViewController

- (instancetype)initWithUserID:(NSString *)userid;

@property (nonatomic, weak) id<PersonalBrokeNewsViewControllerDelegate> delegate;

@end
