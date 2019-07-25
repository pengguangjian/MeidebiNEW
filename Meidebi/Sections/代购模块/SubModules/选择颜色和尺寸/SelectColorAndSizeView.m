//
//  SelectColorAndSizeView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/27.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "SelectColorAndSizeView.h"

#import "SelectGuiGeDataControl.h"

#import "MDB_UserDefault.h"
#import "GuiGeModel.h"

#import "GMDCircleLoader.h"

#import "GuiGeLianXiModel.h"

@interface SelectColorAndSizeView ()
{
    UIView *viewmessage;
    
    UILabel *lbname;
    UIImageView *imgvhd;
    UILabel *lbprice;
    
    NSString *strprice;
    
    NSString *strpurchased_nums;
    
    NSInteger type;
    ///商品id
    NSString *strgoodsid;
    ///购物车商品id
    NSString *strcatid;
    
    UILabel *lbgg1;
    UILabel *lbgg2;
    UILabel *lbgg3;
    UILabel *lbgg4;
    UILabel *lbgg5;
    UILabel *lbgg6;
    
    SelectGuiGeDataControl *datacontrol;
    
    ///所有的规格
    NSMutableArray *arrallGuiGe;
    
    NSMutableDictionary *dicGetInfo;
    
    ///规格之间的联系
    NSMutableArray *arrGuiGedetail;
    
    ///所有不可选中的id
    NSMutableArray *arrallnotselectitemid;
    
    ///所有item数组
    NSMutableArray *arrallItemArr;
    
    ///暂时无货
    UILabel *lbbottomwuhuo;
    
    ///底部加载
//    UIView *viewbottomjiazai;
    
    BOOL isjiazaizhong;
    
    ///数量
    UITextField *fieldnumber;
    
    ////规格详情id
    NSString *strgoodsdetailid;
    
    ///默认规格数据
    NSDictionary *diccartgoodsinfo;
    /*
     cartid = 717;
     goodsdetailid = 2552;
     selectspecs =         (
     3599
     );
     */
    
    ///所有规格页面
    NSMutableArray *arrallGGView;
    
    ///限购数量
    int onelimit;
    
}


@end

@implementation SelectColorAndSizeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame andvalue:(id)value andtype:(NSInteger)itype
{
    if(self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:RGBAlpha(0, 0, 0, 0.3)];
        
        UITapGestureRecognizer *tapview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisAction)];
        [self addGestureRecognizer:tapview];
        
        type = itype;
        dicGetInfo = value;
        strgoodsid = [dicGetInfo objectForKey:@"id"];
        strprice = @"";
        if(type==3)
        {
            strcatid = [NSString nullToString:[dicGetInfo objectForKey:@"cartid"]];
        }
        
        datacontrol = [SelectGuiGeDataControl new];
        
        [self getmessage];
        
        
        
    }
    
    return self;
}

-(void)dismisAction
{
    [UIView animateWithDuration:0.35 animations:^{
        [viewmessage setTop:self.height];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        [datacontrol cancleRequest];
        
    }];
    
}

-(void)getmessage
{
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    if(type==1||type==0)
    {
        [dicpush setObject:strgoodsid forKey:@"id"];
    }
    else
    {
        [dicpush setObject:strcatid forKey:@"cartid"];
        
        
    }
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    
    [datacontrol requestGuiGeAllDataLine:dicpush InView:[UIApplication sharedApplication].keyWindow Callback:^(NSError *error, BOOL state, NSString *describle) {
        
        if(state)
        {
            NSDictionary *dicgoodsspecs = [datacontrol.resultDict objectForKey:@"goodsspecs"];
            
            strprice = [NSString stringWithFormat:@"%@~%@",[dicgoodsspecs objectForKey:@"bottom_price_change"],[dicgoodsspecs objectForKey:@"top_price_change"]];
            onelimit =  [[NSString nullToString:[dicgoodsspecs objectForKey:@"onelimit"]] intValue];
            if([[NSString nullToString:[dicgoodsspecs objectForKey:@"bottom_price_change"]] floatValue]==0)
            {
                strprice = [NSString nullToString:[dicgoodsspecs objectForKey:@"top_price_change"]];
            }
            else if ([[NSString nullToString:[dicgoodsspecs objectForKey:@"top_price_change"]] floatValue]==0)
            {
                strprice = [NSString nullToString:[dicgoodsspecs objectForKey:@"bottom_price_change"]];
            }
            
            strpurchased_nums = [NSString nullToString:[dicgoodsspecs objectForKey:@"purchased_nums"]];
            
            arrGuiGedetail = [NSMutableArray new];
            if([[dicgoodsspecs objectForKey:@"detail"] isKindOfClass:[NSArray class]])
            {
                NSArray *arrdetail =  [dicgoodsspecs objectForKey:@"detail"];
                for(NSDictionary *dic in arrdetail)
                {
                    [arrGuiGedetail addObject:[GuiGeLianXiModel geigeDicValue:dic]];
                }
                
            }
            
            arrallnotselectitemid = [self getallNotSelect];
            
            arrallGuiGe = [NSMutableArray new];
            if([[dicgoodsspecs objectForKey:@"spec"] isKindOfClass:[NSArray class]])
            {
                NSArray *arrspec = [dicgoodsspecs objectForKey:@"spec"];
                for(NSDictionary *dic in arrspec)
                {
                    GuiGeModel *model = [GuiGeModel geigeDicValue:dic];
                    BOOL isyou = NO;
                    for(GuiGeModel *modeltemp in arrallGuiGe)
                    {
                        if([model.strname isEqualToString:modeltemp.strname])
                        {
                           isyou = YES;
                            break;
                        }
                        
                    }
                    
                    if(model.arritem.count>0 && isyou == NO)
                    {
                        [arrallGuiGe addObject:model];
                    }
                    
                    
                    
                }
                
            }
            
            diccartgoodsinfo = [datacontrol.resultDict objectForKey:@"cartgoodsinfo"];
            if(type==3)
            {
                strprice = [NSString nullToString:[diccartgoodsinfo objectForKey:@"price"]];
            }
            
            if(arrallGuiGe.count>0)
            {
                [self drawmessage];
                [self showView];
            }
            else
            {
               [MDB_UserDefault showNotifyHUDwithtext:@"规格数据错误" inView:self.window];
                [self removeFromSuperview];
            }
            
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.window];
            [self removeFromSuperview];
        }
        
    }];
}

