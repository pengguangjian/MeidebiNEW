//
//  TKPictureSelectToolView.h
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/17.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKPictureSelectToolViewDelegate <NSObject>
@optional - (void)pictureSelectBeginSkipToTargetVc:(UIViewController *)targetVc;
@optional - (void)picturePickerDidSelectPhotos:(NSArray *)photos;
- (void)selectTKPictureAction;
@end

@interface TKPictureSelectToolView : UIView
@property (nonatomic, weak) id<TKPictureSelectToolViewDelegate> delegate;
- (void)showPicturePickerView;

-(void)setcaogaoImage:(NSArray *)arrvalue;

@end
