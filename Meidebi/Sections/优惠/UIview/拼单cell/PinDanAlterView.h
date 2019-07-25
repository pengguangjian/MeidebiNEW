//
//  PinDanAlterView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/27.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinDanAlterView : UIView

@property (nonatomic , strong) NSDictionary *dicValue;

@property (nonatomic , retain) NSDictionary *dicnextValue;

-(void)drawSubview;

@end
