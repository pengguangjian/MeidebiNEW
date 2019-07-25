//
//  CheapOrOutsideSubjectsViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 16/5/6.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheapOrOutsideSubjectsViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray *results;

+ (CheapOrOutsideSubjectsViewModel *)viewModelWithSubjects:(NSArray *)subjects;

@end
