//
//  MyInformTableHeadView.h
//  Meidebi
//
//  Created by fishmi on 2017/6/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HeaderViewClickControlType) {
    HeaderViewClickControlTypeUnkown,
    HeaderViewClickControlTypeZan,
    HeaderViewClickControlTypeRemark,
    HeaderViewClickControlTypeCallMe,
    HeaderViewClickControlTypeOrder
};

@protocol MyInformTableHeadViewDelegate <NSObject>

@optional - (void)tableHeaderViewDidClickItemWithType:(HeaderViewClickControlType)type;

@end

@interface MyInformTableHeadView : UIView
@property (nonatomic ,weak) id <MyInformTableHeadViewDelegate> delegate;
- (void)reamrkRemindViewShow:(BOOL)show;
- (void)zanRemindViewShow:(BOOL)show;
- (void)orderRemindViewShow:(BOOL)show;
@end
