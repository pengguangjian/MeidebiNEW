//
//  ZheXianTuView.m
//  ZheXianTu
//
//  Created by mdb-losaic on 2019/2/26.
//  Copyright © 2019年 mcxzfa. All rights reserved.
//

#import "ZheXianTuView.h"


#define MARGIN 40


@interface ZheXianTuView ()
{
    CGRect myFrame;
    
}



@end



@implementation ZheXianTuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//初始化画布
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame])
    {
        //背景视图
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backView.backgroundColor =  [UIColor whiteColor];
        [self addSubview:backView];
        myFrame = frame;
    }
    return self;
}
/*
 /////画折线图
 *targetValues 所有的值 createtime：price：
 
 */
-(void)drawLineChartViewWithValues:(NSMutableArray *)targetValues
{
    NSMutableArray *arrvalue = [NSMutableArray new];
    NSMutableArray *arrtime = [NSMutableArray new];
    float fbig=0;
    float fsmill=0;
    float fstatebig = 0;
    float fstatesmill = 0;
    for(NSDictionary *dicvalue in targetValues)
    {
        [arrvalue addObject:[dicvalue objectForKey:@"price"]];
        [arrtime addObject:[dicvalue objectForKey:@"createtime"]];
        if(fbig==0.0&&fsmill==0.0)
        {
            fbig = [[dicvalue objectForKey:@"price"] floatValue];
            fsmill = [[dicvalue objectForKey:@"price"] floatValue];
        }
        if([[dicvalue objectForKey:@"price"] floatValue] > fbig)
        {
            fbig = [[dicvalue objectForKey:@"price"] floatValue];
        }
        
        if([[dicvalue objectForKey:@"price"] floatValue] < fsmill)
        {
            fsmill = [[dicvalue objectForKey:@"price"] floatValue];
        }
        
    }
    fstatebig = fbig;
    fstatesmill = fsmill;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //1.Y轴、X轴的直线
    [path moveToPoint:CGPointMake(MARGIN+10, 10)];
    [path addLineToPoint:CGPointMake(MARGIN+10, CGRectGetHeight(myFrame)-35)];
    
    //X轴
    [path moveToPoint:CGPointMake(MARGIN+10, CGRectGetHeight(myFrame)-35)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-10, CGRectGetHeight(myFrame)-35)];
    
    //5.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
    
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    ///横间距值
    float fjianjux = (CGRectGetWidth(myFrame)-MARGIN-30)/(arrvalue.count-1);
    //Y轴细线
    for(int i = 0 ; i < arrvalue.count; i++)
    {
        [path1 moveToPoint:CGPointMake(MARGIN+10+fjianjux*i, 10)];
        [path1 addLineToPoint:CGPointMake(MARGIN+10+fjianjux*i, CGRectGetHeight(myFrame)-35)];
        
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN+10+fjianjux*i-50, CGRectGetHeight(myFrame)-30, 60, 15)];
        textLabel.text = arrtime[i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
        textLabel.transform = CGAffineTransformRotate(self.transform, -M_1_PI);
        [self addSubview:textLabel];
    }
    
    //X轴细线
    ///每个像素的值
    float fone = (fbig-fsmill)/(CGRectGetHeight(myFrame)-45);
    ///竖间距值
    int ijianju = [[self decimalwithFormat:@"0.0" floatV:fone] floatValue]*30;
    int ijianjutemp = [[self decimalwithFormat:@"0" floatV:fone*30] intValue];
    ijianju = ijianju==0?ijianjutemp*2||1:ijianju;
    int imaxY = (int)fbig%ijianju;
    int iminY = (int)fsmill%ijianju;
    
    fbig = fbig-(imaxY==0?0:imaxY-ijianju);
    if(fbig-(int)fbig>0)
    {
        fbig+=ijianju;
    }
    fbig = (int)fbig;
    fsmill = fsmill-(iminY==0?0:iminY);
    fsmill = fsmill>ijianju?fsmill:0;
    if(fsmill-(int)fsmill>0)
    {
        fsmill-=ijianju;
    }
    
    
    
    fsmill = [[self decimalwithFormat:@"0" floatV:fsmill] intValue];
    
    ///多少栏
    int inumsline = (fbig-fsmill)/ijianju+1;
    
    
    if(fsmill+ijianju*(inumsline-1) < fstatebig)
    {
        inumsline+=1;
    }
    
