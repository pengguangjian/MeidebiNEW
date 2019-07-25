//
//  PGGCameraViewController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/5/23.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGGCameraViewControllerDelegate <NSObject>

- (void)cameraMovieBack:(NSURL *)movieurl;
- (void)cameraPhotoBack:(UIImage *)image;
@end

@interface PGGCameraViewController : UIViewController

@property (nonatomic , weak)id<PGGCameraViewControllerDelegate>delegate;

@end
