//
//  MyInformMainModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/16.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyInformMainModel : NSObject
@property (nonatomic , retain) NSString *con;
@property (nonatomic , retain) NSString *content;
@property (nonatomic , retain) NSString *createtime;
@property (nonatomic , retain) NSString *fromid;
@property (nonatomic , retain) NSString *fromtype;
@property (nonatomic , retain) NSString *did;
@property (nonatomic , retain) NSString *isdelete;
@property (nonatomic , retain) NSString *isread;
@property (nonatomic , retain) NSString *relatenickname;
@property (nonatomic , retain) NSString *relatephoto;
@property (nonatomic , retain) NSString *relateuserid;

@property (nonatomic , retain) NSString *sysmsgid;
@property (nonatomic , retain) NSString *tonickname;
@property (nonatomic , retain) NSString *touserid;
@property (nonatomic , retain) NSString *ispm;

///所有信息
@property (nonatomic , retain) NSDictionary *dicall;
///是否点击
@property (nonatomic , assign) BOOL isselect;

+(MyInformMainModel *)dicvalueChange:(NSDictionary *)value;

+(NSMutableDictionary *)modelvalueChange:(MyInformMainModel *)model;

@end

NS_ASSUME_NONNULL_END
