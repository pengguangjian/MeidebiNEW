//
//  DaiGouPinDanTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/27.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouPinDanTableViewCell.h"

#import "PinDanAlterView.h"

#import "MDB_UserDefault.h"

#import "PinDanAlterDataController.h"

#import "ProductInfoDataController.h"

#import "VKLoginViewController.h"

@interface DaiGouPinDanTableViewCell()<UIAlertViewDelegate>
{
    UIView *viewback;
    UIImage *imgline;
    UIImageView *imgvline;
    UIImageView *imgvheader;
    UILabel *lbname;
    UILabel *lblitpeople;
    UILabel *lbtime;
    UIButton *btpdAction;
    
    PinDanAlterDataController *dataControl;
    
    ProductInfoDataController *InfodataControl;
}
@end


@implementation DaiGouPinDanTableViewCell

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
        viewback = [[UIView alloc] initWithFrame:CGRectZero];
        [viewback setBackgroundColor:[UIColor clearColor]];
        
        imgvline = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        imgvheader = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imgvheader.layer setMasksToBounds:YES];
        
        lbname = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbname setTextColor:RGB(102, 102, 102)];
        [lbname setTextAlignment:NSTextAlignmentLeft];
        [lbname setFont:[UIFont systemFontOfSize:12]];
        
        lblitpeople = [[UILabel alloc] initWithFrame:CGRectZero];
        [lblitpeople setTextColor:RGB(102, 102, 102)];
        [lblitpeople setTextAlignment:NSTextAlignmentCenter];
        [lblitpeople setFont:[UIFont systemFontOfSize:10]];
        
        lbtime = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbtime setTextColor:RGB(102, 102, 102)];
        [lbtime setTextAlignment:NSTextAlignmentCenter];
        [lbtime setFont:[UIFont systemFontOfSize:10]];
        
        
        btpdAction = [[UIButton alloc] initWithFrame:CGRectZero];
        [btpdAction.layer setBorderColor:RGB(239,118,19).CGColor];
        [btpdAction.layer setBorderWidth:1];
        [btpdAction.layer setMasksToBounds:YES];
        [btpdAction setTitle:@"我要拼单" forState:UIControlStateNormal];
        [btpdAction setTitleColor:RGB(239,118,19) forState:UIControlStateNormal];
        [btpdAction.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btpdAction addTarget:self action:@selector(pinDanAction) forControlEvents:UIControlEventTouchUpInside];
        
        dataControl = [[PinDanAlterDataController alloc] init];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [viewback setFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.contentView addSubview:viewback];
    
    
    [imgvline setFrame:CGRectMake(10, 0, viewback.width-20, 2)];
    [imgvline setImage:[self drawlineByImageView:imgvline]];
    [viewback addSubview:imgvline];
    
    [imgvheader setFrame:CGRectMake(12, 11, 31, 31)];
    [imgvheader.layer setCornerRadius:imgvheader.height/2.0];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvheader url:_model.image];
    [viewback addSubview:imgvheader];
    
    [lbname setFrame:CGRectMake(imgvheader.right+7, 0, 60, viewback.height)];
    [lbname setText:_model.nickname];
    [viewback addSubview:lbname];
    
    [lblitpeople setFrame:CGRectMake(lbname.right, viewback.height/2.0-15, 120, 15)];
    [lblitpeople setText:[NSString stringWithFormat:@"还差%@件成团",_model.remain_pindannum]];
    @try
    {
        [lblitpeople setAttributedText:[self arrstring:lblitpeople.text andstart:2 andend:(int)_model.remain_pindannum.length andfont:10 andcolor:RGB(230, 56, 47)]];
    }
    @finally
    {
        
    }
    
    [viewback addSubview:lblitpeople];
    
    [lbtime setFrame:CGRectMake(lblitpeople.left, lblitpeople.bottom, lblitpeople.width, lblitpeople.height)];
    [lbtime setText:[NSString stringWithFormat:@"%@结束",[MDB_UserDefault strTimefromData:_model0.daiendtime.integerValue dataFormat:nil]]];
    [viewback addSubview:lbtime];
     
    
    
    [btpdAction setFrame:CGRectMake(0, 0, 61, 23)];
    [btpdAction setCenter:viewback.center];
    [btpdAction setRight:viewback.width-12];
    [btpdAction.layer setCornerRadius:2];
    [viewback addSubview:btpdAction];
    
}

-(UIImage *)drawlineByImageView:(UIImageView *)imageView
{
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    
    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {2,2};
    
    CGContextSetStrokeColorWithColor(line, RGB(221,221,221).CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);
    
    CGContextMoveToPoint(line, 0.0, 2.0);
    
    CGContextAddLineToPoint(line, 300, 2.0);
    
    CGContextStrokePath(line);
    
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
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


#pragma mak - 参与拼单
-(void)pinDanAction
{
    
    
    if ([MDB_UserDefault getIsLogin] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        return;
    }
    
    if(InfodataControl == nil)
    {
        InfodataControl = [[ProductInfoDataController alloc] init];
    }
    
    NSString *strgoodsid=[NSString stringWithFormat:@"%@",_model0.goods_id];
    NSString *strpindanid=[NSString stringWithFormat:@"%@",_model.did];
    NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"id":strgoodsid,@"pindanid":strpindanid};
    [InfodataControl requestDGHomeDataInView:self.viewController.view.window dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [self getPinDanMessage];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.viewController.view.window];
        }
    }];
    
    
}

-(void)getPinDanMessage
{
    ////
    [dataControl requestDGHomeDataInView:self.viewController.view pindan_id:_model.did Callback:^(NSError *error, BOOL state, NSString *describle) {
        
        
        PinDanAlterView *pview = [[PinDanAlterView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH, BOUNDS_HEIGHT)];
        pview.dicValue = dataControl.dicreuset;
        pview.dicnextValue = InfodataControl.dicValue;
        [self.viewController.view addSubview:pview];
        [pview drawSubview];
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==111){
        if (buttonIndex==0) {
            
            VKLoginViewController *vkVC = [[VKLoginViewController alloc] init];
            [self.viewController.navigationController pushViewController:vkVC animated:YES];
        }
    }
    
}

@end
