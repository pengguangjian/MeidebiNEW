//
//  MyGoodsCouponTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/24.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyGoodsCouponTableViewCell.h"
#import "MDB_UserDefault.h"

@interface MyGoodsCouponTableViewCell ()
{
    UILabel *lbprice;
    UILabel *lbtitle;
    UILabel *lbtime;
    UIButton *btuser;
    
    UILabel *lbstate;
    
}
@end

@implementation MyGoodsCouponTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setBackgroundColor:RGB(249, 249, 249)];
        UIView *viewback = [[UIView alloc] init];
        [viewback setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:viewback];
        [viewback mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.offset(10);
            make.top.offset(10);
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.bottom.mas_equalTo(self.mas_bottom);
            
        }];
        [viewback.layer setMasksToBounds:YES];
        [viewback.layer setCornerRadius:5];
        
        
        UIView *viewprice = [[UIView alloc] init];
        [viewback addSubview:viewprice];
        [viewprice mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(15);
            make.top.offset(15);
            make.height.equalTo(viewback.mas_height).offset(-30);
            make.width.equalTo(viewback.mas_height).offset(-30);
            
        }];
        [viewprice.layer setMasksToBounds:YES];
        [viewprice.layer setCornerRadius:3];
        [viewprice setBackgroundColor:RGB(255, 236, 228)];
        
        
        lbprice = [[UILabel alloc] init];
        [viewprice addSubview:lbprice];
        [lbprice mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(viewprice.mas_centerX).multipliedBy(0.95);
            make.bottom.mas_equalTo(viewprice.mas_centerY).multipliedBy(1.05);
            make.height.offset(25);
            make.width.offset(25);
        }];
        [lbprice setFont:[UIFont boldSystemFontOfSize:20]];
        [lbprice setTextColor:RGB(240, 69, 39)];
        [lbprice setTextAlignment:NSTextAlignmentCenter];
        [lbprice setText:@"0"];
        
        
        UILabel *lbprice1 = [[UILabel alloc] init];
        [viewprice addSubview:lbprice1];
        [lbprice1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(lbprice.mas_right).offset(2);
            make.bottom.mas_equalTo(lbprice.mas_bottom);
//            make.right.mas_equalTo(viewprice.mas_right).offset(-2);
        }];
        [lbprice1 setFont:[UIFont systemFontOfSize:13]];
        [lbprice1 setTextColor:RGB(240, 69, 39)];
        [lbprice1 setTextAlignment:NSTextAlignmentLeft];
        [lbprice1 setText:@"元"];
        [lbprice mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(lbprice1.mas_left);
        }];
        
        UILabel *lbtype = [[UILabel alloc] init];
        [viewprice addSubview:lbtype];
        [lbtype mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(5);
            make.top.mas_equalTo(lbprice.mas_bottom).offset(3);
            make.right.mas_equalTo(viewprice.mas_right).offset(-5);
            make.height.offset(14);
        }];
        [lbtype setText:@"商品券"];
        [lbtype setTextAlignment:NSTextAlignmentCenter];
        [lbtype setTextColor:RGB(240, 69, 39)];
        [lbtype setFont:[UIFont systemFontOfSize:10]];
        [lbtype setBackgroundColor:[UIColor whiteColor]];
        [lbtype.layer setMasksToBounds:YES];
        [lbtype.layer setCornerRadius:7];
        
        
        lbtitle = [[UILabel alloc] init];
        [viewback addSubview:lbtitle];
        [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(viewprice.mas_right).offset(10);
            make.top.mas_equalTo(viewprice.mas_top);
            make.width.mas_equalTo(viewback.mas_width).multipliedBy(0.45);
            make.height.mas_equalTo(viewback.mas_height).multipliedBy(0.5).offset(-10);
        }];
        [lbtitle setText:@""];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setNumberOfLines:2];
        [lbtitle setTextColor:RGB(30, 30, 30)];
        [lbtitle setFont:[UIFont systemFontOfSize:13]];
        
        
        lbtime = [[UILabel alloc] init];
        [viewback addSubview:lbtime];
        [lbtime mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(lbtitle.mas_left);
            make.top.mas_equalTo(lbtitle.mas_bottom);
            make.width.mas_equalTo(lbtitle.mas_width);
            make.height.offset(20);
        }];
        [lbtime setText:@""];
        [lbtime setTextAlignment:NSTextAlignmentLeft];
        [lbtime setTextColor:RGB(153, 153, 153)];
        [lbtime setFont:[UIFont systemFontOfSize:11]];
        
        btuser = [[UIButton alloc] init];
        [viewback addSubview:btuser];
        [btuser mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(viewback.mas_right).offset(-10);
            make.width.offset(75*kScale);
            make.height.offset(31*kScale);
            make.centerY.mas_equalTo(viewback.mas_centerY);
        }];
        [btuser setBackgroundColor:RGB(240, 69, 39)];
        [btuser setTitle:@"立即使用" forState:UIControlStateNormal];
        [btuser setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btuser.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btuser.layer setMasksToBounds:YES];
        [btuser.layer setCornerRadius:3];
        [btuser setHidden:YES];
        [btuser addTarget:self action:@selector(userAction) forControlEvents:UIControlEventTouchUpInside];
        
        lbstate = [[UILabel alloc] init];
        [viewback addSubview:lbstate];
        [lbstate mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(btuser.mas_right);
            make.width.mas_equalTo(viewprice.mas_height);
            make.height.mas_equalTo(viewprice.mas_height);
            make.centerY.mas_equalTo(viewback.mas_centerY);
        }];
        [lbstate setText:@"已使用"];
        [lbstate setTextAlignment:NSTextAlignmentCenter];
        [lbstate setTextColor:[UIColor whiteColor]];
        [lbstate setFont:[UIFont systemFontOfSize:15]];
        [lbstate setBackgroundColor:RGBAlpha(127, 127, 127,0.7)];
        [lbstate.layer setMasksToBounds:YES];
        [lbstate setHidden:NO];
        
        
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [lbstate.layer setCornerRadius:(self.height-40)/2.0];
    
    [lbprice setText:_model.denomination];
