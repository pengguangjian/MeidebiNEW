//
//  DaiGouXiaDanGoodsTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/30.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouXiaDanGoodsTableViewCell.h"
#import "MDB_UserDefault.h"

@interface DaiGouXiaDanGoodsTableViewCell ()
{
    
    UIView *viewback;
    
    
    ///头图
    UIImageView *imgvhead;
    
    UILabel *lbzhiyou;
    
    ///已截单
    UILabel *lbjiedan;
    
    UILabel *lbtitle;
    UILabel *lbprice;
    
    UILabel *pindantext;
    
    ///邮费税费
    UILabel *lbotherMoney;
    
    UIView *viewline;
    
    ///数量
    UIView *viewnumber;
    UIButton *btdel;
    UIView *viewline0;
    UITextField *fieldnumber;
    UIView *viewline1;
    UIButton *btadd;
    
    UILabel *lbbuynumber;
    
    ///限购数量
    UILabel *lbxgNumber;
    
    ///规格
    UILabel *lbguige;
    
    UILabel *lbisspotgoods;
    
}
@end

@implementation DaiGouXiaDanGoodsTableViewCell

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
        [viewback mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        
        imgvhead = [[UIImageView alloc] init];
        [viewback addSubview:imgvhead];
        [imgvhead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(10);
            make.height.offset(81);
            make.width.offset(81);
        }];
        
        
        lbzhiyou = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 45, 17)];
        [lbzhiyou setText:@"直邮"];
        [lbzhiyou setTextColor:[UIColor whiteColor]];
        [lbzhiyou setTextAlignment:NSTextAlignmentCenter];
        [lbzhiyou setFont:[UIFont systemFontOfSize:13]];
        [lbzhiyou.layer setMasksToBounds:YES];
        [lbzhiyou.layer setCornerRadius:2];
        [lbzhiyou.layer setBorderColor:RGB(230,56,47).CGColor];
        [lbzhiyou.layer setBorderWidth:1];
        [lbzhiyou setBackgroundColor:RGB(230,56,47)];
        [lbzhiyou sizeToFit];
        [lbzhiyou setHeight:17];
        [lbzhiyou setWidth:lbzhiyou.width+6];
        [viewback addSubview:lbzhiyou];
        [lbzhiyou setHidden:YES];
        
        pindantext = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 45, 17)];
        [pindantext setText:@"拼单"];
        [pindantext setTextColor:RGB(230,56,47)];
        [pindantext setTextAlignment:NSTextAlignmentCenter];
        [pindantext setFont:[UIFont systemFontOfSize:13]];
        [pindantext.layer setMasksToBounds:YES];
        [pindantext.layer setCornerRadius:2];
        [pindantext.layer setBorderColor:RGB(230,56,47).CGColor];
        [pindantext.layer setBorderWidth:1];
        [pindantext sizeToFit];
        [pindantext setHeight:17];
        [pindantext setWidth:pindantext.width+6];
        [viewback addSubview:pindantext];
        [pindantext setHidden:YES];
        
        
        lbisspotgoods = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbisspotgoods setTextColor:RadMenuColor];
        [lbisspotgoods setTextAlignment:NSTextAlignmentCenter];
        [lbisspotgoods setFont:[UIFont systemFontOfSize:11]];
        [lbisspotgoods.layer setMasksToBounds:YES];
        [lbisspotgoods.layer setBorderColor:RadMenuColor.CGColor];
        [lbisspotgoods setText:@"现货"];
        [lbisspotgoods.layer setBorderWidth:1];
        [viewback addSubview:lbisspotgoods];
        [lbisspotgoods mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgvhead.mas_left);
            make.top.equalTo(imgvhead.mas_top);
            make.width.offset(29);
            make.height.offset(17);
        }];
        
        
        lbjiedan = [[UILabel alloc] init];
        [viewback addSubview:lbjiedan];
        [lbjiedan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgvhead.mas_left).offset(5);
            make.top.equalTo(imgvhead.mas_top).offset(5);
            make.bottom.equalTo(imgvhead.mas_bottom).offset(-5);
            make.right.equalTo(imgvhead.mas_right).offset(-5);
        }];
        [lbjiedan setBackgroundColor:RGBAlpha(0, 0, 0, 0.5)];
        [lbjiedan setText:@"已截单"];
        [lbjiedan setTextColor:[UIColor whiteColor]];
        [lbjiedan setTextAlignment:NSTextAlignmentCenter];
        [lbjiedan setFont:[UIFont systemFontOfSize:16]];
        [lbjiedan.layer setMasksToBounds:YES];
        [lbjiedan.layer setCornerRadius:71/2.0];
        [lbjiedan setHidden:YES];
        
        
        lbtitle = [[UILabel alloc] init];
        [viewback addSubview:lbtitle];
        [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgvhead.mas_right).offset(10);
            make.top.equalTo(imgvhead).offset(-5);
            make.right.equalTo(viewback).offset(-10);
            make.height.offset(36);
        }];
        [lbtitle setTextColor:RGB(30, 30, 30)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setNumberOfLines:2];
        [lbtitle setFont:[UIFont systemFontOfSize:14]];
        
        lbprice = [[UILabel alloc] init];
        [viewback addSubview:lbprice];
        [lbprice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbtitle);
            make.top.equalTo(lbtitle.mas_bottom).offset(3);
            make.height.offset(20);
        }];
        [lbprice setTextColor:RGB(243,93,0)];
        [lbprice setTextAlignment:NSTextAlignmentLeft];
        [lbprice setFont:[UIFont systemFontOfSize:15]];
        
        
        lbguige = [[UILabel alloc] init];
        [viewback addSubview:lbguige];
        [lbguige mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbtitle);
            make.top.equalTo(lbprice.mas_bottom).offset(5);
            make.width.offset(0);
            make.height.offset(20);
        }];
        [lbguige setNumberOfLines:2];
        [lbguige setBackgroundColor:RGB(234, 234, 234)];
        [lbguige setTextColor:RGB(153,153,153)];
        [lbguige setTextAlignment:NSTextAlignmentLeft];
        [lbguige setFont:[UIFont systemFontOfSize:10]];
        
        
        lbotherMoney = [[UILabel alloc] init];
        [viewback addSubview:lbotherMoney];
        [lbotherMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.equalTo(viewback.mas_right).offset(-10);
            make.top.equalTo(imgvhead.mas_bottom).offset(10);
            make.height.offset(40);
        }];
        [lbotherMoney setNumberOfLines:2];
        [lbotherMoney setTextColor:RGB(153,153,153)];
        [lbotherMoney setTextAlignment:NSTextAlignmentLeft];
        [lbotherMoney setFont:[UIFont systemFontOfSize:12]];
        
        
        viewline = [[UIView alloc] init];
        [viewline setBackgroundColor:RGB(231, 231, 231)];
        [viewback addSubview:viewline];
        [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(viewback);
            make.height.offset(1);
            make.bottom.equalTo(viewback);
        }];
        
        
        lbbuynumber = [[UILabel alloc] init];
        [viewback addSubview:lbbuynumber];
        [lbbuynumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbotherMoney.mas_bottom);
            make.left.equalTo(viewback.mas_left).offset(10);
            make.height.offset(20);
            make.width.offset(60);
        }];
        [lbbuynumber setTextColor:RGB(50,50,50)];
        [lbbuynumber setTextAlignment:NSTextAlignmentLeft];
        [lbbuynumber setFont:[UIFont systemFontOfSize:14]];
        [lbbuynumber setText:@"购买数量"];
        
        lbxgNumber = [[UILabel alloc] init];
        [viewback addSubview:lbxgNumber];
        [lbxgNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbbuynumber);
            make.left.equalTo(lbbuynumber.mas_right).offset(10);
            make.height.offset(20);
        }];
        [lbxgNumber setTextColor:RGB(243,93,0)];
        [lbxgNumber setTextAlignment:NSTextAlignmentLeft];
        [lbxgNumber setFont:[UIFont systemFontOfSize:14]];
        
        
        [self drawNumberSelect:CGRectMake(0, 0, 50, 26*kScale)];
        [viewnumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbprice.mas_top).offset(3*kScale);
            make.right.equalTo(lbtitle.mas_right);
            make.height.offset(26*kScale);
            make.width.offset(viewnumber.width);
        }];
        
        
    }
    return self;
}


