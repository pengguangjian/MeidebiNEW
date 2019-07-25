//
//  OneUserHeadFunctionView.h
//  Meidebi
//
//  Created by fishmi on 2017/6/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OneUserHeadFunctionViewDelegate<NSObject>
- (void)functionSelectbyButton: (UIButton *)btn;
- (void)clickToViewController: (UIViewController *)targetVc;
@end

@interface OneUserHeadFunctionView : UIView
@property (nonatomic ,weak) id<OneUserHeadFunctionViewDelegate> delegate;

@end
