//
//  CouponLiveSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/29.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,CouponSubViewType) {
    CouponSubViewTypeList,
    CouponSubViewTypeReult
};

@protocol CouponLiveSubjectViewDelegate <NSObject>

@optional - (void)couponLiveSubjectViewDidClickSearchBtn:(NSString *)searchStr;
@optional - (void)couponLiveSubjectViewDidSelectProduct:(NSString *)ProductID;

@end

@interface CouponLiveSubjectView : UIView
@property (nonatomic, weak) id<CouponLiveSubjectViewDelegate> delegate;
- (instancetype)initWithType:(CouponSubViewType)type;
@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, strong, readonly) UIView *emptyView;

@end