#pragma mark - 数量选择
-(void)drawNumberSelect:(CGRect)rect
{
    viewnumber = [[UIView alloc] initWithFrame:rect];
    [viewnumber.layer setMasksToBounds:YES];
    [viewnumber.layer setCornerRadius:3];
    [viewnumber.layer setBorderColor:RGB(204,204,204).CGColor];
    [viewnumber.layer setBorderWidth:1];
    [viewnumber setClipsToBounds:YES];
    [viewback addSubview:viewnumber];
    
    btdel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewnumber.height, viewnumber.height)];
    [btdel setTitle:@"-" forState:UIControlStateNormal];
    [btdel setTitleColor:RGB(153,153,153) forState:UIControlStateNormal];
    [btdel.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btdel addTarget:self action:@selector(delNumberAction) forControlEvents:UIControlEventTouchUpInside];
    [viewnumber addSubview:btdel];
    
    viewline0 = [[UIView alloc] initWithFrame:CGRectMake(btdel.right, 0, 1, viewnumber.height)];
    [viewline0 setBackgroundColor:RGB(204,204,204)];
    [viewnumber addSubview:viewline0];
    
    fieldnumber = [[UITextField alloc] initWithFrame:CGRectMake(viewline0.right, 0, viewnumber.height*1.1, viewnumber.height)];
    [fieldnumber setText:@"1"];
    [fieldnumber setTextColor:RadMenuColor];
    [fieldnumber setTextAlignment:NSTextAlignmentCenter];
    [fieldnumber setFont:[UIFont systemFontOfSize:12]];
    [fieldnumber setUserInteractionEnabled:NO];
    [fieldnumber setBackgroundColor:[UIColor whiteColor]];
    [viewnumber addSubview:fieldnumber];
    
    
    viewline1 = [[UIView alloc] initWithFrame:CGRectMake(fieldnumber.right, 0, 1, viewnumber.height)];
    [viewline1 setBackgroundColor:RGB(204,204,204)];
    [viewnumber addSubview:viewline1];
    
    
    btadd = [[UIButton alloc] initWithFrame:CGRectMake(viewline1.right, 0, viewnumber.height, viewnumber.height)];
    [btadd setTitle:@"+" forState:UIControlStateNormal];
    [btadd setTitleColor:RGB(153,153,153) forState:UIControlStateNormal];
    [btadd.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [viewnumber addSubview:btadd];
    [btadd addTarget:self action:@selector(addNumberAction) forControlEvents:UIControlEventTouchUpInside];
    [viewnumber setWidth:btadd.right];
    
}




