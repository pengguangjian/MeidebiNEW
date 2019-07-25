//
//  RemarkComposeViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/2/6.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemarkHomeDatacontroller.h"
typedef void(^remarkComposeDidConfirm)(NSDictionary *dict);

@interface RemarkComposeViewController : UIViewController

@property (nonatomic, assign) RemarkType type;
@property (nonatomic, strong) NSString *linkid;
@property (nonatomic, copy) remarkComposeDidConfirm confirmRemark;
@end
