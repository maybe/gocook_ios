//
//  RecipeDetailController.m
//  HellCook
//
//  Created by panda on 5/6/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MyRecipeDetailController.h"


@interface MyRecipeDetailController ()

@end

@implementation MyRecipeDetailController


- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setRightButton];
}

- (void)setRightButton
{
  UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(_screenWidth - 69, 30, 49, 29)];
  [rightBarButtonView addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
  [rightBarButtonView setBackgroundImage:
      [UIImage imageNamed:@"Images/MyRecipeDetailOp.png"]
                                forState:UIControlStateNormal];
  [self.view addSubview:rightBarButtonView];
}

- (void)editAction
{

}


@end
