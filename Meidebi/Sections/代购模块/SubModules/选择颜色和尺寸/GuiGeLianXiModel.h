//
//  GuiGeLianXiModel.h
//  Meidebi
//  规格自自检的联系
//  Created by mdb-losaic on 2018/12/7.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuiGeLianXiModel : NSObject

@property (nonatomic , retain) NSString *availability;
////规格之间的关系
@property (nonatomic , retain) NSArray *spec_id;


+(GuiGeLianXiModel *)geigeDicValue:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
