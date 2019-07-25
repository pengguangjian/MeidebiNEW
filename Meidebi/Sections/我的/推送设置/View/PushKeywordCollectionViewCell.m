//
//  PushKeywordCollectionViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 16/9/21.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "PushKeywordCollectionViewCell.h"

@implementation PushKeywordCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.button.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:self.button];
    self.button.layer.cornerRadius = 15.0;
    self.button.layer.masksToBounds = YES;
    self.button.layer.borderWidth = 0.8;
    self.button.layer.borderColor = [UIColor colorWithHexString:@"#e5e5e5"].CGColor;
    self.button.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.contentBtn = [NJIndexPathButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.contentBtn];
    [self.contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.button.mas_right).offset(5);
        make.top.equalTo(self.button.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.contentBtn setImage:[UIImage imageNamed:@"pushkeyword_close"] forState:UIControlStateNormal];
}

@end
