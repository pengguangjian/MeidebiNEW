//
//  HandleAlertView.h
//  Meidebi
//
//  Created by mdb-admin on 16/8/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HandleAlertViewDelegate <NSObject>

@optional
- (void)handleAlertViewDidePressDismissBtn;

@end

@interface HandleAlertView : UIControl

@property (nonatomic, weak) id<HandleAlertViewDelegate> delegate;

- (void)showAlert;
@end
