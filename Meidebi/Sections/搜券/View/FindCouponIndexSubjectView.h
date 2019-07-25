//
//  FindCouponIndexSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/7/7.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FindCouponIndexSubjectViewDelegate <NSObject>

@optional - (void)subjectViewDidSearchCouponWithKeyWord:(NSString *)keyWord;

@end

@interface FindCouponIndexSubjectView : UIView
@property (nonatomic, weak) id<FindCouponIndexSubjectViewDelegate> delegate;
- (void)bindeDataWithModel:(NSDictionary *)dict;

@end
