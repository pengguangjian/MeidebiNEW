//
//  SearchEnginesTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/28.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "SearchEnginesTableViewCell.h"

@interface SearchEnginesTableViewCell()
{
    UILabel *lbvalue;
}
@end

@implementation SearchEnginesTableViewCell

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
            make.edges.equalTo(self.contentView);
        }];
        
        lbvalue = [[UILabel alloc] init];
        [lbvalue setTextColor:RGB(80, 80, 80)];
        [lbvalue setTextAlignment:NSTextAlignmentLeft];
        [lbvalue setFont:[UIFont systemFontOfSize:13]];
        [viewback addSubview:lbvalue];
        [lbvalue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(25);
            make.top.bottom.equalTo(viewback);
        }];
        
        UIView *viewline = [[UIView alloc] init];
        [viewline setBackgroundColor:RGB(245, 245, 245)];
        [viewback addSubview:viewline];
        [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(viewback.mas_bottom);
            make.left.right.equalTo(viewback);
            make.height.offset(1);
        }];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [lbvalue setText:[NSString nullToString:_strValue]];
    
}

@end
