//
//  DBManager.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/20.
//  Copyright © 2019 default. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@interface DBManager ()
{
    sqlite3 *_db;
}
@end

@implementation DBManager
+(instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static DBManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[DBManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createTable];
    }
    return self;
}

- (sqlite3 *)openDB
{
    if (_db != nil) {
        return _db;
    }
    
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    // 数据库路径
    NSString *db_suffix = [NSString stringWithFormat:@"%@.db", @"TKDataBase"];
    
    NSString *dbPath = [docuPath stringByAppendingPathComponent:db_suffix];
    
    sqlite3_open(dbPath.UTF8String, &_db);
    return _db;
}

- (void)createTable {
    [self creatTableWithSql:@"CREATE TABLE IF NOT EXISTS ORDERS (order_id text paimary key not NULL);"];
}

- (void)insertData:(NSString *)orderId {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO ORDERS (order_id) values ('%@')",  orderId];
    [self insertDataWithSql:sql];
}

- (void)deleteOrders {
    NSString *sql = @"delete from ORDERS";
    [self openDB];
    char *errmsg = NULL;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errmsg);
}

- (BOOL)selectData: (NSString*)orderId {
    NSString *sql = [NSString stringWithFormat:@"select order_id from ORDERS where order_id = '%@'", orderId];
    [self openDB];
    
    sqlite3_stmt *stmt;
    int count = 0;
    int ret = sqlite3_prepare(_db, sql.UTF8String, -1, &stmt, NULL);
    if (ret == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            count++;
        }
        sqlite3_finalize(stmt);
    }
    return count ? YES: NO;
}

- (void)closeDB {
    int ret = sqlite3_close(_db);
    if (ret == SQLITE_OK) {
        _db = NULL;
    }
}

-(void)creatTableWithSql:(NSString *)sql {
    [self openDB];
    char *errmsg = NULL;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errmsg);
}

- (void)insertDataWithSql:(NSString *)sql {
    [self openDB];
    char *errmsg = NULL;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errmsg);
}

@end
