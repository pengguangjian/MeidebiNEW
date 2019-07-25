//
//  BrokeTypeAlertView.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BrokeTypeActionSheetView;
@protocol BrokeTypeActionSheetViewDelegate <NSObject>

@optional
- (void)brokeTypeActionSheetView:(BrokeTypeActionSheetView *)alertView
             didSelectType:(NSDictionary *)dict;

@end

@interface BrokeTypeActionSheetView : UIView

@property (nonatomic, weak) id<BrokeTypeActionSheetViewDelegate> delegate;
@property (nonatomic, strong) NSArray *types;
- (void)showActionSheet;

@end
