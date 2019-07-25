//
//  ZLJFeaturesGuideView.h
//  ZLJNavigationSwipeView
//
//  Created by mdb-admin on 2017/7/4.
//  Copyright © 2017年 losaic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLJFeaturesGuideView : UIView

+ (void)showGuideViewWithRects:(NSArray <NSValue *>*)rects
                          tips:(NSArray <NSString *>*)tips;

@end
