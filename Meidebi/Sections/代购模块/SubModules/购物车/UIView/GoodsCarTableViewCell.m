//
//  GoodsCarTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "GoodsCarTableViewCell.h"

#import "MDB_UserDefault.h"

#import "GoodsCarDataViewController.h"

@interface GoodsCarTableViewCell ()
{
    
    UIView *viewback;
    
    ///选中
    UIButton *btselect;
    
    ///头图
    UIImageView *imgvhead;
    
    UILabel *lbzhiyou;
    
    ///已截单
    UILabel *lbjiedan;
    
    UILabel *lbtitle;
    UILabel *lbprice;
    
    ///规格
    UILabel *lbguige;
    UIView *viewguigeback;
    
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
    
    ///限购数量
    UILabel *lbxgNumber;
    
    
    UILabel *lbisspotgoods;
    
    
}
@end

@implementation GoodsCarTableViewCell

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
        
        
        btselect = [[UIButton alloc] init];
        [viewback addSubview:btselect];
        [btselect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5);
            make.top.offset(17);
            make.height.offset(81);
            make.width.offset(40);
        }];
        [btselect setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
        [btselect addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
        
        imgvhead = [[UIImageView alloc] init];
        [viewback addSubview:imgvhead];
        [imgvhead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btselect.mas_right);
            make.top.bottom.equalTo(btselect);
            make.width.offset(81);
        }];
        
        
        lbzhiyou = [[UILabel alloc] initWithFrame:CGRectMake(45, 17, 45, 17)];
        [lbzhiyou setText:@"直邮"];
        [lbzhiyou setTextColor:RGB(230,56,47)];
        [lbzhiyou setTextAlignment:NSTextAlignmentCenter];
        [lbzhiyou setFont:[UIFont systemFontOfSize:13]];
        [lbzhiyou.layer setMasksToBounds:YES];
        [lbzhiyou.layer setCornerRadius:2];
        [lbzhiyou.layer setBorderColor:RGB(230,56,47).CGColor];
        [lbzhiyou.layer setBorderWidth:1];
        [lbzhiyou sizeToFit];
        [lbzhiyou setHeight:17];
        [lbzhiyou setWidth:lbzhiyou.width+6];
        [viewback addSubview:lbzhiyou];
        [lbzhiyou setHidden:YES];
        
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
            make.left.equalTo(imgvhead.mas_left).offset(15);
            make.top.equalTo(imgvhead.mas_top).offset(15);
            make.bottom.equalTo(imgvhead.mas_bottom).offset(-15);
            make.right.equalTo(imgvhead.mas_right).offset(-15);
        }];
        [lbjiedan setBackgroundColor:RGBAlpha(0, 0, 0, 0.5)];
        [lbjiedan setText:@"已截单"];
        [lbjiedan setTextColor:[UIColor whiteColor]];
        [lbjiedan setTextAlignment:NSTextAlignmentCenter];
        [lbjiedan setFont:[UIFont systemFontOfSize:14]];
        [lbjiedan.layer setMasksToBounds:YES];
        [lbjiedan.layer setCornerRadius:51/2.0];
        
        
        
        lbtitle = [[UILabel alloc] init];
        [viewback addSubview:lbtitle];
        [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgvhead.mas_right).offset(10);
            make.top.equalTo(imgvhead).offset(-5);
            make.right.equalTo(viewback).offset(-10);
            make.height.offset(41);
        }];
        [lbtitle setTextColor:RGB(30, 30, 30)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setNumberOfLines:2];
        [lbtitle setFont:[UIFont systemFontOfSize:16]];
        
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
        
        lbotherMoney = [[UILabel alloc] init];
        [viewback addSubview:lbotherMoney];
        [lbotherMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.equalTo(viewback.mas_right).offset(-10);
            make.top.equalTo(imgvhead.mas_bottom).offset(17);
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
        
        [self drawNumberSelect:CGRectMake(0, 0, 50, 26*kScale)];
        [viewnumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbprice.mas_top).offset(-3*kScale);
            make.right.equalTo(lbtitle.mas_right);
            make.height.offset(26*kScale);
            make.width.offset(viewnumber.width);
        }];
        
        
        viewguigeback = [[UIView alloc] init];
        [viewguigeback setBackgroundColor:RGB(234, 234, 234)];
        [viewback addSubview:viewguigeback];
        
        
        lbguige = [[UILabel alloc] init];
        [viewback addSubview:lbguige];
        [lbguige mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbtitle);
            make.top.equalTo(viewnumber.mas_bottom).offset(2);
            make.width.offset(0);
            make.height.offset(20);
        }];
        [lbguige setNumberOfLines:2];
        [lbguige setBackgroundColor:RGB(234, 234, 234)];
        [lbguige setTextColor:RGB(153,153,153)];
        [lbguige setTextAlignment:NSTextAlignmentLeft];
        [lbguige setFont:[UIFont systemFontOfSize:10]];
        [lbguige setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapguige = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guigeAction)];
        [lbguige addGestureRecognizer:tapguige];
        
        [viewguigeback mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbtitle).offset(-5);
            make.top.equalTo(viewnumber.mas_bottom).offset(2);
            make.width.equalTo(lbguige.mas_width);
            make.height.equalTo(lbguige.mas_height);
        }];
        
        
        lbxgNumber = [[UILabel alloc] init];
        [viewback addSubview:lbxgNumber];
        [lbxgNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewnumber);
            make.right.equalTo(viewback.mas_left).offset(-10);
            make.bottom.equalTo(viewback);
        }];
        [lbxgNumber setTextColor:RGB(243,93,0)];
        [lbxgNumber setTextAlignment:NSTextAlignmentRight];
        [lbxgNumber setFont:[UIFont systemFontOfSize:14]];
        
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
    
    if([_model.transfertype intValue] == 2)
    {
//        [lbzhiyou setHidden:NO];
        [lbzhiyou setHidden:YES];
    }
    else
    {
        [lbzhiyou setHidden:YES];
    }
    
    
    [lbtitle setText:_model.title];
    
    [lbprice setText:[NSString stringWithFormat:@"￥%@",_model.price]];
    
    
    
    if(_model.isendtime==YES)
    {
        [lbjiedan setHidden:NO];
        [viewnumber setHidden:YES];
    }
    else
    {
        [lbjiedan setHidden:YES];
        [viewnumber setHidden:NO];
    }
    
    
    [btselect setHidden:NO];
    if(_model.isendtime==YES && _model.isEdit== NO)
    {
        [btselect setHidden:YES];
    }
    if(_model.isEdit)
    {
        if(_model.isEditSelect==YES)
        {
            [btselect setImage:[UIImage imageNamed:@"yuan_select_yes"] forState:UIControlStateNormal];
        }
        else
        {
            [btselect setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
        }
    }
    else
    {
        if(_model.isSelect==YES)
        {
            [btselect setImage:[UIImage imageNamed:@"yuan_select_yes"] forState:UIControlStateNormal];
        }
        else
        {
            [btselect setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
        }
    }
    
    [lbxgNumber setText:[NSString stringWithFormat:@"限购%@件",_model.onelimit]];
    
    if(_model.spec_val.length>1)
    {
        [viewguigeback setHidden:NO];
        [lbguige setHidden:NO];
        CGSize size = [MDB_UserDefault countTextSize:CGSizeMake(kMainScreenW-90-80.6*kScale-35, 35) andtextfont:lbguige.font andtext:_model.spec_val];
        [lbguige mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.offset(size.width+6);
            make.height.offset(size.height+5);
        }];
        [lbguige setText:_model.spec_val];
    }
    else
    {
        [viewguigeback setHidden:YES];
        [lbguige setHidden:YES];
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
    
    [self otherpricevalueAndnum];
    
}


-(void)selectAction
{
    if(_model.isEdit)
    {
        if(_model.isEditSelect)
        {
            _model.isEditSelect = NO;
        }
        else
        {
            _model.isEditSelect = YES;
        }
    }
    else
    {
        if(_model.isSelect)
        {
            _model.isSelect = NO;
        }
        else
        {
            _model.isSelect = YES;
        }
    }
    if(_model.isEdit)
    {
        if(_model.isEditSelect==YES)
        {
            [btselect setImage:[UIImage imageNamed:@"yuan_select_yes"] forState:UIControlStateNormal];
        }
        else
        {
            [btselect setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
        }
    }
    else
    {
        if(_model.isSelect==YES)
        {
            [btselect setImage:[UIImage imageNamed:@"yuan_select_yes"] forState:UIControlStateNormal];
        }
        else
        {
            [btselect setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
        }
    }
    
    [self.delegate selectActionItem:_model];
    
}

-(void)delNumberAction
{
    ///还需要判读是否能够加减
    if(_model.num.integerValue<=1)
    {
        return;
    }
    
    [self pushvaluetype:-1];
    
}

-(void)addNumberAction
{
    ///还需要判读是否能够加减
    if(_model.num.integerValue>= _model.onelimit.integerValue)
    {
        [MDB_UserDefault showNotifyHUDwithtext:[NSString stringWithFormat:@"此商品限购%d件",_model.num.intValue] inView:self.viewController.view];
        return;
    }
    
    [self pushvaluetype:1];
    
    
}


-(void)pushvaluetype:(int)valuetype
{
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    [dicpush setObject:_model.did forKey:@"cartids"];
    [dicpush setObject:[NSString stringWithFormat:@"%ld",_model.num.integerValue+valuetype] forKey:@"num"];
    
    GoodsCarDataViewController *datacontrol = [[GoodsCarDataViewController alloc] init];
    [datacontrol requestBuCarListItemEditDataLine:dicpush view:nil Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            _model.num = [NSString stringWithFormat:@"%ld",_model.num.integerValue+valuetype];
            
            [self.delegate itemNumChange];
            [self otherpricevalueAndnum];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.viewController.view];
        }
    }];
    
}


