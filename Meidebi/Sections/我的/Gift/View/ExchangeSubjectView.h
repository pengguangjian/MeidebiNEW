//
//  ExchangeSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2016/11/7.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExchangeSubjectViewDelegate <NSObject>

@optional
- (void)subjectsViewWithPullupTableview;
- (void)subjectsViewWithPullDownTableview;
@end

@interface ExchangeSubjectView : UIView

@property (nonatomic, weak) id<ExchangeSubjectViewDelegate> delegate;

- (void)bindDataWithModel:(NSArray *)model;

@end
