//
//  BargainBottomHandleView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/10/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BargainBottomHandleButtonType){
    BargainBottomHandleButtonTypeLike,
    BargainBottomHandleButtonTypeRead,
    BargainBottomHandleButtonTypeRemark,
    BargainBottomHandleButtonTypeCollect
};

typedef NS_ENUM(NSInteger, BargainBottomUpdateViewType){
    BargainBottomUpdateViewTypeZan,
    BargainBottomUpdateViewTypeShou
};

static NSString * const kBargainBottomLikeNumberKey = @"likenumber";
static NSString * const kBargainBottomReadNumberKey = @"readnumber";
static NSString * const kBargainBottomRemarkNumberKey = @"remarknumber";
static NSString * const kBargainBottomCollectNumberKey = @"collectnumber";

@protocol BargainBottomHandleViewDelegate <NSObject>
@optional - (void)operatingViewDidClickInputView;
@optional - (void)operatingViewDidClickHandleButtonWithType:(BargainBottomHandleButtonType)type;
@end

@interface BargainBottomHandleView : UIView

@property (nonatomic, weak) id<BargainBottomHandleViewDelegate> delegate;
- (void)bindViewData:(NSDictionary *)modelDict;
- (void)updatePelsonalStatuesWithType:(BargainBottomUpdateViewType)type
                              isMinus:(BOOL)minus;
@end
