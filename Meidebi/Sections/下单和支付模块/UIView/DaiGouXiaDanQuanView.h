//
//  DaiGouXiaDanQuanView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/25.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MyGoodsCouponModel;

@protocol DaiGouXiaDanQuanViewDelegate <NSObject>

-(void)selectitem:(MyGoodsCouponModel *)model andnum:(NSInteger)inum;

@end

@interface DaiGouXiaDanQuanView : UIView

@property (nonatomic,weak)id<DaiGouXiaDanQuanViewDelegate>delegate;

@property (nonatomic, retain) NSMutableArray *arrdata;

@property (nonatomic, assign) NSInteger inomoselect;

///商品价格
@property (nonatomic , retain) NSString *strgoodsprice;

-(void)showQuan;

@end

NS_ASSUME_NONNULL_END
