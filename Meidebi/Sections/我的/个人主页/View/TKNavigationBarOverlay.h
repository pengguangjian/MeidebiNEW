//
//  TKNavigationBarOverlay.h
//  TaokeSecretary
//
//  Created by mdb-admin on 2017/2/20.
//  Copyright © 2017年 leecool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (TKNavigationBarOverlay)

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setElementsAlpha:(CGFloat)alpha;
- (void)lt_setTranslationY:(CGFloat)translationY;
- (void)lt_reset;

@end
