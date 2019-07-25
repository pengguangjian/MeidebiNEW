//
//  FilterTypeDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2016/11/22.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterTypeDataController : NSObject

@property (nonatomic, readonly, strong) NSArray *resultArray;


- (void)requestFilterTypeDataWithView:(UIView *)view
                             callback:(completeCallback)callback;


@end
