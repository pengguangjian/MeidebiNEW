//
//  ZiZhuUserInfoView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/5/22.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "ZiZhuUserInfoView.h"

#import "AddressListModel.h"

#import "MDB_UserDefault.h"

#import "SSScanningController.h"

#import "SSCardModel.h"

#import "AddressListModel.h"

#import "DaiGouGuiZheViewController.h"

#import "AddressListViewController.h"

@interface ZiZhuUserInfoView ()<UITextFieldDelegate,UIScrollViewDelegate,SSScanningControllerDelegate,AddressListSelectViewControllerDelegate>
{
    
    UIScrollView *scvback;
    
    UIView *viewShenFen;
    
    NSMutableArray *arrsfimage;
    NSMutableArray *arrsfimage1;
    
    BOOL isguize;
    
    ///身份证需要的信息
    NSInteger itpselectnow;
    SSCardModel *cardmodel;
    SSCardModel *cardmodel1;
    
    AddressListModel *addressmodel;
    BOOL ischange;
    NSString *strfront_pic;
    NSString *strback_pic;
    NSString *strsfIdCoard;
    NSString *strsfname;
    UITextField *fieldSFNumber;
    
    ///当前选中的快递
    UIButton *btnowkuaidi;
    
    UIView *viewaddress;
    
    UIView *viewkuaidi;
    
    UIView *viewdikou;
    
    UIView *viewsfnumber;
    
    UIView *viewguizhe;
    
    UIView *viewwhrite;
    
}

@end

@implementation ZiZhuUserInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self drawSonView];
    }
    return self;
}

-(void)drawSonView
{
    scvback = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-60)];
    [scvback setBackgroundColor:RGB(241,241,241)];
    [scvback setDelegate:self];
    [self addSubview:scvback];
    
    viewaddress = [self drawAddress:CGRectMake(0, 0, scvback.width, 100) andvalue:nil];
    [scvback addSubview:viewaddress];
    
    NSArray *arrkd = @[@"中通快递",@"顺丰快递"];
    viewkuaidi = [self drawKuaiDi:CGRectMake(0, viewaddress.bottom+8, viewaddress.width, 50) andarrtitle:arrkd];
    [scvback addSubview:viewkuaidi];
    
    viewdikou = [self drawyunfeiDiKou:CGRectMake(0, viewkuaidi.bottom, viewaddress.width, 50) andmoney:@"0"];
    [scvback addSubview:viewdikou];
    
    viewsfnumber = [self drawCodeNumber:CGRectMake(0, viewdikou.bottom+8, viewaddress.width, 50)];
    [scvback addSubview:viewsfnumber];
    
    viewShenFen = [self drawShenFen:CGRectMake(0, viewsfnumber.bottom+8, viewaddress.width, 100) andvalue:nil];
    [scvback addSubview:viewShenFen];
    
    viewguizhe = [self drawGuiZe:CGRectMake(0, viewShenFen.bottom+8, viewaddress.width, 50)];
    [scvback addSubview:viewguizhe];
    
    if(viewguizhe.bottom<scvback.height)
    {
        viewwhrite = [[UIView alloc] initWithFrame:CGRectMake(0, viewguizhe.bottom-1, viewaddress.width, scvback.height-viewguizhe.bottom+1)];
        [viewwhrite setBackgroundColor:[UIColor whiteColor]];
        [scvback addSubview:viewwhrite];
    }
    
    [scvback setContentSize:CGSizeMake(0, viewguizhe.bottom)];
    
    UIView *viewbottom = [[UIView alloc] init];
    [viewbottom setBackgroundColor:RGB(246, 246, 246)];
    [self addSubview:viewbottom];
    [viewbottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.offset(60);
    }];
    [self drawbottom:viewbottom];
    
}

