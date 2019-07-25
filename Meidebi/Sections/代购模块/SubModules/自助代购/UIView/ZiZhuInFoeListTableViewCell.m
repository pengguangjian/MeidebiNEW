//
//  ZiZhuInFoeListTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/5/22.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "ZiZhuInFoeListTableViewCell.h"


@interface ZiZhuInFoeListTableViewCell ()
{
    
    UIImageView *imgvhead;
    
    UILabel *lbtitle;
    UILabel *lbprice;
    UILabel *lbshop;
    
}

@end

@implementation ZiZhuInFoeListTableViewCell

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
        
        imgvhead = [[UIImageView alloc] init];
        [imgvhead setBackgroundColor:[UIColor grayColor]];
        [imgvhead setContentMode:UIViewContentModeScaleAspectFit];
        [viewback addSubview:imgvhead];
        [imgvhead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(15);
            make.bottom.equalTo(viewback.mas_bottom).offset(-15);
            make.width.equalTo(viewback.mas_height).offset(-30);
        }];
        
        lbtitle = [[UILabel alloc] init];
        [lbtitle setTextColor:RGB(50, 50, 50)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setNumberOfLines:2];
        [lbtitle setFont:[UIFont systemFontOfSize:16]];
        [viewback addSubview:lbtitle];
        [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgvhead.mas_right).offset(10);
            make.top.offset(12);
            make.right.equalTo(viewback.mas_right).offset(-15);
            make.height.offset(40);
        }];
        
        lbprice = [[UILabel alloc] init];
        [lbprice setTextColor:RadMenuColor];
        [lbprice setTextAlignment:NSTextAlignmentLeft];
        [lbprice setFont:[UIFont systemFontOfSize:16]];
        [viewback addSubview:lbprice];
        [lbprice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(lbtitle);
            make.top.equalTo(lbtitle.mas_bottom);
            make.height.offset(30);
        }];
        
        lbshop = [[UILabel alloc] init];
        [lbshop setTextColor:RGB(180, 180, 180)];
        [lbshop setTextAlignment:NSTextAlignmentLeft];
        [lbshop setFont:[UIFont systemFontOfSize:16]];
        [viewback addSubview:lbshop];
        [lbshop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(lbprice);
            make.top.equalTo(lbprice.mas_bottom);
            make.height.offset(30);
        }];
        
        
        UIButton *btbuy = [[UIButton alloc] init];
        [btbuy setBackgroundColor:RadMenuColor];
        [btbuy setTitle:@"帮我买" forState:UIControlStateNormal];
        [btbuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btbuy.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btbuy.layer setMasksToBounds:YES];
        [btbuy.layer setCornerRadius:3];
        [btbuy addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        [viewback addSubview:btbuy];
        [btbuy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lbtitle);
            make.width.offset(100);
            make.height.offset(40);
            make.top.equalTo(lbprice).offset(15);
        }];
        
        UIView *viewline = [[UIView alloc] init];
        [viewline setBackgroundColor:RGB(236,236,236)];
        [viewback addSubview:viewline];
        [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(viewback);
            make.height.offset(1);
        }];
        
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [lbtitle setText:@"手动阀可视对讲符号达康书记发哈萨克的就"];
    [lbprice setText:@"￥564.67"];
    [lbshop setText:@"美国亚马逊"];
    
}

-(void)buyAction
{
    if(self.delegate)
    {
        [self.delegate buyItemAction:nil];
    }
}

@end
