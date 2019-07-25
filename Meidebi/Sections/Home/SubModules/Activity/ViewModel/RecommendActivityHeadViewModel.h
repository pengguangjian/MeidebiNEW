//
//  RecommendActivityModel.h
//  Meidebi
//
//  Created by fishmi on 2017/5/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendActivityHeadViewModel : NSObject
@property (nonatomic ,copy) NSString *recomendID;
@property (nonatomic ,copy) NSString *image;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,copy) NSString *commodityid;
@property (nonatomic ,copy) NSString *starttime;
@property (nonatomic ,copy) NSString *endtime;
@property (nonatomic ,copy) NSString *hasreward;
@property (nonatomic ,copy) NSString *timeout;
@property (nonatomic ,copy) NSString *createtime;
@property (nonatomic ,copy) NSString *victoryway;
@property (nonatomic ,copy) NSString *explain;
@property (nonatomic ,copy) NSString *entryendtime;
@property (nonatomic ,copy) NSString *needentry;
@property (nonatomic ,copy) NSString *entryfield;
@property (nonatomic ,copy) NSString *entrycount;
@property (nonatomic ,copy) NSString *commentcount;
@property (nonatomic ,copy) NSString *browsecount;
@property (nonatomic ,copy) NSString *praisecount;
@property (nonatomic ,copy) NSString *disparagecount;
@property (nonatomic ,copy) NSString *showentryinfo;
@property (nonatomic ,copy) NSString *prizes;
@property (nonatomic ,copy) NSString *userissigned;
@property (nonatomic ,copy) NSString *favnum;
@property (nonatomic ,copy) NSString *isfav;
@property (nonatomic ,strong) NSArray *comments;
@property (nonatomic ,copy) NSString *info;
@property (nonatomic ,copy) NSString *status;

+ (void)recommendActivityReplaced;

@end
