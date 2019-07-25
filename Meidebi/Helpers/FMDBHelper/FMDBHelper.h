//
//  FMDBHelper.h
//  Meidebi
//
//  Created by mdb-admin on 16/8/29.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
@class Marked;
@class Photoscle;
@interface FMDBHelper : NSObject


extern NSString * const articleTableName;
extern NSString * const markeTableName;
extern NSString * const volumeTableName;

@property (nonatomic, readonly ,strong) FMDatabaseQueue *dbQueue;


+ (instancetype)shareInstance;


/**
 *  创建商品表
 *
 *  @return 如果已创建，返回YES
 */
- (BOOL)createArticleTable;

/**
 *  创建晒单表
 *
 *  @return 如果已创建，返回YES
 */
- (BOOL)createMarkeTable;

/**
 *  创建优惠券表
 *
 *  @return 如果已创建，返回YES
 */
- (BOOL)createVolumeTable;

/**
 *  创建晒单编辑表
 *
 *  @return 如果已创建，返回YES
 */
- (BOOL)createMarkeEditTable;

/**
 *  清空商品表
 *
 *  @return 如果清空成功，返回YES
 */
- (BOOL)clearArticleTable;

/**
 *  清空晒单表
 *
 *  @return 如果清空成功，返回YES
 */
- (BOOL)clearMarkeTable;

/**
 *  清空优惠券表
 *
 *  @return 如果清空成功，返回YES
 */
- (BOOL)clearVolumeTable;

/**
 *  清空晒单编辑表
 *
 *  @return 如果清空成功，返回YES
 */
- (BOOL)clearMarkeEditTableWithFormat:(NSString *)formate;

/** 保存数据 **/
- (BOOL)saveWithTabeleName:(NSString *)name objects:(NSString *)objects type:(NSString *)type;

/** 保存晒单编辑数据 **/
- (BOOL)saveMarkeEditContent:(Marked *)marke;

/** 保存晒单图片数据 **/
- (BOOL)saveMarkePhoto:(Photoscle *)photoData;

/** 更新晒单表 **/
- (BOOL)updateMarkedCount:(NSString *)count markedid:(NSString *)markeid;

/** 查询晒单表 **/
- (NSArray *)findMarkTable;

/** 查询晒单图片表 **/
- (NSArray *)findMarkPhotoWithFormat:(NSString *)formate;

/** 条件查询 **/
- (NSArray *)findObjectWithTabeleName:(NSString *)name format:(NSString *)formate;



@end
