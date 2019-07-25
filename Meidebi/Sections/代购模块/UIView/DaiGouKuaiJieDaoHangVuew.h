//
//  DaiGouKuaiJieDaoHangVuew.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/11/26.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DaiGouKuaiJieDaoHangVuewDelegate <NSObject>

-(void)kuaiJieDaoHangItemAction:(NSInteger )tag;

@end

@interface DaiGouKuaiJieDaoHangVuew : UIView

@property (nonatomic , weak) id<DaiGouKuaiJieDaoHangVuewDelegate>delegate;

@property (nonatomic , retain) UIButton *superbt;


-(void)sousuoAction;

@end

NS_ASSUME_NONNULL_END
