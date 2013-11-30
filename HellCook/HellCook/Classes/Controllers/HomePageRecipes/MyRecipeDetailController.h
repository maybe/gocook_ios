//
//  RecipeDetailController.h
//  HellCook
//
//  Created by panda on 5/6/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeDetailController.h"
#import "MBProgressHUD.h"

@class RecipeDetailBaseTableViewCell;
@interface MyRecipeDetailController : RecipeDetailController <UIActionSheetDelegate, UIAlertViewDelegate>
{
  BOOL isDelRecipe;
}

@end
