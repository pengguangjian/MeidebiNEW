//
//  NJFlagView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/23.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,FlagType) {
    FlagTypeNormal,
    FlagTypeSite,
    FlagTypeCategory
};

typedef NS_ENUM(NSInteger ,FlagTitleType) {
    FlagTitleTypeNormal,
    FlagTitleTypeCustom,
    FlagTitleTypeNoTitle,
};

@protocol NJFlagViewDelegate <NSObject>

@optional - (void)flageViewDidClickItem:(NSDictionary *)item type:(FlagType)type;

@end

@interface NJFlagView : UIView
@property (nonatomic, assign) FlagTitleType titleType;
@property (nonatomic, strong) NSString *flagTitleName;
@property (nonatomic, strong) UIColor *flagTitleColor;
@property (nonatomic, strong) UIFont *flagTitleFont;
@property (nonatomic, assign, readonly) CGFloat viewHeight;
@property (nonatomic, copy) void(^callback)(CGFloat height);
@property (nonatomic, weak) id<NJFlagViewDelegate> delegate;
- (void)flag:(NSArray *)flags;

@end
