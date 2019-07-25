//
//  BangDingAccountTableViewCell.m
//  Meidebi
// 绑定社交账号cell
//  Created by mdb-losaic on 2019/3/4.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "BangDingAccountTableViewCell.h"

@interface BangDingAccountTableViewCell ()
{
    UIImageView *imgvlog;
    UILabel *lbtitle;
    UILabel *lbname;
}

@end

@implementation BangDingAccountTableViewCell

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
        [self.contentView addSubview:viewback];
        [viewback mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [viewback setBackgroundColor:[UIColor whiteColor]];
        
        
        imgvlog = [[UIImageView alloc] init];
        [viewback addSubview:imgvlog];
        [imgvlog mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.top.offset(22);
            make.height.with.offset(21);
        }];
        
        lbtitle = [[UILabel alloc] init];
        [viewback addSubview:lbtitle];
        [lbtitle setTextColor:RGB(60, 60, 60)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setFont:[UIFont systemFontOfSize:14]];
        [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgvlog.mas_right).offset(10);
            make.top.bottom.equalTo(viewback);
        }];
        
        UIImageView *imgvnext = [[UIImageView alloc] init];
        [viewback addSubview:imgvnext];
        [imgvnext mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(20);
            make.right.equalTo(viewback.mas_right).offset(-15);
            make.centerY.equalTo(viewback.mas_centerY);
        }];
        [imgvnext setImage:[UIImage imageNamed:@"wodejiangli_next"]];
        
        
        lbname = [[UILabel alloc] init];
        [viewback addSubview:lbname];
        [lbname setTextColor:RGB(120, 120, 120)];
        [lbname setTextAlignment:NSTextAlignmentRight];
        [lbname setFont:[UIFont systemFontOfSize:14]];
        [lbname mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(150);
            make.right.equalTo(imgvnext.mas_left).offset(-7);
            make.top.bottom.equalTo(viewback);
            
        }];
        
        UIView *viewline = [[UIView alloc] init];
        [viewline setBackgroundColor:RGB(235, 235, 235)];
        [viewback addSubview:viewline];
        [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(1);
            make.left.right.bottom.equalTo(viewback);
        }];
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [imgvlog setImage:[UIImage imageNamed:_model.strimage]];
    
    [lbtitle setText:_model.strtitle];
    
    [lbname setText:_model.strname];
    
    
    
}

@end
