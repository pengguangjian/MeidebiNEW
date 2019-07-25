//
//  MyZanAndCallMeViewController.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/7.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RootTableViewController.h"

typedef NS_ENUM(NSInteger, ViewControllerType) {
    ViewControllerTypeUnknow,
    ViewControllerTypeZan,
    ViewControllerTypeCallMe
};

@interface MyZanAndCallMeViewController: RootTableViewController

- (instancetype)initWithType:(ViewControllerType)type;
@end
