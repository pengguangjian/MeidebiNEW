//
//  TrendTableViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/11/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TableViewTrendType) {
    TableViewTrendTypeCounpon = 1,
    TableViewTrendTypeInland,
    TableViewTrendTypeOverseas
};

@protocol TrendTableViewControllerDelegate <NSObject>

@optional - (void)openCouponWithUrl:(NSString *)url;
@optional - (void)tableViewCellDidSelectWithID:(NSString *)discountID;

@end

@interface TrendTableViewController : UITableViewController
@property (nonatomic, weak) id<TrendTableViewControllerDelegate> delegate;
- (instancetype)initWithType:(TableViewTrendType)type;
@end
