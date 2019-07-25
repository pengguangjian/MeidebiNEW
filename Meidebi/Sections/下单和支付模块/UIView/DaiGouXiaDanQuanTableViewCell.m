//
//  DaiGouXiaDanQuanTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/25.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouXiaDanQuanTableViewCell.h"
#import "MDB_UserDefault.h"
@interface DaiGouXiaDanQuanTableViewCell ()
{
    UIButton *btselect;
    UILabel *lbprice;
    UILabel *lbtitle;
    UILabel *lbtime;
    
    UILabel *lbhght;
    
    UIView *viewmeng;
    
}
@end

@implementation DaiGouXiaDanQuanTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setBackgroundColor:RGB(249, 249, 249)];
        self.transform = CGAffineTransformMakeRotation(M_PI/2);
        
        btselect = [[UIButton alloc] init];
        [btselect setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
        [self addSubview:btselect];
        [btselect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.width.height.offset(15);
            make.centerY.equalTo(self).offset(10);
        }];
        
        UIView *viewback = [[UIView alloc] init];
        [viewback setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:viewback];
        [viewback mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(btselect.mas_right).offset(10);
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
        [lbprice setFont:[UIFont boldSystemFontOfSize:18]];
        [lbprice setTextColor:RGB(240, 69, 39)];
        [lbprice setTextAlignment:NSTextAlignmentLeft];
        [lbprice setText:@"0"];
        
        UILabel *lbprice1 = [[UILabel alloc] init];
        [viewprice addSubview:lbprice1];
        [lbprice1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(lbprice.mas_right).offset(2);
            make.bottom.mas_equalTo(lbprice.mas_bottom);
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
            make.width.mas_equalTo(viewback.mas_width).multipliedBy(0.55);
            make.height.mas_equalTo(viewback.mas_height).multipliedBy(0.5).offset(-10);
        }];
        [lbtitle setText:@""];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setNumberOfLines:2];
        [lbtitle setTextColor:RGB(30, 30, 30)];
        [lbtitle setFont:[UIFont systemFontOfSize:12]];
        
        
        lbtime = [[UILabel alloc] init];
        [viewback addSubview:lbtime];
        [lbtime mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(lbtitle.mas_left);
            make.top.mas_equalTo(lbtitle.mas_bottom);
            make.width.mas_equalTo(lbtitle.mas_width);
            make.height.offset(20);
        }];
        [lbtime setText:@" "];
        [lbtime setTextAlignment:NSTextAlignmentLeft];
        [lbtime setTextColor:RGB(153, 153, 153)];
        [lbtime setFont:[UIFont systemFontOfSize:10]];
        
        
        lbhght = [[UILabel alloc] init];
        [viewback addSubview:lbhght];
        [lbhght mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(viewback.mas_top).offset(3);
            make.right.mas_equalTo(viewback.mas_right).offset(-3);
            make.width.offset(30);
            make.height.offset(15);
        }];
        [lbhght setText:@"最高"];
        [lbhght setTextAlignment:NSTextAlignmentCenter];
        [lbhght setTextColor:RGB(255, 255, 255)];
        [lbhght setFont:[UIFont systemFontOfSize:10]];
        [lbhght setBackgroundColor:RGB(241, 85, 60)];
        [lbhght.layer setMasksToBounds:YES];
        [lbhght.layer setCornerRadius:2];
        
        viewmeng = [[UIView alloc] init];
        [viewmeng setBackgroundColor:RGBAlpha(245, 245, 245, 0.4)];
        [viewback addSubview:viewmeng];
        [viewmeng setHidden:YES];
        [viewmeng mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(viewback);
        }];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [lbprice setText:_model.denomination];
    float fw= [MDB_UserDefault countTextSize:CGSizeMake(100, 30) andtextfont:lbprice.font andtext:lbprice.text].width;
    [lbprice mas_updateConstraints:^(MASConstraintMaker *make) {
        if(fw>=(self.width-40)*0.5)
        {
            make.width.offset((self.width-40)*0.5);
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
        [lbtitle setText:[NSString stringWithFormat:@"%@满%@元可用", _model.name,_model.usecondition]];
    }
    
    [lbtime setText:[NSString stringWithFormat:@"%@-%@",[MDB_UserDefault strTimefromData:_model.use_starttime.integerValue dataFormat:@"yyyy.MM.dd"],[MDB_UserDefault strTimefromData:_model.use_endtime.integerValue dataFormat:@"yyyy.MM.dd"]]];
    [lbhght setHidden:YES];
    if(_ishigh)
    {
        [lbhght setHidden:NO];
    }
    
    if(_model.isselect)
    {
        [btselect setImage:[UIImage imageNamed:@"yuan_select_yes"] forState:UIControlStateNormal];
    }
    else
    {
        [btselect setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
    }
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    if(_model.usecondition.floatValue<=_strgoodsprice.floatValue && _model.denomination.floatValue<= _strgoodsprice.floatValue && a<_model.use_endtime.floatValue)
        
    {
        [viewmeng setHidden:YES];
    }
    else
    {
        [viewmeng setHidden:NO];
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