///没得用 但是要放在这里
-(void)viewmwsage
{
    
}

-(void)showView
{
    [UIView animateWithDuration:0.35 animations:^{
        [viewmessage setBottom:self.height];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)drawmessage
{
    
    viewmessage = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 450*kScale)];
    [viewmessage setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:viewmessage];
    
    UITapGestureRecognizer *tapviewm = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewmwsage)];
    [viewmessage addGestureRecognizer:tapviewm];
    
    
    
    imgvhd = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80*kScale, 80*kScale)];
//    [imgvhd setBackgroundColor:[UIColor grayColor]];
    [viewmessage addSubview:imgvhd];
    [imgvhd setContentMode:UIViewContentModeScaleAspectFit];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhd url:[dicGetInfo objectForKey:@"image"]];
    
    lbname = [[UILabel alloc] initWithFrame:CGRectMake(imgvhd.right+15, 10, viewmessage.width-imgvhd.right-45, 35)];
    [lbname setText:[dicGetInfo objectForKey:@"title"]];
    [lbname setTextColor:RGB(50, 50, 50)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setNumberOfLines:2];
    [lbname setFont:[UIFont systemFontOfSize:14]];
    [viewmessage addSubview:lbname];
    
    
    UIButton *btdel = [[UIButton alloc] initWithFrame:CGRectMake(viewmessage.width-40, 0, 40, 40)];
    [btdel setImage:[UIImage imageNamed:@"guige_shanchu"] forState:UIControlStateNormal];
    [btdel setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [btdel addTarget:self action:@selector(dismisAction) forControlEvents:UIControlEventTouchUpInside];
    [viewmessage addSubview:btdel];
    
    
    lbprice = [[UILabel alloc] initWithFrame:CGRectMake(lbname.left, lbname.bottom+5, lbname.width, 20)];
    [lbprice setText:[NSString stringWithFormat:@"￥%@", strprice]];
    [lbprice setTextColor:RGB(255, 50, 50)];
    [lbprice setTextAlignment:NSTextAlignmentLeft];
    [lbprice setFont:[UIFont systemFontOfSize:14]];
    [viewmessage addSubview:lbprice];
    
    UILabel *lbpaynum = [[UILabel alloc] initWithFrame:CGRectMake(lbprice.left, lbprice.bottom+5, lbprice.width, 20)];
    [lbpaynum setTextColor:RGB(180, 180, 180)];
    [lbpaynum setTextAlignment:NSTextAlignmentLeft];
    [lbpaynum setFont:[UIFont systemFontOfSize:12]];
    [lbpaynum setAttributedText:[self arrstring:[NSString stringWithFormat:@"已下单%@件",strpurchased_nums] andstart:3 andend:(int)strpurchased_nums.length andfont:12 andcolor:RGB(230, 56, 47)]];
    [viewmessage addSubview:lbpaynum];
    if(strpurchased_nums.integerValue<1)
    {
        [lbpaynum setHidden:YES];
    }
    ///无用
    UILabel *lbpaynum1 = [[UILabel alloc] initWithFrame:CGRectMake(imgvhd.left, imgvhd.bottom+10, viewmessage.width-20, 1)];
    [lbpaynum1 setTextColor:RGB(255, 50, 50)];
    [lbpaynum1 setTextAlignment:NSTextAlignmentLeft];
    [lbpaynum1 setFont:[UIFont systemFontOfSize:12]];
    [viewmessage addSubview:lbpaynum1];
    
    UIScrollView *scvmessage = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lbpaynum.bottom, viewmessage.width, viewmessage.height-50-lbpaynum.bottom)];
    [scvmessage setShowsVerticalScrollIndicator:NO];
    [scvmessage setShowsHorizontalScrollIndicator:NO];
    [viewmessage addSubview:scvmessage];
    
    
    float fbottom = 10;
    int itag = 0;
    arrallItemArr = [NSMutableArray new];
    arrallGGView = [NSMutableArray new];
    for(GuiGeModel *model in arrallGuiGe)
    {
        NSMutableArray *arrtmep = [NSMutableArray new];
        UIView *viewcolor = [self drawggView:CGRectMake(0, fbottom, scvmessage.width, 100) andtitle:model.strname andvalue:model.arritem andspecvaltype:model.strspecvaltype anditemarr:arrtmep andtag:itag];
        [scvmessage addSubview:viewcolor];
        [viewcolor setTag:itag];
        fbottom = viewcolor.bottom+10;
        itag++;
        [arrallGGView addObject:viewcolor];
        [arrallItemArr addObject:arrtmep];
    }
    
    if(type==0||type==1)
    {
        UILabel *lbnumt = [[UILabel alloc] initWithFrame:CGRectMake(10, fbottom, 100, 30)];
        [lbnumt setText:@"数量"];
        [lbnumt setTextColor:RGB(50, 50, 50)];
        [lbnumt setTextAlignment:NSTextAlignmentLeft];
        [lbnumt setFont:[UIFont systemFontOfSize:14]];
        [lbnumt sizeToFit];
        [lbnumt setHeight:30];
        [scvmessage addSubview:lbnumt];
        
        
        
        
        UIView *viewnumber = [self drawNumberSelect:CGRectMake(lbnumt.right+10, lbnumt.top, 100, lbnumt.height)];
        [scvmessage addSubview:viewnumber];
        
        
        if(onelimit>0)
        {
            UILabel *lblimitnumt = [[UILabel alloc] initWithFrame:CGRectMake(viewnumber.right+10, viewnumber.top, 100, viewnumber.height)];
            [lblimitnumt setText:[NSString stringWithFormat:@"限购%d件",onelimit]];
            [lblimitnumt setTextColor:RGB(50, 50, 50)];
            [lblimitnumt setTextAlignment:NSTextAlignmentLeft];
            [lblimitnumt setFont:[UIFont systemFontOfSize:14]];
            [lblimitnumt sizeToFit];
            [lblimitnumt setHeight:30];
            [scvmessage addSubview:lblimitnumt];
        }
        
        
        
        
        [scvmessage setContentSize:CGSizeMake(0, viewnumber.bottom+10)];
    }
   else
   {
       [scvmessage setContentSize:CGSizeMake(0, fbottom+10)];
   }
    
    if(scvmessage.contentSize.height<scvmessage.height)
    {
        
        scvmessage.height = scvmessage.contentSize.height;
        [viewmessage setHeight:scvmessage.bottom+50];
    }
    
    
    [self drawbottom];
    
    [self selectnomo];
    
    [self gouwucheselectnomo];
    
    
    [self setnotselectitem];
    
    
}

