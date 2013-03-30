//
//  User.m
//  HellCook
//
//  Created by panda on 13-3-29.
//  Copyright (c) 2012 panda. All rights reserved.
//

#import "UserAccount.h"
#import "GCDSingleton.h"

@implementation UserAccount
@synthesize username,signature,password;

+ (id)sharedInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

-(id)init{
  if(self=[super init]){}
  return self;
}

- (NSComparisonResult)compare:(UserAccount *)otherObject {
  return [self.username localizedCaseInsensitiveCompare:otherObject.username];
}

@end
