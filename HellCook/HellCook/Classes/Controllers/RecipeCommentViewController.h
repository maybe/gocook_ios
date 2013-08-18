//
//  RecipeCommentViewController.h
//  HellCook
//
//  Created by lxw on 13-8-17.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecipeCommentsTableViewCell;
@interface RecipeCommentViewController : UIViewController
{
  UITableView *myTableView;
  UINavigationItem* navgationItem;

  RecipeCommentsTableViewCell *cellForHeight;
  
  NSMutableArray *dataArray;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UINavigationItem* navgationItem;
@property (retain, nonatomic) RecipeCommentsTableViewCell *cellForHeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableArray*)data;

@end
