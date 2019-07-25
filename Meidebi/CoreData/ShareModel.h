//
//  ShareModel.h
//  Meidebi
//
//  Created by mdb-admin on 2017/10/13.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject
@property (nonatomic, strong, readonly) NSString *defaultWord;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *shareImage;
@property (nonatomic, strong, readonly) NSString *content;
@property (nonatomic, strong, readonly) NSString *url;
@property (nonatomic, strong, readonly) NSString *qq_weibocontent;
@property (nonatomic, strong, readonly) NSString *sina_weibocontent;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
