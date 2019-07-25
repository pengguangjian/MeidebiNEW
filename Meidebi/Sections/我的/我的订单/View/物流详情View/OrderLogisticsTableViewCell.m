//
//  OrderLogisticsTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/9.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "OrderLogisticsTableViewCell.h"

@interface OrderLogisticsTableViewCell ()
{
    UIView *viewback;
    
    UIImageView *imgvyuan;
    
    UIView *viewline;
    
    UILabel *lbname;
    
    UILabel *lbtime;
    
}

@end

@implementation OrderLogisticsTableViewCell
@synthesize model,iline,islast;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
       
        viewback = [[UIView alloc] initWithFrame:CGRectZero];
        [viewback setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:viewback];
        
        imgvyuan = [[UIImageView alloc] initWithFrame:CGRectZero];
        [viewback addSubview:imgvyuan];
        
        lbname = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbname setTextColor:RGB(102,102,102)];
        [lbname setTextAlignment:NSTextAlignmentLeft];
        [lbname setFont:[UIFont systemFontOfSize:12]];
        [lbname setNumberOfLines:0];
        [viewback addSubview:lbname];
        
        lbtime = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbtime setTextColor:RGB(153,153,153)];
        [lbtime setTextAlignment:NSTextAlignmentLeft];
        [lbtime setFont:[UIFont systemFontOfSize:12]];
        [viewback addSubview:lbtime];
        
        viewline = [[UIView alloc] initWithFrame:CGRectZero];
        [viewline setBackgroundColor:RGB(238,238,238)];
        [viewback addSubview:viewline];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [viewback setFrame:CGRectMake(0, 0, self.width, self.height)];
    
    [imgvyuan setFrame:CGRectMake(0, 0, 5, 5)];
    [imgvyuan setCenter:CGPointMake(viewline.center.x, viewback.height/2.0)];
    [imgvyuan.layer setMasksToBounds:YES];
    [imgvyuan.layer setCornerRadius:imgvyuan.height/2.0];
    [imgvyuan setBackgroundColor:[UIColor grayColor]];
    [imgvyuan setLeft:40];
    
    [lbname setFrame:CGRectMake(imgvyuan.right+25, 15, viewback.width-imgvyuan.right-35, 20)];
    [lbname setText:model.strname];
    [lbname sizeToFit];
    [lbname setTextColor:RGB(102,102,102)];
    
    [lbtime setFrame:CGRectMake(lbname.left, lbname.bottom, viewback.width-imgvyuan.right-25, 20)];
    [lbtime setText:model.strtime];
    [lbtime setTextColor:RGB(153,153,153)];
    
    
    if(iline == 0)
    {
        [imgvyuan setBackgroundColor:RGB(248,134,28)];
        [lbname setTextColor:RGB(248,134,28)];
    }
    
    
    [viewline setFrame:CGRectMake(10, viewback.height-1, viewback.width, 1)];
    
    
    [viewback bringSubviewToFront:imgvyuan];
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
