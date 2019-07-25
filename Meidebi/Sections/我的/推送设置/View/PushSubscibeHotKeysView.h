//
//  PushSubscibeHotKeysView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/17.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PushSubscibeHotKeysViewDelegate <NSObject>

- (void)PushSubscibeHotKeysViewItemAction:(NSString *)value;

@end

@interface PushSubscibeHotKeysView : UIView


@property (nonatomic, weak) id<PushSubscibeHotKeysViewDelegate>delegate;

-(void)bindkeys:(NSArray *)arrkeys;

@end
