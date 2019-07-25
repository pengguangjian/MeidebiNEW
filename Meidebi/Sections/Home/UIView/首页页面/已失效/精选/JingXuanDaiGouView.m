//
//  JingXuanDaiGouView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/21.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "JingXuanDaiGouView.h"

#import "DaiGouHomeViewController.h"

#import "HomeViewModel.h"


#import "MDB_UserDefault.h"

#import "ProductInfoViewController.h"

@implementation JingXuanDaiGouView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubViews];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"yindaohome"] intValue] != 2)
    {
        [viewyindao removeFromSuperview];
        viewyindao = [MDB_UserDefault drawYinDaoLine:CGRectMake(0, 40, self.width/2.0, self.height-40) addview:self andtitel:@"不会海淘？代购戳这里"];
        UITapGestureRecognizer *tapyindao = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disyindaoAction)];
        [viewyindao addGestureRecognizer:tapyindao];
    }

    
}

-(void)disyindaoAction
{
    [viewyindao removeFromSuperview];
    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"yindaohome"];
}


-(void)setupSubViews
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    [self addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.text = @"比比代购";
    [titleLabel sizeToFit];
    [titleLabel setCenter:CGPointMake(self.width/2.0, 0)];
    [titleLabel setTop:10];
    [titleLabel setHeight:20];
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.left-16, titleLabel.center.y, 16, 1)];
    [self addSubview:leftLineView];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.center.y, 16, 1)];
    [self addSubview:rightLineView];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *viewline0 = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+10, self.width, 1)];
    [viewline0 setBackgroundColor:RGB(245,245,245)];
    [self addSubview:viewline0];
    
    UIButton *btdaigou = [[UIButton alloc] initWithFrame:CGRectMake(0, viewline0.bottom, self.width*0.5-0.5, self.height-viewline0.bottom)];
    [self addSubview:btdaigou];
    [btdaigou addTarget:self action:@selector(daigouAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgvdg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, btdaigou.height-30, btdaigou.height-30)];
    [imgvdg setImage:[UIImage imageNamed:@"daigou_main_qic"]];
    [btdaigou addSubview:imgvdg];
    
    
    UILabel *lbtext1 = [[UILabel alloc]initWithFrame:CGRectMake(imgvdg.right+8, imgvdg.top-5, btdaigou.width-imgvdg.right-16, imgvdg.height/3.0)];
    [btdaigou addSubview:lbtext1];
    [lbtext1 setText:@"你下单 我来买"];
    [lbtext1 setTextColor:RGB(51,51,51)];
    [lbtext1 setTextAlignment:NSTextAlignmentCenter];
    [lbtext1 setFont:[UIFont systemFontOfSize:13]];
    
    
    UILabel *lbtext2 = [[UILabel alloc]initWithFrame:CGRectMake(lbtext1.left, lbtext1.bottom+2, lbtext1.width, imgvdg.height/3.0)];
    [btdaigou addSubview:lbtext2];
    [lbtext2 setText:@"代购菌喊你上车了"];
    [lbtext2 setTextColor:RGB(102,102,102)];
    [lbtext2 setTextAlignment:NSTextAlignmentCenter];
    [lbtext2 setFont:[UIFont systemFontOfSize:10]];
    
    
    UILabel *lbtext3 = [[UILabel alloc]initWithFrame:CGRectMake(lbtext1.left, lbtext2.bottom+5, lbtext1.width, 19)];
    [btdaigou addSubview:lbtext3];
    [lbtext3 setText:@"拼团更低价>>"];
    [lbtext3 setTextColor:RGB(255,99,11)];
    [lbtext3 setTextAlignment:NSTextAlignmentCenter];
    [lbtext3.layer setMasksToBounds:YES];
    [lbtext3.layer setCornerRadius:lbtext3.height/2.0];
    [lbtext3.layer setBorderColor:RGB(255,99,11).CGColor];
    [lbtext3.layer setBorderWidth:1];
    [lbtext3 setFont:[UIFont systemFontOfSize:10]];
    
    UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectMake(btdaigou.right, viewline0.bottom, 1, self.height-viewline0.bottom)];
    [viewline1 setBackgroundColor:RGB(245,245,245)];
    [self addSubview:viewline1];
    
    rectdg = CGRectMake(viewline1.right, viewline0.bottom, self.width-viewline1.right, btdaigou.height);
    
}

-(void)binddaigouData:(id)model
{
    if([model isKindOfClass:[NSArray class]])
    {
        NSArray *arr = model;
        if(arr.count > 0)
        {
            HomeDaiGouViewModel *model1 = arr[0];
            [viewcell removeFromSuperview];
            viewcell = nil;
            ///
            viewcell = [self drawDaiGouCell:model1 andframe:rectdg];
            [self addSubview:viewcell];
            strgoodsid = model1.share_id;
            [viewcell setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tapitem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsAction)];
            [viewcell addGestureRecognizer:tapitem];
        }
    }
    
}

-(UIView *)drawDaiGouCell:(HomeDaiGouViewModel *)model andframe:(CGRect)rect
{
    
    UIView *view = [[UIView alloc]initWithFrame:rect];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, view.height*0.6, view.height*0.6)];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:model.imageLink];
    [view addSubview:imgv];
    [imgv setContentMode:UIViewContentModeScaleAspectFit];
    [imgv setCenterY:view.height/2.0];
    [imgv.layer setMasksToBounds:YES];
    [imgv.layer setCornerRadius:imgv.height/2.0];
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(imgv.right+5, imgv.top-5, view.width-imgv.right-15, imgv.height/2.2+5)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setTextColor:RGB(102,102,102)];
    [lbtitle setText:model.title];
    [lbtitle setNumberOfLines:2];
    [lbtitle setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lbtitle];
    
    UILabel *lbprice = [[UILabel alloc] initWithFrame:CGRectMake(lbtitle.left, lbtitle.bottom, lbtitle.width, imgv.height/3.3)];
    [lbprice setTextAlignment:NSTextAlignmentLeft];
    [lbprice setTextColor:RGB(242,70,58)];
    [lbprice setText:[NSString stringWithFormat:@"￥%@",model.price]];
    [lbprice setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbprice];
    
    UILabel *lbother = [[UILabel alloc] initWithFrame:CGRectMake(lbtitle.left, lbprice.bottom, lbtitle.width, imgv.height/3.5)];
    [lbother setTextAlignment:NSTextAlignmentLeft];
    [lbother setTextColor:RGB(153,153,153)];
    [lbother setText:[NSString stringWithFormat:@"已下单%@件",model.purchased_nums]];
    [lbother setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lbother];
    
    
    
    return view;
}

#pragma mark - 代购主页
-(void)daigouAction
{
    
    DaiGouHomeViewController *dvc = [[DaiGouHomeViewController alloc] init];
    
    [self.viewController.navigationController pushViewController:dvc animated:YES];
    
}

#pragma mark - 代购商品点击
-(void)goodsAction
{
    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
    pvc.productId = strgoodsid;
    [self.viewController.navigationController pushViewController:pvc animated:YES];
    
}

@end
