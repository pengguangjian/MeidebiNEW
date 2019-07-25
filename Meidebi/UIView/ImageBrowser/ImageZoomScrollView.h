//
//  ImageZoomScrollView.h
//  Meidebi
//
//  Created by mdb-admin on 16/6/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageZoomScrollView : UIView

/** imgUrl  图像地址*/
@property (nonatomic, copy) NSString *imgUrl;


//图片的大小
@property (nonatomic, assign) CGSize imgSize;
//图片
@property (nonatomic, strong) UIImage *image;




@property (nonatomic,copy) void (^RemoveView)();

@end
