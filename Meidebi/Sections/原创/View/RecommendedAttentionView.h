//
//  RecommendedAttentionView.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecommendedAttentionViewDelegate <NSObject>
@optional - (void)attentionViewDidSelectUser:(NSString *)userID complete:(void(^)(BOOL state))callback;
@optional - (void)attentionViewDidSelectUserAvater:(NSString *)userID;
@end

@interface RecommendedAttentionView : UIView
@property (nonatomic, weak) id<RecommendedAttentionViewDelegate> delegate;
- (void)bindDataWithModel:(NSArray *)models;
@end
