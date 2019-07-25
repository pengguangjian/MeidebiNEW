//
//  PushYuanChuangLineAlterView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/6.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PushYuanChuangLineAlterViewDelegate <NSObject>
///添加链接
-(void)addLineUrlValue:(NSString *)strurl;

@end

@interface PushYuanChuangLineAlterView : UIView

@property (nonatomic , weak) id<PushYuanChuangLineAlterViewDelegate>delegate;

-(void)showView:(float )fbottom;

-(void)hiddenView;

@end
