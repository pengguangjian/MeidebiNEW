//
//  WelfareReceiveCollectionHeaderView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kAllCopperKey = @"allCopper";
static NSString * const kAllIntegralKey = @"allIntegral";

@protocol WelfareReceiveCollectionHeaderViewDelegate <NSObject>

@optional - (void)welfareReceiveHeaderViewDidClickConversionBtn;

@end

@interface WelfareReceiveCollectionHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<WelfareReceiveCollectionHeaderViewDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)dict;
@end
