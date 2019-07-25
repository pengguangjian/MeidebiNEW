//
//  CouponSimpleCollectionViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/7/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CouponSimpleCollectionViewCell;
@protocol CouponSimpleCollectionViewCellDelegate <NSObject>

@optional - (void)couponSimpleCollectionViewCellDidClickDrawBtn:(CouponSimpleCollectionViewCell *)cell;

@end

@interface CouponSimpleCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) id<CouponSimpleCollectionViewCellDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)model;
@end
