//
//  ActivityCommendHeadView.h
//  Meidebi
//
//  Created by fishmi on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailModel.h"
@protocol ActivityCommendHeadViewDelegate <NSObject>
@optional - (void)detailSubjectViewDidCickAddFollowWithUserid:(NSString *)userid
                                                  didComplete:(void (^)(BOOL state))didComplete;
@optional - (void)imageViewClickedtoController: (UIViewController *)targetVc;
@optional - (void)webViewDidPreseeUrlWithLink:(NSString *)link;
@end

@interface ActivityCommendHeadView : UIView

@property (nonatomic ,weak) id <ActivityCommendHeadViewDelegate> delegate;
@property (nonatomic ,strong) ActivityDetailModel *model;
@property (nonatomic ,copy) void (^callback) (CGFloat height);
@property (nonatomic ,copy) void (^imageDownload) (UIImage *image);

@end
