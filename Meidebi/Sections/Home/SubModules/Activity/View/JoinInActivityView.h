//
//  JoinInActivityView.h
//  Meidebi
//
//  Created by fishmi on 2017/5/23.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>

@protocol JoinInActivityViewDelegate <NSObject>

@optional - (void)picturePickerDidSelectPhotosWithTargeVc:(UIViewController *)vc;
@optional - (void)picturePickerDidSelectPhotos:(NSArray *)photos;

@end
@interface JoinInActivityView : UIView

@property (nonatomic, weak) id<JoinInActivityViewDelegate> delegate;
@property (nonatomic ,strong) NSMutableArray *selectPics;
@property (nonatomic ,weak)  UITextView *textV;
@property (nonatomic ,weak) UILabel *activityLabel;
@end