-(void)uploadLoca
{
    [viewkuaidi setTop:viewaddress.bottom+8];
    [viewdikou setTop:viewkuaidi.bottom];
    
    [viewsfnumber setTop:viewdikou.bottom+8];
    [viewShenFen setTop:viewsfnumber.bottom+8];
    [viewguizhe setTop:viewShenFen.bottom+8];
    [viewwhrite setTop:viewguizhe.bottom-1];
    
    
}

#pragma mark - 地址信息
-(UIView *)drawAddress:(CGRect)rect andvalue:(AddressListModel *)value
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setUserInteractionEnabled:YES];
    
    
    if(value == nil)
    {
        UIImageView *imgvadd = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 15, 15)];
        [imgvadd setImage:[UIImage imageNamed:@"dingdan_address"]];
        [view addSubview:imgvadd];
        
        UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(imgvadd.right+8, imgvadd.top-5, 150, 25)];
        [lbtext setText:@"添加收货地址"];
        [lbtext setTextColor:RGB(102,102,102)];
        [lbtext setTextAlignment:NSTextAlignmentLeft];
        [lbtext setFont:[UIFont systemFontOfSize:14]];
        [view addSubview:lbtext];
        
        
        
        [view setHeight:49];
    }
    else
    {
        
        UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(12, 17, view.width-60, 18)];
        [lbtext setText:[NSString stringWithFormat:@"%@，%@",value.strname,value.strphone]];
        [lbtext setTextColor:RGB(102,102,102)];
        [lbtext setTextAlignment:NSTextAlignmentLeft];
        [lbtext setFont:[UIFont systemFontOfSize:14]];
        [view addSubview:lbtext];
        
        UILabel *lbtext1 = [[UILabel alloc] initWithFrame:CGRectMake(lbtext.left, lbtext.bottom, lbtext.width, 25)];
        [lbtext1 setText:value.straddress];
        [lbtext1 setTextColor:RGB(102,102,102)];
        [lbtext1 setTextAlignment:NSTextAlignmentLeft];
        [lbtext1 setFont:[UIFont systemFontOfSize:14]];
        [lbtext1 setNumberOfLines:2];
        [lbtext1 sizeToFit];
        [view addSubview:lbtext1];
        [view setHeight:lbtext1.bottom+17];
        
        
    }
    
    UIImageView *imgvnext= [[UIImageView alloc] initWithFrame:CGRectMake(view.width-25, 15, 15, 15)];
    [imgvnext setImage:[UIImage imageNamed:@"dingdan_address_next"]];
    [imgvnext setCenter:CGPointMake(0, view.height/2.0)];
    [imgvnext setRight:view.width-10];
    [view addSubview:imgvnext];
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin];
    
    [view setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressAction)];
    [view addGestureRecognizer:tap];
    
    return view;
}

