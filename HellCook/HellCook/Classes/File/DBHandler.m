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
            [rs stringForColumn:@"email"], @"email",
            [rs stringForColumn:@"password"], @"password",
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
    NSString* session_str = [[accountDic[@"session"] componentsSeparatedByString:@";"] objectAtIndex:0];
    
    [db executeUpdate:@"INSERT INTO account (userid, username, email,password, avatar, session) VALUES (?,?,?,?,?,?);", accountDic[@"user_id"], accountDic[@"username"], accountDic[@"email"], accountDic[@"password"], accountDic[@"avatar"], session_str];
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
      [db executeUpdate:@"UPDATE shopping SET name=?,materials=? WHERE recipeid=?;", shoppingDic[@"name"], shoppingDic[@"materials"], shoppingDic[@"recipeid"]];
    } else {
      [db executeUpdate:@"INSERT INTO shopping (recipeid, name, materials) VALUES (?,?,?);", shoppingDic[@"recipeid"], shoppingDic[@"name"], shoppingDic[@"materials"]];
    }
    [db close];
  }
}

- (void)removeFromShoppingList:(NSInteger)recipeId
{
  if ([self openDB]){
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM shopping WHERE recipeid=?;", [NSNumber numberWithInt:recipeId]];
    if ([rs next]) {
      [db executeUpdate:@"DELETE FROM shopping WHERE recipeid=?;", recipeId];
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
             [rs stringForColumn:@"materials"], @"materials",nil];
      
      [retArray addObject:pDic];
    }
    [db close];
  }
  return retArray;
}

#pragma mark  db operation

- (void) initDB
{
  [self openDB];
  
  // create account table
  NSString *accountTableName = [db stringForQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name='account';"];
  
  if (!accountTableName)
  {
    [db executeUpdate:@"CREATE TABLE account(userid text, username text, email text, password text, avatar text, session text);"];
  }
  
  // create shoppinglist table
  NSString *shoppingTableName = [db stringForQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name='shopping';"];
  
  if (!shoppingTableName)
  {
    [db executeUpdate:@"CREATE TABLE shopping(recipeid integer, name text, materials text);"];
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
