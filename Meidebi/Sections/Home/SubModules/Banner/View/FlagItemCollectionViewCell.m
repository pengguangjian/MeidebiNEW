//
//  FlagItemCollectionViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "FlagItemCollectionViewCell.h"

@interface FlagItemCollectionViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation FlagItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _nameLabel.font = [UIFont systemFontOfSize:10.f];

    self.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    self.layer.borderWidth = 0.8f;
    self.layer.cornerRadius = 4.f;
}

- (void)bindFlagItemData:(NSDictionary *)model{
    _nameLabel.text = model[@"name"];
}
@end
