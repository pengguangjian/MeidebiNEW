//
//  PostHandleView.h
//  Meidebi
//
//  Created by leecool on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PulishType) {
    PulishTypeExperience,
    PulishTypeBroke
};

@interface PostHandleView : UIView

@property (nonatomic, copy) void (^didClickPublishBtn) (PulishType type);

- (void)beginAnimate;
- (void)removeAnimation;
@end
