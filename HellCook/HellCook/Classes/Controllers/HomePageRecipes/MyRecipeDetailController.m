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
#import "User.h"
#import "MyRecipesEditController.h"

@interface MyRecipeDetailController ()

@end

@implementation MyRecipeDetailController


- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setRightButton];
  isDelRecipe = NO;
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
    [self modifyMyRecipe];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_ReloadRecipes" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnShouldRefreshKitchenInfo" object:nil];
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
  [super hudWasHidden:hud];
  if (isDelRecipe)
  {
    [self returnToPrev];
  }
}

#pragma  mark - Recipe Operation
- (void)modifyMyRecipe {
  [self getOneRecipeDetailData:mRecipeId];
}

-(void)getOneRecipeDetailData:(NSInteger)recipeId
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
      getRecipeDetailData:recipeId
        completionHandler:^(NSMutableDictionary *resultDic) {
          [self getOneRecipeDetailCallBack:resultDic];
        }
             errorHandler:^(NSError *error) {
             }];
}

- (void)getOneRecipeDetailCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success) {
    NSDictionary* recipeDic = [[NSDictionary alloc]initWithDictionary:resultDic[@"result_recipe"]];
    //初始化修改数据
    [[[User sharedInstance] recipe] resetModifyRecipeData];
    [[[User sharedInstance] recipe] setIsCreate:NO];
    RecipeData* recipeData = [[[User sharedInstance] recipe] getModifyRecipeData];
    recipeData.recipe_id = [recipeDic[@"recipe_id"] intValue];
    recipeData.user_id = [recipeDic[@"author_id"] intValue];
    recipeData.name = recipeDic[@"recipe_name"];
    recipeData.description = recipeDic[@"intro"];
    recipeData.cover_img = recipeDic[@"cover_image"];
    recipeData.cover_img_status = RecipeImage_UPLOADED;
    recipeData.tips = recipeDic[@"tips"];

    NSArray* materialArray = [recipeDic[@"materials"] componentsSeparatedByString:@"|"];
    for (int i = 0; i < materialArray.count/2; i++) {
      NSMutableDictionary* pDic = [[NSMutableDictionary alloc]init];
      pDic[@"material"] = [[NSString alloc]initWithString:[materialArray objectAtIndex:(NSUInteger)i*2]];
      pDic[@"weight"] = [[NSString alloc]initWithString:[materialArray objectAtIndex:(NSUInteger)i*2+1]];

      [recipeData.materials addObject:pDic];
    }

    NSArray* stepArray = (NSArray*)recipeDic[@"steps"];
    for (NSUInteger j = 0; j < stepArray.count; j++) {
      NSMutableDictionary* pDic = [[NSMutableDictionary alloc]init];

      pDic[@"step"] = [[NSString alloc]initWithString:stepArray[j][@"content"]];
      pDic[@"imageUrl"] = [[NSString alloc]initWithString:stepArray[j][@"img"]];
      if ([pDic[@"imageUrl"] isEqual:@""]) {
        pDic[@"imageState"] = [NSString stringWithFormat:@"%d", RecipeImage_UNSELECTED];

      } else {
        pDic[@"imageState"] = [NSString stringWithFormat:@"%d", RecipeImage_UPLOADED];
      }

      [recipeData.recipe_steps addObject:pDic];
    }

    MyRecipesEditController *pEditController = [[MyRecipesEditController alloc] initWithNibName:@"MyRecipesEditView" bundle:nil];
    [self.navigationController pushViewController:pEditController animated:YES];
  }
}

@end
