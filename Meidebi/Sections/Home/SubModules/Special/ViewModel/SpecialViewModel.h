//
//  SpecialViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 2017/9/29.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, SpecialSourceStyle) {
    SpecialSourceStyleInner,           // 自己内部
    SpecialSourceStyleTaobao,          // 淘宝
};
@interface SpecialViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *specialID;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *imageLink;
@property (nonatomic, strong, readonly) NSString *hasreward;
@property (nonatomic, strong, readonly) NSString *praisecount;
@property (nonatomic, strong, readonly) NSString *commentcount;
@property (nonatomic, strong, readonly) NSString *browsecount;
@property (nonatomic, strong, readonly) NSString *tbContent;
@property (nonatomic, assign, readonly) SpecialSourceStyle style;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;

@end