#pragma mark - 快递
-(UIView *)drawKuaiDi:(CGRect)rect andarrtitle:(NSArray *)arrtitle
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIScrollView *scvback = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, view.width, 45)];
    [scvback setShowsHorizontalScrollIndicator:NO];
    [view addSubview:scvback];
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 45)];
    [lbtext setText:@"国内快递"];
    [lbtext setTextColor:RGB(102,102,102)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [lbtext sizeToFit];
    [lbtext setHeight:view.height];
    [scvback addSubview:lbtext];
    
    float fjianju = 7;
    if(BOUNDS_WIDTH>320)
    {
        fjianju = 20;
    }
    
    float fleft = lbtext.right+fjianju;
    
    for(int i = 0 ; i < arrtitle.count; i++)
    {
        UIButton *btkd = [[UIButton alloc] initWithFrame:CGRectMake(fleft, 0, 50, 45)];
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [imgv setImage:[UIImage imageNamed:@"yuan_select_no"]];
        [imgv setCenter:CGPointMake(0, btkd.height/2.0)];
        [imgv setTag:112];
        [imgv setLeft:0];
        [btkd addSubview:imgv];
        
        UILabel *lbkd = [[UILabel alloc] initWithFrame:CGRectMake(imgv.right+5, 0, 100, btkd.height)];
        [lbkd setText:arrtitle[i]];
        [lbkd setTextColor:RGB(102,102,102)];
        [lbkd setTextAlignment:NSTextAlignmentLeft];
        [lbkd setFont:[UIFont systemFontOfSize:12]];
        [lbkd sizeToFit];
        [lbkd setHeight:btkd.height];
        [btkd addSubview:lbkd];
        [btkd setWidth:lbkd.right];
        
        fleft = btkd.right+fjianju;
        [scvback addSubview:btkd];
        [scvback setContentSize:CGSizeMake(btkd.right, 0)];
        [btkd setTag:i];
        [btkd addTarget:self action:@selector(kuaiDiAction:) forControlEvents:UIControlEventTouchUpInside];
//        if(addressmodel.strid.length>1)
//        {
//            if(btnowkuaidi!=nil)
//            {
//                if(i==btnowkuaidi.tag)
//                {
//                    [imgv setImage:[UIImage imageNamed:@"yuan_select_yes"]];
//                    btnowkuaidi = btkd;
//                }
//
//
//            }
//            else
//            {
//                if(i==0)
//                {
//                    btnowkuaidi = btkd;
//                    [imgv setImage:[UIImage imageNamed:@"yuan_select_yes"]];
//                }
//            }
//        }
        
        
    }
    
    float ftempbot = scvback.bottom;
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, ftempbot+10,view.width , 1)];
    [viewlin setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin];
    
    [view setHeight:viewlin.bottom];
    
    return view;
}

#pragma mark - 运费抵扣
-(UIView *)drawyunfeiDiKou:(CGRect)rect andmoney:(NSString *)strmoney
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, view.height)];
    [lbtext setText:@"运费抵扣"];
    [lbtext setTextColor:RGB(102,102,102)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtext];
    
    
    UILabel *lbdikoumoney = [[UILabel alloc] initWithFrame:CGRectMake(lbtext.right, 0, 100, view.height)];
    [lbdikoumoney setText:[NSString nullToString:[NSString stringWithFormat:@"￥%@",strmoney]]];
    [lbdikoumoney setTextColor:RGB(102,102,102)];
    [lbdikoumoney setTextAlignment:NSTextAlignmentLeft];
    [lbdikoumoney setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbdikoumoney];
    
    
    UISwitch *itemswitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [itemswitch setCenter:CGPointMake(0, view.height/2.0)];
    [itemswitch setRight:view.width-10];
    [itemswitch addTarget:self action:@selector(yunfeidikouAction:) forControlEvents:UIControlEventValueChanged];
    [itemswitch setOn:YES];
    [view addSubview:itemswitch];
    
    
    return view;
}

#pragma mark - 身份证号码
-(UIView *)drawCodeNumber:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 45)];
    [lbtext setText:@"身份证号码"];
    [lbtext setTextColor:RGB(102,102,102)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtext];
    
    fieldSFNumber = [[UITextField alloc] initWithFrame:CGRectMake(10, lbtext.bottom, view.width-20, 36*kScale)];
    [fieldSFNumber setTextColor:RGB(153,153,153)];
    [fieldSFNumber setTextAlignment:NSTextAlignmentLeft];
    [fieldSFNumber setFont:[UIFont systemFontOfSize:13]];
    [fieldSFNumber setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldSFNumber setDelegate:self];
    [fieldSFNumber setTag:1110];
    [fieldSFNumber setKeyboardType:UIKeyboardTypeEmailAddress];
    [fieldSFNumber setPlaceholder:@"请输入您的身份证号码"];
    [view addSubview:fieldSFNumber];
    [fieldSFNumber setUserInteractionEnabled:NO];
    
    [view setHeight:fieldSFNumber.bottom+15];
    return view;
}