///设置一行显示不同字体 颜色
-(NSMutableAttributedString *)arrstring:(NSString *)str andstart:(int)istart andend:(int)length andfont:(float)ff andcolor:(UIColor *)color
{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:str];
    @try {
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ff] range:NSMakeRange(istart, length)];
        
        [noteStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(istart, length)];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
    return noteStr;
}


-(void)drawbottom
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, viewmessage.height-50, viewmessage.width, 50)];
    [viewmessage addSubview:view];
    
    
    
    
    
    UIButton *btother = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, (view.width-40)/2.0, 40)];
    [btother.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btother setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:btother];
    [btother.layer setMasksToBounds:YES];
    [btother.layer setCornerRadius:btother.height/2.0];
    [btother addTarget:self action:@selector(bottomOtherAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btaddgwc = [[UIButton alloc] initWithFrame:CGRectMake(btother.right+20, 5, (view.width-40)/2.0, 40)];
    [btaddgwc setTitle:@"加入购物车" forState:UIControlStateNormal];
    [btaddgwc.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btaddgwc setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btaddgwc setBackgroundColor:RadMenuColor];
    [view addSubview:btaddgwc];
    [btaddgwc.layer setMasksToBounds:YES];
    [btaddgwc.layer setCornerRadius:btaddgwc.height/2.0];
    [btaddgwc addTarget:self action:@selector(addgoucheAction) forControlEvents:UIControlEventTouchUpInside];
    
    if(type==0)
    {
        [btother setBackgroundColor:RGB(236, 237, 236)];
        [btother setTitle:@"取消" forState:UIControlStateNormal];
        [btother setTitleColor:RGB(30, 30, 30) forState:UIControlStateNormal];
    }
    else if(type==1)
    {
        [btaddgwc setLeft:10];
        [btother setLeft:btaddgwc.right+20];
        [btother setBackgroundColor:RadMenuColor];
        [btother setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    else
    {
        [btother setHidden:YES];
        [btaddgwc setFrame:CGRectMake(0, 5, view.width, view.height-5)];
        [btaddgwc.layer setCornerRadius:0];
        [btaddgwc setTitle:@"确定" forState:UIControlStateNormal];
    }
    
    
    
    
    
    lbbottomwuhuo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    [lbbottomwuhuo setBackgroundColor:RGB(220, 220, 220)];
    [lbbottomwuhuo setText:@"暂时无货"];
    [lbbottomwuhuo setTextColor:RGB(80, 80, 80)];
    [lbbottomwuhuo setTextAlignment:NSTextAlignmentCenter];
    [lbbottomwuhuo setFont:[UIFont systemFontOfSize:14]];
    [lbbottomwuhuo setHidden:YES];
    [view addSubview:lbbottomwuhuo];
    
//    viewbottomjiazai = [[UIView alloc] initWithFrame:CGRectMake(view.width, 0, view.width, view.height)];
//    [viewbottomjiazai setHidden:YES];
//    [viewbottomjiazai setBackgroundColor:RGBAlpha(223, 122, 35, 0.8)];
//    [view addSubview:viewbottomjiazai];
}

#pragma mark - 只有一种组合需要默认选中
-(void)selectnomo
{
    @try {
        BOOL isnomoselect = YES;
        for(GuiGeModel *model in arrallGuiGe)
        {
            if(model.arritem.count>1)
            {
                isnomoselect = NO;
                break;
            }
        }
        
        if(isnomoselect)
        {//默认选中
            for(int i = 0 ; i < arrallGuiGe.count; i++)
            {
                UIView *view = arrallGGView[i];
                NSMutableArray *arrges = [NSMutableArray new];
                for(UIView *views in view.subviews)
                {
                    if(views.gestureRecognizers!=nil)
                    {
                        [arrges addObjectsFromArray:views.gestureRecognizers];
                    }
                    
                }
                [self itemAction:arrges[0]];
                
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}


///购物车默认选中
-(void)gouwucheselectnomo
{
    NSArray *arrselectspecs;
    if(diccartgoodsinfo.count>1)
    {
        if([[diccartgoodsinfo objectForKey:@"selectspecs"] isKindOfClass:[NSArray class]])
        {
            arrselectspecs = [diccartgoodsinfo objectForKey:@"selectspecs"];
        }
        
    }
    
    @try {
        for(NSArray *arritems in arrallItemArr)
        {
            
            for(UILabel *lbitem in arritems)
            {
                GuiGeModel *model0 = arrallGuiGe[lbitem.superview.tag];
                GuiGeItemModel *model = model0.arritem[lbitem.tag];
                
                
                for(NSString *strtemp in arrselectspecs)
                {
                    if([model.strid isEqualToString:[NSString nullToString:strtemp]])
                    {
                        [self itemselectAction:lbitem.gestureRecognizers[0]];
                        [self itemActionChangeItemState:lbitem.gestureRecognizers[0]];
                        //                [self itemAction:tapitem];
                    }
                }
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
     
    
}





#pragma mark - 数量选择
-(UIView *)drawNumberSelect:(CGRect)rect
{
    UIView *viewnumber = [[UIView alloc] initWithFrame:rect];
    [viewnumber.layer setMasksToBounds:YES];
    [viewnumber.layer setCornerRadius:3];
    [viewnumber.layer setBorderColor:RGB(204,204,204).CGColor];
    [viewnumber.layer setBorderWidth:1];
    [viewnumber setClipsToBounds:YES];
    
    
    UIButton *btdel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewnumber.height, viewnumber.height)];
    [btdel setTitle:@"-" forState:UIControlStateNormal];
    [btdel setTitleColor:RGB(153,153,153) forState:UIControlStateNormal];
    [btdel.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btdel addTarget:self action:@selector(delNumberAction) forControlEvents:UIControlEventTouchUpInside];
    [viewnumber addSubview:btdel];
    
    UIView *viewline0 = [[UIView alloc] initWithFrame:CGRectMake(btdel.right, 0, 1, viewnumber.height)];
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
    
    
    UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectMake(fieldnumber.right, 0, 1, viewnumber.height)];
    [viewline1 setBackgroundColor:RGB(204,204,204)];
    [viewnumber addSubview:viewline1];
    
    
    UIButton *btadd = [[UIButton alloc] initWithFrame:CGRectMake(viewline1.right, 0, viewnumber.height, viewnumber.height)];
    [btadd setTitle:@"+" forState:UIControlStateNormal];
    [btadd setTitleColor:RGB(153,153,153) forState:UIControlStateNormal];
    [btadd.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [viewnumber addSubview:btadd];
    [btadd addTarget:self action:@selector(addNumberAction) forControlEvents:UIControlEventTouchUpInside];
    [viewnumber setWidth:btadd.right];
    
    
    return viewnumber;
}

-(UIView *)drawggView:(CGRect)rect andtitle:(NSString *)title andvalue:(NSArray *)arrvalue andspecvaltype:(NSString *)specvaltype anditemarr:(NSMutableArray *)arritem andtag:(int)tag
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setTag:tag];
    UILabel *lbt = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    [lbt setText:title];
    [lbt setTextColor:RGB(50, 50, 50)];
    [lbt setTextAlignment:NSTextAlignmentLeft];
    [lbt setFont:[UIFont systemFontOfSize:14]];
    [lbt sizeToFit];
    [lbt setHeight:30];
    [view addSubview:lbt];
    
    
    NSMutableArray *arrlbitem = [NSMutableArray new];
    int i = 0;
    
//    NSArray *arrselectspecs;
//    if(diccartgoodsinfo.count>1)
//    {
//        if([[diccartgoodsinfo objectForKey:@"selectspecs"] isKindOfClass:[NSArray class]])
//        {
//            arrselectspecs = [diccartgoodsinfo objectForKey:@"selectspecs"];
//        }
//
//    }
    
    for(GuiGeItemModel *model in arrvalue)
    {
        UILabel *lbitem = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width-20, 30)];
        
//        if(specvaltype.integerValue == 1)
//        {
//
//            UIImageView *imgvtemp = [[UIImageView alloc] init];
//            [lbitem addSubview:imgvtemp];
//
//            [imgvtemp mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.top.right.bottom.equalTo(lbitem);
//            }];
//            [[MDB_UserDefault defaultInstance] setViewWithImage:imgvtemp url:model.strcolor];
//        }
//        else if (specvaltype.integerValue == 2)
//        {
//
//            [lbitem setBackgroundColor:[UIColor colorWithHexString:model.strcolor]];
//        }
        [lbitem setText:model.strname];
        [lbitem setTextColor:RGB(90, 90, 90)];
        [lbitem setTextAlignment:NSTextAlignmentCenter];
        [lbitem setFont:[UIFont systemFontOfSize:13]];
        [lbitem setNumberOfLines:0];
        [lbitem sizeToFit];
        [lbitem setBackgroundColor:RGB(245, 245, 245)];
        [lbitem setHeight:lbitem.height+15];
        if(lbitem.height<=30)
        {
            [lbitem setHeight:30];
        }
//        else if(lbitem.height>40)
//        {
//            [lbitem setTextAlignment:NSTextAlignmentLeft];
//        }
        [lbitem setWidth:lbitem.width+15];
        if(lbitem.width>view.width-20)
        {
            [lbitem setWidth:view.width-20];
        }
        [view addSubview:lbitem];
        [lbitem.layer setMasksToBounds:YES];
        [lbitem.layer setCornerRadius:3];
        [lbitem.layer setBorderColor:RGB(245, 245, 245).CGColor];
        [lbitem.layer setBorderWidth:1];
        [arrlbitem addObject:lbitem];
        [lbitem setUserInteractionEnabled:YES];
        [lbitem setTag:i];
        [arritem addObject:lbitem];
        i++;
        UITapGestureRecognizer *tapitem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)];
        [lbitem addGestureRecognizer:tapitem];
        
//        for(NSString *strtemp in arrselectspecs)
//        {
//            if([model.strid isEqualToString:[NSString nullToString:strtemp]])
//            {
//                [self itemselectAction:tapitem];
////                [self itemActionChangeItemState:tapitem];
////                [self itemAction:tapitem];
//            }
//        }
        
        
    }
    
    
    float fleft = 10;
    float ftop = lbt.bottom+10;
    float fbottom = lbt.bottom;
    float flastitemheight = 30.0;
    for(UILabel *item in arrlbitem)
    {
        
        [item setLeft:fleft];
        [item setTop:ftop];
        if(item.right>view.width-10)
        {
            fleft = 10;
            [item setLeft:fleft];
            ftop = item.top+flastitemheight+10;
            [item setTop:ftop];
        }
        
        
        fleft = item.right+10;
        ftop = item.top;
        fbottom = item.bottom;
        flastitemheight = item.height;
    }
   
    [view setHeight:fbottom+10];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, view.width, 1)];
    [viewline setBackgroundColor:RGB(238, 239, 239)];
    [view addSubview:viewline];
    
    return view;
}

