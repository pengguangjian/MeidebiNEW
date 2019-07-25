//
//  RemarkTableViewController.h
//  Meidebi
//
//  Created by mdb-admin on 16/6/20.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPhotoGroupView.h"
#import "RemarkTableViewMyRemarkCell.h"

typedef NS_ENUM(NSInteger, RemarkMenuType){
    RemarkMenuTypeComment,
    RemarkMenuTypeReply
};

@class RemarkTableViewController;
@protocol RemarkTableViewDelegate <NSObject>

@optional - (void)remarkTableViewVc:(RemarkTableViewController *)remarkTableViewVc
          didSelectRowWithProductId:(NSString *)productId
                         remarkType:(NSString *)type;
@optional - (void)photoGroupView:(YYPhotoGroupView *)photoGroupView
               didClickImageView:(UIView *)fromeView;

@optional - (void)remarkTableViewVc:(RemarkTableViewController *)remarkTableViewVc
                        didClickUrl:(NSString *)urlStr;

@optional - (void)remarkTableViewVc:(RemarkTableViewController *)remarkTableViewVc
                      didClickReply:(PersonalRemark *)replyRemark;
@optional - (void)remarkTableViewVcScrollViewDidDragging;

@end

@interface RemarkTableViewController : UITableViewController

@property (nonatomic, assign) RemarkMenuType remarkType;
@property (nonatomic, weak) id<RemarkTableViewDelegate> delegate;
@end


