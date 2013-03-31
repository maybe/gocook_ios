//
//  User.m
//  HellCook
//
//  Created by panda on 13-3-29.
//  Copyright (c) 2012 panda. All rights reserved.
//

#import "UserAccount.h"

@implementation UserAccount
@synthesize username,signature,password,isLogin,avatar;

-(id)init{
  if(self=[super init]){
    isLogin = NO;
  }
  return self;
}

- (NSComparisonResult)compare:(UserAccount *)otherObject {
  return [self.username localizedCaseInsensitiveCompare:otherObject.username];
}


@end
