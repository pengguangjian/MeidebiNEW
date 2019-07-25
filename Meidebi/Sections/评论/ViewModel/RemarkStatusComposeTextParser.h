//
//  RemarkStatusComposeTextParser.h
//  Meidebi
//
//  Created by mdb-admin on 2017/2/6.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>
@interface RemarkStatusComposeTextParser : NSObject<YYTextParser>
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightTextColor;
@end
