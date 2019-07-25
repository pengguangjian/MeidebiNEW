//
//  RecommendDetailView.m
//  Meidebi
//
//  Created by fishmi on 2017/5/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RecommendDetailView.h"

@implementation RecommendDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    imageV.backgroundColor = [UIColor blueColor];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(imageV.mas_width).multipliedBy(0.5);
    }];
    _imageV = imageV;
    
    
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.textColor = [UIColor colorWithHexString:@"#666666"];
    detailLab.attributedText = [self getAttributedStringWithString:detailLab.text lineSpace:10];
    detailLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:detailLab];
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-17);
        make.left.equalTo(self).offset(16);
        make.top.equalTo(imageV.mas_bottom).offset(17);
    }];
    detailLab.numberOfLines = 0;
    detailLab.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [detailLab sizeThatFits:CGSizeMake(detailLab.frame.size.width,MAXFLOAT)];
    detailLab.frame = CGRectMake(detailLab.frame.origin.x, detailLab.frame.origin.y, detailLab.frame.size.width, size.height);
    
    UIView *timeV = [[UIView alloc] init];
    timeV.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    [self addSubview:timeV];
    [timeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.top.equalTo(detailLab.mas_bottom).offset(18);
        make.height.equalTo(@31);
    }];
    _detailLab = detailLab;
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.text = @"活动起止时间：201704.08-2017.05.08";
    timeLab.font = [UIFont systemFontOfSize:14];
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.textColor = [UIColor colorWithHexString:@"#444444"];
    timeLab.textAlignment = NSTextAlignmentCenter;
    [timeV addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(timeV);
    }];
    _timeLab = timeLab;

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
