//
//  BargainParticipationViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 2017/10/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BargainParticipationViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *itemID;
@property (nonatomic, strong, readonly) NSString *commodityID;
@property (nonatomic, strong, readonly) NSString *imageLink;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *number;
@property (nonatomic, strong, readonly) NSString *required;
@property (nonatomic, strong, readonly) NSString *finish;
@property (nonatomic, strong, readonly) NSString *participants;
@property (nonatomic, strong, readonly) NSString *rank;

+ (instancetype)viewModelWithSubject:(NSDictionary *)dict;

@end