#pragma mark -///身份证信息
-(UIView *)drawShenFen:(CGRect)rect andvalue:(NSArray *)arrvalue
{
    if(viewShenFen != nil)
    {
        for(UIView *view in viewShenFen.subviews)
        {
            [view removeFromSuperview];
        }
        viewShenFen = nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, view.width-20, 25)];
    [lbtext setText:@"身份证信息（身份证正反面）"];
    [lbtext setTextColor:RGB(102,102,102)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtext];
    
    
    UIButton *btmoban = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 70, 25)];
    [btmoban setRight:view.width-8];
    [btmoban setTitleColor:RGB(152,152,152) forState:UIControlStateNormal];
    [btmoban.titleLabel setFont:[UIFont systemFontOfSize:13]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"身份证模板"];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    //    [btmoban setAttributedTitle:title
    //                          forState:UIControlStateNormal];
    [btmoban setTitle:@"身份证模板" forState:UIControlStateNormal];
    [btmoban.titleLabel setAttributedText:title];
    [btmoban addTarget:self action:@selector(mubanAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btmoban];
    
    
    
    
    
    UILabel *lbtext1 = [[UILabel alloc] initWithFrame:CGRectMake(lbtext.left, lbtext.bottom, view.width-20, 20)];
    [lbtext1 setText:@"请上传与收货人一致的身份证正反面（不能带水印）"];
    [lbtext1 setTextColor:RGB(153,153,153)];
    [lbtext1 setTextAlignment:NSTextAlignmentLeft];
    [lbtext1 setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbtext1];
    
    float fitemwh = (view.width-50)/4.0;
    
    UIView *imgvadd = [[UIView alloc] initWithFrame:CGRectMake(10, lbtext1.bottom+15, fitemwh, fitemwh)];
    [imgvadd setBackgroundColor:RGB(252,252,252)];
    [imgvadd.layer setMasksToBounds:YES];
    [imgvadd.layer setCornerRadius:4];
    [imgvadd.layer setBorderColor:RGB(218,218,218).CGColor];
    [imgvadd.layer setBorderWidth:1];
    UIImageView *imgvaddson = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgvadd.width/3.0, imgvadd.width/3.0)];
    [imgvaddson setImage:[UIImage imageNamed:@"topic_picture_add"]];
    [imgvaddson setCenter:CGPointMake(imgvadd.width/2.0, imgvadd.height/2.0)];
    [imgvadd addSubview:imgvaddson];
    [view addSubview:imgvadd];
    [imgvadd setUserInteractionEnabled:YES];
    UILabel *lbimgvadd = [[UILabel alloc] initWithFrame:CGRectMake(0,0, imgvadd.width, 15)];
    [lbimgvadd setText:@"正面身份证"];
    [lbimgvadd setTextColor:RGB(153,153,153)];
    [lbimgvadd setTextAlignment:NSTextAlignmentCenter];
    [lbimgvadd setFont:[UIFont systemFontOfSize:10]];
    [imgvadd addSubview:lbimgvadd];
    [imgvaddson setTop:(imgvadd.height-imgvaddson.height-lbimgvadd.height-3)/2.0];
    [lbimgvadd setTop:imgvaddson.bottom+3];
    [imgvadd setTag:0];
    UITapGestureRecognizer *tapimgvadd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAddAction:)];
    [imgvadd addGestureRecognizer:tapimgvadd];
    
    
    UIView *imgvadd1 = [[UIView alloc] initWithFrame:CGRectMake(imgvadd.right+10, lbtext1.bottom+15, fitemwh, fitemwh)];
    [imgvadd1 setBackgroundColor:RGB(252,252,252)];
    [imgvadd1.layer setMasksToBounds:YES];
    [imgvadd1.layer setCornerRadius:4];
    [imgvadd1.layer setBorderColor:RGB(218,218,218).CGColor];
    [imgvadd1.layer setBorderWidth:1];
    UIImageView *imgvaddson1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgvadd1.width/3.0, imgvadd1.width/3.0)];
    [imgvaddson1 setImage:[UIImage imageNamed:@"topic_picture_add"]];
    [imgvaddson1 setCenter:CGPointMake(imgvadd.width/2.0, imgvadd.height/2.0)];
    [imgvadd1 addSubview:imgvaddson1];
    [view addSubview:imgvadd1];
    [imgvadd1 setUserInteractionEnabled:YES];
    UILabel *lbimgvadd1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0, imgvadd.width, 15)];
    [lbimgvadd1 setText:@"反面身份证"];
    [lbimgvadd1 setTextColor:RGB(153,153,153)];
    [lbimgvadd1 setTextAlignment:NSTextAlignmentCenter];
    [lbimgvadd1 setFont:[UIFont systemFontOfSize:10]];
    [imgvadd1 addSubview:lbimgvadd1];
    [imgvaddson1 setTop:(imgvadd1.height-imgvaddson1.height-lbimgvadd1.height-3)/2.0];
    [lbimgvadd1 setTop:imgvaddson1.bottom+3];
    [imgvadd1 setTag:1];
    UITapGestureRecognizer *tapimgvadd1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAddAction:)];
    [imgvadd1 addGestureRecognizer:tapimgvadd1];
    
    
    NSMutableArray *arrtemp = [NSMutableArray new];
    if(arrsfimage.count>0)
    {
        [arrtemp addObjectsFromArray:arrsfimage];
        
        UIImageView *imgv = [self drawImageViewItem:CGRectMake(0, 0, fitemwh, fitemwh) andtag:0];
        if([arrtemp[0] isKindOfClass:[UIImage class]])
        {
            [imgv setImage:arrtemp[0]];
        }
        else
        {
            [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:arrtemp[0]];
        }
        [imgv setTag:0];
        UITapGestureRecognizer *tapimgvadd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAddAction:)];
        [imgv addGestureRecognizer:tapimgvadd];
        [imgvadd addSubview:imgv];
        [imgv setContentMode:UIViewContentModeScaleAspectFit];
        
    }
    if(arrsfimage1.count>0)
    {
        [arrtemp addObjectsFromArray:arrsfimage1];
        
        
        UIImageView *imgv = [self drawImageViewItem:CGRectMake(0, 0, fitemwh, fitemwh) andtag:((int)arrtemp.count-1)];
        if([arrtemp[arrtemp.count-1] isKindOfClass:[UIImage class]])
        {
            [imgv setImage:arrtemp[arrtemp.count-1]];
        }
        else
        {
            [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:arrtemp[arrtemp.count-1]];
        }
        [imgv setTag:1];
        UITapGestureRecognizer *tapimgvadd1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAddAction:)];
        [imgv addGestureRecognizer:tapimgvadd1];
        [imgvadd1 addSubview:imgv];
        [imgv setContentMode:UIViewContentModeScaleAspectFit];
    }
    
    
    [view setHeight:imgvadd.bottom+15];
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin];
    
    return view;
}

