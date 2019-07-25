//
//  FindCouponResultSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/7/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FindCouponResultSubjectViewDelegate <NSObject>

@optional - (void)subjectViewDidClickDrawBtnWithUrl:(NSString *)url;
@optional - (void)subjectViewDidScroll;

@end

@interface FindCouponResultSubjectView : UIView
@property (nonatomic, weak) id<FindCouponResultSubjectViewDelegate> delegate;
@property (nonatomic, strong) NSString *searhKeyword;

@end
