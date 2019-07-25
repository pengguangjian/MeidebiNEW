//
//  PusnYuanChuangItemModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/5.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PusnYuanChuangItemModel : NSObject
////图片image 视频video    商品卡片goodscard   超链接link
@property (nonatomic , retain) NSString *strtype;

@property (nonatomic , retain) NSString *strid;

///图片
@property (nonatomic , retain) NSString *strimageurl;
@property (nonatomic , retain) UIImage *image;

///视频连接
@property (nonatomic , retain) NSString *strvideourl;

@property (nonatomic , assign) BOOL isvideo;

///描述
@property (nonatomic , retain) NSString *strcontent;

////链接卡片
@property (nonatomic , retain) NSString *strtitle;
@property (nonatomic , retain) NSString *strprice;
@property (nonatomic , retain) NSString *strsitename;
@property (nonatomic , retain) NSString *strlinetype;
@property (nonatomic , retain) NSString *strlineurl;


////链接卡片处理
+(id)viewmodellinedata:(NSDictionary *)dicpush;

+(id)viewmodeldata:(NSDictionary *)dicvalue;

@end
