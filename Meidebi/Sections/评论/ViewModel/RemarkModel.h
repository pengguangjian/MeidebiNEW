//
//  RemarkModel.h
//  Meidebi
//
//  Created by mdb-admin on 2017/2/6.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemarkModel : NSObject


@end


@class EmoticonGroup;

typedef NS_ENUM(NSUInteger, EmoticonType) {
    EmoticonTypeImage = 0, ///< 图片表情
    EmoticonTypeEmoji = 1, ///< Emoji表情
};

@interface Emoticon : NSObject
@property (nonatomic, strong) NSString *chs;  ///< 例如 [吃惊]
@property (nonatomic, strong) NSString *cht;  ///< 例如 [吃驚]
@property (nonatomic, strong) NSString *gif;  ///< 例如 d_chijing.gif
@property (nonatomic, strong) NSString *png;  ///< 例如 d_chijing.png
@property (nonatomic, strong) NSString *code; ///< 例如 0x1f60d
@property (nonatomic, assign) EmoticonType type;
@property (nonatomic, weak) EmoticonGroup *group;
@end


@interface EmoticonGroup : NSObject
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *groupID; ///< 例如 com.sina.default
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, strong) NSString *nameCN; ///< 例如 浪小花
@property (nonatomic, strong) NSString *nameEN;
@property (nonatomic, strong) NSString *nameTW;
@property (nonatomic, assign) NSInteger displayOnly;
@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, strong) NSArray<Emoticon *> *emoticons;
@end

@interface Remark : NSObject

@property(nonatomic,strong)NSString *comentid;
@property(nonatomic,strong)NSString *fromid;
@property(nonatomic,strong)NSString *createtime;
@property(nonatomic,strong)NSString *referto;
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *touserid;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *lottery_prize;
@property(nonatomic,assign)BOOL reward;
@property(nonatomic,assign)BOOL submitState;
@property(nonatomic,strong)NSString *tonickname;
@property(nonatomic,strong)NSString *refernickname;
@property(nonatomic,strong)NSString *refercontent;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *photo;
@property(nonatomic,strong)NSString *votesp;
@property (nonatomic, strong) NSArray *pics;
@end

@interface PersonalRemark : NSObject

@property(nonatomic,strong)NSString *comment;
@property(nonatomic,strong)NSString *createtime;
@property(nonatomic,strong)NSString *fromtitle;
@property(nonatomic,strong)NSString *fromtype;
@property(nonatomic,strong)NSString *fromid;
@property(nonatomic,strong)NSString *pose;
@property(nonatomic,strong)NSString *qcontent;
@property(nonatomic,strong)NSString *ousername;
@property(nonatomic,strong)NSString *ouserid;
@property(nonatomic,strong)NSString *isread;
@property(nonatomic,strong)NSArray *pics;

@end
