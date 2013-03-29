//
//  RegisterController.h
//  HellCook
//
//  Created by panda on 3/27/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardHandlerDelegate.h"

@class RegisterAvatarView;
@class KeyboardHandler;
@interface RegisterController : UIViewController<UITextFieldDelegate,
                                  UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate,
                                  KeyboardHandlerDelegate>
{
  UITableView* tableView;
  UINavigationItem* navgationItem;
  NSMutableArray* cellContentList;
    
  UITextField* nickField;
  UITextField* emailField;
  UITextField* passwordField;
  UITextField* repasswordField;
  
  RegisterAvatarView* headImageView;
  
  KeyboardHandler *keyboard;
}

@property (nonatomic, retain) IBOutlet UINavigationItem* navgationItem;
@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end
