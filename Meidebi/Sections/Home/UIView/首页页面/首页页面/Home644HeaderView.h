//
//  Home644HeaderView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/6.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Home644HeaderViewScrollDelegate <NSObject>

///手指一动多少
-(void)Home644HeaderViewPanMove:(float)fvalue isend:(BOOL)isend;

@end

@interface Home644HeaderView : UIView

@property(nonatomic,weak)id<Home644HeaderViewScrollDelegate>delegate;

@property (nonatomic , assign)float fbouttonHeight;

///
@property (nonatomic , assign) BOOL isHiddennav;

#pragma mark - bananer 数据
-(void)bindBanarData:(NSArray *)arrmodels;

@end
