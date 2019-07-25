//
//  Qqshare.h
//  Meidebi
//
//  Created by 杜非 on 15/3/25.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Qqshare : NSObject

@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSString *qqsharecontent;
@property(nonatomic,strong)NSString *qqsharetitle;
@property(nonatomic,strong)NSString *qqshareuserdefaultword;
@property(nonatomic,strong)NSString *qqweibocontent;
@property(nonatomic,strong)NSString *sinaweibocontent;
@property(nonatomic,strong)NSString *url;
///小程序链接地址
@property(nonatomic,strong)NSString *applet_url;
- (id)initWithdic:(NSDictionary *)dic;


@end
