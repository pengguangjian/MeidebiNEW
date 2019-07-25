//
//  ReadMoreTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ReadMoreTableViewCell.h"

@implementation ReadMoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupSubviews{

    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    titleLabel.text = @"查看更多评论 >>";
    titleLabel.textColor = [UIColor colorWithHexString:@"#A6A6A6"];
    titleLabel.font = [UIFont systemFontOfSize:14.f];

}

@end