-(NSString *)itemselectAction:(UIGestureRecognizer *)gesture
{
    if(isjiazaizhong)return @"";
    
    NSInteger isupertag = gesture.view.superview.tag;
    
    UILabel *lbtemp;
    if(isupertag==0)
    {
        lbtemp = lbgg1;
    }
    else if (isupertag==1)
    {
        lbtemp = lbgg2;
    }
    else if (isupertag==2)
    {
        lbtemp = lbgg3;
    }
    else if (isupertag==3)
    {
        lbtemp = lbgg4;
    }
    else if (isupertag==4)
    {
        lbtemp = lbgg5;
    }
    else if (isupertag==5)
    {
        lbtemp = lbgg6;
    }
    if(lbtemp!=nil)
    {
        [lbtemp.layer setBorderColor:RGB(245, 245, 245).CGColor];
        [lbtemp setBackgroundColor:RGB(245, 245, 245)];
        [lbtemp setTextColor:RGB(90, 90, 90)];
    }
    
    
    BOOL isselect = YES;
    
    if(lbtemp != gesture.view)
    {
        UILabel *lbitem = (UILabel *)gesture.view;
        [lbitem.layer setBorderColor:RadMenuColor.CGColor];
        [lbitem setBackgroundColor:RGBAlpha(253.0, 122.0, 15.0, 0.1)];
        [lbitem setTextColor:RadMenuColor];
        if(isupertag==0)
        {
            lbgg1 = lbitem;
        }
        else if (isupertag==1)
        {
            lbgg2 = lbitem;
        }
        else if (isupertag==2)
        {
            lbgg3 = lbitem;
        }
        else if (isupertag==3)
        {
            lbgg4 = lbitem;
        }
        else if (isupertag==4)
        {
            lbgg5 = lbitem;
        }
        else if (isupertag==5)
        {
            lbgg6 = lbitem;
        }
        
    }
    else
    {
        UILabel *lbitem = (UILabel *)gesture.view;
        [lbitem.layer setBorderColor:RGB(245, 245, 245).CGColor];
        [lbitem setBackgroundColor:RGB(245, 245, 245)];
        [lbitem setTextColor:RGB(90, 90, 90)];
        if(isupertag==0)
        {
            lbgg1 = nil;
        }
        else if (isupertag==1)
        {
            lbgg2 = nil;
        }
        else if (isupertag==2)
        {
            lbgg3 = nil;
        }
        else if (isupertag==3)
        {
            lbgg4 = nil;
        }
        else if (isupertag==4)
        {
            lbgg5 = nil;
        }
        else if (isupertag==5)
        {
            lbgg6 = nil;
        }
        isselect = NO;
    }
    
    
    
    
    
    
    NSString *strid = @"";
    if(isselect)
    {
        if(lbgg1!=nil && arrallGuiGe.count==1)
        {
            GuiGeModel *model = arrallGuiGe[0];
            GuiGeItemModel *itemmodel = model.arritem[lbgg1.tag];
            strid = itemmodel.strid;
            
        }
        else if (lbgg1!=nil &&lbgg2!=nil && arrallGuiGe.count==2)
        {
            GuiGeModel *model = arrallGuiGe[0];
            GuiGeItemModel *itemmodel = model.arritem[lbgg1.tag];
            strid = itemmodel.strid;
            
            GuiGeModel *model1 = arrallGuiGe[1];
            GuiGeItemModel *itemmodel1 = model1.arritem[lbgg2.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel1.strid];
            
            
        }
        else if (lbgg1!=nil &&lbgg2!=nil&&lbgg3!=nil && arrallGuiGe.count==3)
        {
            GuiGeModel *model = arrallGuiGe[0];
            GuiGeItemModel *itemmodel = model.arritem[lbgg1.tag];
            strid = itemmodel.strid;
            
            GuiGeModel *model1 = arrallGuiGe[1];
            GuiGeItemModel *itemmodel1 = model1.arritem[lbgg2.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel1.strid];
            
            
            GuiGeModel *model2 = arrallGuiGe[2];
            GuiGeItemModel *itemmodel2 = model2.arritem[lbgg3.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel2.strid];
            
        }
        else if (lbgg1!=nil &&lbgg2!=nil&&lbgg3!=nil&&lbgg4!=nil && arrallGuiGe.count==4)
        {
            GuiGeModel *model = arrallGuiGe[0];
            GuiGeItemModel *itemmodel = model.arritem[lbgg1.tag];
            strid = itemmodel.strid;
            
            GuiGeModel *model1 = arrallGuiGe[1];
            GuiGeItemModel *itemmodel1 = model1.arritem[lbgg2.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel1.strid];
            
            
            GuiGeModel *model2 = arrallGuiGe[2];
            GuiGeItemModel *itemmodel2 = model2.arritem[lbgg3.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel2.strid];
            
            GuiGeModel *model3 = arrallGuiGe[3];
            GuiGeItemModel *itemmodel3 = model3.arritem[lbgg4.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel3.strid];
            
        }
        else if (lbgg1!=nil &&lbgg2!=nil&&lbgg3!=nil&&lbgg4!=nil&&lbgg5!=nil && arrallGuiGe.count==5)
        {
            GuiGeModel *model = arrallGuiGe[0];
            GuiGeItemModel *itemmodel = model.arritem[lbgg1.tag];
            strid = itemmodel.strid;
            
            GuiGeModel *model1 = arrallGuiGe[1];
            GuiGeItemModel *itemmodel1 = model1.arritem[lbgg2.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel1.strid];
            
            
            GuiGeModel *model2 = arrallGuiGe[2];
            GuiGeItemModel *itemmodel2 = model2.arritem[lbgg3.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel2.strid];
            
            GuiGeModel *model3 = arrallGuiGe[3];
            GuiGeItemModel *itemmodel3 = model3.arritem[lbgg4.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel3.strid];
            
            GuiGeModel *model4 = arrallGuiGe[4];
            GuiGeItemModel *itemmodel4 = model4.arritem[lbgg5.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel4.strid];
            
        }
        else if (lbgg1!=nil &&lbgg2!=nil&&lbgg3!=nil&&lbgg4!=nil&&lbgg5!=nil&&lbgg6!=nil && arrallGuiGe.count==6)
        {
            GuiGeModel *model = arrallGuiGe[0];
            GuiGeItemModel *itemmodel = model.arritem[lbgg1.tag];
            strid = itemmodel.strid;
            
            GuiGeModel *model1 = arrallGuiGe[1];
            GuiGeItemModel *itemmodel1 = model1.arritem[lbgg2.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel1.strid];
            
            
            GuiGeModel *model2 = arrallGuiGe[2];
            GuiGeItemModel *itemmodel2 = model2.arritem[lbgg3.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel2.strid];
            
            GuiGeModel *model3 = arrallGuiGe[3];
            GuiGeItemModel *itemmodel3 = model3.arritem[lbgg4.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel3.strid];
            
            GuiGeModel *model4 = arrallGuiGe[4];
            GuiGeItemModel *itemmodel4 = model4.arritem[lbgg5.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel4.strid];
            
            GuiGeModel *model5 = arrallGuiGe[5];
            GuiGeItemModel *itemmodel5 = model5.arritem[lbgg6.tag];
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel5.strid];
            
        }
    }
    
    return strid;
}

