//
//  KitchenInfo.h
//  HellCook
//
//  Created by panda on 11/21/13.
//  Copyright (c) 2013 VeryPanda Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface KitchenInfo : NSObject
{
  NSInteger coll_count;
  NSInteger recipe_count;
  NSInteger following_count;
  NSInteger followed_count;
  NSInteger order_count;
}

@property NSInteger coll_count;
@property NSInteger recipe_count;
@property NSInteger following_count;
@property NSInteger followed_count;
@property NSInteger order_count;

@end