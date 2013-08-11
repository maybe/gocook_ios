//
//  User.h
//  HellCook
//
//  Created by panda on 3/31/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccount.h"
#import "UserCollection.h"
#import "Recipe.h"

@interface User : NSObject
{
  UserAccount* account;
  UserCollection* collection;
  Recipe* recipe;
}

@property (nonatomic, retain)UserAccount* account;
@property (nonatomic, retain)UserCollection* collection;
@property (nonatomic, retain)Recipe* recipe;

+ (id)sharedInstance;
- (id)init;

@end