-(UIImageView *)drawImageViewItem:(CGRect)rect andtag:(int)tag
{
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:rect];
    [imgv setUserInteractionEnabled:YES];
    
    UIButton *btdelimgv = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgv.width*0.3, imgv.width*0.3)];
    [btdelimgv setTag:tag];
    [imgv addSubview:btdelimgv];
    [btdelimgv setRight:imgv.width];
    [btdelimgv setTop:0];
    [btdelimgv addTarget:self action:@selector(imgvDelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgvdel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [imgvdel setImage:[UIImage imageNamed:@"photo_delete"]];
    [imgvdel setTop:3];
    [imgvdel setRight:btdelimgv.width-3];
    [btdelimgv addSubview:imgvdel];
    
    
    return imgv;
}

#pragma mark - 规则
-(UIView *)drawGuiZe:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    UIButton *btkd = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, view.height)];
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    [imgv setCenter:CGPointMake(0, btkd.height/2.0)];
    [imgv setImage:[UIImage imageNamed:@"fang_select_no"]];
    isguize = NO;
    [imgv setLeft:0];
    [imgv setTag:2];
    [btkd addSubview:imgv];
    UILabel *lbkd = [[UILabel alloc] initWithFrame:CGRectMake(imgv.right+5, 0, 100, btkd.height)];
    [lbkd setText:@"同意"];
    [lbkd setTextColor:RGB(102,102,102)];
    [lbkd setTextAlignment:NSTextAlignmentLeft];
    [lbkd setFont:[UIFont systemFontOfSize:13]];
    [lbkd sizeToFit];
    [lbkd setHeight:btkd.height];
    [btkd addSubview:lbkd];
    [btkd setWidth:lbkd.right];
    [view addSubview:btkd];
    [btkd addTarget:self action:@selector(guizeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *lbtext1 = [[UILabel alloc] initWithFrame:CGRectMake(btkd.right, 0, 140, view.height)];
    [lbtext1 setText:@"<<没得比代购协议>>"];
    [lbtext1 setTextColor:RGB(153,153,153)];
    [lbtext1 setTextAlignment:NSTextAlignmentLeft];
    [lbtext1 setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbtext1];
    [lbtext1 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapguiz = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guizeDetaileAction)];
    [lbtext1 addGestureRecognizer:tapguiz];
    
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin];
    
    return view;
}
////
-(void)drawbottom:(UIView *)view
{
    UILabel *lbkd = [[UILabel alloc] init];
    [lbkd setText:@"总计: "];
    [lbkd setTextColor:RGB(51,51,51)];
    [lbkd setTextAlignment:NSTextAlignmentLeft];
    [lbkd setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:lbkd];
    [lbkd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(10);
        make.height.offset(30);
    }];
    
    UILabel *lbprice = [[UILabel alloc] init];
    [lbprice setText:@"￥0.0"];
    [lbprice setTextColor:RGB(253,122,14)];
    [lbprice setTextAlignment:NSTextAlignmentLeft];
    [lbprice setFont:[UIFont fontWithName:@"Arial_BlodMT" size:15]];
    [view addSubview:lbprice];
    [lbprice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbkd.mas_right);
        make.top.height.equalTo(lbkd);
    }];
    
    UILabel *lbshouxufei = [[UILabel alloc] init];
    [lbshouxufei setText:@"（含手续费0元）"];
    [lbshouxufei setTextColor:RGB(151,151,151)];
    [lbshouxufei setTextAlignment:NSTextAlignmentLeft];
    [lbshouxufei setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbshouxufei];
    [lbshouxufei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbkd);
        make.top.equalTo(lbkd.mas_bottom);
    }];
    
    UIButton *btsend = [[UIButton alloc] init];
    [btsend setTitle:@"提交订单" forState:UIControlStateNormal];
    [btsend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btsend.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btsend addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [btsend setBackgroundColor:RGB(253,122,14)];
    [btsend.layer setMasksToBounds:YES];
    [btsend.layer setCornerRadius:3];
    [view addSubview:btsend];
    [btsend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.offset(10);
        make.bottom.equalTo(view).offset(-10);
        make.width.offset(90);
    }];
}


