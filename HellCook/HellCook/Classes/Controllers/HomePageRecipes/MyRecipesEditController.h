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
#import "CPTextViewPlaceholder.h"

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
  CPTextViewPlaceholder* introTextView;
  
  MyRecipeEditAvatarView* headImageView;
  
  KeyboardHandler *keyboard;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) UITextField* nameField;
@property (nonatomic, retain) CPTextViewPlaceholder* introTextView;

@end
