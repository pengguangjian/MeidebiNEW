//
//  WoGuanZhuPeopleModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/1.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WoGuanZhuPeopleModel : NSObject
@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)NSString *follow_time;
@property(nonatomic,strong)NSString *did;
@property (nonatomic, strong) NSString *nickname;
///是否取消了关注
@property (nonatomic, assign) BOOL iscancle;

-(id)initWithdic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
