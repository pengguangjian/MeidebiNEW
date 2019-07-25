//
//  CouponSimpleTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/29.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CouponSimpleTableViewCell.h"
#import "MDB_UserDefault.h"
@interface CouponSimpleTableViewCell ()

@property (strong, nonatomic) UIImageView *heardImage;
@property (strong, nonatomic) UILabel *sitenameTitle;
@property (strong, nonatomic) UILabel *timeLable;
@property (strong, nonatomic) UILabel *contentLable;
@property (strong, nonatomic) UILabel *priceLable;
@property (strong, nonatomic) UIImageView *timetout;
@property (nonatomic, strong) UIImageView *recommendImageView;
@property (nonatomic, strong) UIButton *couponBtn;
@end

@implementation CouponSimpleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
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
            make.top.equalTo(self.contentView.mas_top).with.offset(19);
            make.left.equalTo(self.contentView.mas_left).with.offset(14);
            make.size.mas_equalTo(CGSizeMake(100, 100));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-19);
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
    
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentLable.mas_right);
        make.bottom.equalTo(_heardImage.mas_bottom).offset(-2);
        
    }];
   
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_timeLable.mas_left).offset(-5);
        make.top.equalTo(_timeLable.mas_top).offset(2);
        make.bottom.equalTo(_timeLable.mas_bottom).offset(-2);
        make.width.offset(0.5);
    }];
    
    [_sitenameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView.mas_left).offset(-5);
        //        make.left.equalTo(lineView.mas_right).offset(5);
        make.centerY.equalTo(_timeLable.mas_centerY);
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
    
    UIButton *couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:couponBtn];
    [couponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentLable.mas_left);
        make.bottom.equalTo(_heardImage.mas_bottom).offset(-2);
        make.size.mas_equalTo(CGSizeMake(90, 22));
    }];
    [couponBtn setBackgroundImage:[UIImage imageNamed:@"coupon_value_bg"] forState:UIControlStateNormal];
    [couponBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [couponBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _couponBtn = couponBtn;

}


- (void)fetchCommodityData:(Commodity *)aCommodity{
    [[MDB_UserDefault defaultInstance]setViewWithImage:_heardImage url:aCommodity.image options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            _heardImage.image=image;
        }else{
            _heardImage.image=[UIImage imageNamed:@"punot.png"];
        }
    }];
    [_sitenameTitle setText:[self filterSiteName:aCommodity.sitename]];
    
    [_timeLable setText:[NSString stringWithFormat:@"%@",[MDB_UserDefault CalDateIntervalFromData:[NSDate dateWithTimeIntervalSince1970:[aCommodity.createtime integerValue]] endDate:[NSDate date] ]]];
    [_contentLable setText:aCommodity.title];
    if ([aCommodity.linktype intValue]==2) {
        if (![aCommodity.prodescription isKindOfClass:[NSNull class]]) {
            _priceLable.text=[NSString stringWithFormat:@"%@",aCommodity.prodescription];
        }
        
    }else{
        NSString *str = @" 券后价";
        NSString *price = @"";
        if ([aCommodity.proprice floatValue]<[aCommodity.price floatValue]&&[aCommodity.proprice floatValue]!=0.0f) {
            price = [NSString stringWithFormat:@"￥%.2f",[aCommodity.proprice floatValue]];
        }else{
            price = [NSString stringWithFormat:@"￥%.2f",[aCommodity.price floatValue]];
        }
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:[price stringByAppendingString:str]];
        [attributed addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithHexString:@"#fc6e00"]
                           range:NSMakeRange(0, price.length)];
        [attributed addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithHexString:@"#999999"]
                           range:NSMakeRange(price.length, str.length)];
        [attributed addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:16]
                           range:NSMakeRange(0, price.length)];
        [attributed addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:12]
                           range:NSMakeRange(price.length, str.length)];
        _priceLable.attributedText = attributed.mutableCopy;

    }
    if (aCommodity.timeout) {
        _timetout.hidden=[aCommodity.timeout intValue]==2?NO:YES;
    }else{
        _timetout.hidden=YES;
    }
    NSString *denomination = @"0";
    if ([aCommodity.denomination floatValue]!=0.0f) {
        denomination = [NSString stringWithFormat:@"￥%.f",[aCommodity.denomination floatValue]];
    }
    [_couponBtn setTitle:[NSString stringWithFormat:@"%@元券",denomination] forState:UIControlStateNormal];
  
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
