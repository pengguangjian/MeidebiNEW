//
//  NJPushSetAlertView.h
//  Meidebi
//
//  Created by mdb-admin on 16/4/5.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NJPushSetAlertView : UIView

@property (nonatomic, strong) NSString *alertTitle;
@property (nonatomic, strong) NSString *alertContent;

- (void)show;
@end
