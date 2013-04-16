//
//  NetManager.h
//  HellCook
//
//  Created by panda on 3/29/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountEngine.h"
#import "RecipeEngine.h"

@interface NetManager : NSObject
{
  AccountEngine *accountEngine;
  RecipeEngine *recipeEngine;
  NSString* host;
}

@property (strong, nonatomic) AccountEngine *accountEngine;
@property (strong, nonatomic) RecipeEngine *recipeEngine;
@property (strong, nonatomic) NSString* host;


+ (id)sharedInstance;
- (id)init;
- (void)InitEngines;

@end
