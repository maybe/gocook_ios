//
//  FileHandler.h
//  HC
//
//  Created by panda on 11-12-11.
//  Copyright (c) 2013 panda. All rights reserved.
//
//  account db存放用户登录数据


#import <Foundation/Foundation.h>
#import "GCDSingleton.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface DBHandler : NSObject{
  FMDatabase* db;
}

@property (nonatomic, retain) FMDatabase* db;

+ (id)sharedInstance;

- (id)init;

- (void)initDB;
- (BOOL)openDB;
- (void)closeDB;

- (NSMutableDictionary*)getAccount;
- (BOOL)setAccount:(NSMutableDictionary*)accountDic;
- (BOOL)delAccount;

@end
