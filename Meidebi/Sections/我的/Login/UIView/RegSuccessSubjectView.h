//
//  RegSuccessSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/14.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RegSuccessType) {
    RegSuccessTypeNormal,
    RegSuccessTypeBinding,
    RegSuccessTypeSeting
};
@class RegSuccessSubjectView;
@protocol RegSuccessSubjectViewDelegate <NSObject>

@optional
- (void)regSuccessViewDidPressLoginBtn;

@end

@interface RegSuccessSubjectView : UIView

@property (nonatomic, assign) RegSuccessType successType;
@property (nonatomic, weak) id<RegSuccessSubjectViewDelegate> delegate;
@end
