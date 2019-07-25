//
//  BrokeInfoSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/27.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrokeInfoViewModel.h"
@class BrokeInfoSubjectView;
@protocol BrokeInfoSubjectViewDelegate <NSObject>

@optional
- (void)brokeInfoSubjectView:(BrokeInfoSubjectView *)subView
            didPressBrokeBtnWithInfo:(NSDictionary *)dict;
- (void)brokeInfoSubjectViewDidPressNoBrokeBtn;
- (void)brokeInfoSubjectViewDidPressChoicePhotoBtnWithDidComplete:(void (^) (UIImage *image))callback;
@end

@interface BrokeInfoSubjectView : UIView
@property (nonatomic, assign) BOOL isShowShareExtension;
@property (nonatomic, weak) id<BrokeInfoSubjectViewDelegate> delegate;
- (instancetype)initWithType:(BrokeType)type;
- (void)bindDataWithViewModel:(BrokeInfoViewModel *)viewModel;

@end
