//
//  PersonalBirthAlertView.h
//  Meidebi
//
//  Created by fishmi on 2017/6/23.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PersonalBirthAlertViewDelegate <NSObject>
- (void)finishBtnClicked: (NSString *)text view:(UIView *)view;

@end
@interface PersonalBirthAlertView : UIView
@property (nonatomic ,weak) id<PersonalBirthAlertViewDelegate> delegate;

-(void)show;
@end
