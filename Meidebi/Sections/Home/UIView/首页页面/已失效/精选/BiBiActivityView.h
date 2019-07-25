//
//  BiBiActivityView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/22.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BiBiActivityViewDelegate <NSObject>
///比比活动点击
-(void)BiBiActivityViewAction:(NSInteger)index;


@end

@interface BiBiActivityView : UIView

@property (nonatomic , weak)id<BiBiActivityViewDelegate>delegate;

-(void)loadBiBiData:(NSArray *)arrbb;

@end