////item点击
-(void)itemAction:(UIGestureRecognizer *)gesture
{
    if(isjiazaizhong)return;
    
    NSString *strid = [self itemselectAction:gesture];
    [self itemActionChangeItemState:gesture];
    if(strid.length>0)
    {
        [self getitemMessage:strid];
    }
    
}

////更改其他item状态
-(void)itemActionChangeItemState:(UIGestureRecognizer *)gesture
{
    NSString *strid = [self itemguanxiAction:gesture];
    NSMutableArray *arrselectid = [NSMutableArray arrayWithArray:[strid componentsSeparatedByString:@","]];
    [arrselectid removeObject:@""];
//    if(arrselectid.count == arrallGuiGe.count)return;
    NSMutableArray *arrkeyixuanzde = [self getallnomoSelect:arrselectid];
    NSInteger supertag = gesture.view.superview.tag;
    
    NSMutableArray *arrselectDetail = [self guigeDetailIn:arrselectid];
    
    int i = 0;
    for(NSArray *arrArr in arrallItemArr)
    {
        
        if(supertag == i&&([gesture.view isEqual:lbgg1]||[gesture.view isEqual:lbgg2]||[gesture.view isEqual:lbgg3]||[gesture.view isEqual:lbgg4]||[gesture.view isEqual:lbgg5]||[gesture.view isEqual:lbgg6]))
        {
            i++;
            continue;
        }
        if([arrallItemArr[gesture.view.superview.tag] count] == 1)
        {

            if(lbgg1 != nil || lbgg2!= nil|| lbgg3!= nil|| lbgg4!= nil|| lbgg5!= nil|| lbgg6!= nil)
            {
                i++;
                continue;
            }

        }
        
        
        i++;
        
        ////循环设置
        for(UILabel *lbitem in arrArr)
        {
            GuiGeModel *model = arrallGuiGe[ lbitem.superview.tag];
            GuiGeItemModel *model1 = model.arritem[lbitem.tag];
            
            if([arrallnotselectitemid containsObject:model1.strid])
            {///
                [lbitem setUserInteractionEnabled:NO];
                
                [lbitem setTextColor:RGB(205, 205, 205)];
            }
            else
            {///
                if(arrselectDetail.count==0||arrselectid.count==0)
                {
                    [lbitem setTextColor:RGB(90, 90, 90)];
                    [lbitem setUserInteractionEnabled:YES];
                }
                else
                {
                    if(arrselectid.count==1 && ([lbitem.superview isEqual:lbgg1.superview] || [lbitem.superview isEqual:lbgg2.superview]|| [lbitem.superview isEqual:lbgg3.superview]|| [lbitem.superview isEqual:lbgg4.superview]|| [lbitem.superview isEqual:lbgg5.superview]|| [lbitem.superview isEqual:lbgg6.superview]))
                    {
                        ///判断是否是选中了的item
                        if([lbitem isEqual: lbgg1] || [lbitem isEqual: lbgg2] || [lbitem isEqual: lbgg3] || [lbitem isEqual: lbgg4] || [lbitem isEqual: lbgg5] || [lbitem isEqual: lbgg6])
                        {
                            ///当前item已选中
                            [lbitem.layer setBorderColor:RadMenuColor.CGColor];
                            [lbitem setBackgroundColor:RGBAlpha(253.0, 122.0, 15.0, 0.1)];
                            [lbitem setTextColor:RadMenuColor];
                            [lbitem setUserInteractionEnabled:YES];
                        }
                        else
                        {
                            [lbitem setTextColor:RGB(90, 90, 90)];
                            [lbitem setUserInteractionEnabled:YES];
                        }
                    }
                    else
                    {
                        for(GuiGeLianXiModel *model2 in arrselectDetail)
                        {
                            ///判断是否是选中了的item
                            if([lbitem isEqual: lbgg1] || [lbitem isEqual: lbgg2] || [lbitem isEqual: lbgg3] || [lbitem isEqual: lbgg4] || [lbitem isEqual: lbgg5] || [lbitem isEqual: lbgg6])
                            {
                                ///当前item已选中
                                [lbitem.layer setBorderColor:RadMenuColor.CGColor];
                                [lbitem setBackgroundColor:RGBAlpha(253.0, 122.0, 15.0, 0.1)];
                                [lbitem setTextColor:RadMenuColor];
                            }
                            else
                            {
                                BOOL isbool = [model2.spec_id containsObject: model1.strid];
                                if(isbool==NO)
                                {
                                    
                                    if([arrkeyixuanzde containsObject:model1.strid])
                                    {
                                        [lbitem setTextColor:RGB(90, 90, 90)];
                                        [lbitem setUserInteractionEnabled:YES];
                                    }
                                    else
                                    {
                                        [lbitem setUserInteractionEnabled:NO];
                                        
                                        [lbitem setTextColor:RGB(205, 205, 205)];
                                    }
                                    
                                    
                                }
                                else
                                {
                                    [lbitem setTextColor:RGB(90, 90, 90)];
                                    [lbitem setUserInteractionEnabled:YES];
                                    break;
                                }
                            }
                            
                        }
                    }
                }
            }
            
        }
    }
}

