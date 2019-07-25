//
//  MyAccountOrderListTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/10.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountOrderListTableViewCell.h"


@interface MyAccountOrderListTableViewCell ()

@end

@implementation MyAccountOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        UIView *viewback = [[UIView alloc] init];
        [viewback setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:viewback];
        [viewback mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIImageView *imgvhd = [[UIImageView alloc] init];
        [imgvhd setBackgroundColor:[UIColor grayColor]];
        [viewback addSubview:imgvhd];
        [imgvhd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(5);
            make.bottom.equalTo(viewback).offset(-5);
            make.width.equalTo(viewback.mas_height).offset(-10);
        }];
        
        ///状态
        UILabel *lbstate0 = [[UILabel alloc] init];
        [lbstate0 setTextColor:RadMenuColor];
        [lbstate0 setTextAlignment:NSTextAlignmentCenter];
        [lbstate0 setFont:[UIFont systemFontOfSize:12]];
        [lbstate0.layer setBorderColor:RadMenuColor.CGColor];
        [lbstate0.layer setBorderWidth:1];
        [lbstate0.layer setCornerRadius:3];
        [viewback addSubview:lbstate0];
        [lbstate0 setText:@"待生效"];///已取消的话隐藏
        [lbstate0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgvhd);
            make.top.equalTo(imgvhd);
            make.height.offset(20);
            make.width.offset(45);
        }];
        
        
        UILabel *lbtitle = [[UILabel alloc] init];
        [lbtitle setTextColor:RGB(30, 30, 30)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setNumberOfLines:2];
        [lbtitle setFont:[UIFont systemFontOfSize:15]];
        [viewback addSubview:lbtitle];
        [lbtitle setText:@"标题标题标题标题标题标题标题标题标题标题"];
        [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgvhd.mas_right).offset(15);
            make.right.equalTo(viewback).offset(-15);
            make.top.equalTo(imgvhd);
            make.height.offset(40);
        }];
        
        UILabel *lbstate = [[UILabel alloc] init];
        [lbstate setTextColor:RGB(255, 255, 255)];
        [lbstate setTextAlignment:NSTextAlignmentCenter];
        [lbstate setFont:[UIFont systemFontOfSize:13]];
        [lbstate setBackgroundColor:RGB(74, 202, 149)];
        [viewback addSubview:lbstate];
        [lbstate setText:@"待发货"];
        [lbstate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbtitle);
            make.top.equalTo(lbtitle.mas_bottom).offset(10);
            make.width.offset(70);
            make.height.offset(20);
        }];
        [lbstate.layer setMasksToBounds:YES];
        [lbstate.layer setCornerRadius:2];
        
    }
    return self;
}

@end