#pragma mark - 地址点击
-(void)addressAction
{
    ischange = YES;
    AddressListViewController *avc = [[AddressListViewController alloc] init];
    avc.delegateitem = self;
    if(addressmodel!= nil)
    {
        avc.strnomoid = addressmodel.strid;
    }
    [self.viewController.navigationController pushViewController:avc animated:YES];
}
#pragma mark - 地址点击返回
-(void)addressSelectItem:(id)value
{
    addressmodel = value;
    [viewaddress removeFromSuperview];
    
    
    if(strsfname!= nil)
    {
        if(![addressmodel.strname isEqualToString:strsfname])
        {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份证图片必须与收货人一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alter show];
        }
    }
    
    float ftop = viewaddress.top;
    viewaddress = nil;
    viewaddress = [self drawAddress:CGRectMake(0, ftop, scvback.width, 50) andvalue:addressmodel];
    [scvback addSubview:viewaddress];
    [self uploadLoca];
    
//    ////需要获取快递的价格
//    [self getExpressValue:addressmodel.strid];
//
//    ///
//    [self getUserMessage:addressmodel.strname];
}

///删除item
-(void)addressDelItem:(id)value
{
    //    NSString *straddressid = value;
    
    addressmodel = nil;
    [viewaddress removeFromSuperview];
    float ftop = viewaddress.top;
    viewaddress = nil;
    viewaddress = [self drawAddress:CGRectMake(0, ftop, scvback.width, 50) andvalue:addressmodel];
    [scvback addSubview:viewaddress];
    [self uploadLoca];
}



