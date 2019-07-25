//
//  LatestNewsViewController.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LatestNewsViewControllerDelegate <NSObject>

@optional - (void)latesDiscountNewsTableViewDidSelectRowWithItemID:(NSString *)itemID;
@optional - (void)latesOriginalNewsTableViewDidSelectRowWithItemID:(NSString *)itemID;
@optional - (void)latesSpecialNewsTableViewDidSelectRowWithItemID:(NSString *)itemID;
@optional - (void)latesNewsTableViewWihtFirstRow:(NSString *)itemID;

@end

@interface LatestNewsViewController: UITableViewController
@property (nonatomic, weak) id<LatestNewsViewControllerDelegate> delegate;
- (void)updateLatestNewsDataIsCallback:(BOOL)isCall;
@end