//    [lbprice setText:@"9"];
    float fw= [MDB_UserDefault countTextSize:CGSizeMake(100, 30) andtextfont:lbprice.font andtext:lbprice.text].width;
    [lbprice mas_updateConstraints:^(MASConstraintMaker *make) {
        if(fw>=(self.height-40)*0.5)
        {
            make.width.offset((self.height-40)*0.5);
        }
        else
        {
            make.width.offset(fw+3);
        }
        lbprice.adjustsFontSizeToFitWidth=YES;
        lbprice.minimumScaleFactor=0.1;
    }];
    
    [lbtitle setText:_model.name];
    if(_model.usecondition.floatValue>0)
    {
        [lbtitle setText:[NSString stringWithFormat:@"%@满%@可用", _model.name,_model.usecondition]];
    }
    
    [lbtime setText:[NSString stringWithFormat:@"%@-%@",[MDB_UserDefault strTimefromData:_model.use_starttime.integerValue dataFormat:@"yyyy.MM.dd"],[MDB_UserDefault strTimefromData:_model.use_endtime.integerValue dataFormat:@"yyyy.MM.dd"]]];
    
    if(_model.state.integerValue == 1)
    {
        [btuser setHidden:NO];
        [lbstate setHidden:YES];
    }
    else if (_model.state.integerValue == 2)
    {
        [btuser setHidden:YES];
        [lbstate setHidden:NO];
        
        [lbstate setText:@"已使用"];
    }
    else if (_model.state.integerValue == 3)
    {
        [btuser setHidden:YES];
        [lbstate setHidden:NO];
        
        [lbstate setText:@"已过期"];
    }
    
    
}

-(void)userAction
{
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"2"];
    [self.viewController.navigationController popToRootViewControllerAnimated:YES];
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
