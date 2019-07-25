//
//  MyJiangLiView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyJiangLiView : UIView

@property (nonatomic,retain)NSTimer *yidongTimer;

-(void)bindheaderValue:(NSDictionary *)dicvalue;

-(void)bindListValue:(NSArray *)arr;

@end
