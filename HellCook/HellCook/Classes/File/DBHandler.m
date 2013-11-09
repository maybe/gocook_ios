//
//  FileHandler.m
//  HC
//
//  Created by panda on 11-12-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "DBHandler.h"

@implementation DBHandler
@synthesize db;

+ (id)sharedInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

-(id)init{
  if(self=[super init]){
    [self initDB];
  }
  return self;
}


#pragma mark  account

- (NSMutableDictionary*)getAccount
{
  NSMutableDictionary* dic = nil;

  if ([self openDB])
  {
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM account;"];
    if ([rs next]) {
      dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
            [rs stringForColumn:@"userid"], @"user_id",
            [rs stringForColumn:@"username"], @"username",
            [rs stringForColumn:@"avatar"], @"avatar",
            [rs stringForColumn:@"session"], @"session",nil];
    }
    [db close];
  }
  return dic;
}

- (BOOL)setAccount:(NSMutableDictionary*)accountDic
{
  [self delAccount];
  if ([self openDB])
  {
    //NSLog(@"%@", accountDic[@"session"]);
    //NSString* session_str = [[accountDic[@"session"] componentsSeparatedByString:@";"] objectAtIndex:0];
    
    [db executeUpdate:@"INSERT INTO account (userid, username, avatar, session) VALUES (?,?,?,?,?,?);", accountDic[@"user_id"], accountDic[@"username"], accountDic[@"avatar"], accountDic[@"session"]];
    [db close];
    return YES;
  }
  return NO;
}

- (BOOL)changeAvatar:(NSString *)avatar {
  if ([self openDB])
  {
    [db executeUpdate:@"UPDATE account SET avatar=?;", avatar];
    [db close];
    return YES;
  }
  return NO;
}

- (BOOL)changeName:(NSString *)name {
  if ([self openDB])
  {
    [db executeUpdate:@"UPDATE account SET username=?;", name];
    [db close];
    return YES;
  }
  return NO;
}


- (BOOL)delAccount
{
  if ([self openDB]){
    [db executeUpdate:@"DELETE FROM account;"];
    [db close];
    return YES;
  }
  return NO;
}

#pragma mark  shopping list

- (BOOL)emptyShoppingList
{
  if ([self openDB]){
    [db executeUpdate:@"DELETE FROM shopping;"];
    [db close];
    return YES;
  }
  return NO;
}

- (void)addToShoppingList:(NSMutableDictionary*)shoppingDic
{
  if ([self openDB]){
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM shopping WHERE recipeid=?;", shoppingDic[@"recipeid"]];
    if ([rs next]) {
      [db executeUpdate:@"UPDATE shopping SET name=?,materials=?,slashitems=? WHERE recipeid=?;", shoppingDic[@"name"], shoppingDic[@"materials"], shoppingDic[@"slashitems"], shoppingDic[@"recipeid"]];
    } else {
      [db executeUpdate:@"INSERT INTO shopping (recipeid, name, materials, slashitems) VALUES (?,?,?,?);", shoppingDic[@"recipeid"], shoppingDic[@"name"], shoppingDic[@"materials"], shoppingDic[@"slashitems"]];
    }
    [db close];
  }
}

- (void)removeFromShoppingList:(NSInteger)recipeId
{
  if ([self openDB]){
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM shopping WHERE recipeid=?;", [NSNumber numberWithInt:recipeId]];
    if ([rs next]) {
      [db executeUpdate:@"DELETE FROM shopping WHERE recipeid=?;", [NSNumber numberWithInt:recipeId]];
    }
    [db close];
  }
}

- (BOOL)isInShoppingList:(NSInteger)recipeId
{
  if ([self openDB]){
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM shopping WHERE recipeid=?;", [NSNumber numberWithInt:recipeId]];
    if ([rs next]) {
      [db close];
      return YES;
    }
    [db close];
  }
  return NO;
}

- (NSMutableArray*)getShoppingList
{
  NSMutableArray* retArray = [[NSMutableArray alloc]init];
  if ([self openDB]){
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM shopping;"];
    while([rs next]) {
      NSMutableDictionary* pDic = NULL;
      pDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
             [rs stringForColumn:@"recipeid"], @"recipeid",
             [rs stringForColumn:@"name"], @"name",
             [rs stringForColumn:@"materials"], @"materials",
             [rs stringForColumn:@"slashitems"], @"slashitems",nil];
      
      [retArray addObject:pDic];
    }
    [db close];
  }
  return retArray;
}

- (NSInteger)getShoppingListCount
{
  NSInteger count = 0;
  if ([self openDB]){
    FMResultSet *rs = [db executeQuery:@"SELECT count(*) FROM shopping;"];
    if([rs next]) {
      count = [rs intForColumnIndex: 0];
    }
    [db close];
  }
  return count;
}

#pragma mark  data cache

- (void)addDataCache:(NSString*)data For:(NSInteger)dataType
{
  if ([self openDB]){
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM data_cache WHERE datatype=?;", [NSNumber numberWithInt:dataType]];
    if ([rs next]) {
      [db executeUpdate:@"UPDATE data_cache SET datacache=? WHERE datatype=?;", [NSNumber numberWithInt:dataType]];
    } else {
      [db executeUpdate:@"INSERT INTO data_cache (datatype, datacache) VALUES (?,?);", [NSNumber numberWithInt:dataType], data];
    }
    [db close];
  }
}


- (void)removeDataCache:(NSInteger)dataType
{
  if ([self openDB]){
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM data_cache WHERE datatype=?;", [NSNumber numberWithInt:dataType]];
    if ([rs next]) {
      [db executeUpdate:@"DELETE FROM data_cache WHERE datatype=?;", [NSNumber numberWithInt:dataType]];
    }
    [db close];
  }
}

- (void)emptyDataCache
{
  if ([self openDB]){
    [db executeUpdate:@"DELETE FROM data_cache;"];
    [db close];
  }
}


#pragma mark  db operation

- (void) initDB
{
  [self openDB];
  
  // create account table
  NSString *accountTableName = [db stringForQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name='account';"];
  
  if (!accountTableName)
  {
    [db executeUpdate:@"CREATE TABLE account(userid text, username text, avatar text, session text);"];
  }
  
  // create shoppinglist table
  NSString *shoppingTableName = [db stringForQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name='shopping';"];
  
  if (!shoppingTableName)
  {
    [db executeUpdate:@"CREATE TABLE shopping(recipeid integer, name text, materials text, slashitems text);"];
  }
  
  // create data_cache table
  NSString *dataCacheTableName = [db stringForQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name='data_cache';"];
  
  if (!dataCacheTableName)
  {
    [db executeUpdate:@"CREATE TABLE data_cache(datatype integer, datacache text);"];
  }
  
  [self closeDB];
}

- (BOOL) openDB
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentDirectory = [paths objectAtIndex:0];
  NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"hellcook.db"];
  db= [FMDatabase databaseWithPath:dbPath];
  if (![db open]) {
    return NO;
  }else{
    return YES;
  }
}

- (void) closeDB
{
  [db close];
}

@end
