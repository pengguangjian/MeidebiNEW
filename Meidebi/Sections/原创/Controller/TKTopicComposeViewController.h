//
//  TKTopicComposeViewController.h
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/17.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import "RootViewController.h"
#import "TKTopicModuleConstant.h"
@interface TKTopicComposeViewController : RootViewController
- (instancetype)initWithTopicType:(TKTopicType)type;

@property (nonatomic , retain)NSString *strcaogaoid;

@end
