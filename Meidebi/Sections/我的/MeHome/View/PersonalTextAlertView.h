//
//  PersonalTextAlertView.h
//  Meidebi
//
//  Created by fishmi on 2017/6/23.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PersonalTextAlertViewDelegate <NSObject>
- (void)finishBtnClicked: (NSString *)text view:(UIView *)view;

@end
@interface PersonalTextAlertView : UIView

@property (nonatomic ,weak) id<PersonalTextAlertViewDelegate> delegate;

- (void)setTitle:(NSString *)title placeholder:(NSString *)placeholder text:(NSString *)text image:(UIImage *)image;
-(void)show;
@end
