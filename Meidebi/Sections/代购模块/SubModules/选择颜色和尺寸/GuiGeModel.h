//
//  GuiGeModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/11/15.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GuiGeItemModel.h"

@interface GuiGeModel : NSObject

@property (nonatomic , retain) NSString *strid;

@property (nonatomic , retain) NSString *strname;
////1是颜色图片  2的话 是色号 0的话 没有 colorcodes 这个值
@property (nonatomic , retain) NSString *strspecvaltype;

@property (nonatomic , retain) NSMutableArray *arritem;

@property (nonatomic , retain) NSString *purchased_nums;

+(GuiGeModel *)geigeDicValue:(NSDictionary *)dic;


@end
