//
//  PGGCameraLineView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/5/24.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PGGCameraLineView.h"


@interface PGGCameraLineView ()

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end



@implementation PGGCameraLineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    
    CGPoint center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);  //设置圆心位置
    CGFloat radius = rect.size.width/2.0-(12*kScale)/2.0;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //圆终点位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    CGContextSetLineWidth(ctx, 12*kScale); //设置线条宽度
    [[UIColor blueColor] setStroke]; //设置描边颜色
    
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(ctx);  //渲染
    
}

- (void)drawProgress:(CGFloat )progress
{
    _progress = progress;
    [_progressLayer removeFromSuperlayer];
//    [_gradientLayer removeFromSuperlayer];
    [self setNeedsDisplay];
}


@end
