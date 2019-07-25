//
//  JingXuanYouHuiQuanTableViewCell.m
//  Meidebi
//  优惠券home cell
//  Created by mdb-losaic on 2019/2/18.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "JingXuanYouHuiQuanTableViewCell.h"
#import "MDB_UserDefault.h"


@interface JingXuanYouHuiQuanTableViewCell ()

@property (strong, nonatomic) UIImageView *heardImage;
//@property (strong, nonatomic) UILabel *sitenameTitle;
@property (strong, nonatomic) UILabel *fuliLable;
@property (strong, nonatomic) UILabel *timeLable;
@property (strong, nonatomic) UILabel *contentLable;
@property (strong, nonatomic) UILabel *priceLable;
//@property (strong, nonatomic) UILabel *commentLable;
//@property (strong, nonatomic) UILabel *creatLable;
@property (strong, nonatomic) UIImageView *timetout;
//@property (nonatomic, strong) UIImageView *commentImageView;
//@property (nonatomic, strong) UIImageView *creatImageView;
////推荐
@property (nonatomic, strong) UIImageView *recommendImageView;

//@property (nonatomic, strong) UILabel *lbhongbao;

@end

@implementation JingXuanYouHuiQuanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
    
    
    _fuliLable = [[UILabel alloc] init];
    [self.contentView addSubview:_fuliLable];
    [_fuliLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_heardImage);
        make.size.mas_equalTo(CGSizeMake(25, 15));
    }];
    _fuliLable.textColor = [UIColor redColor];
    _fuliLable.font = [UIFont systemFontOfSize:10.f];
    [_fuliLable setBackgroundColor:[UIColor clearColor]];
    [_fuliLable.layer setMasksToBounds:YES];
    [_fuliLable.layer setCornerRadius:2];
    [_fuliLable setTextAlignment:NSTextAlignmentCenter];
    [_fuliLable.layer setBorderColor:[UIColor redColor].CGColor];
    [_fuliLable.layer setBorderWidth:1];
    [_fuliLable setText:@"福利"];
    [_fuliLable setHidden:NO];
    
    
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
    
//    // 评论
//    _commentLable = ({
//        UILabel *label = [UILabel new];
//        [self.contentView addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView.mas_right).offset(-10);
//            make.bottom.equalTo(_heardImage.mas_bottom).offset(-2);
//        }];
//        label.textColor = [UIColor colorWithHexString:@"#999999"];
//        label.font = [UIFont systemFontOfSize:11.f];
//        label;
//    });
//    [_commentLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//
//    _commentImageView = ({
//        UIImageView *imageView = [UIImageView new];
//        [self.contentView addSubview:imageView];
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_commentLable.mas_centerY);
//            make.right.equalTo(_commentLable.mas_left).with.offset(-2);
//            make.size.mas_equalTo(CGSizeMake(20, 20));
//        }];
//        imageView.image = [UIImage imageNamed:@"pinglun"];
//        imageView.hidden = YES;
//        imageView;
//    });
//
//    _creatLable = ({
//        UILabel *label = [UILabel new];
//        [self.contentView addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(_commentImageView.mas_left).with.offset(-5);
//            make.centerY.equalTo(_commentImageView.mas_centerY);
//        }];
//        label.textColor = [UIColor colorWithHexString:@"#999999"];
//        label.font = [UIFont systemFontOfSize:11.f];
//        label;
//    });
//    [_creatLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//
//    _creatImageView = ({
//        UIImageView *imageView = [UIImageView new];
//        [self.contentView addSubview:imageView];
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_commentImageView.mas_centerY).offset(-1);
//            make.right.equalTo(_creatLable.mas_left).with.offset(-2);
//            make.size.mas_equalTo(CGSizeMake(20, 20));
//        }];
//        imageView.hidden = YES;
//        imageView;
//    });
//    _creatImageView.image = [UIImage imageNamed:@"zhan"];
    
    
    _timeLable = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:11.f];
        label;
    });
    
