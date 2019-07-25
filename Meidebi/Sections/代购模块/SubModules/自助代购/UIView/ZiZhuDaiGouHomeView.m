//
//  ZiZhuDaiGouHomeView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/5/21.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "ZiZhuDaiGouHomeView.h"
#import "PushYuanChuangTextView.h"
#import "MDB_UserDefault.h"

#import "ZiZhuInForListTableViewController.h"

#import "ZiZhuInForViewController.h"

@interface ZiZhuDaiGouHomeView ()<UITextViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *scvback;
    
    PushYuanChuangTextView *brokeLinkTextField;
    
    UIView *viewzizu;
    UILabel *lbnoInfo;
    
}
@end

@implementation ZiZhuDaiGouHomeView

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
        [self drawSubview];
    }
    return self;
}

-(void)drawSubview
{
    
    scvback = [[UIScrollView alloc] init];
    [scvback setDelegate:self];
    [self addSubview:scvback];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    ///
    UIView *viewtop = [[UIView alloc] init];
    [viewtop setBackgroundColor:RadMenuColor];
    [scvback addSubview:viewtop];
    [viewtop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(scvback);
        make.width.offset(kMainScreenW);
    }];
    [self drawTopView:viewtop];
    
    ////1
    viewzizu = [[UIView alloc] init];
    [viewzizu setBackgroundColor:[UIColor whiteColor]];
    [scvback addSubview:viewzizu];
    [viewzizu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewtop.mas_bottom);
        make.left.right.equalTo(viewtop);
    }];
    [self drawOneItem:viewzizu];
    
    
    
    
    ///2
    UIView *viewzici = [[UIView alloc] init];
    [viewzici setBackgroundColor:[UIColor whiteColor]];
    [scvback addSubview:viewzici];
    [viewzici mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewzizu.mas_bottom);
        make.left.right.equalTo(viewtop);
    }];
    [self drawTwo:viewzici];
    
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewzici.mas_bottom).offset(20);
    }];
//    [scvback setContentSize:CGSizeMake(0, 1800)];
}


///头部橘色
-(void)drawTopView:(UIView *)view
{
    brokeLinkTextField = [PushYuanChuangTextView new];
    [view addSubview:brokeLinkTextField];
    [brokeLinkTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.left.equalTo(view.mas_left).offset(17);
        make.right.equalTo(view.mas_right).offset(-17);
        make.height.offset(37);
    }];
    brokeLinkTextField.backgroundColor = [UIColor whiteColor];
    brokeLinkTextField.font = [UIFont systemFontOfSize:15.f];
    brokeLinkTextField.PlaceholderText = @"链接商品链接到此处";
    brokeLinkTextField.layer.masksToBounds = YES;
    brokeLinkTextField.layer.borderWidth = 1;
    brokeLinkTextField.layer.borderColor = [UIColor colorWithHexString:@"#DEDEDE"].CGColor;
    brokeLinkTextField.layer.cornerRadius = 3.f;
    [brokeLinkTextField setDelegate:self];
    
    
    UILabel *lbtext = [[UILabel alloc] init];
    [lbtext setNumberOfLines:0];
    [lbtext setText:@"目前只支持6pm、美国亚马逊、ebay、finishline、new、puma官网、banlance奥莱工厂店、jomashop、escentual。chemistwarehouse更多网站持续开发中。"];
    [lbtext setTextColor:[UIColor whiteColor]];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbtext];
    [lbtext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(brokeLinkTextField);
        make.top.equalTo(brokeLinkTextField.mas_bottom).offset(10);
    }];
    
    
    UIButton *btnext = [[UIButton alloc] init];
    [btnext setTitle:@"下一步" forState:UIControlStateNormal];
    [btnext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnext.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnext.layer setMasksToBounds:YES];
    [btnext.layer setCornerRadius:3];
    [btnext setBackgroundColor:RGB(255, 155, 89)];
    [btnext addTarget:self action:@selector(newxtAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnext];
    [btnext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(45);
        make.width.offset(130*kScale);
        make.top.equalTo(lbtext.mas_bottom).offset(20);
        make.centerX.equalTo(view);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btnext.mas_bottom).offset(30);
    }];
    
    
}

