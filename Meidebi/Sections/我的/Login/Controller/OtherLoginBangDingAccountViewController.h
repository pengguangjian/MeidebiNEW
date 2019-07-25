//
//  OtherLoginBangDingAccountViewController.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/11.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OtherLoginBangDingAccountViewController : RootViewController

@property (nonatomic , retain ) NSString *strname;

///微信 淘宝 微博 QQ
@property (nonatomic , retain ) NSString *strtype;

@property (nonatomic , retain ) NSString *strpushurl;
///第三方参数
@property (nonatomic , retain ) NSDictionary *dicparams;

@end

NS_ASSUME_NONNULL_END
