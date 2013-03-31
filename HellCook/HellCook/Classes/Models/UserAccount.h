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
  NSString* username;
  NSString* password;
  NSString* signature;
  BOOL isLogin;
  NSString* avatar;
}

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* signature;
@property BOOL isLogin;
@property (nonatomic, retain) NSString* avatar;

- (NSComparisonResult)compare:(UserAccount *)otherObject;

- (BOOL)isLogin;

@end
