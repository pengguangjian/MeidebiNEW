//
//  ProductInfoQiuKaiTuanView.h
//  Meidebi
//  求开团弹框
//  Created by mdb-losaic on 2018/9/10.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ProductInfoQiuKaiTuanViewDelegate <NSObject>

-(void)qiukaituanAction:(NSString *)strmessage;

@end

@interface ProductInfoQiuKaiTuanView : UIView

@property (nonatomic , weak ) id<ProductInfoQiuKaiTuanViewDelegate>delegate;

///ftype = 1有同款代购商品 0无同款代购商品
-(id)initWithFrame:(CGRect)frame andtype:(int)ftype;

-(void)drawTkItems:(NSMutableArray *)arritems;

@end
