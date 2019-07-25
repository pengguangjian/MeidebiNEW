//
//  DaiGouHomeView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/28.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DaiGouHomeViewDelegate <NSObject>

////添加购物车
-(void)gouwucheadd;

@end

@interface DaiGouHomeView : UIView
@property (nonatomic , strong) NSTimer *timer;

@property (nonatomic , weak) id<DaiGouHomeViewDelegate>delegate;


-(void)loadListTimeData;

@end
