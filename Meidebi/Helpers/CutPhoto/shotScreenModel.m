//
//  shotScreenModel.m
//  截屏
//
//  Created by PYC/Mr.ma on 14-7-7.
//  Copyright (c) 2014年 PYC\MFW. All rights reserved.
//

#import "shotScreenModel.h"

@implementation shotScreenModel
//截全屏
//-(UIImage*)imageFromView:(UIView*)theView andDelegate:(id<passImageDelegate>)delegate
//{
//    
//    self.delegate = delegate;
//    UIGraphicsBeginImageContext(theView.frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [theView.layer renderInContext:context];
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self.delegate passImage:theImage];
//    return theImage;
//    
//}

////根据 rect 截屏
//-(UIImage*)imageFromView:(UIView *)theView atFrame:(CGRect)r andDelegate:(id<passImageDelegate>)delegate
//{  NSLog(@"theview %f %f",theView.width,theView.height);
//    self.delegate = delegate;
//    UIGraphicsBeginImageContext(theView.frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    UIRectClip(r);
//    [theView.layer renderInContext:context];
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self.delegate passImage:theImage];
//    return  theImage;
//}

//根据 rect 截屏//烂
-(UIImage*)imageFromView:(UIImageView *)theView atFrame:(CGRect)r andDelegate:(id<passImageDelegate>)delegate
{    ///NSLog(@"theview %f %f",theView.width,theView.height);
    self.delegate = delegate;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([theView.image CGImage], r);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
 
     NSLog(@"剪裁后 %f %f",subImage.size.width,subImage.size.height);
    if (subImage.size.width>320) {
       subImage= [subImage imageByScalingProportionallyToSize:CGSizeMake(320, 320)];
    }
     NSLog(@"缩小后 %f %f",subImage.size.width,subImage.size.height);
    [self.delegate passImage:subImage];
    return  subImage;
    

}
//-(UIImage*)imageFromView:(UIImageView *)theView atFrame:(CGRect)r andDelegate:(id<passImageDelegate>)delegate{
//    self.delegate = delegate;
//    CGImageRef subImageRef = CGImageCreateWithImageInRect([theView.image CGImage], r);
//    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
//
//    UIGraphicsBeginImageContext(smallBounds.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, smallBounds, subImageRef);
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext();
//    [self.delegate passImage:smallImage];
//    return smallImage;
//}

@end


