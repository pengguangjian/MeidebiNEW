//
//  PushYuanChuangView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/5.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PushYuanChuangViewDelegate <NSObject>
///进入没有选择图片
-(void)selectNomoImageNO;

@end

@interface PushYuanChuangView : UIView

@property (nonatomic , weak) id<PushYuanChuangViewDelegate>delegate;

///原创草稿id
@property (nonatomic , retain) NSString *strdraft_id;

///获取草稿数据
-(void)getcaogaoNOMO:(NSString *)cgid;

///获取消息的爆料卡片
-(void)getMessageBaoLiao:(NSArray *)arrbaoliao;

-(NSInteger)gettype;
-(NSString *)gettitle;
-(NSString *)getcontent;
-(NSMutableArray *)getlistmodel;
-(NSTimer *)getcaogaotimer;

- (void)selectNomoImageItem;

-(void)saveCaoGao;
-(void)timerremove;

@end
