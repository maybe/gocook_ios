//
//  DBHandler.h
//  HC
//
//  Created by panda on 11-12-11.
//  Copyright (c) 2013 panda. All rights reserved.
//


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
- (BOOL)changeAvatar:(NSString*)avatar;
- (BOOL)changeName:(NSString*)name;
- (BOOL)delAccount;

- (BOOL)emptyShoppingList;
- (void)addToShoppingList:(NSMutableDictionary*)shoppingDic;
- (void)removeFromShoppingList:(NSInteger)recipeId;
- (BOOL)isInShoppingList:(NSInteger)recipeId;
- (NSMutableArray*)getShoppingList;

- (void)addDataCache:(NSString*)data For:(NSInteger)datatype;
- (void)removeDataCache:(NSInteger)datatype;
- (void)emptyDataCache;

@end
