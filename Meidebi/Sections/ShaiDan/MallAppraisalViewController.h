//
//  MallAppraisalViewController.h
//  Meidebi
//
//  Created by 杜非 on 15/4/28.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpShareViewController.h"


@interface MallAppraisalViewController : UIViewController


-(void)setText:(NSString *)text arr:(NSArray *)photoArr;
@property(nonatomic,weak)UpShareViewController *upshareView;

@end
