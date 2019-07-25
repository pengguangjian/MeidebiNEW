//
//  PelsonalHandleButton.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/25.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PelsonalHandleButton.h"

@implementation PelsonalHandleButton

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
    CGRect imageFrame = self.imageView.frame;
//    imageFrame.origin.x = 0;
    self.imageView.frame = imageFrame;
    
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = CGRectGetMaxX(imageFrame) + 5;
    self.titleLabel.frame = titleFrame;
    
//    CGRect frame = self.frame;
//    frame.size.width = CGRectGetMaxX(self.titleLabel.frame)+5;
//    self.frame = frame;
//    if (IOS_VERSION_9_OR_ABOVE) {
//        CGRect frame = self.frame;
//        frame.size.width = CGRectGetMaxX(self.titleLabel.frame)+5;
//    }
}


@end
