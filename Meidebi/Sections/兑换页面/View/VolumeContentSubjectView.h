//
//  VolumeContentSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2016/9/29.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VolumeContentSubjectView;
@protocol VolumeContentSubjectViewDelegate <NSObject>

@optional
- (void)volumeSubjectView:(VolumeContentSubjectView *)subjectView
         didSelectWebLink:(NSString *)linkStr;

@end

@interface VolumeContentSubjectView : UIView

@property (nonatomic, readonly, strong) UIImageView *iconImageView;

@property (nonatomic, weak) id<VolumeContentSubjectViewDelegate>delegate;

- (void)bindDataWithModel:(NSDictionary *)model;
- (void)bindMaterialDataWithModel:(NSDictionary *)model;

@end
