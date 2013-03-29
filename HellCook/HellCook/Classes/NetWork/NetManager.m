//
//  NetManager.m
//  HellCook
//
//  Created by panda on 3/29/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "NetManager.h"
#import "GCDSingleton.h"

@implementation NetManager
@synthesize accountEngine;

+ (id)sharedInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (id)init{
  if(self=[super init])
  {
    [self InitEngines];
  }
  return self;
}

- (void)InitEngines
{
  self.accountEngine = [[AccountEngine alloc] initWithHostName:_myHostName
                                            customHeaderFields: @{@"x-client-identifier" : @"Mobile"}];

}

@end
