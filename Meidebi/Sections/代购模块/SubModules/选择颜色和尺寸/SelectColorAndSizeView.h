//
//  SelectColorAndSizeView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/27.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectColorAndSizeViewDelegate <NSObject>
///购买商品
-(void)buyGoods:(NSString *)strid andnum:(NSString *)strnum;
///添加购物车
-(void)addGouWuChe:(NSString *)strid andnum:(NSString *)strnum;
///修改购物车规格
-(void)changeGouWuChe:(NSString *)strid andcartid:(NSString *)strcartid;
@end

@interface SelectColorAndSizeView : UIView

@property (nonatomic, weak) id<SelectColorAndSizeViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame andvalue:(id)value andtype:(NSInteger)itype;

-(void)showView;

-(void)dismisAction;

@end
