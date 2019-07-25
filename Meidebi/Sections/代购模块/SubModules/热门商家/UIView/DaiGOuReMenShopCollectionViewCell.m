//
//  DaiGOuReMenShopCollectionViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGOuReMenShopCollectionViewCell.h"

#import "MDB_UserDefault.h"

@interface DaiGOuReMenShopCollectionViewCell()
{
    UIView *viewback;
    UIImageView *imgvicon;
    UILabel *lbname;
}
@end

@implementation DaiGOuReMenShopCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self drawSubview];
    }
    return self;
}


-(void)drawSubview
{
    viewback = [[UIView alloc] initWithFrame:CGRectZero];
    [viewback setBackgroundColor:[UIColor whiteColor]];
    
    imgvicon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imgvicon.layer setBorderColor:RGB(226,226,226).CGColor];
    [imgvicon.layer setBorderWidth:1];
    [imgvicon.layer setMasksToBounds:YES];
    [imgvicon setContentMode:UIViewContentModeScaleAspectFit];
    
    lbname = [[UILabel alloc] initWithFrame:CGRectZero];
    [lbname setTextColor:RGB(102,102,102)];
    [lbname setTextAlignment:NSTextAlignmentCenter];
    [lbname setFont:[UIFont systemFontOfSize:11]];
    
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [viewback setFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.contentView addSubview:viewback];
    
    [imgvicon setFrame:CGRectMake(0, 0, viewback.width, (viewback.width)*0.73)];
    [imgvicon.layer setCornerRadius:4];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvicon url:[_dicvalue objectForKey:@"logo1"]];
    [viewback addSubview:imgvicon];
    
    [lbname setFrame:CGRectMake(0, imgvicon.bottom, viewback.width, viewback.height-imgvicon.bottom)];
    [lbname setText:[NSString nullToString:[_dicvalue objectForKey:@"name"]]];
    [viewback addSubview:lbname];
    
}


@end
