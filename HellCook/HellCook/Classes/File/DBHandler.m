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
            [rs stringForColumn:@"username"], @"username",
            [rs stringForColumn:@"password"], @"password",
            [rs stringForColumn:@"avatar"], @"avatar", nil];
    }
    [db close];
  }
  return dic;
}

- (BOOL)setAccount:(NSMutableDictionary*)accountDic
{
  //[self delAccount];
  if ([self openDB])
  {
    [db executeUpdate:@"INSERT INTO account (username, password, avatar) VALUES (?,?,?);", accountDic[@"username"], accountDic[@"password"], accountDic[@"avatar"]];
    [db close];
    return YES;
  }
  return NO;
}

- (BOOL)delAccount
{
  if ([self openDB]){
    [db executeUpdate:@"DELETE FROM account"];
    [db close];
    return YES;
  }
  return NO;
}



#pragma mark  db operation

- (void) initDB
{
  [self openDB];
  
  NSString *accountTableName = [db stringForQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name='account';"];
  
  if (!accountTableName)
  {
    [db executeUpdate:@"CREATE TABLE account(username text, password text, avatar text)"];
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
