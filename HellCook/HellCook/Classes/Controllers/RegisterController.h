//
//  RegisterController.h
//  HellCook
//
//  Created by panda on 3/27/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardHandlerDelegate.h"
#import "MBProgressHUD.h"

@class RegisterAvatarView;
@class KeyboardHandler;
@interface RegisterController : UIViewController<UITextFieldDelegate,
                                UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate,
                                KeyboardHandlerDelegate,
                                MBProgressHUDDelegate>
{
  MBProgressHUD *HUD;
  
  UITableView* tableView;
  UINavigationItem* navigationItem;
  NSMutableArray* cellContentList;
    
  UITextField* nickField;
  UITextField* telField;
  //UITextField* emailField;
  UITextField* passwordField;
  UITextField*rePasswordField;
  
  RegisterAvatarView* headImageView;
  
  KeyboardHandler *keyboard;
}

@property (nonatomic, retain) IBOutlet UINavigationItem* navigationItem;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (strong, nonatomic) MKNetworkOperation *registerOperation;
@property (nonatomic, retain) NSString* pickedImagePath;


@end
