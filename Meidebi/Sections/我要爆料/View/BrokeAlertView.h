//
//  BrokeAlertView.h
//  Meidebi
//
//  Created by losaic on 16/7/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, alertStyle){
    alertStyleNormal,
    alertStyleBrokeCopy,
    alertStyleReport,
    alertStyleSocialBound
};

@class BrokeAlertView;
@protocol BrokeAlertViewDelegate <NSObject>

@optional
- (void)brokeAlertViewDidPressEnsureBtnWithAlertView:(BrokeAlertView *)alertView;
- (void)brokeAlertViewDidPressCancelBtnWithAlertView:(BrokeAlertView *)alertView;

@end

@interface BrokeAlertView : UIView

@property (nonatomic, weak) id<BrokeAlertViewDelegate> delegate;
@property (nonatomic, assign) alertStyle style;
- (void)showAlert;

@end
