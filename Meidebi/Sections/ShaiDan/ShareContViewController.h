//
//  ShareContViewController.h
//  Meidebi
//
//  Created by 杜非 on 15/2/1.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sharecle.h"

@interface ShareContViewController : UIViewController{
}
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong)Sharecle *share;
@property(nonatomic,assign)NSInteger   shareid;
@property(nonatomic,assign)BOOL     isDockView;
@property(nonatomic,assign)BOOL     isRightBut;

@end
