//
//  KitchenInfo.m
//  HellCook
//
//  Created by panda on 11/21/13.
//  Copyright (c) 2013 VeryPanda Inc. All rights reserved.
//
#import "KitchenInfo.h"

@implementation KitchenInfo
@synthesize coll_count, recipe_count, followed_count, following_count, order_count;

-(id)init{
  if(self=[super init]){
    coll_count = 0;
    recipe_count = 0;
    followed_count = 0;
    following_count = 0;
    order_count = 0;
  }
  return self;
}

@end