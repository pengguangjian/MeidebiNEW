//
//  PersonalAlertView.h
//  Meidebi
//
//  Created by fishmi on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonalAlertViewDelegate <NSObject>
- (void)finishBtnClicked: (NSString *)text view:(UIView *)view;

@end

@interface PersonalAlertView : UIView

@property (nonatomic ,weak) id<PersonalAlertViewDelegate> delegate;

-(void)show;

@end
