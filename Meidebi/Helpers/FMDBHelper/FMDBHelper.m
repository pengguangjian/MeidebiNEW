//
//  FMDBHelper.m
//  Meidebi
//
//  Created by mdb-admin on 16/8/29.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "FMDBHelper.h"
#import "Marked.h"
#import "Photoscle.h"

NSString * const articleTableName = @"article";
NSString * const markeTableName = @"sharecle";
NSString * const volumeTableName = @"volume";
NSString * const markeEditTableName = @"markeedit";
NSString * const markePhotoTableName = @"markephoto";

@interface FMDBHelper ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) NSString *tableName;
@end

@implementation FMDBHelper

static FMDBHelper *_instance = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FMDBHelper alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (id)copyWithZone:(struct _NSZone *)zon{
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self.class dbPath]];
    }
    return self;
}

+ (NSString *)dbPathWithDirectoryName:(NSString *)directoryName{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (!directoryName || directoryName.length == 0) {
        docsdir = [docsdir stringByAppendingPathComponent:@"MDBC"];
    }else{
        docsdir = [docsdir stringByAppendingPathComponent:directoryName];
    }
    BOOL isDir;
    BOOL exit = [fileManager fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [fileManager createDirectoryAtPath:docsdir
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    NSString *dbPath = [docsdir stringByAppendingPathComponent:@"meidebi.db"];
    return dbPath;
}

+ (NSString *)dbPath{
    return [self dbPathWithDirectoryName:nil];
}


/** 创建表 **/

- (NSString *)editSqlWithName:(NSString  *)tableName{
    return [NSString stringWithFormat:@"create table if not exists %@ (content text, type text)",tableName];
}

- (BOOL)createArticleTable{
    
    return [self createTableWithSql:[self editSqlWithName:articleTableName]];
}

- (BOOL)createMarkeTable{
    return [self createTableWithSql:[self editSqlWithName:markeTableName]];
}

- (BOOL)createVolumeTable{
    return [self createTableWithSql:[self editSqlWithName:volumeTableName]];
}

- (BOOL)createMarkeEditTable{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (markedid text, content text, title text, usertoken text, count text, time text, sdquality text, sdship text, sdcustom text, siteid text)",markeEditTableName];
    NSString *phoneSql = [NSString stringWithFormat:@"create table if not exists %@ (indexx text, markid text, pdata blob)",markePhotoTableName];
    [self createTableWithSql:phoneSql];
    BOOL res1 = [self createTableWithSql:sql];
    return res1;
}

- (BOOL)createTableWithSql:(NSString *)sql{
    __block  BOOL result = YES;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            result = NO;
        }else{
            if (![db executeUpdate:sql]) {
                result = NO;
            }
        }
        [db close];
    }];
  
    return result;
}


/** 清空表 */

- (BOOL)clearArticleTable{
    return [self clearTableWithName:articleTableName];
}

- (BOOL)clearMarkeTable{
    return [self clearTableWithName:markeTableName];
}

- (BOOL)clearVolumeTable{
    return [self clearTableWithName:volumeTableName];
}

- (BOOL)clearTableWithName:(NSString *)name
{
    __block BOOL res = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",name];
            res = [db executeUpdate:sql];
            NSLog(res?@"清空成功":@"清空失败");
        }
        [db close];
    }];
    return res;
}

- (BOOL)clearMarkeEditTableWithFormat:(NSString *)formate{
    __block BOOL res = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if([db open]){
            NSString *sql = [NSString stringWithFormat:@"delete from %@ where markedid =?",markeEditTableName];
            res = [db executeUpdate:sql,formate];
            NSLog(res?@"清空成功":@"清空失败");
        }
        [db close];
    }];
    [self clearMarkePhotoTableWithFormat:formate];
    return res;
}

- (BOOL)clearMarkePhotoTableWithFormat:(NSString *)formate{
    __block BOOL res = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"delete from %@ where markid =?",markePhotoTableName];
            res = [db executeUpdate:sql,formate];
            NSLog(res?@"清空成功":@"清空失败");
        }
        [db close];
    }];
    return res;
}


