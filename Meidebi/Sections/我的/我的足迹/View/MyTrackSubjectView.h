//
//  MyTrackSubjectView.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackTableViewCell.h"

@protocol MyTrackSubjectViewDelegate<NSObject>
@optional - (void)lastPage;
@optional - (void)nextPage;
@optional - (void)tableViewCellSelectShowdanRow:(NSString *)showdanID;
@optional - (void)tableViewCellSelectDiscountRow:(NSString *)discountID;
@optional - (void)bannerTableViewCellSelectDiscountRow:(NSString *)discountID;
@end

@interface MyTrackSubjectView : UIView
@property (nonatomic, weak) id<MyTrackSubjectViewDelegate> delegate;
- (void)bindBannerDataWithModel:(NSDictionary *)model;
- (void)bindTrackDataWithModel:(NSArray *)models;
- (void)updateTrackDataWithModel:(NSArray *)models;
@end

