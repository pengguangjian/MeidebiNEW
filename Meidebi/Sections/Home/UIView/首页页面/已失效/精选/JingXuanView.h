//
//  JingXuanView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/21.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewModel.h"

@protocol JingXuanViewDelegate <NSObject>
///下拉刷新
-(void)jingxuanHeaderRefAction;
@end

@interface JingXuanView : UIView

@property (nonatomic , weak) id<JingXuanViewDelegate>delegate;

- (void)bindData:(NSDictionary *)dicmodels;

-(void)bindBanarData:(NSArray *)arrmodels;

///精选下拉刷新数据
- (void)bindJinXuanRefData:(NSDictionary *)dicmodels;

@end