///1什么是自助？
-(void)drawOneItem:(UIView *)view
{
    UILabel *lbtitle = [[UILabel alloc] init];
    [lbtitle setTextColor:RGB(30, 30, 30)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:15]];
    [lbtitle setText:@"1、什么是自助代购？"];
    [view addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.top.offset(20);
        make.height.offset(30);
        make.right.equalTo(view.mas_right).offset(-17);
    }];
    
    
    UILabel *lbtext = [[UILabel alloc] init];
    [lbtext setTextColor:RGB(80, 80, 80)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [lbtext setNumberOfLines:0];
    [lbtext setText:@"为更好的提供代购服务，没得比特别推出自助代购业务，即比比可直接提交商品链接，输入争取的基础信息，代购菌收到订单计算运费后，用户支付商品价格和运费即可。"];
    [view addSubview:lbtext];
    [lbtext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lbtitle);
        make.top.equalTo(lbtitle.mas_bottom).offset(10);
    }];
    
    NSArray *arrtitle = @[@"挑选商品\n复制链接",@"提交订单并支付",@"代购菌确认订单并下单",@"坐等收货"];
    
    UIView *lastvalue = lbtext;
    UIView *viewone = [self drawOneItemLiuCheng:arrtitle[0] andsuperview:view];
    [viewone mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lastvalue);
        make.top.equalTo(lastvalue.mas_bottom).offset(10);
        
    }];
    lastvalue = viewone;
    UIImageView *imagevone = [self drawItemImageView:view];
    [imagevone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastvalue.mas_right).offset(8);
        make.centerY.equalTo(lastvalue);
    }];
    int itemp = 1;
    for(int i = 1 ; i < arrtitle.count; i++)
    {
        UIView *viewtwo = [self drawOneItemLiuCheng:arrtitle[i] andsuperview:view];
        if(137+120*itemp>kMainScreenW-17)
        {
            itemp=0;
            [viewtwo mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(lbtext.mas_left);
                make.top.equalTo(lastvalue.mas_bottom).offset(20);
            }];
            lastvalue = viewtwo;
            if(i<arrtitle.count-1)
            {
                UIImageView *imagevtwo = [self drawItemImageView:view];
                [imagevtwo mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastvalue.mas_right).offset(8);
                    make.centerY.equalTo(lastvalue);
                }];
            }
        }
        else
        {
            [viewtwo mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(lastvalue.mas_right).offset(30);
                make.top.equalTo(lastvalue);
            }];
            lastvalue = viewtwo;
            if(i<arrtitle.count-1)
            {
                UIImageView *imagevtwo = [self drawItemImageView:view];
                [imagevtwo mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastvalue.mas_right).offset(8);
                    make.centerY.equalTo(lastvalue);
                }];
            }
        }
        itemp++;
        
    }
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastvalue.mas_bottom).offset(20);
    }];
    
}

-(UIView *)drawOneItemLiuCheng:(NSString *)strvalue andsuperview:(UIView *)superview
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:RGB(254, 243, 235)];
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:3];
    [view.layer setBorderColor:RadMenuColor.CGColor];
    [view.layer setBorderWidth:1];
    [superview addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(90);
        make.height.offset(60);
    }];
    
    UILabel *lbvalue = [[UILabel alloc] init];
    [lbvalue setTextColor:RadMenuColor];
    [lbvalue setTextAlignment:NSTextAlignmentCenter];
    [lbvalue setFont:[UIFont systemFontOfSize:13]];
    [lbvalue setNumberOfLines:0];
    [lbvalue setText:strvalue];
    [view addSubview:lbvalue];
    [lbvalue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.equalTo(view);
        make.right.equalTo(view.mas_right).offset(-10);
    }];
    
    return view;
}

-(UIImageView *)drawItemImageView:(UIView *)superview
{
    UIImageView *imagev = [[UIImageView alloc] init];
    [imagev setImage:[UIImage imageNamed:@"zizhudaigoujiantou"]];
    [imagev setContentMode:UIViewContentModeScaleAspectFit];
    [superview addSubview:imagev];
    [imagev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(14);
        make.height.offset(12);
    }];
    return imagev;
}

