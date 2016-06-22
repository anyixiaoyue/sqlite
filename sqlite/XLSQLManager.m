//
//  XLSQLManager.m
//  sqlite
//
//  Created by 肖乐 on 16/6/17.
//  Copyright © 2016年 Shaw. All rights reserved.
//

#import "XLSQLManager.h"


@implementation XLSQLManager

#define kNameFile (@"Student.sqlite")

static XLSQLManager *sqlManager = nil;

+ (XLSQLManager *)shareManager {
    
    static dispatch_once_t oncetoken;
    
    dispatch_once(&oncetoken, ^{
        
        sqlManager = [[self alloc] init];
        
        [sqlManager createDataBaseTableIfNeed];
    
    });
    
    return sqlManager;
}

- (NSString *)applicationDocumentsDirectoryfile {
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [path firstObject];
    
    NSString *patch = [documentDirectory stringByAppendingPathComponent:kNameFile];
    
    return patch;
}

- (void)createDataBaseTableIfNeed {
    
    NSString *writePath = [self applicationDocumentsDirectoryfile];
    
    NSLog(@"数据库的地址是 = %@", writePath);
    
    if (sqlite3_open([writePath UTF8String], &db) != SQLITE_OK) {
        
        NSLog(@"数据库打开败！");
        
        sqlite3_close(db);
        
        NSAssert(NO, @"数据库打开失败！");
        
    } else {
        
        NSLog(@"数据库打开成功!");
        
        char *err;
        
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS StudentName (idNum TEXT PRIMARYKEY, name TEXT);"];
        
        /**执行函数 sqlite3_exec
         第一个参数 db对象
         第二个参数 SQL语句
         第三个参数 回调函数
         第四个参数 回调函数的参数
         第五个参数 错误信息
         */
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK) {
          
            //失败
            sqlite3_close(db);
            
            NSAssert1(NO, @"建表失败！%s", err);
            
            
        } else {
            
            //成功
            sqlite3_close(db);
            
        }
    }
}

//查询
- (NSArray *)searchWithIdNum:(StudentMode *)model{
    
    NSString *path = [self applicationDocumentsDirectoryfile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        
        sqlite3_close(db);
        
        NSAssert(NO, @"数据库打开失败！");
        
    } else {
        
        NSString *qsql = [NSString stringWithFormat:@"SELECT idNum,name FROM StudentName Where idNum = ?"];
        
        sqlite3_stmt *statement; // 语句对象
        
        /**预处理函数 sqlite3_prepare_v2
         第一个参数 db对象
         第二个参数 SQL语句
         第三个参数 执行SQL语句的长度 -1是全部长度
         第四个参数 语句对象
         第五个参数 没有执行的语句部分
         */
        if(sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            //进行 按主键查询数据库
            NSString *idNum = model.idNum;
            
            /*绑定函数 sqlite3_bind_text 
             第一个参数 语句对象
             第二个参数 参数开始执行的序号
             第三个参数 我们要绑定的值
             第四个参数 绑定的字符串长度
             第五个参数 指针 NULL
             */
            sqlite3_bind_text(statement, 1, [idNum UTF8String], -1, NULL);
            
            NSMutableArray *searchArray = [NSMutableArray array];
            
            //有一个返回值，SQLITE_ROW常量代表查出来了
            while(sqlite3_step(statement) == SQLITE_ROW) {
                
                //提取数据
                //第一个参数， 语句对象
                //第二个参数， 字段的索引
                char *idNum = (char *)sqlite3_column_text(statement, 0);
                
                NSString *idNumStr = [[NSString alloc] initWithUTF8String:idNum];
                
                char *name = (char *)sqlite3_column_text(statement, 1);
                
                NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
                
                StudentMode *model = [[StudentMode alloc ]init];
                
                model.idNum = idNumStr;
                
                model.name = nameStr;
                
                [searchArray addObject:model];
                
            }
            
            sqlite3_finalize(statement);
            
            sqlite3_close(db);
            
            return searchArray.copy;
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(db);

    }
    
    return nil;
}

- (NSArray *)searchAllModel {
    
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    
    NSString *path = [self applicationDocumentsDirectoryfile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        
        sqlite3_close(db);
        
        NSAssert(NO, @"数据库打开失败！");
        
    } else {
        
        NSString *sql = @"SELECT * FROM StudentName";
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
//            sqlite3_bind_null(statement, 1);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                char *idNum = (char *)sqlite3_column_text(statement, 0);
                
                NSString *idNumStr = [[NSString alloc] initWithUTF8String:idNum];
                
                char *name = (char *)sqlite3_column_text(statement, 1);
                
                NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
                
                StudentMode *model = [[StudentMode alloc ]init];
                
                model.idNum = idNumStr;
                
                model.name = nameStr;
                
                [modelArray addObject:model];

            }
            
            NSArray *returenArray = modelArray.copy;
            
            sqlite3_finalize(statement);
            
            sqlite3_close(db);
            
            return returenArray;
            
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(db);
        
    }
    
    return nil;
}

//修改
- (int)insert:(StudentMode *)model {
    
    NSString *path = [self applicationDocumentsDirectoryfile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        
        sqlite3_close(db);
        
        NSAssert(NO,@"打开数据库失败！");
        
    }else {
        
        NSString *sql = @"INSERT OR REPLACE INTO StudentName (idNum, name) VALUES (?,?)";
        
        sqlite3_stmt *statement;
        
        //预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_text(statement, 1, [model.idNum UTF8String], -1, NULL);
            
            sqlite3_bind_text(statement, 2, [model.name UTF8String], -1, NULL);
            
            if(sqlite3_step(statement) != SQLITE_DONE) {
                
                NSAssert(NO, @"插入数据失败！");
            }

        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(db);
        
    }
    return 0;
}

- (void)remove:(StudentMode *)model {
    
    NSString *path = [self applicationDocumentsDirectoryfile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        
        sqlite3_close(db);
        
        NSAssert(NO, @"数据库打开失败！");
        
    } else {
        
        NSString *sql = @"DELETE FROM StudentName WHERE idNum = ?";
                
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_text(statement, 1, [model.idNum UTF8String], -1, NULL);
            
            if (sqlite3_step(statement) != SQLITE_DONE) {
                
                NSAssert(NO, @"删除数据失败！");
                
            }
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(db);
    }
    
}

- (void)modify:(StudentMode *)model {
    
    NSString *path = [self applicationDocumentsDirectoryfile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        
        sqlite3_close(db);
        
        NSAssert(NO, @"数据库打开失败！");
        
    } else {
        
        NSString *sql = @"UPDATE StudentName SET name = ? WHERE idNum = ?";
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_text(statement, 1, [model.name UTF8String], -1, NULL);
            
            sqlite3_bind_text(statement, 2, [model.idNum UTF8String], -1, NULL);
            
            if (sqlite3_step(statement) != SQLITE_DONE) {
                
                NSAssert(NO, @"修改数据库失败！");
                
            }
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(db);
        
    }
    
}

@end
