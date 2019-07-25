//
//  DaiGouBannerHotView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/28.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaiGouBannerHotView : UIView

@property (nonatomic , strong) NSTimer *timer;

@property (nonatomic , retain) NSMutableArray *arrData;

-(void)timeAction;

@end
