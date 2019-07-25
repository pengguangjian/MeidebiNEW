//
//  WelfareStrategyCollectionHeaderView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WelfareStrategyCollectionHeaderViewDelegate <NSObject>

@optional -(void)didClickCloseAdBtn;
@optional -(void)didClickMyWelfareBtn;
@optional -(void)didClickMyWelfareAd;

@end

@interface WelfareStrategyCollectionHeaderView : UICollectionReusableView
@property (nonatomic, weak) id<WelfareStrategyCollectionHeaderViewDelegate> delegate;
@property (nonatomic, strong) NSString *receivedNumStr;
- (void)bindDataWithModel:(NSDictionary *)dict;
@end
