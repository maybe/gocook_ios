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
}

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* signature;

+ (id)sharedInstance;
- (NSComparisonResult)compare:(UserAccount *)otherObject;

@end
