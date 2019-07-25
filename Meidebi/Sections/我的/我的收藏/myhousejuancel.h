//
//  myhousejuancel.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/20.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface myhousejuancel : NSObject

@property(nonatomic,strong)NSString *juanid;
@property(nonatomic,strong)NSString *strDown;
@property(nonatomic,strong)NSString *strImgUrl;
@property(nonatomic,strong)NSString *strUp;
@property (nonatomic, strong) NSString *statue;

-(id)initWithdic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
