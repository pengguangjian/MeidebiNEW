//
//  PelsonalOperatingView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PelsonalHandleButtonType){
    PelsonalHandleButtonTypeLike,
    PelsonalHandleButtonTypeRead,
    PelsonalHandleButtonTypeCollect
};

typedef NS_ENUM(NSInteger, PelsonalUpdateViewType){
    PelsonalUpdateViewTypeZan,
    PelsonalUpdateViewTypeShou
};

static NSString * const kPelsonalLikeNumberKey = @"likenumber";
static NSString * const kPelsonalReadNumberKey = @"readnumber";
static NSString * const kPelsonalCollectNumberKey = @"collectnumber";
static NSString * const kPelsonalCollectType = @"collecttype";

@protocol PelsonalOperatingViewDelegate <NSObject>
@optional - (void)operatingViewDidClickInputView;
@optional - (void)operatingViewDidClickHandleButtonWithType:(PelsonalHandleButtonType)type;
@end

@interface PelsonalOperatingView : UIView

@property (nonatomic, weak) id<PelsonalOperatingViewDelegate> delegate;
- (void)bindViewData:(NSDictionary *)modelDict;
- (void)updatePelsonalStatuesWithType:(PelsonalUpdateViewType)type
                              isMinus:(BOOL)minus;
@end
