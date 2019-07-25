//
//  HomeGuanZhuDongTaiView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/23.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeGuanZhuDongTaiViewDelegate <NSObject>
///更新红点
-(void)latesNewsTableViewWihtFirstRow:(NSString *)strvalue;
@end

@interface HomeGuanZhuDongTaiView : UIView

@property (nonatomic , weak) id<HomeGuanZhuDongTaiViewDelegate>delegate;

-(void)loadrefdata;

@end