//    UIView *lineView = ({
//        UIView *view = [UIView new];
//        [self.contentView addSubview:view];
//        view.backgroundColor = [UIColor colorWithRed:0.86 green:0.8554 blue:0.8645 alpha:1.0];
//        view;
//    });
//
//    _sitenameTitle = ({
//        UILabel *label = [UILabel new];
//        [self.contentView addSubview:label];
//        label.textColor = [UIColor colorWithHexString:@"#999999"];
//        label.font = [UIFont systemFontOfSize:11.f];
//        label;
//    });
//
//    [_sitenameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_contentLable.mas_left);
//        make.bottom.equalTo(_heardImage.mas_bottom).offset(-2);
//        make.width.offset(100*kScale);
//    }];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_sitenameTitle.mas_right).offset(5);
//        make.top.equalTo(_sitenameTitle.mas_top).offset(2);
//        make.bottom.equalTo(_sitenameTitle.mas_bottom).offset(-2);
//        make.width.offset(0.5);
//    }];
    
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentLable.mas_left);
        make.bottom.equalTo(_heardImage.mas_bottom).offset(-2);
        make.width.offset(180*kScale);
    }];
    
    //    [_timeLable setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
//    [_sitenameTitle setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
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

- (void)fetchCellData:(Article *)article{
    
    //    [[MDB_UserDefault defaultInstance]setViewWithImage:_heardImage url:article.image options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //        if (image) {
    //            _heardImage.image=image;
    //        }else{
    //            _heardImage.image=[UIImage imageNamed:@"punot.png"];
    //        }
    //    }];
    if(article==nil)return;
    
    [[MDB_UserDefault defaultInstance] setViewWithImage:_heardImage url:article.img];
    //    [_sitenameTitle setText:[self filterSiteName:[NSString nullToString:article.sitename]]];
//    [_sitenameTitle setText:[NSString nullToString:article.sitename]];
//    float fwitdt = [MDB_UserDefault getStrWightFont:[UIFont systemFontOfSize:11.f] str:[NSString nullToString:article.sitename] hight:15].width+3;
//    if(fwitdt>(BOUNDS_WIDTH-255)*0.9)
//    {
//        fwitdt = (BOUNDS_WIDTH-255)*0.9;
//    }
//    [_sitenameTitle mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(fwitdt);
//    }];
    
    
    
//    [_timeLable setText:[NSString stringWithFormat:@"%@",[MDB_UserDefault CalDateIntervalFromData:article.createtime endDate:[NSDate date] ]]];
    
    [_timeLable setText:[NSString stringWithFormat:@"截止时间：%@",[MDB_UserDefault strTimefromData:[article.getend integerValue] dataFormat:@"yyyy-MM-dd"]]];
    
    [_contentLable setText:article.title];
    
    NSMutableArray *arrbldj = [[NSUserDefaults standardUserDefaults] objectForKey:@"baoliaoyidianji"];
    BOOL isbool = [arrbldj containsObject:[NSString stringWithFormat:@"%@", article.main_id]];
    if(article.isSelected == YES || isbool==YES)
    {
        [_contentLable setTextColor:RGB(150, 150, 150)];
        
    }
    else
    {
        [_contentLable setTextColor:[UIColor colorWithHexString:@"#333333"]];
    }
    
    
    _priceLable.text=[NSString stringWithFormat:@"%@",article.desc];
    
//    if ([article.linktype intValue]==2) {
//        if (![article.prodescription isKindOfClass:[NSNull class]]) {
//
//        }
//
//    }else{
//        //        if ([article.proprice floatValue]<[article.price floatValue]&&[article.proprice floatValue]!=0.0f) {
//        //            [_priceLable setText:[NSString stringWithFormat:@"￥%.2f",[article.proprice floatValue]]];
//        //        }else{
//        [_priceLable setText:[NSString stringWithFormat:@"￥%.2f",[article.price floatValue]]];
//        //        }
//    }
//    if (article.timeout) {
//        _timetout.hidden=[article.timeout intValue]==2?NO:YES;
//    }else{
//        _timetout.hidden=YES;
//    }
    //    [_creatLable setText:[NSString stringWithFormat:@"%@",article.votesp]];
    //    [_commentLable setText:[NSString stringWithFormat:@"%@",article.commentcount]];
    
//    [_creatLable setText:[self numberChangeStringValue:article.votesp]];
//    [_commentLable setText:[self numberChangeStringValue:article.commentcount]];
//    
//    _commentImageView.hidden = NO;
//    _creatImageView.hidden = NO;
    
//    if(article.tljurl.length>6||article.tljurl.integerValue==1)
//    {
//        [_lbhongbao setHidden:NO];
//    }
//    else
//    {
//        [_lbhongbao setHidden:YES];
//    }
    
    if (article.recommend.integerValue == 1) {
        _recommendImageView.hidden = NO;
    }else{
        _recommendImageView.hidden = YES;
    }
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

@end
