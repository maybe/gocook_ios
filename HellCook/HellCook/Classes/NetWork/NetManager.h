//
//  NetManager.h
//  HellCook
//
//  Created by panda on 3/29/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountEngine.h"
#import "CookEngine.h"

@interface NetManager : NSObject
{
  AccountEngine *accountEngine;
  CookEngine *cookEngine;
  NSString* host;
}

@property (strong, nonatomic) AccountEngine *accountEngine;
@property (strong, nonatomic) CookEngine *cookEngine;
@property (strong, nonatomic) NSString* host;


+ (id)sharedInstance;
- (id)init;
- (void)InitEngines;

@end
