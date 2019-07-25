//
//  NJFlagItemCollectionViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/23.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "NJFlagItemCollectionViewCell.h"
#import "UIColor+Hex.h"

@interface NJFlagItemCollectionViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation NJFlagItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews{
    _nameLabel.frame = self.bounds;
    [super layoutSubviews];

}
- (void)setupSubviews{
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
//    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor colorWithHexString:@"#2D2D2D"];
    _nameLabel.font = [UIFont systemFontOfSize:12.f];
    
    self.layer.cornerRadius = 4.f;
    self.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
}

- (void)bindFlagItemData:(NSDictionary *)model{
    _nameLabel.text = [NSString stringWithFormat:@"%@",model[@"name"]];
}

@end
