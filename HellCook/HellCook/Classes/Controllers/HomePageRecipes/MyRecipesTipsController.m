//
//  MyRecipesEditController.m
//  HellCook
//
//  Created by panda on 8/5/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MyRecipesTipsController.h"
#import "KeyboardHandler.h"
#import "UIView+FindFirstResponder.h"
#import "NetManager.h"
#import "User.h"
#import "DefaultGroupedTableCell.h"

#define kTableCellHeader  48
#define kTableCellBody    45
#define kTableCellFooter  160
#define kTableCellSingle  200

@interface MyRecipesTipsController ()

@end

@implementation MyRecipesTipsController
@synthesize tableView, tipsTextView, uploadOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [self setLeftButton];
  [self setRightButton];

  self.title = @"小贴士";

  tipsTextView = [[SSTextView alloc]init];
  
  CGRect frame = self.tableView.tableHeaderView.frame;
  frame.size.height = 44;
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
  UIImageView* headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/TipsHeader.png"]];
  [headerImageView setFrame:CGRectMake(26, 15, 168, 13)];
  [self.tableView.tableHeaderView addSubview:headerImageView];

  //keyboard
  keyboard = [[KeyboardHandler alloc] init];
  
  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];
  [self.tableView setFrame:viewFrame];

  RecipeData* pRecipeData = nil;
  if ([[[User sharedInstance] recipe] getIsCreate]) {
    pRecipeData = [[[User sharedInstance] recipe] getCreateRecipeData];
  } else {
    pRecipeData = [[[User sharedInstance] recipe] getModifyRecipeData];
  }

  if (pRecipeData.tips) {
    [tipsTextView setText:pRecipeData.tips];
  }

  HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
  [self.navigationController.view addSubview:HUD];
  HUD.mode = MBProgressHUDModeCustomView;
  HUD.delegate = self;
  
  [super viewDidLoad];
}

