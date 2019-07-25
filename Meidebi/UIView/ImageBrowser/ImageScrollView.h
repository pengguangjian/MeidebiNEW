//
//  ImageScrollView.h
//  Meidebi
//
//  Created by mdb-admin on 16/6/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIView

@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, strong) NSArray *imgUrlArr;

//图片的大小
@property (nonatomic, assign) CGSize imgSize;
//图片
@property (nonatomic, strong) UIImage *image;




+ (ImageScrollView *)showImageWithImageArr:(NSArray *)urlArr;

@end
