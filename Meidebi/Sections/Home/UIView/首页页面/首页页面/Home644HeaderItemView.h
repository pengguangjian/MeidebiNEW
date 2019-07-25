//
//  Home644HeaderItemView.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/20.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol Home644HeaderViewDelegate <NSObject>

-(void)btNowSelectItem:(NSInteger)item;


@end

@interface Home644HeaderItemView : UIView

@property (nonatomic , weak)id<Home644HeaderViewDelegate>delegate;

@property (nonatomic , assign) NSInteger inowselectitem;

#pragma mark - items数据
-(void)bindItemsData:(NSArray *)arrmodels;

-(void)btselectItem:(NSInteger)item;

@end

NS_ASSUME_NONNULL_END
