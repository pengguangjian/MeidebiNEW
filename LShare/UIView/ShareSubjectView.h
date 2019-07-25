//
//  ShareSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 16/8/2.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "BrokeInfoViewModel.h"
@class ShareSubjectView;
@protocol ShareSubjectViewDelegate <NSObject>

@optional
- (void)shareSubjectView:(ShareSubjectView *)subView
    didPressBrokeBtnWithInfo:(NSDictionary *)dict;
- (void)shareSubjectViewDidPressNoBrokeBtn;

@end

@interface ShareSubjectView : UIView
@property (nonatomic, strong) NSString *brokeLink;
@property (nonatomic, weak) id<ShareSubjectViewDelegate> delegate;

- (void)bindDataWithViewModel:(BrokeInfoViewModel *)viewModel;

@end
