//
//  User.m
//  HellCook
//
//  Created by panda on 13-3-29.
//  Copyright (c) 2012 panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccount : NSObject
{
  NSInteger user_id;
  NSString* username;
  NSString* signature;
  BOOL isLogin;
  BOOL shouldResetLogin;
  NSString* avatar;
}

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* signature;
@property NSInteger user_id;
@property BOOL isLogin;
@property BOOL shouldResetLogin;
@property (nonatomic, retain) NSString* avatar;

- (NSComparisonResult)compare:(UserAccount *)otherObject;

- (BOOL)isLogin;

- (void)login:(NSMutableDictionary*)dic;
- (void)logout;

@end
