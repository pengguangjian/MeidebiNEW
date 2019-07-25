//
//  LastOriginalNewsTableViewCell.m
//  Meidebi
//
//  Created by leecool on 2017/9/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "LastOriginalNewsTableViewCell.h"
#import "MDB_UserDefault.h"
@interface LastOriginalNewsTableViewCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *creatLabel;
@end

@implementation LastOriginalNewsTableViewCell

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
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.height.equalTo(imageView.mas_width).with.multipliedBy(0.44);
        }];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 4.f;
        imageView;
    });
    [_iconImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    // 评论
    _commentLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(_iconImageView.mas_bottom).with.offset(23);
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
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_left);
            make.centerY.equalTo(creatImageView.mas_centerY);
            make.right.equalTo(creatImageView.mas_left).with.offset(-10);
        }];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.font = [UIFont systemFontOfSize:14.f];
        label;
    });
    
    [_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)bindDataWithModel:(LastNewsModel *)model{
    if (!model) return;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[NSString nullToString:model.imageLink]];
    _sourceLabel.text = model.sourceStr;
    [_titleLabel setText:model.title];
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
@end