#pragma mark - 快递选择
-(void)kuaiDiAction:(UIButton *)sender
{
    if(addressmodel.strid.length<1)
    {
        
        [MDB_UserDefault showNotifyHUDwithtext:@"请先添加收货地址哦" inView:self.window];
        return;
    }
    ischange = YES;
    if(btnowkuaidi !=nil)
    {
        UIImageView *imgv = [btnowkuaidi viewWithTag:112];
        [imgv setImage:[UIImage imageNamed:@"yuan_select_no"]];
    }
    btnowkuaidi = sender;
    
    UIImageView *imgv = [sender viewWithTag:112];
    [imgv setImage:[UIImage imageNamed:@"yuan_select_yes"]];
}

#pragma mark - 是否抵扣运费
-(void)yunfeidikouAction:(UISwitch *)sender
{
    
}
#pragma mark - 身份证模板
-(void)mubanAction
{
    DaiGouGuiZheViewController *dvc = [[DaiGouGuiZheViewController alloc] init];
    dvc.strtitle = @"身份证模板";
    dvc.strurl = WenZheng_ALL_rol;
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:@"id_template" forKey:@"key"];
    dvc.dicpush = dicpush;
    [self.viewController.navigationController pushViewController:dvc animated:YES];
}
#pragma mark - 添加身份证图片
-(void)imageAddAction:(UIGestureRecognizer *)gesture
{
    itpselectnow = gesture.view.tag;
    SSScanningController *svc = [[SSScanningController alloc] init];
    svc.delegate = self;
    [self.viewController.navigationController pushViewController:svc animated:YES];
}
#pragma mark - 身份证信息扫描获取
-(void)SSScanningControllerPopController:(SSCardModel *)model
{
    if(itpselectnow==0)
    {
        if(model.num!=nil||model.name!=nil)
        {//正面
            model.open = YES;
        }
        else
        {//反面
            model.back = YES;
        }
        
        if(cardmodel1!= nil)
        {
            if(cardmodel1.num!=nil||cardmodel1.name!=nil)
            {//正面
                if(model.open == YES)
                {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请传入身份证背面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alter show];
                    return;
                }
            }
            else
            {//反面
                if(model.back == YES)
                {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请传入身份证正面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alter show];
                    return;
                }
                cardmodel1.back = YES;
            }
        }
        cardmodel = model;
    }
    else
    {
        if(model.num!=nil||model.name!=nil)
        {//正面
            model.open = YES;
        }
        else
        {//反面
            model.back = YES;
        }
        
        if(cardmodel!= nil)
        {
            if(cardmodel.num!=nil||cardmodel.name!=nil)
            {//正面
                if(model.open == YES)
                {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请传入身份证背面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alter show];
                    return;
                }
            }
            else
            {//反面
                if(model.back == YES)
                {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请传入身份证正面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alter show];
                    return;
                }
            }
        }
        
        cardmodel1 = model;
    }
    
    ischange = YES;
    if(itpselectnow == 0)
    {
        [arrsfimage removeAllObjects];
        arrsfimage = [NSMutableArray arrayWithObject:model.image];
        
        strfront_pic = nil;
    }
    else if(itpselectnow == 1)
    {
        [arrsfimage1 removeAllObjects];
        arrsfimage1 = [NSMutableArray arrayWithObject:model.image];
        
        strback_pic = nil;
    }
    
    
    CGRect rect = viewShenFen.frame;
    [viewShenFen removeFromSuperview];
    viewShenFen = nil;
    viewShenFen = [self drawShenFen:rect andvalue:arrsfimage];
    [scvback addSubview:viewShenFen];
    
    
    if(model.num!=nil||model.name!=nil)
    {//正面
        strsfIdCoard = model.num;
        strsfname = model.name;
        [fieldSFNumber setText:strsfIdCoard];
        if(addressmodel!=nil)
        {
            if(![addressmodel.strname isEqualToString:model.name])
            {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份证图片必须与收货人一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
            }
        }
        
    }
    else
    {///反面
        if(model.issue!=nil||model.valid!=nil)
        {
            NSArray *arrtemp = [model.valid componentsSeparatedByString:@"-"];
            if(arrtemp.count==2)
            {
                NSString *strendtime = arrtemp[1];
                
                if([[self getUTCFormateDate:strendtime] integerValue]<3)
                {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请上传有效期大于3个月的身份证图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alter show];
                }
                
            }
            
        }
    }
    [self uploadLoca];
}
-(NSString *)getUTCFormateDate:(NSString *)newsDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];[dateFormatter setTimeZone:timeZone];
    NSDate* current_date = [[NSDate alloc] init];
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    int year =((int)time)/(3600*24*30*12);
    int month=((int)time)/(3600*24*30);
    NSString *dateContent;
    if (year!=0) {
        dateContent = @"3";
        
    }else if(month!=0){
        dateContent = [NSString stringWithFormat:@"%i",month];
        
    }else {
        dateContent = @"0";
        
    }
    return dateContent;
}



