//
//  ProductInfoQiuKaiTuanView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/10.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "ProductInfoQiuKaiTuanView.h"

#import "PushYuanChuangTextView.h"
#import "MDB_UserDefault.h"
#import "ProductInfoViewController.h"

@interface ProductInfoQiuKaiTuanView ()
{
    
    UIView *viewback;
    
    PushYuanChuangTextView *textview;
    
    ///同款现货
    UIScrollView *scvTk;
    
    NSMutableArray *arrdata;
    
}

@end

@implementation ProductInfoQiuKaiTuanView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame andtype:(int)ftype
{
    if(self= [super initWithFrame:frame])
    {
        
        [self setBackgroundColor:RGBAlpha(0, 0, 0, 0.4)];
        UITapGestureRecognizer *tapview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiskeyb)];
        [self addGestureRecognizer:tapview];
        
        UIScrollView *scvback = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 0, self.width-30, 305)];
        [self addSubview:scvback];
        [scvback.layer setMasksToBounds:YES];
        [scvback.layer setCornerRadius:5];
        [scvback setShowsVerticalScrollIndicator:NO];
        [scvback setCenter:CGPointMake(BOUNDS_WIDTH/2.0, BOUNDS_HEIGHT/2.0-50*kScale)];
        
        UIView *viewmeng = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH-30, 305)];
//        viewmeng.layer.shadowColor = [UIColor blackColor].CGColor;
//        viewmeng.layer.shadowOpacity = 0.8f;
//        viewmeng.layer.shadowOffset = CGSizeMake(0,4);
//        viewmeng.layer.shadowRadius = 5;
        [scvback addSubview:viewmeng];
        
        viewback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewmeng.width, viewmeng.height)];
        [viewback setBackgroundColor:[UIColor whiteColor]];
        [viewback.layer setMasksToBounds:YES];
        [viewback.layer setCornerRadius:5];
        [viewmeng addSubview:viewback];
        float fbottom = 0;
        if(ftype==1)
        {
            UILabel *lbtk = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewback.width, 60)];
            [lbtk setText:@"咦？好像有同款现货吖"];
            [lbtk setTextColor:RGB(0, 0, 0)];
            [lbtk setTextAlignment:NSTextAlignmentCenter];
            [lbtk setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
            [viewback addSubview:lbtk];
            
            scvTk = [[UIScrollView alloc] initWithFrame:CGRectMake(15, lbtk.bottom, viewback.width-30, (viewback.width-30)/2.4+65)];
            [scvTk setShowsHorizontalScrollIndicator:NO];
            [viewback addSubview:scvTk];
            
            fbottom = scvTk.bottom;
        }
        
        UILabel *lbtop = [[UILabel alloc] initWithFrame:CGRectMake(0, fbottom, viewback.width, 60)];
        [lbtop setText:@"想要这款，求开团"];
        if(ftype==1)
        {
            [lbtop setText:@"没有想要的？求开团"];
        }
        [lbtop setTextColor:RGB(0, 0, 0)];
        [lbtop setTextAlignment:NSTextAlignmentCenter];
        [lbtop setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        [viewback addSubview:lbtop];
        
        UILabel *lbtop1 = [[UILabel alloc] initWithFrame:CGRectMake(15, lbtop.bottom, viewback.width-30, 60)];
        [lbtop1 setText:@"代购菌收到后会尽快处理哦，请随时关注APP代购频道，以免错过~"];
        [lbtop1 setNumberOfLines:2];
        [lbtop1 setTextColor:RGB(100, 100, 100)];
        [lbtop1 setTextAlignment:NSTextAlignmentLeft];
        [lbtop1 setFont:[UIFont systemFontOfSize:13]];
        [lbtop1 sizeToFit];
        [viewback addSubview:lbtop1];
        
        
        UILabel *lbtop2 = [[UILabel alloc] initWithFrame:CGRectMake(15, lbtop1.bottom+15, viewback.width-30, 30)];
        [lbtop2 setText:@"给代购菌留言？"];
        [lbtop2 setTextColor:RGB(0, 0, 0)];
        [lbtop2 setTextAlignment:NSTextAlignmentLeft];
        [lbtop2 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
        [viewback addSubview:lbtop2];
        
        
        textview = [[PushYuanChuangTextView alloc] initWithFrame:CGRectMake(15, lbtop2.bottom, viewback.width-30, 90)];
        if(ftype==1)
        {
            [textview setHeight:40];
        }
        [textview setTextColor:RGB(80, 80, 80)];
        [textview setFont:[UIFont systemFontOfSize:13]];
        [textview setPlaceholderText:@"请输入想要对代购菌说的话吧......（选填）"];
        [textview setBackgroundColor:RGB(249, 249, 249)];
        [textview.layer setBorderColor:RGB(210, 210, 210).CGColor];
        [textview.layer setBorderWidth:1];
        [viewback addSubview:textview];
        
        
        NSArray *arrbtt = [NSArray arrayWithObjects:@"确认",@"取消", nil];
        for(int i = 0 ; i  <arrbtt.count; i++)
        {
            UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, textview.bottom+15, 90*kScale, 40)];
            [bt setTitle:arrbtt[i] forState:UIControlStateNormal];
            [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bt.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [bt setTag:i];
            [bt.layer setMasksToBounds:YES];
            [bt.layer setCornerRadius:3];
            [bt addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
            if(i == 0)
            {
                [bt setBackgroundColor:RadMenuColor];
                [bt setCenterX:viewback.width/2.0/2.0+viewback.width/2.0/2.0*0.1];
            }
            else
            {
                [bt setBackgroundColor:RGB(178, 178, 178)];
                [bt setCenterX:viewback.width/2.0/2.0*3-viewback.width/2.0/2.0*0.1];
            }
            
            [viewback addSubview:bt];
        }
        if(ftype==1)
        {
            [scvback setHeight:305+fbottom-50];
            if(scvback.height>self.height*0.8)
            {
                [scvback setHeight:self.height*0.8];
            }
            [scvback setCenter:CGPointMake(BOUNDS_WIDTH/2.0, BOUNDS_HEIGHT/2.0-50*kScale)];
            [scvback setContentSize:CGSizeMake(0, 305+fbottom-50)];
            [viewmeng setHeight:305+fbottom-50];
            [viewback setHeight:viewmeng.height];
        }
        
    }
    return self;
}

