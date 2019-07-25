//
//  OrderDetaileView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/8.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderDetaileViewDelegate <NSObject>

-(void)orderdetailAction;

-(void)orderYiChangMessage:(NSString *)message;

@end

@interface OrderDetaileView : UIView

@property (nonatomic,weak)id<OrderDetaileViewDelegate>delegate;

-(void)bindData:(NSString *)strid bindorderno:(NSString *)strorderno;


@end
