//
//  RemarkDataController.h
//  Meidebi
//
//  Created by mdb-admin on 16/6/23.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RemarkDataType){
    RemarkDataTypeNormal,
    RemarkDataTypeReply
};

@interface RemarkDataController : NSObject

@property (nonatomic, strong, readonly) NSArray *requestResults;


- (void)requestSubjectDataWithType:(RemarkDataType)type
                            InView:(UIView *)view
                          callback:(completeCallback)Callback;

- (void)nextPageDataWithCallback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;

- (void)requestCommentReplySubjectData:(NSDictionary *)dict
                                InView:(UIView *)view
                              callback:(completeCallback)Callback;

@end
