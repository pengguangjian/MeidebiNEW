//
//  RootViewController.h
//  test1
//
//  Created by madao on 14-8-6.
//  Copyright (c) 2014年 焦子成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shotScreenModel.h"

@protocol FSCutViewControllerDelegate<NSObject>

-(void)loadimvImage:(UIImage *)image;

@end
@interface FSCutViewController : UIViewController<passImageDelegate,UIScrollViewDelegate>{

}

@property (nonatomic,strong)UIImage *originImg;
@property (nonatomic,weak)id<FSCutViewControllerDelegate>delegate;


@end
