//
//  BaiCaiView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/22.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewModel.h"

@protocol BaiCaiViewDelegate <NSObject>

- (void)baiCaiDidClichkCurrentHotWithItem:(HomeCheapViewModel *)item;

@end

@interface BaiCaiView : UIView

@property(nonatomic , weak)id<BaiCaiViewDelegate>delegate;

- (float)bindDataWithModel:(NSArray *)model;

@end
