//
//  BangDingAccountModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/4.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BangDingAccountModel : NSObject

@property (nonatomic,retain) NSString *strtitle;

@property (nonatomic,retain) NSString *strimage;

@property (nonatomic,retain) NSString *strname;

@property (nonatomic,assign) BOOL isbangding;

////1-QQ|2-微博|3-淘宝|4-微信
@property (nonatomic,assign) int type;

@end

NS_ASSUME_NONNULL_END
