//
//  PersonalBrokeNewsTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalBrokeNewsTableViewCell.h"
#import "MDB_UserDefault.h"
@interface PersonalBrokeNewsTableViewCell ()

@property (strong, nonatomic) UIImageView *heardImage;
@property (strong, nonatomic) UILabel *sitenameTitle;
@property (strong, nonatomic) UILabel *timeLable;
@property (strong, nonatomic) UILabel *contentLable;
@property (strong, nonatomic) UILabel *priceLable;
@property (strong, nonatomic) UILabel *commentLable;
@property (strong, nonatomic) UILabel *creatLable;
@property (strong, nonatomic) UIImageView *timetout;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UIImageView *creatImageView;
@property (nonatomic, strong) UIImageView *recommendImageView;

@end

@implementation PersonalBrokeNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _heardImage = ({
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(12);
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        imageView;
    });
    [_heardImage setContentMode:UIViewContentModeScaleAspectFit];
    
    
    _recommendImageView = [UIImageView new];
    [_heardImage addSubview:_recommendImageView];
    [_recommendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_heardImage);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    _recommendImageView.contentMode = UIViewContentModeScaleAspectFit;
    _recommendImageView.image = [UIImage imageNamed:@"recommend_list"];
    _recommendImageView.hidden = YES;
    
    _contentLable = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_heardImage.mas_right).with.offset(10);
            make.top.equalTo(_heardImage.mas_top).with.offset(5);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.height.offset(40);
        }];
        label.numberOfLines = 2;
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:16.f];
        label;
    });
    
    _priceLable = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentLable.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(_contentLable.mas_bottom).with.offset(5);
        }];
        label.textColor = [UIColor colorWithHexString:@"#fc6e00"];
        label.font = [UIFont systemFontOfSize:16.f];
        label;
    });
    
    // 评论
    _commentLable = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(_heardImage.mas_bottom).offset(-2);
        }];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:11.f];
        label;
    });
    [_commentLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    _commentImageView = ({
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_commentLable.mas_centerY);
            make.right.equalTo(_commentLable.mas_left).with.offset(-2);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        imageView.image = [UIImage imageNamed:@"pinglun"];
        imageView.hidden = YES;
        imageView;
    });
    
    _creatLable = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_commentImageView.mas_left).with.offset(-5);
            make.centerY.equalTo(_commentImageView.mas_centerY);
        }];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:11.f];
        label;
    });
    [_creatLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    _creatImageView = ({
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_commentImageView.mas_centerY).offset(-1);
            make.right.equalTo(_creatLable.mas_left).with.offset(-2);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        imageView.hidden = YES;
        imageView;
    });
    _creatImageView.image = [UIImage imageNamed:@"zhan"];
    
    
    _timeLable = ({
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
        make.left.equalTo(_contentLable.mas_left);
        make.bottom.equalTo(_heardImage.mas_bottom).offset(-2);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sitenameTitle.mas_right).offset(5);
        make.top.equalTo(_sitenameTitle.mas_top).offset(2);
        make.bottom.equalTo(_sitenameTitle.mas_bottom).offset(-2);
        make.width.offset(0.5);
    }];
    
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_creatImageView.mas_left).offset(-5);
        make.left.equalTo(lineView.mas_right).offset(5);
        make.centerY.equalTo(_commentLable.mas_centerY);
    }];
    
    //    [_timeLable setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [_sitenameTitle setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    //    [_sitenameTitle setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    _timetout = ({
        UIImageView *imageView = [UIImageView new];
        [_heardImage addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(_heardImage);
            make.size.mas_equalTo(CGSizeMake(47, 23));
        }];
        imageView.image = [UIImage imageNamed:@"timeout"];
        imageView.hidden = YES;
        imageView;
    });
    
}

- (void)bindDataWithModel:(PersonalBrokeNewsViewModel *)model{
    [[MDB_UserDefault defaultInstance]setViewWithImage:_heardImage url:model.image options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            _heardImage.image=image;
        }else{
            _heardImage.image=[UIImage imageNamed:@"punot.png"];
        }
    }];
    [_sitenameTitle setText:[self filterSiteName:model.sitename]];
    
    [_timeLable setText:[NSString stringWithFormat:@"%@",model.createtime]];
    [_contentLable setText:model.title];
    if ([model.linktype intValue]==2) {
        if (![model.prodescription isKindOfClass:[NSNull class]]) {
            _priceLable.text=[NSString stringWithFormat:@"%@",model.prodescription];
        }
    }else{
        [_priceLable setText:[NSString stringWithFormat:@"￥%.2f",[model.price floatValue]]];
    }
    if (model.timeout) {
        _timetout.hidden=[model.timeout intValue]==2?NO:YES;
    }else{
        _timetout.hidden=YES;
    }
//    [_creatLable setText:[NSString stringWithFormat:@"%@",model.votesp]];
//    [_commentLable setText:[NSString stringWithFormat:@"%@",model.commentcount]];
    
    [_creatLable setText:[self numberChangeStringValue:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",model.votesp].intValue]]];
    [_commentLable setText:[self numberChangeStringValue:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",model.commentcount].intValue]]];
    
    
    
    _commentImageView.hidden = NO;
    _creatImageView.hidden = NO;
    
//    if (model.recommend.integerValue == 1) {
//        _recommendImageView.hidden = NO;
//    }else{
//        _recommendImageView.hidden = YES;
//    }
}

-(NSString *)numberChangeStringValue:(NSNumber *)value
{
    NSString *strtemp = @"";
    if(value.integerValue>=1000&&value.integerValue<10000)
    {
        strtemp = [NSString stringWithFormat:@"%dk+",value.intValue/1000];
    }
    else if (value.integerValue>=10000)
    {
        strtemp = [NSString stringWithFormat:@"%dw+",value.intValue/10000];
    }
    else
    {
        strtemp = [NSString stringWithFormat:@"%d",value.intValue];
    }
    return strtemp;
}


- (NSString *)filterSiteName:(NSString *)siteName{
    if(siteName==nil)
    {
        siteName = @"";
    }
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
