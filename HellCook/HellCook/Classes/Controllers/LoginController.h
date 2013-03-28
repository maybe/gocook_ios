//
//  LoginController.h
//  HellCook
//
//  Created by panda on 3/28/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController<UITextFieldDelegate>
{
  UINavigationItem* navgationItem;
  UITableView* tableView;
  NSMutableArray* cellList;
  UITextField* usernameField;
  UITextField* passwordField;
}

@property (nonatomic, retain) IBOutlet UINavigationItem* navgationItem;
@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end
