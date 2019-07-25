//
//  JingXuanDaiGouView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/21.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JingXuanDaiGouView : UIView
{
    UIView *viewcell;
    CGRect rectdg;
    
    NSString *strgoodsid;
    
    UIView *viewyindao;
    
}

-(void)binddaigouData:(id)model;

@end
