//
//  WelfareDynamicSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/26.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WelfareDynamicSubjectViewDelegate <NSObject>

@optional - (void)welfareDynamicSubjectViewDidRefreshHeader;
@optional - (void)welfareDynamicSubjectViewDidClickAvater:(NSString *)userid;
@optional - (void)welfareDynamicSubjectViewDidClickAd:(NSDictionary *)adInfo;

@end

@interface WelfareDynamicSubjectView : UIView
@property (nonatomic, weak) id<WelfareDynamicSubjectViewDelegate> delegate;
- (void)bindAdDataWithModel:(NSDictionary *)dict;
- (void)bindDynamicWithModel:(NSArray *)models;

@end
