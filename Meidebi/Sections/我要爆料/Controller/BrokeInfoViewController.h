//
//  BrokeInfoViewController.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/27.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrokeInfoSubjectView.h"

@interface BrokeInfoViewController : UIViewController
@property (nonatomic, strong) NSDictionary *brokeInfoDict;
- (instancetype)initWithType:(BrokeType)type;
@end
