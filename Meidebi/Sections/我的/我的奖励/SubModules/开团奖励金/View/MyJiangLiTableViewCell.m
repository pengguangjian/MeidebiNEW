//
//  MyJiangLiTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyJiangLiTableViewCell.h"

@interface MyJiangLiTableViewCell ()
{
    UIView *viewback;
    UIView *viewtitle;
    UILabel *lbtitle;
    
    UILabel *lbktds;
    UILabel*lbktdsValue;
    
    UILabel *lbctds;
    UILabel *lbctdsValue;
    
    UILabel *lbjlg;
    UILabel *lbjlgValue;
    
}
@end

@implementation MyJiangLiTableViewCell

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
        
        viewtitle = [[UIView alloc] init];
        [viewtitle setBackgroundColor:RGB(246, 245, 246)];
        [viewback addSubview:viewtitle];
        
        lbtitle = [[UILabel alloc] init];
        [lbtitle setText:@""];
        [lbtitle setTextColor:RGB(50, 50, 50)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setFont:[UIFont systemFontOfSize:15]];
        [viewtitle addSubview:lbtitle];
        
        lbktds = [[UILabel alloc] init];
        [lbktds setText:@"开团单数"];
        [lbktds setTextColor:RGB(50, 50, 50)];
        [lbktds setTextAlignment:NSTextAlignmentCenter];
        [lbktds setFont:[UIFont systemFontOfSize:15]];
        [viewback addSubview:lbktds];
        
        
        lbktdsValue = [[UILabel alloc] init];
        [lbktdsValue setText:@"0"];
        [lbktdsValue setTextColor:RGB(255, 38, 39)];
        [lbktdsValue setTextAlignment:NSTextAlignmentCenter];
        [lbktdsValue setFont:[UIFont systemFontOfSize:15]];
        [viewback addSubview:lbktdsValue];
        
        lbctds = [[UILabel alloc] init];
        [lbctds setText:@"成团单数"];
        [lbctds setTextColor:RGB(50, 50, 50)];
        [lbctds setTextAlignment:NSTextAlignmentCenter];
        [lbctds setFont:[UIFont systemFontOfSize:15]];
        [viewback addSubview:lbctds];
        
        
        lbctdsValue = [[UILabel alloc] init];
        [lbctdsValue setText:@"0"];
        [lbctdsValue setTextColor:RGB(255, 38, 39)];
        [lbctdsValue setTextAlignment:NSTextAlignmentCenter];
        [lbctdsValue setFont:[UIFont systemFontOfSize:15]];
        [viewback addSubview:lbctdsValue];
        
        lbjlg = [[UILabel alloc] init];
        [lbjlg setText:@"奖励金额"];
        [lbjlg setTextColor:RGB(50, 50, 50)];
        [lbjlg setTextAlignment:NSTextAlignmentCenter];
        [lbjlg setFont:[UIFont systemFontOfSize:15]];
        [viewback addSubview:lbjlg];
        
        
        lbjlgValue = [[UILabel alloc] init];
        [lbjlgValue setText:@"￥0"];
        [lbjlgValue setTextColor:RGB(255, 38, 39)];
        [lbjlgValue setTextAlignment:NSTextAlignmentCenter];
        [lbjlgValue setFont:[UIFont systemFontOfSize:15]];
        [viewback addSubview:lbjlgValue];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [viewback setFrame:CGRectMake(0, 0, self.width, self.height)];
    
    [viewtitle setFrame:CGRectMake(0, 0, viewback.width, 40)];
    
    [lbtitle setFrame:CGRectMake(10, 0, 150, viewtitle.height)];
    
    
    [lbktds setFrame:CGRectMake(10, viewtitle.bottom+15, (viewback.width-20)/3.0, 25)];
    
    [lbktdsValue setFrame:CGRectMake(lbktds.left, lbktds.bottom+5, lbktds.width, 25)];
    
    [lbctds setFrame:CGRectMake(lbktds.right, lbktds.top, lbktds.width, lbktds.height)];
    
    [lbctdsValue setFrame:CGRectMake(lbctds.left, lbctds.bottom+5, lbctds.width, 25)];
    
    
    [lbjlg setFrame:CGRectMake(lbctds.right, lbktds.top, lbktds.width, lbktds.height)];
    
    [lbjlgValue setFrame:CGRectMake(lbjlg.left, lbjlg.bottom+5, lbjlg.width, 25)];
     
    
}

-(void)bindValue:(NSDictionary *)value
{
    [lbtitle setText:[NSString nullToString:[NSString stringWithFormat:@"%@",[value objectForKey:@"monthtime"]]]];
    
    [lbktdsValue setText:[NSString nullToString:[NSString stringWithFormat:@"%@",[value objectForKey:@"month_num"]]]];
    
    
    [lbctdsValue setText:[NSString nullToString:[NSString stringWithFormat:@"%@",[value objectForKey:@"complete_num"]]]];
    
    [lbjlgValue setText:[NSString nullToString:[NSString stringWithFormat:@"￥%@",[value objectForKey:@"month_money"]]]];
    
}


@end
