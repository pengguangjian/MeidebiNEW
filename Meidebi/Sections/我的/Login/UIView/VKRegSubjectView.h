//
//  VKRegSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/12.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VKRegSubjectView;

@protocol VKRegSubjectViewDelegate <NSObject>

@optional
- (void)regUserInfoView:(VKRegSubjectView *)subView
didPressSubmitBtnWithData:(NSDictionary *)dataDict;

@end

@interface VKRegSubjectView : UIView

@property (nonatomic, weak) id<VKRegSubjectViewDelegate> delegate;

@end
