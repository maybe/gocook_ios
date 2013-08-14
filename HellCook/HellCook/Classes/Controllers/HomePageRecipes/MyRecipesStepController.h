//
//  MyRecipesEditController.h
//  HellCook
//
//  Created by panda on 8/5/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardHandlerDelegate.h"
#import "MyRecipeStepTableViewCell.h"

@class KeyboardHandler;
@interface MyRecipesStepController : UIViewController<KeyboardHandlerDelegate,
                                                      RecipeStepCellInputDelegate,
                                                      UITableViewDataSource,
                                                      UITableViewDelegate>
{
  UITableView* tableView;
  NSMutableArray* cellContentList;
  KeyboardHandler *keyboard;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end