-(void)drawTkItems:(NSMutableArray *)arritems
{
    arrdata = arritems;
    float fright = 0;
    for(int i = 0 ; i < arritems.count; i++)
    {
        if(i>3)break;
        
        UIView *viewitem = [self tkitem:arritems[i] andframe:CGRectMake((scvTk.width/2.4+10)*i, 0, scvTk.width/2.4, 100)];
        [scvTk addSubview:viewitem];
        [viewitem setTag:i];
        [viewitem setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapitem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTkAction:)];
        [viewitem addGestureRecognizer:tapitem];
        fright = viewitem.right;
    }
    [scvTk setContentSize:CGSizeMake(fright, 0)];
}

-(UIView *)tkitem:(NSDictionary *)value andframe:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:RGBAlpha(247, 247, 247, 1)];
    ///
    UIView *viewimage = [[UIView alloc] initWithFrame:CGRectMake(5, 5, view.width-10, view.width-10)];
    [viewimage setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:viewimage];
    UIImageView *imgvh = [[UIImageView alloc] initWithFrame:CGRectMake(viewimage.width*0.1, viewimage.width*0.1, viewimage.width-viewimage.width*0.2, viewimage.width-viewimage.width*0.2)];
    [imgvh setBackgroundColor:[UIColor whiteColor]];
    [viewimage addSubview:imgvh];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvh url:[NSString nullToString:[value objectForKey:@"image"]]];
    [imgvh setContentMode:UIViewContentModeScaleAspectFit];
    
    
    
    
    
    UILabel *lbtit = [[UILabel alloc] initWithFrame:CGRectMake(5, viewimage.bottom, view.width-10, 30)];
    [lbtit setText:[NSString nullToString:[value objectForKey:@"title"]]];
    [lbtit setNumberOfLines:2];
    [lbtit setTextColor:RGB(100, 100, 100)];
    [lbtit setTextAlignment:NSTextAlignmentLeft];
    [lbtit setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbtit];
    
    UILabel *lbprice = [[UILabel alloc] initWithFrame:CGRectMake(5, lbtit.bottom, view.width-10, 20)];
    [lbprice setText:[NSString stringWithFormat:@"￥%@",[self reviseString:[NSString nullToString:[value objectForKey:@"price"]]]]];
    [lbprice setTextColor:RGB(224, 40, 40)];
    [lbprice setTextAlignment:NSTextAlignmentLeft];
    [lbprice setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbprice];
    
    
//    UILabel *lbshop = [[UILabel alloc] initWithFrame:CGRectMake(lbprice.right, lbtit.bottom, lbprice.width, 20)];
//    [lbshop setText:[NSString nullToString:[value objectForKey:@"site_name"]]];///
//    [lbshop setTextColor:RGB(100, 100, 100)];
//    [lbshop setTextAlignment:NSTextAlignmentLeft];
//    [lbshop setFont:[UIFont systemFontOfSize:11]];
//    [view addSubview:lbshop];
    
    [view setHeight:lbprice.bottom+10];
    
    return view;
}


-(NSString *)reviseString:(NSString *)str
{
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [str doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
    
}

-(void)dismiskeyb
{
    [textview resignFirstResponder];
}

-(void)btAction:(UIButton *)sender
{
    [textview resignFirstResponder];
    if(sender.tag== 0)
    {
        
        [self.delegate qiukaituanAction:textview.text];
        
    }
    [self removeFromSuperview];
    
}

-(void)itemTkAction:(UIGestureRecognizer *)gesture
{
    NSDictionary *dicvalue = arrdata[gesture.view.tag];
    NSString *shareid = [NSString nullToString:[dicvalue objectForKey:@"share_id"]];
    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
    pvc.productId = shareid;
    [self.viewController.navigationController pushViewController:pvc animated:YES];
}

@end
