//
//  MyJiangLiMingXiTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyJiangLiMingXiTableViewCell.h"

@interface MyJiangLiMingXiTableViewCell ()
{
    UIView *viewback;
    
    UILabel *lbtime;
    
    UILabel *lbmoney;
    
    UIView *viewline;
    
}
@end

@implementation MyJiangLiMingXiTableViewCell

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
        viewback = [[UIView alloc] init];
        [viewback setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:viewback];
        
        lbtime = [[UILabel alloc] init];
        [lbtime setText:@""];
        [lbtime setTextColor:RGB(50, 50, 50)];
        [lbtime setTextAlignment:NSTextAlignmentLeft];
        [lbtime setFont:[UIFont systemFontOfSize:14]];
        [viewback addSubview:lbtime];
        
        lbmoney = [[UILabel alloc] init];
        [lbmoney setText:@""];
        [lbmoney setTextColor:RGB(50, 50, 50)];
        [lbmoney setTextAlignment:NSTextAlignmentRight];
        [lbmoney setFont:[UIFont systemFontOfSize:14]];
        [viewback addSubview:lbmoney];
        
        
        
        viewline = [[UIView alloc] init];
        [viewline setBackgroundColor:RGB(236, 236, 236)];
        [viewback addSubview:viewline];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [viewback setFrame:CGRectMake(0, 0, self.width, self.height)];
    
    
    [lbtime setFrame:CGRectMake(10, 0, 150, viewback.height)];
    
    
    [lbmoney setFrame:CGRectMake(lbtime.right, 0, viewback.width-lbtime.right-10, viewback.height)];
    
    [viewline setFrame:CGRectMake(10, viewback.height-1, viewback.width-20, 1)];
    
}

-(void)bindValue:(NSDictionary *)value
{
    [lbtime setText:[NSString nullToString:[NSString stringWithFormat:@"%@",[value objectForKey:@"createtime"]]]];
    
    [lbmoney setText:[NSString nullToString:[NSString stringWithFormat:@"%@",[value objectForKey:@"money"]]]];
    
}
@end
