//
//  LastNewsTableViewCell.m
//  Meidebi
//
//  Created by leecool on 2017/9/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "LastNewsTableViewCell.h"
#import "MDB_UserDefault.h"
@interface LastNewsTableViewCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *creatLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *sitenameTitle;
@end

@implementation LastNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _sourceLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.top.equalTo(self.contentView.mas_top).with.offset(12);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:12.f];
        label;
    });
    
    _iconImageView = ({
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sourceLabel.mas_bottom).with.offset(12);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        imageView;
    });
    [_iconImageView setContentMode:UIViewContentModeScaleAspectFit];
    

    _titleLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).with.offset(10);
            make.top.equalTo(_iconImageView.mas_top).with.offset(5);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.height.mas_lessThanOrEqualTo(40);
        }];
        label.numberOfLines = 2;
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:16.f];
        label;
    });
    
    _priceLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(5);
        }];
        label.textColor = [UIColor colorWithHexString:@"#fc6e00"];
        label.font = [UIFont systemFontOfSize:16.f];
        label;
    });
    
    // 评论
    _commentLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(_iconImageView.mas_bottom).offset(-8);
        }];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:11.f];
        label;
    });
    [_commentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    UIImageView *commentImageView = ({
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_commentLabel.mas_centerY);
            make.right.equalTo(_commentLabel.mas_left).with.offset(-2);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        imageView.image = [UIImage imageNamed:@"pinglun"];
        imageView;
    });
    
    _creatLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(commentImageView.mas_left).with.offset(-5);
            make.centerY.equalTo(commentImageView.mas_centerY);
        }];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:11.f];
        label;
    });
    [_creatLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    UIImageView *creatImageView = ({
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(commentImageView.mas_centerY).offset(-1);
            make.right.equalTo(_creatLabel.mas_left).with.offset(-2);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        imageView;
    });
    creatImageView.image = [UIImage imageNamed:@"zhan"];
    
    
    _timeLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:11.f];
        label;
    });
    
    UIView *lineView = ({
        UIView *view = [UIView new];
        [self.contentView addSubview:view];
        view.backgroundColor = [UIColor colorWithRed:0.86 green:0.8554 blue:0.8645 alpha:1.0];
        view;
    });
    
    _sitenameTitle = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:11.f];
        label;
    });
    
    [_sitenameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.bottom.equalTo(_iconImageView.mas_bottom).offset(-8);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sitenameTitle.mas_right).offset(5);
        make.top.equalTo(_sitenameTitle.mas_top).offset(2);
        make.bottom.equalTo(_sitenameTitle.mas_bottom).offset(-2);
        make.width.offset(0.5);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(creatImageView.mas_left).offset(-5);
        make.left.equalTo(lineView.mas_right).offset(5);
        make.centerY.equalTo(_commentLabel.mas_centerY);
    }];
    [_sitenameTitle setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)bindDataWithModel:(LastNewsModel *)model{
    if (!model) return;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[NSString nullToString:model.imageLink]];
    _sourceLabel.text = model.sourceStr;
    [_sitenameTitle setText:[self filterSiteName:model.site]];
    if(model.isSelect)
    {
        [_titleLabel setTextColor:RGB(150, 150, 150)];
    }
    else
    {
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
    }
    @try
    {
        [_timeLabel setText:[NSString stringWithFormat:@"%@",[MDB_UserDefault CalDateIntervalFromData:[NSDate dateWithTimeIntervalSince1970:[model.time integerValue]] endDate:[NSDate date] ]]];
        [_titleLabel setText:model.title];
        [_priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[model.price floatValue]]];
        [_creatLabel setText:[NSString stringWithFormat:@"%@",model.likeCount]];
        [_commentLabel setText:[NSString stringWithFormat:@"%@",model.remarkCount]];
    }
    @catch(NSException *exc)
    {
        
    }
    @finally
    {
        
    }
    
}

- (NSString *)filterSiteName:(NSString *)siteName{
    NSInteger maxlenght = 0;
    if ([self inspectStr:siteName]) {
        maxlenght = 5;
    }else{
        maxlenght = 10;
    }
    if (siteName.length<=maxlenght) return siteName;
    NSMutableString *site = [[NSMutableString alloc] initWithString:[siteName substringToIndex:maxlenght]];
    return [site stringByAppendingString:@"..."];
}

- (BOOL)inspectStr:(NSString *)str{
    BOOL isChinese = NO;
    NSInteger length = [str length];
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [str substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3 && ![subString isEqualToString:@"."])
        {
            isChinese = YES;
            break;
        }
    }
    return isChinese;
}
@end
