//
//  HCDrawerController.m
//  HellCook
//
//  Created by panda on 11/1/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "HCDrawerController.h"
#import "HCNavigationController.h"

@interface HCDrawerController ()

@end

@implementation HCDrawerController

-(BOOL)shouldAutorotate
{
  HCNavigationController* navController = (HCNavigationController*)self.centerViewController;
  return [navController shouldAutorotate];
}

@end
