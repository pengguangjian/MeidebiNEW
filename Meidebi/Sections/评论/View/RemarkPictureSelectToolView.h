//
//  RemarkPictureSelectToolView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/2/7.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RemarkPictureSelectToolViewDelegate <NSObject>

@optional - (void)pictureSelectBeginSkipToTargetVc:(UIViewController *)targetVc;
@optional - (void)picturePickerDidSelectPhotos:(NSArray *)photos;

@end

@interface RemarkPictureSelectToolView : UIView

@property (nonatomic, weak) id<RemarkPictureSelectToolViewDelegate> delegate;

- (void)showPicturePickerView;

@end