-(void)drawTwo:(UIView *)view
{
    UILabel *lbtitle = [[UILabel alloc] init];
    [lbtitle setTextColor:RGB(30, 30, 30)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:15]];
    [lbtitle setText:@"2、目前支持的网站"];
    [view addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.top.offset(20);
        make.height.offset(30);
        make.right.equalTo(view.mas_right).offset(-17);
    }];
    
    
    UILabel *lbtext = [[UILabel alloc] init];
    [lbtext setTextColor:RGB(80, 80, 80)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [lbtext setNumberOfLines:0];
    [lbtext setText:@"目前只支持6pm、美国亚马逊、ebay、iherb、jomashop、puma官网、eastbay、new balance奥莱工厂店。"];
    [view addSubview:lbtext];
    [lbtext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lbtitle);
        make.top.equalTo(lbtitle.mas_bottom).offset(10);
    }];
    
    NSArray *arrvalue = @[@"",@"",@"",@"",@"",@"",@"",@""];
    __block int itemp = 0;
    UIView *lastvalue = lbtext;
    float fitemw = (kMainScreenW-74)/3.0;
    for(int i = 0 ; i < arrvalue.count; i++)
    {
        UIImageView *imgvtemp = [[UIImageView alloc] init];
        [imgvtemp setBackgroundColor:[UIColor grayColor]];
        [imgvtemp.layer setMasksToBounds:YES];
        [imgvtemp.layer setCornerRadius:3];
        [imgvtemp.layer setBorderColor:RGB(245, 245, 245).CGColor];
        [imgvtemp.layer setBorderWidth:1];
        [view addSubview:imgvtemp];
        [imgvtemp mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i==0)
            {
                make.left.equalTo(lbtext.mas_left);
                make.top.equalTo(lbtext.mas_bottom).offset(10);
            }
            else
            {
                if(17+(fitemw+20)*itemp>kMainScreenW-17)
                {
                    make.left.equalTo(lbtext.mas_left);
                    make.top.equalTo(lastvalue.mas_bottom).offset(15);
                    itemp=0;
                }
                else
                {
                    make.left.equalTo(lastvalue.mas_right).offset(20);
                    make.top.equalTo(lastvalue);
                }
            }
            make.width.offset(fitemw);
            make.height.offset(fitemw*0.6);
        }];
        lastvalue = imgvtemp;
        itemp++;
    }
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastvalue.mas_bottom).offset(20);
    }];
}


-(void)noInfoView
{
    lbnoInfo = [[UILabel alloc] init];
    [lbnoInfo setText:@"无法获取到商品信息，请检查链接后重试"];
    [lbnoInfo setTextColor:[UIColor redColor]];
    [lbnoInfo setTextAlignment:NSTextAlignmentCenter];
    [lbnoInfo setFont:[UIFont systemFontOfSize:13]];
    [viewzizu addSubview:lbnoInfo];
    [lbnoInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewzizu);
        make.top.offset(5);
    }];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(disNoInfo) userInfo:nil repeats:NO];
}
-(void)disNoInfo
{
    [lbnoInfo removeFromSuperview];
}
#pragma mark - 下一步
-(void)newxtAction
{
//    ///没有数据要显示这个东东
//    [self noInfoView];
    
//    ////
//    ZiZhuInForListTableViewController *zvc = [[ZiZhuInForListTableViewController alloc] init];
//    [self.viewController.navigationController pushViewController:zvc animated:YES];
    
    
    ////
    ZiZhuInForViewController *zvc = [[ZiZhuInForViewController alloc] init];
    [self.viewController.navigationController pushViewController:zvc animated:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    [brokeLinkTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        NSString *str = textView.text;
        float fheight = [MDB_UserDefault countTextSize:CGSizeMake(brokeLinkTextField.width, 200) andtextfont:brokeLinkTextField.font andtext:str].height+15;
        if(fheight>120)
        {
            fheight=120;
        }
        if(fheight<37)
        {
            make.height.offset(37);
        }
        else
        {
            make.height.offset(fheight);
        }
        
    }];
}


@end
