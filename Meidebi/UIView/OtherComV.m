//
//  OtherComV.m
//  Meidebi
//
//  Created by 杜非 on 15/3/13.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "OtherComV.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "MDB_UserDefault.h"
#import "CommentViewController.h"
#import "NSString+extend.h"
@implementation OtherComV
CAGradientLayer *gradient;

-(id)initWithFrame:(CGRect)frame{
    if (self) {
        self=[super initWithFrame:frame];
        labelyin=[self setLabelFrom:CGRectMake(6.0, 6.0, 30.0, 14.0) str:@"引用" color:RadCellBiaoColor];
        [self addSubview:labelyin];
        
        labelname=[self setLabelFrom:CGRectMake(38.0, 5.0, 30.0, 14.0) str:@"月牙" color:RadDaoBiaoColor];
        [self addSubview:labelname];
        
        labelyuan=[self setLabelFrom:CGRectMake(85.0, 6.0, 90.0, 14.0) str:@"发表的原文" color:RadCellBiaoColor];
        [self addSubview:labelyuan];
        
        labelcont=[self setLabelFrom:CGRectMake(6.0, 24.0, frame.size.width-12.0, 14.0) str:@"有人用过吗" color:RadCellBiaoColor];
        [self addSubview:labelcont];
        [self setBackgroundColor:RGB(240.0, 240.0, 240.0)];
    }
    return self;
}
-(UILabel *)setLabelFrom:(CGRect)rect  str:(NSString *)text color:(UIColor *)color{
   UILabel *labely=[[UILabel alloc]initWithFrame:rect];
    labely.textColor=color;
    labely.font=[UIFont systemFontOfSize:14.0];
    if (![text isKindOfClass:[NSNull class]]) {
    labely.text=text;
    }
    return labely;
}
-(void)setWithDic:(Comment *)dic{
    CGSize size;

    size=[MDB_UserDefault getStrWightFont:labelname.font str:[NSString stringWithFormat:@"@%@",[NSString nullToString:dic.refernickname]] hight:labelname.frame.size.height];
    
    CGRect frme=labelname.frame;
    frme.size=size;
    labelname.frame=frme;
    if (![dic.refernickname isKindOfClass:[NSNull class]]) {
        
    labelname.text=[NSString stringWithFormat:@"@%@",dic.refernickname];
    }
    labelyuan.frame=CGRectMake(size.width+frme.origin.x, labelyuan.frame.origin.y, labelyuan.frame.size.width, labelyuan.frame.size.height);
    if (![dic.refercontent isKindOfClass:[NSNull class]]) {
    labelcont.text=dic.refercontent;
     }
    labelcont.frame=CGRectMake(6.0, 24.0, self.frame.size.width-12.0, 14.0);

};









@end
