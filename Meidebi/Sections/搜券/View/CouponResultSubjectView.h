//
//  CouponResultSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/7/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponResultSubjectViewDelegate <NSObject>

@optional - (void)couponResultCollectionViewDidScroll;
@optional - (void)reloadCollectionViewDataSource;
@optional - (void)footReloadCollectionViewDataSource;
@optional - (void)couponSimpleCollectionViewCellDidClickDrawBtnWithCouponURL:(NSString *)url;
@end

@interface CouponResultSubjectView : UIView
@property (nonatomic, weak) id<CouponResultSubjectViewDelegate> delegate;
@property (nonatomic, strong) NSString *searchKey;
- (void)bindDataWithModel:(NSArray *)model;
- (void)updataDataWithModel:(NSArray *)model;

@end
