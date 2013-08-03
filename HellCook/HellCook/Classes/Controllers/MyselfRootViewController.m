//
//  MyselfRootViewController.m
//  HellCook
//
//  Created by lxw on 13-8-1.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyselfRootViewController.h"

@interface MyselfRootViewController ()

@end

@implementation MyselfRootViewController
@synthesize menuView,introductionLabel,followLabel,fanLabel,recipeLabel,introductionBtn,followBtn,fanBtn,recipeBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //设置tabbar背景图
  UIImageView *tabBarBgView = [[UIImageView alloc] initWithFrame:tabBar.bounds];
  [tabBarBgView setImage:[UIImage imageNamed:@"Images/TabBarBackground.png"]];
  [tabBarBgView setContentMode:UIViewContentModeScaleToFill];
  [tabBar insertSubview:tabBarBgView atIndex:1];
  //设置item字体颜色
  [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor redColor] }
                                           forState:UIControlStateNormal];
  [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor blackColor] }
                                           forState:UIControlStateHighlighted]; 
  //设置item背景图
  [[tabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"Images/RecipeItemImageSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/RecipeItemImageDeSelected.png"]];
  
  [tabBar setSelectedItem:[tabBar.items objectAtIndex:0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  tabBar = nil;
  [super viewDidUnload];
}
@end
