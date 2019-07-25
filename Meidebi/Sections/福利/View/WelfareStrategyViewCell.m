//
//  WelfareStrategyViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "WelfareStrategyViewCell.h"
#import "RemarkStatusHelper.h"
@interface WelfareStrategyViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *describeLabel;

@end

@implementation WelfareStrategyViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = .8f;
        self.layer.borderColor = [UIColor colorWithHexString:@"#D9D9D9"].CGColor;
    }
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = [UIColor whiteColor];
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-2);
    }];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:13.f];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
    _describeLabel = [UILabel new];
    [self.contentView addSubview:_describeLabel];
    [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.top.equalTo(self.contentView.mas_centerY).offset(2);
    }];
    _describeLabel.textAlignment = NSTextAlignmentCenter;
    _describeLabel.font = [UIFont systemFontOfSize:13.f];
    _describeLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    _describeLabel.numberOfLines = 2;
    
}

- (void)bindDataWithModel:(NSDictionary *)dict{
    if (!dict) return;
    _nameLabel.text = dict[kWelfareStrategyName];
   _describeLabel.attributedText = [self afreshDescribe:dict[kWelfareStrategyDescribe]];
    if ([dict[kWelfareStrategyStatus] isEqualToString:@"1"]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        self.userInteractionEnabled = NO;
    }else{
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
}

- (NSAttributedString *)afreshDescribe:(NSString *)dscribe{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:dscribe];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:12.f]
                          range:NSMakeRange(0, dscribe.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#444444"]
                          range:NSMakeRange(0, dscribe.length)];
    NSArray<NSTextCheckingResult *> *results = [[RemarkStatusHelper regexWelfareStrategy] matchesInString:dscribe options:kNilOptions range:dscribe.rangeOfAll];
    for (NSTextCheckingResult *result in results) {
        [attributedStr addAttribute:NSForegroundColorAttributeName
                                          value:[UIColor colorWithHexString:@"#EF0000"]
                                          range:NSMakeRange(result.range.location, result.range.length)];
    }
    return attributedStr.mutableCopy;
}


@end