-(void)layoutSubviews
{
    
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhead url:_model.image];
    [imgvhead setContentMode:UIViewContentModeScaleAspectFit];
    
    [pindantext setHidden:YES];
    if([_model.daigoutype integerValue]==2)
    {
        [pindantext setHidden:NO];
        
        [lbisspotgoods mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pindantext.mas_right).offset(3);
        }];
    }
    else
    {
        [lbisspotgoods mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgvhead.mas_left);
        }];
    }
    
    
    if([_model.transfertype intValue] == 2)
    {
//        [lbzhiyou setHidden:NO];
//        [pindantext setLeft:lbzhiyou.right+3];
        
        [lbzhiyou setHidden:YES];
        
        [pindantext setLeft:10];
    }
    else
    {
        [lbzhiyou setHidden:YES];
        
        [pindantext setLeft:10];
        
    }
    
    
    [lbtitle setText:_model.title];
    
    [lbprice setText:[NSString stringWithFormat:@"￥%@",_model.price]];
    
    [lbxgNumber setHidden:YES];
    
    
    [self otherpricevalueAndnum];
    
    [fieldnumber setText:[NSString stringWithFormat:@"%d",_model.iselectnumber]];
    
    if(_iseditnumber)
    {
        
    }
    else
    {
        [btadd setBackgroundColor:RGB(234, 234, 234)];
        [btdel setBackgroundColor:RGB(234, 234, 234)];
        
        [viewnumber.layer setBorderWidth:0];
        [btdel setHidden:YES];
        [viewline0 setHidden:YES];
        [viewline1 setHidden:YES];
        [btadd setHidden:YES];
        
        [fieldnumber setText:[NSString stringWithFormat:@"X%d",_model.iselectnumber]];
        [lbbuynumber setHidden:YES];
        
        [lbxgNumber mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbbuynumber.mas_left);
        }];
        
        
        
    }
    [btdel setUserInteractionEnabled:_iseditnumber];
    [btadd setUserInteractionEnabled:_iseditnumber];
    
    
    
    if(_model.isspotgoods.integerValue==1)
    {
        if(_model.onelimit.integerValue>0)
        {
            [lbbuynumber setHidden:YES];
            
            [lbxgNumber mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lbbuynumber.mas_left);
            }];
            
            [lbxgNumber setHidden:NO];
            [lbxgNumber setText:[NSString stringWithFormat:@"剩余%d件",_model.stock.intValue-_model.purchased_nums.intValue]];
        }
    }
    else
    {
        if(_model.onelimit.integerValue>0)
        {
            [lbxgNumber setHidden:NO];
            [lbxgNumber setText:[NSString stringWithFormat:@"限购%@件",_model.onelimit]];
        }
    }
    
    
    if(_model.spec_val.length>1)
    {
        CGSize size = [MDB_UserDefault countTextSize:CGSizeMake(kMainScreenW-90-80.6*kScale-35, 35) andtextfont:lbguige.font andtext:_model.spec_val];
        [lbguige mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.offset(size.width+5);
            
            make.height.offset(size.height+5);
        }];
        [lbguige setText:_model.spec_val];
    }
    else
    {
        [lbprice mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbtitle.mas_bottom).offset(10);
        }];
    }
    
    
    [lbisspotgoods.layer setCornerRadius:2];
    if(_model.isspotgoods.integerValue==1)
    {
        [lbisspotgoods setHidden:NO];
        
    }
    else
    {
        [lbisspotgoods setHidden:YES];
    }
    
}

