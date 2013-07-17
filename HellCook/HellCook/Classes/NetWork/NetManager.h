//
//  NetManager.h
//  HellCook
//
//  Created by panda on 3/29/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HellEngine.h"

@interface NetManager : NSObject
{
  HellEngine *hellEngine;
  NSString* host;
}

@property (strong, nonatomic) HellEngine *hellEngine;
@property (strong, nonatomic) NSString* host;


+ (id)sharedInstance;
- (id)init;
- (void)InitEngines;

@end
