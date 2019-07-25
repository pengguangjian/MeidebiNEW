//
//  WuLiuXieYiTangChuangView.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/5/8.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WuLiuXieYiTangChuangViewSelectDelegate <NSObject>

-(void)tongyixieyiAction;

@end

@interface WuLiuXieYiTangChuangView : UIView

@property (nonatomic,weak)id<WuLiuXieYiTangChuangViewSelectDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
