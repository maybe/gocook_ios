//
//  NetManager.h
//  HellCook
//
//  Created by panda on 3/29/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountEngine.h"

@interface NetManager : NSObject
{
  AccountEngine *accountEngine;
}

@property (strong, nonatomic) AccountEngine *accountEngine;

+ (id)sharedInstance;
- (id)init;

@end