-(NSMutableArray *)guigeDetailIn:(NSArray *)arrselectid
{
    NSMutableArray *arrtemp = [NSMutableArray new];
    for(GuiGeLianXiModel *model in arrGuiGedetail)
    {
        BOOL isContains = YES;
        for(NSString *str in arrselectid)
        {
            if (![model.spec_id containsObject:str]) {
                isContains = NO;
            }
        }
        if(isContains&&model.availability.integerValue==1)
        {
            [arrtemp addObject:model];
        }
        
    }
    
    return arrtemp;
}

///所有不能选中的id
-(NSMutableArray *)getallNotSelect
{
    NSMutableArray *arrtemp = [NSMutableArray new];
    NSMutableArray *arrxunhuanid = [NSMutableArray new];
    
    for(GuiGeLianXiModel *model in arrGuiGedetail)
    {
        for(NSString *strid in model.spec_id)
        {
            if([arrxunhuanid containsObject:strid])
            {
                continue;
            }
            [arrxunhuanid addObject:strid];
            BOOL isyou = NO;
            for(GuiGeLianXiModel *model1 in arrGuiGedetail)
            {
                if ([model1.spec_id containsObject:strid] && model1.availability.integerValue == 1) {
                    ///可以选择
                    isyou = YES;
                    break;
                }
                
            }
            if(isyou == NO && ![arrtemp containsObject:strid])
            {
                [arrtemp addObject:strid];
            }
            
        }
        
    }
    
    return arrtemp;
}



