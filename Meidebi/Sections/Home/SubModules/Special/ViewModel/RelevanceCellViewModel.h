//
//  RelevanceCellViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/25.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RelevanceType) {
    RelevanceTypeNormal,
    RelevanceTypeRecommend
};

@interface RelevanceCellViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *relevanceID;
@property (nonatomic, strong, readonly) NSString *iconImageLink;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *orginprice;
@property (nonatomic, strong, readonly) NSString *activeprice;
@property (nonatomic, strong, readonly) NSString *siteName;
@property (nonatomic, strong, readonly) NSString *publishTime;
@property (nonatomic, strong, readonly) NSString *likeNumber;
@property (nonatomic, strong, readonly) NSString *linkurl;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, assign, readonly) RelevanceType type;
@property (nonatomic, assign, readonly) BOOL isLike;
@property (nonatomic , assign) BOOL isSelect;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;
- (void)updateLikeAmount;
@end
