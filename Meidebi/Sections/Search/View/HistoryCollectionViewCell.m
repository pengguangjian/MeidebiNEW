//
//  HistoryCollectionViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 16/4/7.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "HistoryCollectionViewCell.h"
#import "UIColor+Hex.h"
@implementation HistoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.button = [NJIndexPathButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.button.backgroundColor = [UIColor colorWithRed:0.9961 green:0.9961 blue:0.9961 alpha:1.0];
    [self.contentView addSubview:self.button];
    self.button.layer.cornerRadius = 15.0;
    self.button.layer.masksToBounds = YES;
    self.button.layer.borderWidth = 0.8;
    self.button.layer.borderColor = [UIColor colorWithHexString:@"#8f8f8f"].CGColor;
    self.button.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
}

@end
