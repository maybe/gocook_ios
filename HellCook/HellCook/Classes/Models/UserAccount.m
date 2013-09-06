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
@synthesize username,signature,password,isLogin,avatar,shouldResetLogin,tel,user_id;

-(id)init{
  if(self=[super init]){
    
    NSMutableDictionary* dic = [[DBHandler sharedInstance] getAccount];
    if (dic) {
      username = [dic valueForKey:@"username"];
      tel = [dic valueForKey:@"tel"];
      password = [dic valueForKey:@"password"];
      avatar = [dic valueForKey:@"avatar"];
      user_id = [[dic valueForKey:@"user_id"] intValue];
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
  username = [dic valueForKey:@"username"];
  tel = [dic valueForKey:@"tel"];
  password = [dic valueForKey:@"password"];
  avatar = [dic valueForKey:@"avatar"];
  user_id = [[dic valueForKey:@"user_id"] intValue];
  
  DBHandler* dbHandler = [DBHandler sharedInstance];
  [dbHandler setAccount:dic];
  
  isLogin = YES;
}

- (void)logout
{
  username = @"";
  password = @"";
  avatar = @"";
  tel = @"";
  isLogin = NO;
  
  DBHandler* dbHandler = [DBHandler sharedInstance];
  [dbHandler delAccount];
}


@end
