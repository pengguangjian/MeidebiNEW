//
//  SignInListModel.m
//  Meidebi
//
//  Created by fishmi on 2017/6/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SignInListModel.h"
#import <MJExtension/MJExtension.h>
@implementation SignInListModel

+ (void)listKeyReplace{
    
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"commentyid":@"id"
                 };
    }];
    
}
@end
