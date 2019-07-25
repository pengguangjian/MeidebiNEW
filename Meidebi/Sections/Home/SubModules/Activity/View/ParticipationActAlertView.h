//
//  ParticipationActAlertView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/10/13.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ActAlertHandleShareType) {
    ActAlertHandleShareTypeWeChat = 10000,
    ActAlertHandleShareTypeSinaWeibo,
    ActAlertHandleShareTypeWeMoments,
    ActAlertHandleShareTypeQQ
};

@protocol ParticipationActAlertViewDelegate <NSObject>

@optional - (void)shareAlertViewDidClickedShareButtonAtType:(ActAlertHandleShareType)type;

@end

@interface ParticipationActAlertView : UIView
@property (nonatomic, weak) id<ParticipationActAlertViewDelegate> delegate;
- (void)show;
- (void)dismiss;
@end
