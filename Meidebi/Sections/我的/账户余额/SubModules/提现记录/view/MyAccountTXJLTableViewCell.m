//
//  MyAccountTXJLTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/11.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountTXJLTableViewCell.h"


@interface MyAccountTXJLTableViewCell ()

@end

@implementation MyAccountTXJLTableViewCell

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
        
        UILabel *lbtx = [[UILabel alloc] init];
        [lbtx setTextColor:RGB(150, 150, 150)];
        [lbtx setTextAlignment:NSTextAlignmentLeft];
        [lbtx setText:@"提现"];
        [lbtx setFont:[UIFont systemFontOfSize:14]];
        [viewback addSubview:lbtx];
        [lbtx mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.top.offset(10);
            make.width.offset(100);
            make.height.offset(20);
        }];
        
        UILabel *lbtime = [[UILabel alloc] init];
        [lbtime setTextColor:RGB(150, 150, 150)];
        [lbtime setTextAlignment:NSTextAlignmentLeft];
        [lbtime setText:@"06.12  15:00"];
        [lbtime setFont:[UIFont systemFontOfSize:14]];
        [viewback addSubview:lbtime];
        [lbtime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbtx);
            make.top.equalTo(lbtx.mas_bottom);
            make.width.offset(100);
            make.height.offset(20);
        }];
        
        
        UILabel *lbstate = [[UILabel alloc] init];
        [lbstate setTextColor:RGB(130, 130, 130)];
        [lbstate setTextAlignment:NSTextAlignmentCenter];
        [lbstate setText:@"审核中"];
        [lbstate setFont:[UIFont systemFontOfSize:14]];
        [viewback addSubview:lbstate];
        [lbstate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(viewback);
            make.top.equalTo(lbtx);
            make.width.offset(100);
            make.height.offset(20);
        }];
        
        
        UILabel *lbmoney = [[UILabel alloc] init];
        [lbmoney setTextColor:RadMenuColor];
        [lbmoney setTextAlignment:NSTextAlignmentRight];
        [lbmoney setText:@"-60"];
        [lbmoney setFont:[UIFont boldSystemFontOfSize:14]];
        [viewback addSubview:lbmoney];
        [lbmoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(viewback).offset(-20);
            make.top.equalTo(lbtx);
            make.width.offset(100);
            make.height.offset(20);
        }];
        
        
        
        UIView *viewline = [[UIView alloc] init];
        [viewline setBackgroundColor:RGB(234, 234, 234)];
        [viewback addSubview:viewline];
        [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbtx);
            make.right.equalTo(lbmoney);
            make.bottom.equalTo(viewback);
            make.height.offset(1);
        }];
        
        
    }
    return self;
}

@end
