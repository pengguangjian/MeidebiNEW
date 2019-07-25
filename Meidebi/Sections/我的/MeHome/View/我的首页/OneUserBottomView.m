//
//  OneUserBottomView.m
//  Meidebi
//
//  Created by fishmi on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OneUserBottomView.h"

@implementation OneUserBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubView];
    }
    return self;
}
- (void)setUpSubView{
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(1, 16));
    }];
    
    UILabel *talkLabel = [[UILabel alloc] init];
    talkLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    talkLabel.textAlignment = NSTextAlignmentCenter;
    talkLabel.text = @"app交流群 140579954";
    talkLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:talkLabel];
    [talkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(lineV.mas_left).offset(-10);
    }];
    _talkLabel = talkLabel;
    
    UILabel *telLabel = [[UILabel alloc] init];
    telLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    telLabel.textAlignment = NSTextAlignmentCenter;
    telLabel.text = @"海淘代购群 465635708";
    telLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:telLabel];
    [telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(lineV.mas_right).offset(10);
    }];
    _telLabel = telLabel;
}

@end
