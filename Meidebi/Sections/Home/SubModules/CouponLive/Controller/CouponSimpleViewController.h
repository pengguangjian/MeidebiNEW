//
//  CouponSimpleViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/29.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponSimpleViewControllerDelegate <NSObject>

@optional - (void)couponSimpleTableViewDidScroll;
@optional - (void)couponSimpleTableViewDidIndexRowWithProductID:(NSString *)productid;
@optional - (void)couponSimpleTableViewInquireResult:(BOOL)status;

@end

@interface CouponSimpleViewController : UITableViewController
@property (nonatomic, weak) id<CouponSimpleViewControllerDelegate>delegate;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *keyword;
@end
