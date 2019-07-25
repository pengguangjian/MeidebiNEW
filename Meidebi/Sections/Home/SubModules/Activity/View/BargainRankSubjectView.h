//
//  BargainRankSubjectView.h
//  Meidebi
//
//  Created by leecool on 2017/10/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BargainRankSubjectViewDelegate <NSObject>
@optional - (void)detailSubjectViewDidCickAvaterViewWithUserid:(NSString *)userid;
@end

@interface BargainRankSubjectView : UIView
@property (nonatomic, weak) id<BargainRankSubjectViewDelegate> delegate;
- (void)bindDataWithModel:(NSArray *)model;

@end
