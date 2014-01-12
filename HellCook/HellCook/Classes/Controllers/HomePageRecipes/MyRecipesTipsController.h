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

@class KeyboardHandler;
@interface MyRecipesTipsController : UIViewController<UITextViewDelegate,
                                                      UITableViewDataSource,
                                                      UITableViewDelegate,
                                                      KeyboardHandlerDelegate,
                                                      MBProgressHUDDelegate>
{
  UITableView* tableView;
  SSTextView* tipsTextView;
  KeyboardHandler *keyboard;
  MBProgressHUD *HUD;
  BOOL isCreate;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) SSTextView* tipsTextView;
@property (strong, nonatomic) MKNetworkOperation *uploadOperation;

@end
