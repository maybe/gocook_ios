//
//  RecipeDetailController.m
//  HellCook
//
//  Created by panda on 5/6/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MyRecipeDetailController.h"
#import "NetManager.h"
#import "LoginController.h"

@interface MyRecipeDetailController ()

@end

@implementation MyRecipeDetailController


- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setRightButton];
  isDelRecipe = NO;

  HUD = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:HUD];
  HUD.mode = MBProgressHUDModeCustomView;
  HUD.delegate = self;
}

- (void)setRightButton
{
  UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(_screenWidth - 69, 30, 49, 29)];
  [rightBarButtonView addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
  [rightBarButtonView setBackgroundImage:
      [UIImage imageNamed:@"Images/MyRecipeDetailOp.png"]
                                forState:UIControlStateNormal];
  [self.view addSubview:rightBarButtonView];
}

- (void)editAction
{
  UIActionSheet *actionSheet = [[UIActionSheet alloc]
             initWithTitle:@""
             delegate:self
             cancelButtonTitle:@"取消"
             destructiveButtonTitle:@"修改菜谱"
             otherButtonTitles:@"删除菜谱",nil];
  [actionSheet showInView:self.mm_drawerController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {

  } else if (buttonIndex == 1) {
    [self confirmDeleteRecipe];
  } else if (buttonIndex == 2) {

  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    // cancel
  } else if (buttonIndex == 1){
    [self deleteRecipeData: mRecipeId];
  }
}


- (void)confirmDeleteRecipe {
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"确认删除吗？"
                                                   message:@""
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定",nil];
    [alert show];
}


- (void)deleteRecipeData:(NSInteger)recipeId {

  HUD.labelText = @"正在删除...";
  [HUD show:YES];

  self.netOperation = [[[NetManager sharedInstance] hellEngine]
      deleteRecipe:recipeId
 completionHandler:^(NSMutableDictionary *resultDic) {
   [self deleteRecipeResultCallBack:resultDic];
 }
      errorHandler:^(NSError *error) {
      }
  ];
}

- (void)deleteRecipeResultCallBack:(NSMutableDictionary *)resultDic {

  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success) {
    HUD.labelText = @"删除成功";
    [HUD hide:YES afterDelay:1.0];
    isDelRecipe = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnDeleteRecipe" object:nil];
  }
  else {
    [HUD hide:YES];
    NSInteger $errorCode = [[resultDic valueForKey:@"errorcode"] intValue];
    if ($errorCode == GC_AuthAccountInvalid) {
      LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);

      if (self.navigationController) {
        [self.mm_drawerController.navigationController pushViewController:m animated:YES];
      }
    }
  }
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
  if (isDelRecipe)
  {
    [self returnToPrev];
  }
}

@end