-(void)otherpricevalueAndnum
{
    [fieldnumber setText:_model.num];
    NSInteger inum = _model.num.integerValue-1;
    if(inum<0)
    {
        inum = 0;
    }
    if(inum>=_model.arrincidentals.count-1)
    {
        inum = _model.arrincidentals.count-1;
    }
    
    GoodsGarincidentalsModel *modeltemp = _model.arrincidentals[inum];
    if(_model.transfertype.intValue == 2)
    {///直邮2
        [lbotherMoney setText:[NSString stringWithFormat:@"直邮邮费%@元，税费%@元（均为预估，多退少补）",modeltemp.directmailmoney,modeltemp.tariff]];
    }
    else
    {
        if(modeltemp.transfermoney.floatValue>0)
        {
            [lbotherMoney setText:[NSString stringWithFormat:@"本土邮费%@元，转运费%@元，税费%@元（均为预估，多退少补）",modeltemp.hpostage,modeltemp.transfermoney,modeltemp.tariff]];
        }
        else
        {
            [lbotherMoney setText:[NSString stringWithFormat:@"本土邮费%@元，税费%@元（均为预估，多退少补）",modeltemp.hpostage,modeltemp.tariff]];
        }
        
    }
}

///规格点击
-(void)guigeAction
{
    [self.delegate changeGuiGeItem:_model];
}


@end