//    if(fsmill+ijianju<fstatebig)
//    {
//        inumsline-=1;
//        fsmill+=ijianju;
//    }
    fbig = fsmill+ijianju*(inumsline-1);
    ///每栏的高度
    float fyone = (CGRectGetHeight(myFrame)-55)/inumsline;
    
    for(int i = 0 ; i < inumsline; i++)
    {
        
        [path1 moveToPoint:CGPointMake(MARGIN+10, CGRectGetHeight(myFrame)-35-fyone*(i+1))];
        [path1 addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-10, CGRectGetHeight(myFrame)-35-fyone*(i+1))];
        
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(myFrame)-35-fyone*(i+1)-8, MARGIN+5, 15)];
        textLabel.text = [NSString stringWithFormat:@"%.2lf",fsmill+ijianju*i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
        [self addSubview:textLabel];
        
        
        
        
    }
    
    //渲染路径
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.path = path1.CGPath;
    shapeLayer1.strokeColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1].CGColor;
    shapeLayer1.fillColor = [UIColor clearColor].CGColor;
    shapeLayer1.borderWidth = 1.0;
    [self.subviews[0].layer addSublayer:shapeLayer1];
    
    ///////////////坐标绘制完成///////////////
    
    //2.获取目标值点坐标
    NSMutableArray *allPoints = [NSMutableArray array];
    for (int i=0; i<arrvalue.count; i++) {
        CGFloat X = MARGIN+10 + fjianjux*i;
        CGFloat Y = CGRectGetHeight(myFrame)-35-fyone-(fyone*(inumsline-1)*([arrvalue[i] floatValue]-fsmill)/(fbig-fsmill));
        
        if(fbig==fsmill)
        {
            Y = CGRectGetHeight(myFrame)-35-fyone-([arrvalue[i] floatValue]-fsmill);
        }
        
        CGPoint point = CGPointMake(X,Y);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-1.25, point.y-1.25, 2.5, 2.5) cornerRadius:2.5];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor colorWithRed:47/255.0 green:144/255.0 blue:216/255.0 alpha:1].CGColor;
        layer.fillColor = [UIColor colorWithRed:47/255.0 green:144/255.0 blue:216/255.0 alpha:1].CGColor;
        layer.path = path.CGPath;
        [self.subviews[0].layer addSublayer:layer];
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
        
        
        UILabel *lbvalue = [[UILabel alloc] initWithFrame:CGRectMake(X, Y, 50, 20)];
        [lbvalue setText:arrvalue[i]];
        [lbvalue setTextColor:[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1]];
        [lbvalue setTextAlignment:NSTextAlignmentCenter];
        [lbvalue setFont:[UIFont systemFontOfSize:8]];
        [lbvalue sizeToFit];
        [self.subviews[0] addSubview:lbvalue];
        if(i!=0)
        {
            [lbvalue setCenter:CGPointMake(X, Y-lbvalue.frame.size.height)];
        }
    }
    
    
    //3.坐标连线
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:[allPoints[0] CGPointValue]];
    for (int i =1; i<allPoints.count; i++) {
        CGPoint point = [allPoints[i] CGPointValue];
        [path2 addLineToPoint:point];
    }
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.path = path2.CGPath;
    shapeLayer2.strokeColor = [UIColor colorWithRed:47/255.0 green:144/255.0 blue:216/255.0 alpha:1].CGColor;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.borderWidth = 2.0;
    [self.subviews[0].layer addSublayer:shapeLayer2];
    
    
    ////填充
    CGPoint pointfirst = CGPointMake(MARGIN+10, CGRectGetHeight(myFrame)-35);
    CGPoint pointlast = CGPointMake(CGRectGetWidth(myFrame)-20, CGRectGetHeight(myFrame)-35);
    [allPoints addObject:[NSValue valueWithCGPoint:pointlast]];
    [allPoints insertObject:[NSValue valueWithCGPoint:pointfirst] atIndex:0];
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:[allPoints[0] CGPointValue]];
    for (int i =1; i<allPoints.count; i++) {
        CGPoint point = [allPoints[i] CGPointValue];
        [path3 addLineToPoint:point];
    }
    CAShapeLayer *shapeLayer3 = [CAShapeLayer layer];
    shapeLayer3.path = path3.CGPath;
    shapeLayer3.strokeColor = [UIColor clearColor].CGColor;
    shapeLayer3.fillColor = [UIColor colorWithRed:47/255.0 green:144/255.0 blue:216/255.0 alpha:0.15].CGColor;
    shapeLayer3.borderWidth = 1.0;
    [self.subviews[0].layer addSublayer:shapeLayer3];
    
}


//格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

@end
