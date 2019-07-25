//
//  BrokeSuccessSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, BrokeSuccessType) {
    BrokeSuccessTypeNomal,
    BrokeSuccessTypeFailed
};

@protocol BrokeSuccessSubjectViewDelegate <NSObject>

@optional
- (void)brokeSuccessSubjectViewdidPressJumpBtn;

@end

@interface BrokeSuccessSubjectView : UIView

@property (nonatomic, weak) id<BrokeSuccessSubjectViewDelegate> delegate;
@property (nonatomic, assign) BrokeSuccessType brokeType;

@end
