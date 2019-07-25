//
//  JoinInActivityViewController.h
//  Meidebi
//
//  Created by fishmi on 2017/5/23.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RootViewController.h"

@interface JoinInActivityViewController : RootViewController
@property(nonatomic,strong)NSString *activityId;
@property (nonatomic ,strong) NSString *text_title;
@property (nonatomic ,copy) void (^didFinish) (void);

@end
