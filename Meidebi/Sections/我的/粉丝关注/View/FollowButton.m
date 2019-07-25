//
//  FollowButton.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "FollowButton.h"

@implementation FollowButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.frame;

    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = CGRectGetWidth(frame)/2 - CGRectGetWidth(imageFrame)/2;
    imageFrame.origin.y = CGRectGetHeight(frame)/2 - CGRectGetHeight(imageFrame)/2-4;
    self.imageView.frame = imageFrame;
    
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = CGRectGetWidth(frame)/2 - CGRectGetWidth(titleFrame)/2;
    titleFrame.origin.y = CGRectGetMaxY(imageFrame)+4;
    self.titleLabel.frame = titleFrame;
//    frame.size.width = CGRectGetMaxX(self.titleLabel.frame)+5;
//    self.frame = frame;
}

@end
