//
//  MyRecipesEditController.h
//  HellCook
//
//  Created by panda on 8/5/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardHandlerDelegate.h"
#import "MBProgressHUD.h"
#import "SSTextView.h"
#import "MyRecipesMaterialController.h"
#import "MyRecipesStepController.h"
#import "MyRecipesTipsController.h"

@class MyRecipeEditAvatarView;
@class KeyboardHandler;
@interface MyRecipesEditController : UIViewController<UITextFieldDelegate,
                                                      UITextViewDelegate,
                                                      UIImagePickerControllerDelegate,
                                                      UINavigationControllerDelegate,
                                                      KeyboardHandlerDelegate,
                                                      MBProgressHUDDelegate>
{
  UITableView* tableView;
  NSMutableArray* cellContentList;
  UITextField* nameField;
  SSTextView* introTextView;
  MyRecipeEditAvatarView* headImageView;
  KeyboardHandler *keyboard;

  MyRecipesMaterialController* materialController;
  MyRecipesStepController* stepController;
  MyRecipesTipsController* tipsController;

  BOOL isCoverUploaded;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) UITextField* nameField;
@property (nonatomic, retain) SSTextView* introTextView;
@property (strong, nonatomic) MKNetworkOperation *uploadOperation;
@property (strong, nonatomic) MyRecipesMaterialController* materialController;
@property (strong, nonatomic) MyRecipesStepController* stepController;
@property (strong, nonatomic) MyRecipesTipsController* tipsController;
@property BOOL isCoverUploaded;
@end
