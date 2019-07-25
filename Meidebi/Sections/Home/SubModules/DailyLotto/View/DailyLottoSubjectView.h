//
//  DailyLottoSubjectView.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DailyLottoSubjectViewDelegate <NSObject>

@optional - (void)lottoSubjectViewDidClickRecordBtn;
@optional - (void)lottoSubjectViewDidClickAddressBtn;
@optional - (void)lottoSubjectViewDidClickDoLotto;
@optional - (void)lottoSubjectViewToLogin;

@end

@interface DailyLottoSubjectView : UIView
@property (nonatomic, weak) id<DailyLottoSubjectViewDelegate> delegate;

- (void)bindCurrentCionsDataWithModel:(NSDictionary *)model;
- (void)bindLottoListDataWithModel:(NSDictionary *)model;
- (void)bindLottoResultDataWithModel:(NSDictionary *)model;
@end