///判断哪些能选的id
-(NSMutableArray *)getallnomoSelect:(NSArray *)arrselectid
{
    NSMutableArray *arrtemp = [NSMutableArray new];
    
    for(GuiGeLianXiModel *model in arrGuiGedetail)
    {
        BOOL isselectno = NO;
        for(NSString *strtttt in arrselectid)
        {
            if([model.spec_id containsObject:strtttt] && model.availability.intValue == 1)
            {
                isselectno = YES;
                break;
            }
        }
        
        if(isselectno == YES)
        {
            [arrtemp addObjectsFromArray:model.spec_id];
        }
        
    }
    
    return arrtemp;
}




///处理不可选中的item
-(void)setnotselectitem
{
    for(NSArray *arrArr in arrallItemArr)
    {
        ////循环设置
        for(UILabel *lbitem in arrArr)
        {
            GuiGeModel *model = arrallGuiGe[ lbitem.superview.tag];
            GuiGeItemModel *model1 = model.arritem[lbitem.tag];
            
            if([arrallnotselectitemid containsObject:model1.strid])
            {///
                [lbitem setUserInteractionEnabled:NO];
                
                [lbitem setTextColor:RGB(205, 205, 205)];
            }
        }
        
    }
    
    
}

///得到item选中的id
-(NSString *)itemguanxiAction:(UIGestureRecognizer *)gesture
{
    if(isjiazaizhong)return @"";
    
    NSString *strid = @"";
    if(lbgg1!=nil)
    {
        GuiGeModel *model = arrallGuiGe[0];
        GuiGeItemModel *itemmodel = model.arritem[lbgg1.tag];
        strid = itemmodel.strid;
        if([arrallItemArr[lbgg1.superview.tag] count]==1)
        {
            strid = @"";
        }
        
    }
    if (lbgg2!=nil)
    {
        GuiGeModel *model1 = arrallGuiGe[1];
        GuiGeItemModel *itemmodel1 = model1.arritem[lbgg2.tag];
        
        if([arrallItemArr[lbgg2.superview.tag] count]==1)
        {
            
        }
        else
        {
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel1.strid];
        }
        
    }
    if (lbgg3!=nil)
    {
        
        GuiGeModel *model2 = arrallGuiGe[2];
        GuiGeItemModel *itemmodel2 = model2.arritem[lbgg3.tag];
        
        if([arrallItemArr[lbgg3.superview.tag] count]==1)
        {
            
        }
        else
        {
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel2.strid];
        }
    }
    if (lbgg4!=nil)
    {
        
        GuiGeModel *model3 = arrallGuiGe[3];
        GuiGeItemModel *itemmodel3 = model3.arritem[lbgg4.tag];
        
        if([arrallItemArr[lbgg4.superview.tag] count]==1)
        {
            
        }
        else
        {
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel3.strid];
        }
    }
    if (lbgg5!=nil)
    {
        
        GuiGeModel *model4 = arrallGuiGe[4];
        GuiGeItemModel *itemmodel4 = model4.arritem[lbgg5.tag];
        
        if([arrallItemArr[lbgg5.superview.tag] count]==1)
        {
            
        }
        else
        {
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel4.strid];
        }
    }
    if (lbgg6!=nil)
    {
        GuiGeModel *model5 = arrallGuiGe[5];
        GuiGeItemModel *itemmodel5 = model5.arritem[lbgg6.tag];
        
        if([arrallItemArr[lbgg6.superview.tag] count]==1)
        {
            
        }
        else
        {
            strid = [NSString stringWithFormat:@"%@,%@",strid,itemmodel5.strid];
        }
    }
    return strid;
}


-(void)getitemMessage:(NSString *)strid
{
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:strgoodsid forKey:@"id"];
    [dicpush setObject:strid forKey:@"specids"];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    
    isjiazaizhong = YES;
