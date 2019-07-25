//
//  DaiGouXiaDanGoodsView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/30.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DaiGouXiaDanGoodsViewDelegate <NSObject>

-(void)DaiGouXiaDanGoodsNumChange;

@end

@interface DaiGouXiaDanGoodsView : UIView

@property (nonatomic , weak) id<DaiGouXiaDanGoodsViewDelegate>delegate;

@property (nonatomic ,retain) NSMutableArray *arrgoods;

@property (nonatomic , assign) BOOL iseditnumber;

@property (nonatomic , assign) int igoodsnomonum;

@end
