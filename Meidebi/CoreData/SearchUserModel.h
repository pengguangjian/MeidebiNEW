//
//  SearchUserModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/12.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchUserModel : NSObject
typedef enum GUANZHUTYPE
{
    GUANZHUTYPEa = 0,     ///未关注
    GUANZHUTYPEb = 1      ///已关注
    
} guanZhuType;

///id
@property (nonatomic , retain) NSString *strid;
///关注
@property (nonatomic , assign) guanZhuType type;
///图标
@property (nonatomic , retain) NSString *strpicurl;
///名字
@property (nonatomic , retain) NSString *strname;
///粉丝数量
@property (nonatomic , retain) NSString *strfsnumber;
///关注数量
@property (nonatomic , retain) NSString *strgznumber;

@property (nonatomic , assign) BOOL isSelect;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
