//
//  SelectGuiGeDataControl.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/11/15.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectGuiGeDataControl : NSObject

@property (nonatomic , retain) NSDictionary *resultDict;

@property (nonatomic , retain) NSDictionary *resultItemDict;

// 获取规格数据
- (void)requestGuiGeAllDataLine:(NSDictionary *)dicpush
                             InView:(UIView *)view
                           Callback:(completeCallback)callback;

// 获取对应具体规格数据
- (void)requestGuiGeItemDataLine:(NSDictionary *)dicpush
                         InView:(UIView *)view
                       Callback:(completeCallback)callback;

-(void)cancleRequest;

@end
