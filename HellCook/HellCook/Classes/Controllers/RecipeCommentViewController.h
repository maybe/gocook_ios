//
//  RecipeCommentViewController.h
//  HellCook
//
//  Created by lxw on 13-8-17.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecipeCommentsTableViewCell;
@class RecipeSendCommentView;
@interface RecipeCommentViewController : UIViewController<UITextViewDelegate>
{
  UITableView *myTableView;

  RecipeCommentsTableViewCell *cellForHeight;
  RecipeSendCommentView *sendView;
  
  NSMutableArray *dataArray;
  NSInteger mRecipeID;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) RecipeCommentsTableViewCell *cellForHeight;
@property (retain, nonatomic) RecipeSendCommentView *sendView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRecipeID:(NSInteger)recipeID withData:(NSMutableArray*)data;

@end
