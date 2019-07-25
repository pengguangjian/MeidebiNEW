//
//  DaiGouFenLeiTableViewController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/11/26.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "RootTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DaiGouFenLeiTableViewController : RootTableViewController

@property (nonatomic , retain) NSString *strtitle;

@property (nonatomic , retain) NSString *strurl;

@property (nonatomic , retain) NSMutableDictionary *dicpush;
///1post 2get
@property (nonatomic , assign) int ipost;

///是否隐藏现货图标
@property (nonatomic , assign) BOOL ishiddenxianhuo;
///是否是现货
@property (nonatomic , assign) BOOL isxianhuo;

@end

NS_ASSUME_NONNULL_END