/** 保存数据 **/
- (BOOL)saveWithTabeleName:(NSString *)name objects:(NSString *)objects type:(NSString *)type{
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (content,type) values (?,?)", name];
            result = [db executeUpdate:sql, objects, type];
            NSLog(result?@"插入成功":@"插入失败");
        }
        [db close];
    }];
    return result;
}

- (BOOL)saveMarkeEditContent:(Marked *)marke{
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (markedid, content, title, usertoken, count, time, sdquality, sdship, sdcustom, siteid) values (?,?,?,?,?,?,?,?,?,?)", markeEditTableName];
            result = [db executeUpdate:sql,marke.markedid,marke.content,marke.title,marke.usertoken,marke.count,marke.time,marke.sdquality,marke.sdship,marke.sdcustom,marke.siteid];
            NSLog(result?@"插入成功":@"插入失败");
        }
        [db close];
    }];
    return result;
}

- (BOOL)saveMarkePhoto:(Photoscle *)photoData{
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (indexx, markid, pdata) values (?,?,?)", markePhotoTableName];
            result = [db executeUpdate:sql,photoData.index,photoData.markid,photoData.pdata];
            NSLog(result?@"插入成功":@"插入失败");
        }
        [db close];
    }];
    return result;
}

- (BOOL)updateMarkedCount:(NSString *)count markedid:(NSString *)markeid{
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"update %@ set count=? where markedid = ?", markeEditTableName];
            result = [db executeUpdate:sql,count,markeid];
            NSLog(result?@"修改成功":@"修改失败");
        }
        [db close];
       
    }];
    return result;
}


- (NSArray *)findMarkTable{
    NSMutableArray *results = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql = [NSString stringWithFormat:@"select * from %@",markeEditTableName];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            Marked *mark = [[Marked alloc] init];
            mark.markedid = [resultSet stringForColumn:@"markedid"];
            mark.content = [resultSet stringForColumn:@"content"];
            mark.title = [resultSet stringForColumn:@"title"];
            mark.usertoken = [resultSet stringForColumn:@"usertoken"];
            mark.count = [resultSet stringForColumn:@"count"];
            mark.time = [resultSet stringForColumn:@"time"];
            mark.sdquality = [resultSet stringForColumn:@"sdquality"];
            mark.sdship = [resultSet stringForColumn:@"sdship"];
            mark.sdcustom = [resultSet stringForColumn:@"sdcustom"];
            mark.siteid = [resultSet stringForColumn:@"siteid"];
            [results addObject:mark];
        }
        [db close];
    }];
    
    return results.mutableCopy;
}

- (NSArray *)findMarkPhotoWithFormat:(NSString *)formate{
    NSMutableArray *results = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where markid = ?",markePhotoTableName];
        FMResultSet *resultSet = [db executeQuery:sql,formate];
        while ([resultSet next]) {
            Photoscle *photo = [[Photoscle alloc] init];
            photo.markid = [resultSet stringForColumn:@"markid"];
            photo.index = [resultSet stringForColumn:@"indexx"];
            photo.pdata = [resultSet dataForColumn:@"pdata"];
            [results addObject:photo];
        }
        [db close];
    }];
    return results.mutableCopy;
}

- (NSArray *)findObjectWithTabeleName:(NSString *)name format:(NSString *)formate{
    NSMutableArray *results = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where type = ?",name];
        FMResultSet *resultSet = [db executeQuery:sql,formate];
        while ([resultSet next]) {
            NSString *content = [resultSet stringForColumn:@"content"];
            [results addObject:content];
        }
        [db close];
    }];
    
    return results;

}

//#pragma mark - getters and setters
//- (FMDatabaseQueue *)dbQueue{
//    if (!_dbQueue) {
//        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self.class dbPath]];
//    }
//    return _dbQueue;
//}

@end
