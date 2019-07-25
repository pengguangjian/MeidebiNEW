//
//  BrokeInfoViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, BrokeType) {
    BrokeTypeSimply,
    BrokeTypeActivity
};
@interface BrokeInfoViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *linkImgeLink;
@property (nonatomic, strong, readonly) NSString *proprice;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *token;
@property (nonatomic, strong, readonly) NSString *session;
@property (nonatomic, strong, readonly) NSString *linkurl;
///货币符号
@property (nonatomic, strong) NSString *coinsign;
///汇率
@property (nonatomic, strong) NSString *exchange;
@property (nonatomic, strong, readonly) NSArray *tags;
@property (nonatomic, assign, readonly) BrokeType type;

+ (BrokeInfoViewModel *)viewModelWithSubjects:(NSDictionary *)dict;
- (void)updateImageLinkWithNewLink:(NSString *)link;
@end
