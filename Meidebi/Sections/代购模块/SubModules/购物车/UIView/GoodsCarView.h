//
//  GoodsCarView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsCarViewDelegate <NSObject>

///是否有数据
-(void)goodsListcount:(BOOL)isgoods;

@end

@interface GoodsCarView : UIView

@property(nonatomic , weak) id<GoodsCarViewDelegate>delegate;

///编辑和完成编辑
-(void)iseditAction:(BOOL)isedit;

-(void)dataMessage;

@end
