//
//  MyRecipesEditController.h
//  HellCook
//
//  Created by panda on 8/5/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardHandlerDelegate.h"
#import "MyRecipeMaterialTableViewCell.h"

@class KeyboardHandler;
@class RecipeData;
@interface MyRecipesMaterialController : UIViewController<KeyboardHandlerDelegate, RecipeMaterialCellInputDelegate, UITableViewDataSource,UITableViewDelegate>
{
  UITableView* tableView;
  NSMutableArray* cellContentList;
  KeyboardHandler *keyboard;
  RecipeData* recipeData;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) RecipeData* recipeData;

@end
