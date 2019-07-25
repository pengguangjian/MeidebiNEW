//
//  CheapOrOutsideSubjectsViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 16/5/6.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "CheapOrOutsideSubjectsViewModel.h"
#import <MJExtension/MJExtension.h>
#import "Commodity.h"
@interface CheapOrOutsideSubjectsViewModel ()

@property (nonatomic, strong) NSMutableArray *commoditys;

@end

@implementation CheapOrOutsideSubjectsViewModel


+ (CheapOrOutsideSubjectsViewModel *)viewModelWithSubjects:(NSArray *)subjects{
    CheapOrOutsideSubjectsViewModel *viewModel = [[CheapOrOutsideSubjectsViewModel alloc] init];
    [viewModel viewModelWithSubjects:subjects];
    return viewModel;
}

- (void)viewModelWithSubjects:(NSArray *)subjects{
    
    for (NSDictionary *dict in subjects) {
         Commodity *aCommodity = [Commodity mj_objectWithKeyValues:dict];
        if (aCommodity) {
            [self.commoditys addObject:aCommodity];
        }
    }
    
}

#pragma makr - getters and setters
- (NSMutableArray *)commoditys{
    if (!_commoditys) {
        _commoditys = [NSMutableArray array];
    }
    return _commoditys;
}

- (NSArray *)results{
    return self.commoditys? :@[];
}
@end
