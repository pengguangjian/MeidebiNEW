//
//  DaShangJiLuTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/8.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "DaShangJiLuTableViewCell.h"
#import "MDB_UserDefault.h"

@interface DaShangJiLuTableViewCell ()

@end

@implementation DaShangJiLuTableViewCell

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
        [self drawUI];
    }
    return self;
}

-(void)drawUI
{
    UIView *viewback = [[UIView alloc] init];
    [viewback setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:viewback];
    [viewback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIImageView *imgv = [[UIImageView alloc] init];
    [imgv setBackgroundColor:[UIColor grayColor]];
    [viewback addSubview:imgv];
    [imgv.layer setMasksToBounds:YES];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(15);
        make.bottom.equalTo(viewback).offset(-15);
        make.width.equalTo(viewback.mas_height).offset(-30);
    }];
    [imgv.layer setCornerRadius:(120-30)/2.0];
    
    UILabel *lbname = [[UILabel alloc] init];
    [lbname setText:@"用户名"];
    [lbname setTextColor:RGB(50, 50, 50)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:14]];
    [viewback addSubview:lbname];
    [lbname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgv.mas_right).offset(10);
        make.bottom.equalTo(imgv.mas_centerY);
        make.width.offset(kMainScreenW*0.5);
        make.height.offset(30);
    }];
    
    UILabel *lbtime = [[UILabel alloc] init];
    [lbtime setText:@"2019-08-08"];
    [lbtime setTextColor:RGB(150, 150, 150)];
    [lbtime setTextAlignment:NSTextAlignmentLeft];
    [lbtime setFont:[UIFont systemFontOfSize:14]];
    [viewback addSubview:lbtime];
    [lbtime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lbname);
        make.top.equalTo(lbname.mas_bottom);
        make.height.offset(30);
    }];
    
    UILabel *lbdashang = [[UILabel alloc] init];
    [lbdashang setText:@"打赏 5 元"];
    [lbdashang setTextColor:RGB(50, 50, 50)];
    [lbdashang setTextAlignment:NSTextAlignmentRight];
    [lbdashang setFont:[UIFont systemFontOfSize:14]];
    [viewback addSubview:lbdashang];
    [lbdashang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewback).offset(-20);
        make.top.equalTo(lbname);
        make.height.offset(20);
    }];
    [lbdashang setAttributedText:[MDB_UserDefault arrstring:lbdashang.text andstart:2 andend:(int)lbdashang.text.length-3 andfont:[UIFont systemFontOfSize:14] andcolor:RGB(255, 17, 18)]];
    
    
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(234, 234, 234)];
    [viewback addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(viewback);
        make.height.offset(1);
    }];
    
}

@end