-(void)delNumberAction
{
    ///还需要判读是否能够加减
    if(_model.iselectnumber<=1)
    {
        return;
    }
    
    [self pushvaluetype:-1];
    
}

-(void)addNumberAction
{
    ///还需要判读是否能够加减
    if(_model.iselectnumber>= _model.onelimit.integerValue)
    {
        [MDB_UserDefault showNotifyHUDwithtext:[NSString stringWithFormat:@"限购%@件，不能再加了哦~",_model.onelimit] inView:self.viewController.view];
        return;
    }
    
    
    [self pushvaluetype:1];
    
}


-(void)pushvaluetype:(int)valuetype
{
    
    _model.iselectnumber = _model.iselectnumber+valuetype;
    [self otherpricevalueAndnum];
    [self.delegate DaiGouXiaDanGoodsNumChange];
}


-(void)otherpricevalueAndnum
{
    [fieldnumber setText:[NSString stringWithFormat:@"%d",_model.iselectnumber]];
    NSInteger inum = _model.iselectnumber-1;
    if(inum<0)
    {
        inum = 0;
    }
    if(inum>=_model.incidentals.count-1)
    {
        inum = _model.incidentals.count-1;
    }
    
    OrderGoodsMoneyInfoModel *modeltemp = _model.incidentals[inum];
    if(_model.transfertype.intValue == 2)
    {///直邮2
        [lbotherMoney setText:[NSString stringWithFormat:@"直邮邮费%@元，税费%@元（均为预估，多退少补）",modeltemp.directmailmoney,modeltemp.tariff]];
    }
    else
    {
        float ftemp = _fcarriage_discount;
        if(_model.isspotgoods.integerValue == 1)
        {
            ftemp = 1;
        }
        
        if(modeltemp.transfermoney.floatValue>0)
        {
            [lbotherMoney setText:[NSString stringWithFormat:@"本土邮费%.2lf元，转运费%.2lf元，税费%@元（均为预估，多退少补）",modeltemp.hpostage.floatValue*ftemp,modeltemp.transfermoney.floatValue*ftemp,modeltemp.tariff]];
        }
        else
        {
            [lbotherMoney setText:[NSString stringWithFormat:@"本土邮费%.2lf元，税费%@元（均为预估，多退少补）",modeltemp.hpostage.floatValue*ftemp,modeltemp.tariff]];
        }
        
    }
}





@end
