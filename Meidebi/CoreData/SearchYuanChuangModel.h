//
//  SearchYuanChuangModel.h
//  Meidebi
//  搜索原创model
//  Created by mdb-losaic on 2018/3/12.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchYuanChuangModel : NSObject

///id
@property (nonatomic , retain) NSString *strid;
///图标
@property (nonatomic , retain) NSString *strpicurl;

///标题
@property (nonatomic , retain) NSString *strtitle;

///描述
@property (nonatomic , retain) NSString *strcontent;

@property (nonatomic , assign) BOOL isSelect;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
