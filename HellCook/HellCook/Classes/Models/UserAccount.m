//
//  User.m
//  HellCook
//
//  Created by panda on 13-3-29.
//  Copyright (c) 2012 panda. All rights reserved.
//

#import "UserAccount.h"
#import "DBHandler.h"

@implementation UserAccount
@synthesize username,signature,password,isLogin,avatar,shouldResetLogin;

-(id)init{
  if(self=[super init]){
    
    NSMutableDictionary* dic = [[DBHandler sharedInstance] getAccount];
    if (dic) {
      username = [dic valueForKey:@"username"];
      password = [dic valueForKey:@"password"];
      avatar = [dic valueForKey:@"avatar"];
      isLogin = YES;
      shouldResetLogin = YES;
    }
    else{
      isLogin = NO;
    }
  }
  return self;
}

- (NSComparisonResult)compare:(UserAccount *)otherObject {
  return [self.username localizedCaseInsensitiveCompare:otherObject.username];
}

- (void)login:(NSMutableDictionary*)dic
{
  DBHandler* dbHandler = [DBHandler sharedInstance];
  [dbHandler setAccount:dic];
  
  isLogin = YES;
}

- (void)logout
{
  username = @"";
  password = @"";
  avatar = @"";
  isLogin = NO;
  
  DBHandler* dbHandler = [DBHandler sharedInstance];
  [dbHandler delAccount];
}


@end
