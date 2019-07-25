//
//  ZLMultiLevelMenuViewModel.h
//  FilterWares
//
//  Created by mdb-admin on 2016/11/15.
//  Copyright © 2016年 losaic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLMenuItem.h"

@interface ZLMultiLevelMenuViewModel : NSObject

/**
 menu table view sections
 */
@property (nonatomic, readonly, assign) NSInteger tableSections;

/**
 menu tableview max row height
 */
@property (nonatomic, readonly, assign) NSInteger tableMaxRowHeight;

/**
 menu tableview min row height
 */
@property (nonatomic, readonly, assign) NSInteger tableMinRowHeight;

@property (nonatomic, readonly, strong) NSArray *tableContents;


+ (instancetype)multiLevelMenuViewModel:(NSArray *)model;

@end
