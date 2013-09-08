//
//  LoginController.h
//  HellCook
//
//  Created by panda on 3/28/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate> {
  MBProgressHUD *HUD;

  UINavigationItem *navgationItem;
  UITableView *tableView;
  NSMutableArray *cellList;
  UITextField *usernameField;
  UITextField *passwordField;
  NSString *callerClassName;
}

@property(nonatomic, retain) IBOutlet UINavigationItem *navgationItem;
@property(nonatomic, retain) IBOutlet UITableView *tableView;
@property(strong, nonatomic) MKNetworkOperation *loginOperation;

@property(nonatomic, retain) NSString *callerClassName;

@end
