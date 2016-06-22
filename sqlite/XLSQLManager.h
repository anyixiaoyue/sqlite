//
//  XLSQLManager.h
//  sqlite
//
//  Created by 肖乐 on 16/6/17.
//  Copyright © 2016年 Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "sqlite3.h"

#import "StudentMode.h"


@interface XLSQLManager : NSObject {
    
    sqlite3 *db;
}

+ (XLSQLManager *)shareManager;


- (void)createTableWithTableName:(NSString *)name;

//查询数据
- (NSArray *)searchWithIdNum:(StudentMode *)model;

- (NSArray *)searchAllModel;


//增加数据
- (int)insert:(StudentMode *)model;

//删除数据
- (void)remove:(StudentMode *)model;

//修改数据
- (void)modify:(StudentMode *)model;

@end
