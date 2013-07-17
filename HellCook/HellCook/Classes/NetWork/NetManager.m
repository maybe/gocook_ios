//
//  NetManager.m
//  HellCook
//
//  Created by panda on 3/29/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "NetManager.h"
#import "ConfigHandler.h"
#import "GCDSingleton.h"

@implementation NetManager
@synthesize hellEngine,host;

+ (id)sharedInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (id)init{
  if(self=[super init])
  {
    host = [[[ConfigHandler sharedInstance] settingDictionary] objectForKey:@"host"];
    [self InitEngines];
  }
  return self;
}

- (void)InitEngines
{
  [self InitHellEngine];
}

- (void)InitHellEngine
{
  self.hellEngine = [[HellEngine alloc] initWithHostName:host
                                            customHeaderFields: @{@"x-client-identifier" : @"Mobile"}];
}

@end
