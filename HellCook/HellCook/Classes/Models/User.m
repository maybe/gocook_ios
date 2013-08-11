//
//  User.m
//  HellCook
//
//  Created by panda on 3/31/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "User.h"
#import "GCDSingleton.h"


@implementation User
@synthesize account, collection, recipe;

+ (id)sharedInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (id)init
{
  if(self=[super init]){
    collection = [[UserCollection alloc]init];
    account = [[UserAccount alloc]init];
    recipe = [[Recipe alloc]init];
  }
  return self;
}

@end
