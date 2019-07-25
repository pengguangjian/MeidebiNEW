//
//  WelfareReceiveSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WelfareReceiveSubjectViewDelegate <NSObject>

@optional - (void)welfareReceiveSubjectViewDidClickConversionBtn;

@end

@interface WelfareReceiveSubjectView : UIView
@property (nonatomic, weak) id<WelfareReceiveSubjectViewDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)dict;
@end
