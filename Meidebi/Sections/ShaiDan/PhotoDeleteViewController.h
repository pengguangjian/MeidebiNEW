//
//  PhotoDeleteViewController.h
//  Meidebi
//
//  Created by 杜非 on 15/3/23.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpShareViewController.h"
@protocol PhotoDelegate <NSObject>

@optional
-(void)delet:(NSArray *)arr;

@end

@interface PhotoDeleteViewController : UIViewController

@property(nonatomic,strong)NSMutableArray *photoArr;
@property(nonatomic,assign)NSInteger       beloct;
@property(nonatomic,weak)id<PhotoDelegate> delegate;

@property(nonatomic,weak)UpShareViewController *upShareVC;


@end
