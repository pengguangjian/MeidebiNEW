//
//  PushYuanChuangSelectFMViewController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/7.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "RootViewController.h"

@interface PushYuanChuangSelectFMViewController : RootViewController
////item
@property (nonatomic , retain) NSMutableArray *arrlistitem;
///标题
@property (nonatomic , retain) NSString *strtitle;
///内容
@property (nonatomic , retain) NSString *strcontent;
///原创类型
@property (nonatomic , assign) NSInteger type;
///原创草稿id
@property (nonatomic , retain) NSString *strdraft_id;


@property (nonatomic , retain) NSTimer *timercaogao;

@end
