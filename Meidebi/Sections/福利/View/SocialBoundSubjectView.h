//
//  SocialBoundSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,SocialPlatformType) {
    SocialPlatformTypeSina = 100,
    SocialPlatformTypeQQ
};

@protocol SocialBoundSubjectViewDelegate <NSObject>

@optional - (void)socialBoundSubjectViewDidSelectCellWithPlatform:(SocialPlatformType)platform complete:(void(^)(void))complete;
@optional - (void)socialBoundSubjectViewDidSelectCellWithCancelPlatformAuthorized:(SocialPlatformType)platform complete:(void(^)(void))complete;

@end

@interface SocialBoundSubjectView : UIView
@property (nonatomic, weak) id<SocialBoundSubjectViewDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)model;
@end
