//
//  OtherLoginBangDingAccountView.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/11.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OtherLoginBangDingAccountView : UIView

@property (nonatomic , retain ) NSString *strname;

///微信 淘宝 微博 QQ
@property (nonatomic , retain ) NSString *strtype;
///第三方参数
@property (nonatomic , retain ) NSDictionary *dicparams;
@property (nonatomic , retain ) NSString *strpushurl;

-(void)valueInput;

-(void)backsAction;

@end

NS_ASSUME_NONNULL_END
