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
@synthesize username,signature,isLogin,avatar,shouldResetLogin,user_id;

-(id)init{
  if(self=[super init]){
    
    NSMutableDictionary* dic = [[DBHandler sharedInstance] getAccount];
    if (dic) {
      username = [dic valueForKey:@"username"];
      if (username == nil]) {
        isLogin = NO;
      } else {
        avatar = [dic valueForKey:@"avatar"];
        user_id = [[dic valueForKey:@"user_id"] intValue];
        isLogin = YES;
        shouldResetLogin = YES;
      }
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
  avatar = [dic valueForKey:@"avatar"];
  user_id = [[dic valueForKey:@"user_id"] intValue];
  
  DBHandler* dbHandler = [DBHandler sharedInstance];
  [dbHandler setAccount:dic];
  
  isLogin = YES;
}

- (void)logout
{
  username = @"";
  avatar = @"";
  isLogin = NO;
  
  DBHandler* dbHandler = [DBHandler sharedInstance];
  [dbHandler delAccount];
}


@end
