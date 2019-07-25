//
//  ConversionSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConversionSubjectView;
@protocol ConversionSubjectViewDelegate <NSObject>

@optional
- (void)handleAttendance;
- (void)handleWelfareShare;
- (void)welfareHomeSubjectViewReferCopperRule;
- (void)welfareHomeSubjectViewReferLogisticsAddress;
- (void)conversionCouponWithID:(NSString *)couponID;
- (void)conversionMaterialWaresWithInfo:(NSDictionary *)infoDict
                                success:(void(^)(NSString *describle))success
                                failure:(void(^)(NSString *describle))failure;
- (void)welfareHomeSubjectView:(ConversionSubjectView *)subjectView
      didSelectWaresWithItemId:(NSString *)waresId
                     waresType:(NSString *)type
                        haveto:(NSString *)haveto
                  present_type:(NSString *)present_type;
- (void)jumpLoginVc;
@end

@interface ConversionSubjectView : UIView

@property (nonatomic, weak) id<ConversionSubjectViewDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)dict;
- (void)showLastAlertView;

-(void)showLastAlertViewAddress:(id)value;

@end