#pragma mark - 删除身份证图片
-(void)imgvDelAction:(UIButton *)sender
{
    if(sender.tag == 0)
    {
        if(arrsfimage.count>0)
        {
            
            [arrsfimage removeObjectAtIndex:0];
            strfront_pic = nil;
        }
        else
        {
            
            [arrsfimage1 removeObjectAtIndex:0];
            strback_pic = nil;
        }
        
        cardmodel = nil;
        
        
    }
    else if (sender.tag == 1)
    {
        [arrsfimage1 removeObjectAtIndex:0];
        strback_pic = nil;
        cardmodel1 = nil;
    }
    
    if(cardmodel1.num==nil&&cardmodel.num==nil)
    {
        strsfIdCoard = @"";
        strsfname = @"";
        [fieldSFNumber setText:@""];
        
        
    }
    
    CGRect rect = viewShenFen.frame;
    [viewShenFen removeFromSuperview];
    viewShenFen = nil;
    viewShenFen = [self drawShenFen:rect andvalue:arrsfimage];
    [scvback addSubview:viewShenFen];
}
#pragma mark - 同意规则
-(void)guizeAction:(UIButton *)sender
{
    UIImageView *imgv = [sender viewWithTag:2];
    if(isguize)
    {
        [imgv setImage:[UIImage imageNamed:@"fang_select_no"]];
        isguize = NO;
    }
    else
    {
        [imgv setImage:[UIImage imageNamed:@"fang_select_yes"]];
        isguize = YES;
    }
}
#pragma mark - 规则详情
-(void)guizeDetaileAction
{
    DaiGouGuiZheViewController *dvc = [[DaiGouGuiZheViewController alloc] init];
    dvc.strtitle = @"代购协议";
    dvc.strurl = WenZheng_ALL_rol;
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:@"service" forKey:@"key"];
    dvc.dicpush = dicpush;
    [self.viewController.navigationController pushViewController:dvc animated:YES];
}
#pragma mark - 提交订单
-(void)nextAction
{
    
}

@end
