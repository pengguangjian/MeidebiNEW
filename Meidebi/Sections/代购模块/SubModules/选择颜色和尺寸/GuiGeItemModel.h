//
//  GuiGeItemModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/11/15.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuiGeItemModel : NSObject

@property (nonatomic , retain) NSString *strid;

@property (nonatomic , retain) NSString *strname;

///颜色规格才有的参数
@property (nonatomic , retain) NSString *strcolor;

+(GuiGeItemModel *)geigeDicValue:(NSDictionary *)dic;

@end
