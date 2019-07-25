//
//  GoodsCollectionViewCell.m
//  Meidebi
//
//  Created by fishmi on 2017/5/11.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "GoodsCollectionViewCell.h"
#import "MDB_UserDefault.h"
#import <YYKit/YYKit.h>
@interface GoodsCollectionViewCell ()
@property(nonatomic,strong)UIImageView *pictureV;
@property(nonatomic,strong)UIImageView *headV;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *text_label;
@property(nonatomic,strong)UIImageView *praiseV;
@property(nonatomic,strong)UILabel *numLabel;
@end

@implementation GoodsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setModel:(RecommendListViewModel *)model{
    _model = model;
    _nameLabel.text = [NSString nullToString:model.username];
    _text_label.text = [NSString nullToString:model.recommendDescription];
    _numLabel.text = [self numberChangeStringValue:[NSNumber numberWithInt:model.praisecount.intValue]];
    
    [_numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if(_numLabel.text.length>3)
        {
            make.width.offset(30);
        }
        else
        {
           make.width.offset(10*_numLabel.text.length);
        }
        
    }];
    [_praiseV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_numLabel.mas_left).offset(-1);
    }];
    
    [[MDB_UserDefault defaultInstance] setViewWithImage:_headV url:[NSString nullToString:model.avatar]];
//    [[MDB_UserDefault defaultInstance] setViewWithImage:_pictureV url:[NSString nullToString:model.image]];

    UIImageView *imageView = _pictureV;
    [imageView.layer removeAnimationForKey:@"contents"];
    @weakify(imageView);
    [imageView.layer setImageWithURL:[NSURL URLWithString:[NSString nullToString:model.image]]
                         placeholder:[UIImage imageNamed:@"punot.png"]
                             options:YYWebImageOptionAvoidSetImage
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                                int width = image.size.width;
                                if (width > kMainScreenW/2) {
                                    image = [image imageByResizeToSize:CGSizeMake(kMainScreenW/2, 100) contentMode:UIViewContentModeScaleAspectFill];
                                }
                                return image;
                            } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                @strongify(imageView);
                                if (image && stage == YYWebImageStageFinished) {
                                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                                    imageView.image = image;
                                    if (from != YYWebImageFromMemoryCacheFast) {
                                        CATransition *transition = [CATransition animation];
                                        transition.duration = 0.15;
                                        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                        transition.type = kCATransitionFade;
                                        [imageView.layer addAnimation:transition forKey:@"contents"];
                                    }
                                }
                            }];

}

- (void)setSubView{
    UIImageView *pictureV = [[UIImageView alloc] init];
    pictureV.contentMode = UIViewContentModeScaleAspectFill;
    pictureV.layer.cornerRadius = 4;
    pictureV.clipsToBounds = YES;
    [self addSubview:pictureV];
    [pictureV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.height.equalTo(pictureV.mas_width).multipliedBy(0.5);
    }];
    self.pictureV = pictureV;
    
    UIImageView *headV = [[UIImageView alloc] init];
    headV.layer.cornerRadius = 10;
    headV.clipsToBounds = YES;
    [self addSubview:headV];
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(pictureV.mas_bottom).offset(11);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    _headV = headV;
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = @"";
    [self addSubview:numLabel];
    numLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    numLabel.font = [UIFont systemFontOfSize:12];
    [numLabel sizeToFit];
    [numLabel setTextAlignment:NSTextAlignmentRight];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(pictureV.mas_right);
//        make.size.mas_equalTo(CGSizeMake(20, 12));
        make.height.offset(12);
        make.width.offset(20);
        make.top.equalTo(pictureV.mas_bottom).offset(17);
    }];
    _numLabel = numLabel;
    
    UIImageView *praiseV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"praise"]];
    [self addSubview:praiseV];
    [praiseV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(numLabel.mas_left).offset(-4);
        make.size.mas_equalTo(CGSizeMake(13, 14));
        make.top.equalTo(pictureV.mas_bottom).offset(14);
    }];
    _praiseV = praiseV;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"";
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    nameLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headV.mas_right).offset(5);
        make.centerY.equalTo(headV.mas_centerY);
        make.right.equalTo(praiseV.mas_left).offset(-5);
    }];
    _nameLabel = nameLabel;
    
    UILabel *text_label = [[UILabel alloc] init];
    text_label.text = @"";
    text_label.numberOfLines = 2;
    text_label.textAlignment = NSTextAlignmentLeft;
    text_label.font = [UIFont systemFontOfSize:12];
    text_label.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:text_label];
    [text_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(nameLabel.mas_bottom).offset(14);
        make.centerX.equalTo(self);
    }];
    _text_label = text_label;
    
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
