//
//  MyRecipesEditController.m
//  HellCook
//
//  Created by panda on 8/5/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MyRecipesMaterialController.h"
#import "KeyboardHandler.h"
#import "UIView+FindFirstResponder.h"
#import "User.h"
#import "MyRecipesStepController.h"

@interface MyRecipesMaterialController ()

@end

@implementation MyRecipesMaterialController
@synthesize tableView, recipeData;

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
  
  CGRect frameHeader = self.tableView.tableHeaderView.frame;
  frameHeader.size.height = 44;
  self.tableView.tableHeaderView = [[MyRecipeMaterialTableViewHeader alloc]initWithFrame:frameHeader];
  
  CGRect frameFooter = self.tableView.tableFooterView.frame;
  frameFooter.size.height = 44;
  self.tableView.tableFooterView = [[MyRecipeMaterialTableViewFooter alloc]initWithFrame:frameFooter];
  
  //keyboard
  keyboard = [[KeyboardHandler alloc] init];
  
  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];
  [self.tableView setFrame:viewFrame];
  
  cellContentList = [[NSMutableArray alloc]init];
  recipeData = nil;
  if ([[[User sharedInstance] recipe] getIsCreate]) {
    recipeData = [[[User sharedInstance] recipe] getCreateRecipeData];
  } else {
    recipeData = [[[User sharedInstance] recipe] getModifyRecipeData];
  }

  [self autoLayout];
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  keyboard.delegate = self;

  [cellContentList removeAllObjects];
  [cellContentList addObjectsFromArray: recipeData.materials];
  [tableView reloadData];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
  return cellContentList.count;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  NSString* Identifier = @"MaterialCell";
  MyRecipeMaterialTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:Identifier];
  if (cell == nil) {
    cell = [[MyRecipeMaterialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: Identifier];
  }
  
  [cell setDelegate: self];
  [cell setData: [cellContentList objectAtIndex: (NSUInteger)indexPath.row]];
  
  return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignMyRecipeMaterialTextField" object:nil];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Add line
- (void)addMaterialLine
{
  NSMutableDictionary* pMaterialLineDic = [[NSMutableDictionary alloc]init];
  [pMaterialLineDic setObject:@"" forKey:@"material"];
  [pMaterialLineDic setObject:@"" forKey:@"weight"];
  [cellContentList addObject: pMaterialLineDic];
  
  NSMutableArray* indexPathArray = [[NSMutableArray alloc]init];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellContentList.count-1 inSection:0];
  [indexPathArray addObject:indexPath];
  
  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
  [self.tableView endUpdates];
}

#pragma mark - Keyboard

- (void)keyboardSizeChanged:(CGSize)delta
{
  UIView* frView = [self.tableView findFirstResponder];
  if ([frView isKindOfClass:[UITextField class]]) {
    if (delta.height > 0) {
      CGPoint realOrigin = [frView convertPoint:frView.frame.origin toView:nil];
      if (realOrigin.y + frView.frame.size.height  > _screenHeight - delta.height) {
        CGFloat deltaHeight = realOrigin.y + frView.frame.size.height - ( _screenHeight - delta.height) + 10;
        CGRect frame = self.tableView.frame;
        frame.origin.y -= deltaHeight;
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


#pragma mark - Navigation Buttons

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
   [UIImage imageNamed:@"Images/NextStepNormal.png"]
                                forState:UIControlStateNormal];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/NextStepHighLight.png"]
                                forState:UIControlStateHighlighted];

  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
  
  [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

-(void)returnToPrev
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignMyRecipeMaterialTextField" object:nil];
  
  [self setDataToRecipe];
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNext
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignMyRecipeMaterialTextField" object:nil];
  
  [self setDataToRecipe];

  [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnPushStepController" object:nil];
}

#pragma mark - Set Data to Recipe
-(void)setDataToRecipe
{
  [recipeData.materials removeAllObjects];
  
  for (NSUInteger i = 0; i < cellContentList.count; i++) {
    NSString* materialStr = [cellContentList[i][@"material"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* weightStr = [cellContentList[i][@"weight"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (![materialStr isEqualToString:@""]) {
      
      NSMutableDictionary* pDic = [[NSMutableDictionary alloc]init];
      
      pDic[@"material"] = [[NSString alloc]initWithString:materialStr];
      pDic[@"weight"] = [[NSString alloc]initWithString:weightStr];
      
      [recipeData.materials addObject:pDic];
    }
  }
}

- (void)changeInputData:(NSString*)data On:(NSInteger)type WithIndex:(NSUInteger)index
{
  // 0: material
  if (type == 0) {
    cellContentList[index][@"material"] = [[NSString alloc]initWithString:data];
  } else {
    cellContentList[index][@"weight"] = [[NSString alloc]initWithString:data];    
  }
}

@end
