//
//  TaoLiJinHongBaoView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/27.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaoLiJinHongBaoViewDelegate <NSObject>

-(void)fenxianghongbao;

@end

@interface TaoLiJinHongBaoView : UIView

@property(nonatomic , weak)id<TaoLiJinHongBaoViewDelegate>delegate;

@end
