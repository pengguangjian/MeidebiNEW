//
//  AboutMDBView.m
//  Meidebi
//  关于我们
//  Created by fishmi on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "AboutMDBView.h"
#import "MDB_UserDefault.h"

@implementation AboutMDBView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpSubView];
    }
    return self;
    
}

- (void)setUpSubView{
    UIScrollView * scrollV = [[UIScrollView alloc] init];
    scrollV.bounces = NO;
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.contentSize = CGSizeMake(kMainScreenW, kMainScreenH);
    [self addSubview:scrollV];
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
//    scrollV.showsVerticalScrollIndicator = NO;
    
    UIView *containView = [[UIView alloc] init];
    [scrollV addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollV);
        make.width.equalTo(scrollV);
    }];
    
    UIView *backgroundV = [[UIView alloc] init];
    backgroundV.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [containView addSubview:backgroundV];
    [backgroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(containView);
        make.height.offset(181 *kScale);
    }];
    
    UIImageView *mdbImageV = [[UIImageView alloc] init];
    [backgroundV addSubview:mdbImageV];
    [mdbImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backgroundV);
        make.size.mas_equalTo(CGSizeMake(242 *kScale, 115 *kScale));
    }];
    mdbImageV.image = [UIImage imageNamed:@"AboutMDB"];
    
    UILabel *aboutUs = [[UILabel alloc] init];
    aboutUs.textAlignment = NSTextAlignmentCenter;
    aboutUs.text = @"ABOUT US";
    aboutUs.font = [UIFont systemFontOfSize:15];
    aboutUs.textColor = [UIColor colorWithHexString:@"#E45100"];
    [containView addSubview:aboutUs];
    [aboutUs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containView);
        make.top.equalTo(backgroundV.mas_bottom).offset(26 *kScale);
        make.size.mas_equalTo(CGSizeMake(80, 15));
    }];
    UIView *aboutUsLeftLineV = [[UIView alloc] init];
    aboutUsLeftLineV.backgroundColor = [UIColor colorWithHexString:@"#E45100"];
    [containView addSubview:aboutUsLeftLineV];
    [aboutUsLeftLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aboutUs.mas_centerY);
        make.height.offset(3);
        make.right.equalTo(aboutUs.mas_left).offset(-10);
        make.width.offset(20);
    }];
    
    UIView *aboutUsRightLineV = [[UIView alloc] init];
    aboutUsRightLineV.backgroundColor = [UIColor colorWithHexString:@"#E45100"];
    [containView addSubview:aboutUsRightLineV];
    [aboutUsRightLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aboutUs.mas_centerY);
        make.height.offset(3);
        make.left.equalTo(aboutUs.mas_right).offset(10);
        make.width.offset(20);
    }];
    
    UILabel *aboutUsdetailLab = [[UILabel alloc] init];
    aboutUsdetailLab.text = @"重庆市狸狗信息科技有限公司旗下没得比理性消费社区（以下简称没得比），是一个中立的、高性价比网购商品分享、推荐平台，是一个为了帮助广大网友购买到高性价比产品的分享平台。";
    aboutUsdetailLab.textColor = [UIColor colorWithHexString:@"#666666"];
    aboutUsdetailLab.attributedText = [self getAttributedStringWithString:aboutUsdetailLab.text lineSpace:10];
    aboutUsdetailLab.font = [UIFont systemFontOfSize:15];
    [containView addSubview:aboutUsdetailLab];
    [aboutUsdetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(aboutUs.mas_bottom).offset(20 *kScale);
        make.left.equalTo(containView).offset(16);
        make.right.equalTo(containView).offset(-16);
    }];
    aboutUsdetailLab.numberOfLines = 0;
    aboutUsdetailLab.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [aboutUsdetailLab sizeThatFits:CGSizeMake(aboutUsdetailLab.frame.size.width,MAXFLOAT)];
    aboutUsdetailLab.frame = CGRectMake(aboutUsdetailLab.frame.origin.x, aboutUsdetailLab.frame.origin.y, aboutUsdetailLab.frame.size.width, size.height);
    
    UIImageView *aboutUsPicV = [[UIImageView alloc] init];
    [containView addSubview:aboutUsPicV];
    [aboutUsPicV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containView.mas_centerX);
        make.top.equalTo(aboutUsdetailLab.mas_bottom).offset(34 *kScale);
        make.size.mas_equalTo(CGSizeMake(297 *kScale, 132 *kScale));
    }];
    aboutUsPicV.image = [UIImage imageNamed:@"aboutUsPicture"];
    
    
    UILabel *boutiqueL = [[UILabel alloc] init];
    boutiqueL.text = @"每日精选 平价好物";
    boutiqueL.textAlignment = NSTextAlignmentCenter;
    boutiqueL.font = [UIFont systemFontOfSize:15];
    boutiqueL.textColor = [UIColor colorWithHexString:@"#E45100"];
    [containView addSubview:boutiqueL];
    [boutiqueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containView);
        make.top.equalTo(aboutUsPicV.mas_bottom).offset(65 *kScale);
        make.size.mas_equalTo(CGSizeMake(130, 15));
    }];
    UIView *boutiqueLeftLineV = [[UIView alloc] init];
    boutiqueLeftLineV.backgroundColor = [UIColor colorWithHexString:@"#E45100"];
    [containView addSubview:boutiqueLeftLineV];
    [boutiqueLeftLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(boutiqueL.mas_centerY);
        make.height.offset(3);
        make.right.equalTo(boutiqueL.mas_left).offset(-10);
        make.width.offset(20);
    }];
    
    UIView *boutiqueRightLineV = [[UIView alloc] init];
    boutiqueRightLineV.backgroundColor = [UIColor colorWithHexString:@"#E45100"];
    [containView addSubview:boutiqueRightLineV];
    [boutiqueRightLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(boutiqueL.mas_centerY);
        make.height.offset(3);
        make.left.equalTo(boutiqueL.mas_right).offset(10);
        make.width.offset(20);
    }];
    
    UILabel *boutiquedetailLab = [[UILabel alloc] init];
    boutiquedetailLab.text = @"没得比每日精选国内外超高性价比正品商品，聚合了数百个大型购物网站最新的商品折扣优惠信息。来这里花￥100买￥500的东西，绝对正品";
    boutiquedetailLab.textColor = [UIColor colorWithHexString:@"#666666"];
    boutiquedetailLab.attributedText = [self getAttributedStringWithString:boutiquedetailLab.text lineSpace:10];
    boutiquedetailLab.font = [UIFont systemFontOfSize:15];
    [containView addSubview:boutiquedetailLab];
    [boutiquedetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(boutiqueL.mas_bottom).offset(20 *kScale);
        make.left.equalTo(containView).offset(16);
        make.right.equalTo(containView).offset(-16);
    }];
    boutiquedetailLab.numberOfLines = 0;
    boutiquedetailLab.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize boutiqueSize = [boutiquedetailLab sizeThatFits:CGSizeMake(boutiquedetailLab.frame.size.width,MAXFLOAT)];
    boutiquedetailLab.frame = CGRectMake(boutiquedetailLab.frame.origin.x, boutiquedetailLab.frame.origin.y, boutiquedetailLab.frame.size.width, boutiqueSize.height);
    
   
    
    UIImageView *boutiqueLeftPicV = [[UIImageView alloc] init];
    [containView addSubview:boutiqueLeftPicV];
    [boutiqueLeftPicV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containView).offset(16);
        make.top.equalTo(boutiquedetailLab.mas_bottom).offset(34 *kScale);
        make.size.mas_equalTo(CGSizeMake((kMainScreenW - 16 * 2 -  10 *2) / 3, 124 *kScale));
    }];
    boutiqueLeftPicV.image = [UIImage imageNamed:@"goodsPicture1"];
    
    UIImageView *boutiqueCenterPicV = [[UIImageView alloc] init];
    [containView addSubview:boutiqueCenterPicV];
    [boutiqueCenterPicV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containView);
        make.top.equalTo(boutiquedetailLab.mas_bottom).offset(34 *kScale);
        make.size.mas_equalTo(CGSizeMake((kMainScreenW - 16 * 2 -  10 *2) / 3, 124 *kScale));
    }];
    boutiqueCenterPicV.image = [UIImage imageNamed:@"goodsPicture2"];
    
    UIImageView *boutiqueRightPicV = [[UIImageView alloc] init];
    [containView addSubview:boutiqueRightPicV];
    [boutiqueRightPicV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containView).offset(-16);
        make.top.equalTo(boutiquedetailLab.mas_bottom).offset(34 *kScale);
        make.size.mas_equalTo(CGSizeMake((kMainScreenW - 16 * 2 -  10 *2) / 3, 124 *kScale));
    }];
    boutiqueRightPicV.image = [UIImage imageNamed:@"goodsPicture3"];
    
    
    UILabel *concessionL = [[UILabel alloc] init];
    concessionL.text = @"优惠劵直播";
    concessionL.textAlignment = NSTextAlignmentCenter;
    concessionL.font = [UIFont systemFontOfSize:15];
    concessionL.textColor = [UIColor colorWithHexString:@"#E45100"];
    [containView addSubview:concessionL];
    [concessionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containView);
        make.top.equalTo(boutiqueRightPicV.mas_bottom).offset(65 *kScale);
        make.size.mas_equalTo(CGSizeMake(80, 15));
    }];
    UIView *concessionLeftLineV = [[UIView alloc] init];
    concessionLeftLineV.backgroundColor = [UIColor colorWithHexString:@"#E45100"];
    [containView addSubview:concessionLeftLineV];
    [concessionLeftLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(concessionL.mas_centerY);
        make.height.offset(3);
        make.right.equalTo(concessionL.mas_left).offset(-10);
        make.width.offset(20);
    }];
    
    UIView *concessionRightLineV = [[UIView alloc] init];
    concessionRightLineV.backgroundColor = [UIColor colorWithHexString:@"#E45100"];
    [containView addSubview:concessionRightLineV];
    [concessionRightLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(concessionL.mas_centerY);
        make.height.offset(3);
        make.left.equalTo(concessionL.mas_right).offset(10);
        make.width.offset(20);
    }];
    
    UILabel *concessiondetailLab = [[UILabel alloc] init];
    concessiondetailLab.text = @"比友爆料天猫商城用券后的优惠商品，能快速的领取优惠劵，不错过每一个白菜。 网友评价：“自从上了没得比，我每个月可以节约7成的生活成本！”";
    concessiondetailLab.textColor = [UIColor colorWithHexString:@"#666666"];
    concessiondetailLab.attributedText = [self getAttributedStringWithString:concessiondetailLab.text lineSpace:10];
    concessiondetailLab.font = [UIFont systemFontOfSize:15];
    [containView addSubview:concessiondetailLab];
    [concessiondetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(concessionL.mas_bottom).offset(20 *kScale);
        make.left.equalTo(containView).offset(16);
        make.right.equalTo(containView).offset(-16);
    }];
    concessiondetailLab.numberOfLines = 0;
    concessiondetailLab.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize concessionSize = [concessiondetailLab sizeThatFits:CGSizeMake(concessiondetailLab.frame.size.width,MAXFLOAT)];
    concessiondetailLab.frame = CGRectMake(concessiondetailLab.frame.origin.x, concessiondetailLab.frame.origin.y, concessiondetailLab.frame.size.width, concessionSize.height);
    
    UIImageView * concessionPicV = [[UIImageView alloc] init];
    [containView addSubview:concessionPicV];
    [concessionPicV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containView.mas_centerX);
        make.top.equalTo(concessiondetailLab.mas_bottom).offset(34 *kScale);
        make.size.mas_equalTo(CGSizeMake(297 *kScale, 132 *kScale));
    }];
    concessionPicV.image = [UIImage imageNamed:@"concessionPicture"];


    UILabel *shareL = [[UILabel alloc] init];
    shareL.text = @"原创精选原创";
    shareL.textAlignment = NSTextAlignmentCenter;
    shareL.font = [UIFont systemFontOfSize:15];
    shareL.textColor = [UIColor colorWithHexString:@"#E45100"];
    [containView addSubview:shareL];
    [shareL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containView);
        make.top.equalTo(concessionPicV.mas_bottom).offset(65 *kScale);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    UIView *shareLeftLineV = [[UIView alloc] init];
    shareLeftLineV.backgroundColor = [UIColor colorWithHexString:@"#E45100"];
    [containView addSubview:shareLeftLineV];
    [shareLeftLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shareL.mas_centerY);
        make.height.offset(3);
        make.right.equalTo(shareL.mas_left).offset(-10);
        make.width.offset(20);
    }];
    
    UIView *shareRightLineV = [[UIView alloc] init];
    shareRightLineV.backgroundColor = [UIColor colorWithHexString:@"#E45100"];
    [containView addSubview:shareRightLineV];
    [shareRightLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shareL.mas_centerY);
        make.height.offset(3);
        make.left.equalTo(shareL.mas_right).offset(10);
        make.width.offset(20);
    }];
    
    UILabel *sharedetailLab = [[UILabel alloc] init];
    sharedetailLab.text = @"没得比丰富的原创精选原创，为用户提供更多的参考价值，商品好快一看便知。";
    sharedetailLab.textColor = [UIColor colorWithHexString:@"#666666"];
    sharedetailLab.attributedText = [self getAttributedStringWithString:sharedetailLab.text lineSpace:10];
    sharedetailLab.font = [UIFont systemFontOfSize:15];
    [containView addSubview:sharedetailLab];
    [sharedetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(shareL.mas_bottom).offset(20 *kScale);
        make.left.equalTo(containView).offset(16);
        make.right.equalTo(containView).offset(-16);
    }];
    sharedetailLab.numberOfLines = 0;
    sharedetailLab.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize shareSize = [sharedetailLab sizeThatFits:CGSizeMake(sharedetailLab.frame.size.width,MAXFLOAT)];
    concessiondetailLab.frame = CGRectMake(sharedetailLab.frame.origin.x, sharedetailLab.frame.origin.y, sharedetailLab.frame.size.width, shareSize.height);
    
    UIImageView * shareLeftPicV = [[UIImageView alloc] init];
    [containView addSubview:shareLeftPicV];
    [shareLeftPicV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containView).offset(16);
        make.top.equalTo(sharedetailLab.mas_bottom).offset(34 *kScale);
        make.size.mas_equalTo(CGSizeMake((kMainScreenW - 16 * 2 - 12 ) * 0.5, 112 *kScale));
    }];
    shareLeftPicV.image = [UIImage imageNamed:@"sharePicture1"];
    
    UIImageView * shareRightPicV = [[UIImageView alloc] init];
    [containView addSubview:shareRightPicV];
    [shareRightPicV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containView).offset(-16);
        make.top.equalTo(sharedetailLab.mas_bottom).offset(34 *kScale);
        make.size.mas_equalTo(CGSizeMake((kMainScreenW - 16 * 2 - 12 ) * 0.5, 112 *kScale));
    }];
    shareRightPicV.image = [UIImage imageNamed:@"sharePicture2"];
    
    UIView *QRcodeView = [[UIView alloc] init];
    QRcodeView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [containView addSubview:QRcodeView];
    [QRcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(containView);
        make.top.equalTo(shareRightPicV.mas_bottom).offset(29 *kScale);
        make.height.offset(250 *kScale);
    }];
    
    UIImageView *QRcodeImageV = [[UIImageView alloc] init];
    [QRcodeView addSubview:QRcodeImageV];
    [QRcodeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(QRcodeView);
        make.size.mas_equalTo(CGSizeMake(167 *kScale, 159*kScale));
    }];
    QRcodeImageV.image = [UIImage imageNamed:@"QRcodeImage"];
    
    NSString *appVersion =[[MDB_UserDefault defaultInstance] applicationVersion];
    
    UILabel *versionL = [[UILabel alloc] init];
    versionL.text=[NSString stringWithFormat:@"版本号   %@",appVersion];
    [containView addSubview:versionL];
    versionL.textAlignment = NSTextAlignmentCenter;
    versionL.font = [UIFont systemFontOfSize:11];
    versionL.textColor = [UIColor colorWithHexString:@"#999999"];
    [versionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containView);
        make.left.equalTo(containView).offset(20);
        make.top.equalTo(QRcodeView.mas_bottom).offset(20);
    }];
    
    UILabel *lastL = [[UILabel alloc] init];
    [containView addSubview:lastL];
    lastL.text = @"重庆狸狗科技版权所有，并保留所有权利";
    lastL.textAlignment = NSTextAlignmentCenter;
    lastL.font = [UIFont systemFontOfSize:11];
    lastL.textColor = [UIColor colorWithHexString:@"#999999"];
    [lastL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containView);
        make.left.equalTo(containView).offset(20);
        make.top.equalTo(versionL.mas_bottom).offset(10);

    }];
    
    [scrollV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastL.mas_bottom).offset(30 *kScale);
    }];
    
    
    
}

//string转换成AttributedString
-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}

@end
