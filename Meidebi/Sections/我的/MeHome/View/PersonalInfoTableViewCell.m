//
//  PersonalInfoTableViewCell.m
//  Meidebi
//  个人信息cell
//  Created by fishmi on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalInfoTableViewCell.h"
#import "PersonalInfoModel.h"

@implementation PersonalInfoTableViewCell



//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self setSubView];
//    }
//    return self;
//}
//
//-(instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self setSubView];
//    }
//    return self;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    UIView *lineV = [[UIView alloc] init];
    [self addSubview:lineV];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(1);
    }];
    UILabel *text_Label = [[UILabel alloc] init];
    text_Label.font = [UIFont systemFontOfSize:16];
    text_Label.text = @"";
    text_Label.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:text_Label];
    [text_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20 *kScale);
        make.width.offset(100 * kScale);
    }];
    _text_Label = text_Label;
    
    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.font = [UIFont systemFontOfSize:14];
    subLabel.textAlignment = NSTextAlignmentRight;
    subLabel.text = @"";
    subLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(text_Label.mas_right).offset(20 *kScale);
        make.right.equalTo(self).offset(-46 *kScale);
    }];
    _subLabel = subLabel;
}


@end
