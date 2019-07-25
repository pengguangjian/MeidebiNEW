//
//  BrokeHomeSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/27.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BrokeHomeSubjectView;
@protocol BrokeHomeSubjectViewDelegate <NSObject>

@optional
- (void)brokeHomeSubjectViewIntoLoginVc;
- (void)brokeHomeSubjectView:(BrokeHomeSubjectView *)subView
        didPressEnsureBtnWithBrokeLink:(NSString *)link
                        type:(NSString *)type;

@end

@interface BrokeHomeSubjectView : UIView

@property (nonatomic, weak) id<BrokeHomeSubjectViewDelegate> delegate;
- (void)inspectPasteboard;
@end
