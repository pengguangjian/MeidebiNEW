//
//  AddressListTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/8.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "AddressListTableViewCell.h"

@interface AddressListTableViewCell ()<UIAlertViewDelegate>
{
    UIView *viewback;
    
    UILabel *lbname;
    
    UILabel *lbaddress;
    
    
    UIView *viewline;
    
    UIButton *btnomo;
    UIImageView *imgvnomo;
    UILabel *lbnomo;
    
    UIButton *btedit;
    UIButton *btdel;
    
}
@end

@implementation AddressListTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        viewback = [[UIView alloc] initWithFrame:CGRectZero];
        [viewback setBackgroundColor:[UIColor whiteColor]];
        
        lbname = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbname setTextColor:RGB(102,102,102)];
        [lbname setTextAlignment:NSTextAlignmentLeft];
        [lbname setFont:[UIFont systemFontOfSize:14]];
        
        
        lbaddress = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbaddress setTextColor:RGB(102,102,102)];
        [lbaddress setTextAlignment:NSTextAlignmentLeft];
        [lbaddress setFont:[UIFont systemFontOfSize:14]];
        [lbaddress setNumberOfLines:2];
        
        viewline = [[UIView alloc] initWithFrame:CGRectZero];
        [viewline setBackgroundColor:RGB(226,226,226)];
        
        btnomo = [[UIButton alloc] initWithFrame:CGRectZero];
        imgvnomo = [[UIImageView alloc] initWithFrame:CGRectZero];
        lbnomo = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbnomo setTextColor:RGB(153,153,153)];
        [lbnomo setTextAlignment:NSTextAlignmentLeft];
        [lbnomo setFont:[UIFont systemFontOfSize:12]];
        [btnomo addSubview:imgvnomo];
        [btnomo addSubview:lbnomo];
        [btnomo addTarget:self action:@selector(nomoAction) forControlEvents:UIControlEventTouchUpInside];
        
        btdel = [[UIButton alloc] initWithFrame:CGRectZero];
        [btdel.layer setBorderColor:RGB(187,187,187).CGColor];
        [btdel.layer setBorderWidth:1];
        [btdel.layer setMasksToBounds:YES];
        [btdel setTitle:@"删除" forState:UIControlStateNormal];
        [btdel setTitleColor:RGB(102,102,102) forState:UIControlStateNormal];
        [btdel.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btdel addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        btedit = [[UIButton alloc] initWithFrame:CGRectZero];
        [btedit.layer setBorderColor:RGB(187,187,187).CGColor];
        [btedit.layer setBorderWidth:1];
        [btedit.layer setMasksToBounds:YES];
        [btedit setTitle:@"编辑" forState:UIControlStateNormal];
        [btedit setTitleColor:RGB(102,102,102) forState:UIControlStateNormal];
        [btedit.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btedit addTarget:self action:@selector(ediAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setBackgroundColor:RGB(249, 249, 249)];
    
    [viewback setFrame:CGRectMake(0, 0, self.width, self.height-10)];
    [self.contentView addSubview:viewback];
    
    
    [lbname setFrame:CGRectMake(10, 15, viewback.width-20, 20)];
    [lbname setText:[NSString stringWithFormat:@"%@ %@",_model.strname,_model.strphone]];
    [viewback addSubview:lbname];
    
    
    [lbaddress setFrame:CGRectMake(lbname.left, lbname.bottom+5, lbname.width, 35)];
    [lbaddress setText:_model.straddress];
    [viewback addSubview:lbaddress];
    
    [viewline setFrame:CGRectMake(0, lbaddress.bottom+15, viewback.width, 1)];
    [viewback addSubview:viewline];
    
    
    [btnomo setFrame:CGRectMake(10, viewline.bottom, 150, 55)];
    [viewback addSubview:btnomo];
    [imgvnomo setFrame:CGRectMake(0, 0, 12, 12)];
    [imgvnomo setCenter:CGPointMake(0, btnomo.height/2.0)];
    [imgvnomo setLeft:0];
    [lbnomo setFrame:CGRectMake(imgvnomo.right+7, 0, btnomo.width-imgvnomo.right-10, btnomo.height)];
    if([_model.strisnomo intValue] == 1)
    {
        [imgvnomo setImage:[UIImage imageNamed:@"address_select_nomo_yes"]];
        [lbnomo setText:@"已被设为默认地址"];
        [lbnomo setTextColor:RGB(254,122,14)];
    }
    else
    {
        [imgvnomo setImage:[UIImage imageNamed:@"fang_select_no"]];
        [lbnomo setText:@"设为默认地址"];
        [lbnomo setTextColor:RGB(153,153,153)];
    }
    
    [btdel setFrame:CGRectMake(0, 0, 61*kScale, 29*kScale)];
    [btdel setCenter:CGPointMake(0, btnomo.center.y)];
    [btdel setRight:viewback.width-10];
    [viewback addSubview:btdel];
    [btdel.layer setCornerRadius:2];
    
    [btedit setFrame:CGRectMake(0, btdel.top, btdel.width, btdel.height)];
    [btedit setRight:btdel.left-10];
    [viewback addSubview:btedit];
    [btedit.layer setCornerRadius:2];
    
    
    
    
    
    
    
}

///设置默认
-(void)nomoAction
{
    if([_model.strisnomo intValue] == 1)return;
    
    [self.delegate nomoAddresscell:_model.strid];
}
///删除
-(void)delAction
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要删除该地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alter setTag:111];
    [alter show];
    
}
///编辑
-(void)ediAction
{
    [self.delegate editAddresscell:_model];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 111 && buttonIndex == 1)
    {
        [self.delegate deleteAddresscell:_model.strid];
    }
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
