//
//  RecipeCommentViewController.h
//  HellCook
//
//  Created by lxw on 13-8-17.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardHandlerDelegate.h"
#import "MBProgressHUD.h"

@class RecipeCommentsTableViewCell;
@class RecipeSendCommentView;
@class KeyboardHandler;
@interface RecipeCommentViewController : UIViewController<UITextViewDelegate,KeyboardHandlerDelegate,MBProgressHUDDelegate>
{
  UITableView *myTableView;

  RecipeCommentsTableViewCell *cellForHeight;
  RecipeSendCommentView *sendView;
  
  NSMutableArray *dataArray;
  NSInteger mRecipeID;
  
  KeyboardHandler *keyboard;
  MBProgressHUD *HUD;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) RecipeCommentsTableViewCell *cellForHeight;
@property (retain, nonatomic) RecipeSendCommentView *sendView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (strong, nonatomic) NSMutableDictionary *sendMessageDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRecipeID:(NSInteger)recipeID withData:(NSMutableArray*)data;

@end
