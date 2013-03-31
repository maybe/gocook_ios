//
//  UserCollection.m
//  HellCook
//
//  Created by panda on 3/31/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "UserCollection.h"

@implementation UserCollection
@synthesize collectCount;

-(id)init{
  if(self=[super init]){
    collectCount = 0;
  }
  return self;
}

@end
