//
//  PaddingLabel.m
//  Meidebi
//
//  Created by mdb-admin on 2016/10/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "PaddingLabel.h"

@implementation PaddingLabel

-(CGSize)intrinsicContentSize{
    CGSize contentSize = [super intrinsicContentSize];
    return CGSizeMake(contentSize.width + 12, contentSize.height + 6);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.frame;
    if (frame.size.width<frame.size.height) {
        frame.size.width = frame.size.height;
        self.frame = frame;
    }
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height/2.f;
}
@end
