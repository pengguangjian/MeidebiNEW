//
//  TKTopicModuleConstant.h
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/17.
//  Copyright © 2018年 leecool. All rights reserved.
//

#ifndef TKTopicModuleConstant_h
#define TKTopicModuleConstant_h


typedef NS_ENUM(NSInteger, TopicSortStyle) {
    TopicSortStyleUnknown,                 //未知
    TopicSortStyleTime,
    TopicSortStyleChoiceness
};

typedef NS_ENUM(NSInteger, TKTopicType) {
    TKTopicTypeUnknown=0,                 ///未知
    TKTopicTypeEnable=1,                  ///生活经验
    TKTopicTypeLooks=2,                   ///服饰鞋包
    TKTopicTypeBeauty=3,                  ///美妆护肤
    TKTopicType3C=4,                      ///数码家电
    TKTopicTypeDeliciousfood=5,           ///美食旅游
    TKTopicTypeEvaluation=6,              ///评测试用
    TKTopicTypeOther=7,                   ///其他
    TKTopicTypeSpitslot=10,                ///匿名吐槽
    TKTopicTypeDaily=15,                   ///日常话题
    TKTopicTypeShaiDan=100,                 ///晒单广场
    TKTopicTypeShoppingList=101             ///必买清单
    
};


#endif /* TKTopicModuleConstant_h */

