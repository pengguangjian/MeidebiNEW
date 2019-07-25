//
//  ConversionAlertView.h
//  Meidebi
//
//  Created by mdb-admin on 2016/10/27.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ConversionAlertType) {
    ConversionAlertNormal,
    ConversionAlertVirtual,
    ConversionAlertMaterial,
    ConversionAlertAttendancGift,
    ConversionAlertSubTitle
};

typedef NS_ENUM(NSInteger,ConversionAlertState) {
    ConversionAlertStateSuccess,
    ConversionAlertStateFailure,
    ConversionAlertStateCopperFailure
};

@class ConversionAlertView;
@protocol ConversionAlertViewDelegate <NSObject>

@optional

- (void)conversionAlertView:(ConversionAlertView *)alertView
 handleConversionWithNumber:(NSString *)numberStr;
- (void)conversionAlertView:(ConversionAlertView *)alertView
 handleExchangeGiftWithNumber:(NSString *)numberStr;
- (void)referCopperRule;
- (void)referLogisticsAddress;
@end

@interface ConversionAlertView : UIView

@property (nonatomic, weak) id<ConversionAlertViewDelegate> delegate;
@property (nonatomic, assign) ConversionAlertType alertType;
@property (nonatomic, assign) ConversionAlertState alertState;
@property (nonatomic, strong) NSString *waresName;
@property (nonatomic, strong) NSString *placeholderStr;
@property (nonatomic, strong) NSString *subTitleStr;
@property (nonatomic, strong) NSString *faultRemindStr;
@property (nonatomic, strong) NSString *alertDescribleStr;
- (void)show;
@end