//    [viewbottomjiazai setHidden:NO];
//    [UIView animateWithDuration:0.3 animations:^{
//        [viewbottomjiazai setLeft:0];
//    }];
    
    __block UIView *viewtemp = viewmessage;
    strgoodsdetailid = @"";
    [GMDCircleLoader setOnView:viewtemp withTitle:nil animated:YES];
    
    [datacontrol requestGuiGeItemDataLine:dicpush InView:nil Callback:^(NSError *error, BOOL state, NSString *describle) {
        [GMDCircleLoader hideFromView:viewtemp animated:YES];
//        [viewbottomjiazai setLeft:viewbottomjiazai.width];
//        [viewbottomjiazai setHidden:YES];
        isjiazaizhong = NO;
        if(state)
        {
            /*
             "quantity_in_stock" : "",
             "availability" : 0,
             "price_unit" : "USD",
             "image" : "https:\/\/pumaimages.azureedge.net\/images\/367734\/01\/sv01\/fnd\/PNA\/h\/600\/w\/600",
             "price" : null,
             "price_change" : "0.00"
             */
            strgoodsdetailid = [NSString nullToString:[datacontrol.resultItemDict objectForKey:@"goodsdetailid"]];
//            [dicGetInfo setObject:[NSString nullToString:[datacontrol.resultItemDict objectForKey:@"image"]] forKey:@"image"];
//
//
//            [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhd url:[NSString nullToString:[datacontrol.resultItemDict objectForKey:@"image"]]];
            [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhd url:[NSString nullToString:[datacontrol.resultItemDict objectForKey:@"image"]]  options:SDWebImageLowPriority completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
               
                if(image && error==nil)
                {
                    [dicGetInfo setObject:[NSString nullToString:[datacontrol.resultItemDict objectForKey:@"image"]] forKey:@"image"];
                }
                else
                {
//                    [dicGetInfo setObject:[NSString nullToString:[datacontrol.resultItemDict objectForKey:@"image"]] forKey:@"image"];
                }
            }];
            
            if([[datacontrol.resultItemDict objectForKey:@"availability"] intValue] == 1)
            {
                
                [lbprice setText:[NSString stringWithFormat:@"￥%@", [NSString nullToString:[datacontrol.resultItemDict objectForKey:@"price_change"]]]];
                [lbbottomwuhuo setHidden:YES];
                
                
            }
            else
            {
                
                [lbprice setText:[NSString stringWithFormat:@"￥%@",strprice]];
                [lbbottomwuhuo setHidden:NO];
                
            }
            
            
            
        }
        else
        {
            strgoodsdetailid = nil;
//            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.window];
            [lbbottomwuhuo setHidden:NO];
        }
    }];
    
}

-(void)delNumberAction
{
    if(isjiazaizhong)return;
    NSInteger num = fieldnumber.text.integerValue;
    if(num>1)
    {
        [fieldnumber setText:[NSString stringWithFormat:@"%ld",num-1]];
    }
    
}
-(void)addNumberAction
{
    if(isjiazaizhong)return;
    NSInteger num = fieldnumber.text.integerValue;
    if(onelimit>0)
    {
        if(num<onelimit)
        {
            [fieldnumber setText:[NSString stringWithFormat:@"%ld",num+1]];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:[NSString stringWithFormat:@"商品限购%d件",onelimit] inView:self];
        }
    }
    else if(onelimit<0)
    {
        [fieldnumber setText:[NSString stringWithFormat:@"%ld",num+1]];
    }
}

-(NSString *)getNoSelectValue
{
    NSString *strtemp = @"";
    @try
    {
        if(lbgg1==nil&&arrallGuiGe.count>0)
        {
            GuiGeModel *model  = arrallGuiGe[0];
            strtemp = model.strname;
        }
        else if (lbgg2==nil&&arrallGuiGe.count>1)
        {
            GuiGeModel *model  = arrallGuiGe[1];
            strtemp = model.strname;
        }
        else if (lbgg3==nil&&arrallGuiGe.count>2)
        {
            GuiGeModel *model  = arrallGuiGe[2];
            strtemp = model.strname;
        }
        else if (lbgg4==nil&&arrallGuiGe.count>3)
        {
            GuiGeModel *model  = arrallGuiGe[3];
            strtemp = model.strname;
        }
        else if (lbgg5==nil&&arrallGuiGe.count>4)
        {
            GuiGeModel *model  = arrallGuiGe[4];
            strtemp = model.strname;
        }
        else if (lbgg6==nil&&arrallGuiGe.count>5)
        {
            GuiGeModel *model  = arrallGuiGe[5];
            strtemp = model.strname;
        }
    }
    @catch(NSException *exc)
    {
        
    }
    @finally
    {
        
    }
    
    return strtemp;
}

///加入购物车
-(void)addgoucheAction
{
    if(isjiazaizhong)return;
    
    if(strgoodsdetailid==nil || strgoodsdetailid.length==0)
    {
        
        [MDB_UserDefault showNotifyHUDwithtext:[NSString stringWithFormat:@"请选择%@的具体规格",[self getNoSelectValue]] inView:self.window];
        return;
    }
    if(type==0||type==1)
    {
        if([self.delegate respondsToSelector:@selector(addGouWuChe:andnum:)])
        {
            [self.delegate addGouWuChe:strgoodsdetailid andnum:fieldnumber.text];
        }
    }
    else
    {
        ///修改规格
        if([self.delegate respondsToSelector:@selector(changeGouWuChe:andcartid:)])
        {
            [self.delegate changeGouWuChe:strgoodsdetailid andcartid:strcatid];
        }
        
    }
    
    
}

///取消和购买
-(void)bottomOtherAction
{
    if(isjiazaizhong)return;
    if(strgoodsdetailid==nil || strgoodsdetailid.length==0)
    {
        
        [MDB_UserDefault showNotifyHUDwithtext:[NSString stringWithFormat:@"请选择%@的具体规格",[self getNoSelectValue]] inView:self.window];
        return;
    }
    if(type==0)
    {
      [self dismisAction];
    }
    else if(type==1)
    {
        if([self.delegate respondsToSelector:@selector(buyGoods:andnum:)])
        {
             [self.delegate buyGoods:strgoodsdetailid andnum:fieldnumber.text];
        }
       
    }
    else
    {///暂时无
        
    }
    
}

@end
