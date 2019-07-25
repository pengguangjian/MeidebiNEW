//
//  MyInformTableViewCell.m
//  Meidebi
//
//  Created by 杜非 on 15/2/11.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MyInformTableViewCell.h"
#import "MDB_UserDefault.h"
#import <UIImageView+WebCache.h>

@interface MyInformTableViewCell ()


@end

@implementation MyInformTableViewCell

//- (void)awakeFromNib {
//    // Initialization code
//    [super awakeFromNib];
//    _contentLabel = [[UILabel alloc] init];
//    [self.contentView addSubview:_contentLabel];
//    _contentLabel.font = [UIFont systemFontOfSize:14.f];
//    _contentLabel.textColor = [UIColor grayColor];
//    _contentLabel.numberOfLines = 0;
//    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    
//    
//}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpSubView];
    }
    return self;
}

- (void)setUpSubView{
    
    UIImageView *imageVedit = [[UIImageView alloc] init];
    [self addSubview:imageVedit];
    [imageVedit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.size.sizeOffset(CGSizeMake(15, 15));
    }];
    [imageVedit setHidden:YES];
    [imageVedit setImage:[UIImage imageNamed:@"brok_type_normal"]];
    _imageedit = imageVedit;
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.offset(18*kScale);
        make.size.mas_equalTo(CGSizeMake(56 *kScale, 56 * kScale));
    }];
    imageV.layer.cornerRadius = 28 * kScale;
    imageV.clipsToBounds = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchToWithGesture:)];
    [imageV addGestureRecognizer:tapGesture];
    _imageV = imageV;
    
    UILabel *nameL = [[UILabel alloc] init];
    nameL.text = @"";
    nameL.font = [UIFont systemFontOfSize:13];
    [self addSubview:nameL];
     [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(imageV.mas_right).offset(10 *kScale);
         make.top.equalTo(self).offset(20 *kScale);
         make.width.offset(100 *kScale);
     }];
    
    nameL.textColor = [UIColor colorWithHexString:@"#a2a2a2"];
    nameL.textAlignment = NSTextAlignmentLeft;
    _nameL = nameL;
    
    UILabel *textL = [[UILabel alloc] init];
    textL.font = [UIFont systemFontOfSize:14];
    [self addSubview:textL];
    [textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameL.mas_left);
        make.top.equalTo(nameL.mas_bottom).offset(20 *kScale);
        make.right.equalTo(self).offset(-18 *kScale);
    }];
    [textL setNumberOfLines:2];
    textL.textColor = [UIColor colorWithHexString:@"#666666"];
    textL.textAlignment = NSTextAlignmentLeft;
    _textL = textL;

    UILabel *timeL = [[UILabel alloc] init];
    timeL.font = [UIFont systemFontOfSize:14];
    [self addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-18 *kScale);
        make.centerY.equalTo(nameL.mas_centerY);
        make.left.equalTo(nameL.mas_right).offset(20 *kScale);
    }];
    
    timeL.textColor = [UIColor colorWithHexString:@"#a2a2a2"];
    timeL.textAlignment = NSTextAlignmentRight;
    _timeL = timeL;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)touchToWithGesture:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(touchWithId:)]) {
        [self.delegate touchWithId:_imageV.tag];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if ([_model.relatenickname isEqualToString:@"admin"]) {
        _nameL.textColor = [UIColor orangeColor];
        _nameL.text = @"没得比";
        _imageV.image = [UIImage imageNamed:@"mdb_photo"];
        
    }else{
        _nameL.textColor = [UIColor colorWithHexString:@"#a2a2a2"];
        _nameL.text = [NSString nullToString:_model.relatenickname];
        if (_model.relatephoto) {
            [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString nullToString :_model.relatephoto]]];
        }
        
    }
    
    BOOL isread=[[NSString stringWithFormat:@"%@",_model.isread] boolValue];
    if (isread) {
        _textL.textColor = [UIColor colorWithHexString:@"#666666"];
    }else{
        _textL.textColor= [UIColor blackColor];
    }
    
    if (_model.con) {
        _textL.text = [NSString nullToString:_model.con];
    }
    
    if (_model.createtime) {
        _timeL.text = [MDB_UserDefault strTimefromData:[[NSString nullToString:_model.createtime] integerValue] dataFormat:nil];
    }
    
    if(_isedit)
    {
        
        if(_model.isselect)
        {
            [_imageedit setImage:[UIImage imageNamed:@"brok_type_select"]];
        }
        else
        {
            [_imageedit setImage:[UIImage imageNamed:@"brok_type_normal"]];
        }
        [_imageedit setHidden:NO];
        [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(35);
        }];
        
    }
    else
    {
        [_imageedit setImage:[UIImage imageNamed:@"brok_type_normal"]];
        [_imageedit setHidden:YES];
        [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(18*kScale);
        }];
        
    }
}

@end
