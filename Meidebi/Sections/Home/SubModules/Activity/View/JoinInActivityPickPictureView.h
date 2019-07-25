//
//  JoinInActivityPickPictureView.h
//  Meidebi
//
//  Created by fishmi on 2017/5/24.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JoinInActivityPickPictureViewDelegate <NSObject>

@optional - (void)pictureSelectBeginSkipToTargetVc:(UIViewController *)targetVc;
@optional - (void)picturePickerDidSelectPhotos:(NSMutableArray *)photos;

@end
@interface JoinInActivityPickPictureView : UIView

@property (nonatomic, weak) id<JoinInActivityPickPictureViewDelegate> delegate;

- (void)showPicturePickerView;

@end
