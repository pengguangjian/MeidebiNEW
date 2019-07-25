//
//  RecomendListViewModel.h
//  Meidebi
//
//  Created by fishmi on 2017/6/5.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendListViewModel : NSObject
@property (nonatomic ,copy) NSString *commodityid;
@property (nonatomic ,copy) NSString *userid;
@property (nonatomic ,copy) NSString *image;
@property (nonatomic ,copy) NSString *recommendDescription;
@property (nonatomic ,copy) NSString *praisecount;
@property (nonatomic ,copy) NSString *commentcount;
@property (nonatomic ,copy) NSString *avatar;
@property (nonatomic ,copy) NSString *username;

+ (void)recommendReplaceKey;
@end
