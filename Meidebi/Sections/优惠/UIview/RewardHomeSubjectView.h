//
//  RewardHomeSubjectView.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/4.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RewardHomeSubjectViewDelegate <NSObject>

@optional - (void)rewardSubjectViewSubmitRewardWithContent:(NSString *)content
                                                    amount:(NSString *)amount;
@end

@interface RewardHomeSubjectView : UIView
@property (nonatomic, weak) id<RewardHomeSubjectViewDelegate> delegate;
@property (nonatomic, strong) NSString *type;
- (void)bindDataWithModel:(NSDictionary *)model;
@end
