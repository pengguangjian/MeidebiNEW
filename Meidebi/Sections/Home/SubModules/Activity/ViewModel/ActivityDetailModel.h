//
//  ActivityDetailModel.h
//  Meidebi
//
//  Created by fishmi on 2017/6/2.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityDetailModel : NSObject
@property (nonatomic ,copy) NSString *commodityid;
@property (nonatomic ,copy) NSString *actid;
@property (nonatomic ,copy) NSString *userid;
@property (nonatomic ,copy) NSString *image;
@property(nonatomic,strong)NSArray *images;
@property (nonatomic ,copy) NSString *activityDescription;
@property (nonatomic ,copy) NSString *praisecount;
@property (nonatomic ,copy) NSString *commentcount;
@property (nonatomic ,copy) NSString *browsecount;
@property (nonatomic ,copy) NSString *createtime;
@property (nonatomic ,copy) NSString *status;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *favnum;
@property (nonatomic ,copy) NSString *isfav;
@property (nonatomic ,copy) NSString *avatar;
@property (nonatomic ,copy) NSString *username;
@property (nonatomic ,copy) NSString *share_num;
@property (nonatomic ,copy) NSString *showdan_num;
@property (nonatomic ,copy) NSString *is_follow;
+ (void)activityKeyReplace;
@end
