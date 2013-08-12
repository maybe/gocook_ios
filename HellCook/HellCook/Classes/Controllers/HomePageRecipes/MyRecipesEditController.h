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
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) UITextField* nameField;
@property (nonatomic, retain) SSTextView* introTextView;
@property (strong, nonatomic) MKNetworkOperation *uploadOperation;

@end
