//
//  CustomNavigationController.m
//  HellCook
//
//  Created by panda on 3/24/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "CustomNavigationController.h"
#import "CustomNavigationBar.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setValue:[self customNavigationBar] forKeyPath:@"navigationBar"];
	}
	return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
	self = [super initWithRootViewController:rootViewController];
	if (self) {
		[self setValue:[self customNavigationBar] forKeyPath:@"navigationBar"];
	}
	return self;
}

- (CustomNavigationBar *)customNavigationBar {
	CustomNavigationBar *navBar = [[CustomNavigationBar alloc] init];
   // [navBar setFrame:CGRectMake(0, 0, _sideWindowWidth, _navigationBarHeight)];

	return navBar;
}

@end
