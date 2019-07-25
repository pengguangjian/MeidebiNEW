//
//  TrackViewModel.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TrackEventType) {
    TrackEventTypeUnknown,
    TrackEventTypeBeginUse,
    TrackEventTypeSigin,
    TrackEventTypeShowdan,
    TrackEventTypeDiscount,
    TrackEventTypeHaveBy,
    TrackEventTypeWantBy,
};

@interface TrackViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *time;
@property (nonatomic, strong, readonly) NSArray *events;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;

@end


@interface TrackEventModel : NSObject
@property (nonatomic, strong, readonly) NSString *trackID;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *orginprice;
@property (nonatomic, strong, readonly) NSString *siteName;
@property (nonatomic, strong, readonly) NSString *iconImageLink;
@property (nonatomic, strong, readonly) NSString *publishTime;
@property (nonatomic, strong, readonly) NSString *handle;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, assign, readonly) TrackEventType type;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;

@end