- (void)dealloc
{
  [HUD removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
  keyboard.delegate = self;
  
  [super viewWillAppear:animated];

  [tipsTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
  keyboard.delegate = nil;
  
  [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotate {
  
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
  
  return UIInterfaceOrientationMaskAll;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellSingle;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  DefaultGroupedTableCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"TipsCell"];
  
  if (cell == nil) {
    cell = [[DefaultGroupedTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"TipsCell"];

    tipsTextView.delegate = self;
    [tipsTextView setFrame:CGRectMake(20, 5, 280, 185)];
    [tipsTextView setBackgroundColor: [UIColor clearColor]];
    [tipsTextView setPlaceholder: @"小贴士"];
    tipsTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tipsTextView.keyboardType = UIKeyboardTypeDefault;
    tipsTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [tipsTextView setFont:[UIFont systemFontOfSize:14]];
    tipsTextView.returnKeyType = UIReturnKeyDone;
    [tipsTextView setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
    
    cell.tableCellBodyHeight = kTableCellBody;
    cell.tableCellHeaderHeight = kTableCellHeader;
    cell.tableCellFooterHeight = kTableCellFooter;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setCellStyle:1 Index:indexPath.row];
    
    [cell addSubview:tipsTextView];
  }
  
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - Textreturn
-(void)textViewDidBeginEditing:(UITextView *)textView
{
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  if ([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  return YES;
} 


#pragma mark - Avatar View
- (void)setHeaderView
{
  
}

#pragma mark - Keyboard

- (void)keyboardSizeChanged:(CGSize)delta
{
  UIView* frView = [self.tableView findFirstResponder];
  if ([frView isKindOfClass:[UITextField class]] || [frView isKindOfClass:[SSTextView class]]) {
    if ([frView isKindOfClass:[SSTextView class]]) {
      frView = frView.superview;
    }
    if (delta.height > 0) {
      CGPoint realOrigin = [frView convertPoint:frView.frame.origin toView:nil];
      if (realOrigin.y + frView.frame.size.height  > _screenHeight - delta.height) {
        CGFloat deltaHeight = realOrigin.y + frView.frame.size.height - ( _screenHeight - delta.height) -30;
        CGRect frame = self.tableView.frame;
        frame.origin.y -= deltaHeight;
        if (-frame.origin.y > delta.height) {
          frame.origin.y = - delta.height;
        }
        self.tableView.frame = frame;
      }
    }
    else{
      CGRect frame = self.tableView.frame;
      frame.origin.y =  0;
      self.tableView.frame = frame;
    }
  }
}


#pragma mark - Navi Butons

- (void)setLeftButton
{
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 29)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
      [UIImage imageNamed:@"Images/BackButtonNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
      [UIImage imageNamed:@"Images/BackButtonHighLight.png"]
                               forState:UIControlStateHighlighted];
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
  
}

- (void)setRightButton
{
  UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 29)];
  [rightBarButtonView addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/CompleteButtonNormal.png"]
                                forState:UIControlStateNormal];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/CompleteButtonHighLight.png"]
                                forState:UIControlStateHighlighted];
  
  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
  
  [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

-(void)returnToPrev
{
  NSString *trimedDesc = @"";
  if (tipsTextView.text) {
    trimedDesc = [tipsTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  }

  RecipeData* pRecipeData = nil;
  if ([[[User sharedInstance] recipe] getIsCreate]) {
    pRecipeData = [[[User sharedInstance] recipe] getCreateRecipeData];
  } else {
    pRecipeData = [[[User sharedInstance] recipe] getModifyRecipeData];
  }

  pRecipeData.tips = [[NSString alloc]initWithString: trimedDesc];
  
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNext
{

  NSString *trimedDesc = @"";
  if (tipsTextView.text) {
    trimedDesc = [tipsTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  }

  RecipeData* pRecipeData = nil;
  if ([[[User sharedInstance] recipe] getIsCreate]) {
    pRecipeData = [[[User sharedInstance] recipe] getCreateRecipeData];
  } else {
    pRecipeData = [[[User sharedInstance] recipe] getModifyRecipeData];
  }

  pRecipeData.tips = [[NSString alloc]initWithString: trimedDesc];
  
  
  NSMutableDictionary* pUploadRecipeDic = [[NSMutableDictionary alloc]init];
  pUploadRecipeDic[@"name"] = pRecipeData.name;
  pUploadRecipeDic[@"desc"] = pRecipeData.description;
  
  pUploadRecipeDic[@"cover_img"] = pRecipeData.cover_img;

  
  NSString* materialString = [[NSString alloc]init];
  for (int i = 0; i < pRecipeData.materials.count; i++) {
    NSString* m = pRecipeData.materials[i][@"material"];
    NSString* w = pRecipeData.materials[i][@"weight"];
    if (i == 0) {
      materialString = [materialString stringByAppendingFormat:@"%@|%@",m,w];
    } else {
      materialString = [materialString stringByAppendingFormat:@"|%@|%@",m,w];
    }
  }
  
  pUploadRecipeDic[@"materials"] = materialString;
  pUploadRecipeDic[@"tips"] = pRecipeData.tips;
  
  NSString* stepString = [[NSString alloc]init];
  stepString = [stepString stringByAppendingString:@"{\"steps\":["];
  
  for (int i = 0; i < pRecipeData.recipe_steps.count; i++) {
    NSString* pFirstTag = @",";
    if (i == 0) {
      pFirstTag = @"";
    }
    
    stepString = [stepString stringByAppendingFormat:@"%@{\"no\":%d,", pFirstTag, i+1];
    stepString = [stepString stringByAppendingFormat:@"\"content\":\"%@\",", pRecipeData.recipe_steps[i][@"step"]];
    
    if (pRecipeData.recipe_steps[i][@"imageUrl"]) {
      stepString = [stepString stringByAppendingFormat:@"\"img\":\"%@\"}", pRecipeData.recipe_steps[i][@"imageUrl"]];
    } else {
      stepString = [stepString stringByAppendingFormat:@"\"img\":\"%@\"}", @""];
    }
  }
  
  stepString = [stepString stringByAppendingString:@"]}"]; 
  
  pUploadRecipeDic[@"steps"] = stepString;

  if (![[[User sharedInstance] recipe] getIsCreate]) {
    pUploadRecipeDic[@"recipe_id"] = [NSString stringWithFormat:@"%d", pRecipeData.recipe_id];
  }

  HUD.detailsLabelText = nil;
  HUD.labelText = @"发布中...";
  [HUD show:YES];
  isCreate = NO;

  self.uploadOperation = [[[NetManager sharedInstance] hellEngine]
                          createRecipe: pUploadRecipeDic
                          completionHandler:^(NSMutableDictionary *resultDic) {
                            [self createCallBack:resultDic];}
                          errorHandler:^(NSError *error) {
                            HUD.labelText = @"发布超时，请检查网络";
                            HUD.detailsLabelText = nil;
                            [HUD hide:YES afterDelay:1.0];
                          }
                          ];
}

-(void)createCallBack:(NSMutableDictionary*)resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    HUD.labelText = @"发布成功";
    HUD.detailsLabelText = nil;
    [HUD hide:YES afterDelay:1.0];
    isCreate = YES;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_ReloadRecipes" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnShouldRefreshKitchenInfo" object:nil];
  }
  else if (result == 1){

    HUD.labelText = @"发布失败";

    NSInteger error_code = [[resultDic valueForKey:@"errorcode"] intValue];
    if (error_code == GC_RecipeNameInvalid) {
      HUD.labelText = nil;
      HUD.detailsLabelText = @"菜谱名至少两个字并且为英文或是中文字符";
    } else if (error_code == GC_RecipeMaterialInvalid) {
      HUD.labelText = nil;
      HUD.detailsLabelText = @"食材格式不符合规范";
    } else if (error_code == GC_RecipeStepInvalid) {
      HUD.labelText = nil;
      HUD.detailsLabelText = @"步骤格式不符合规范";
    } else if (error_code == GC_RecipeCoverInvalid) {
      HUD.labelText = nil;
      HUD.detailsLabelText = @"封面不存在或者未上传";
    } else if (error_code == GC_RecipeNotBelong2U) {
      HUD.labelText = nil;
      HUD.detailsLabelText = @"你不是菜谱的作者";
    } else if (error_code == GC_RecipeNotExist) {
      HUD.labelText = nil;
      HUD.detailsLabelText = @"菜谱不存在";
    }

    [HUD hide:YES afterDelay:1.0];
    isCreate = NO;
  }
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
  if (isCreate)
  {
    [self.navigationController popToRootViewControllerAnimated:YES];
  }
}

@end
