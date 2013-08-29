//
//  RecipeDetailController.m
//  HellCook
//
//  Created by panda on 5/6/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "RecipeDetailController.h"
#import "RecipeDetailHeaderTableViewCell.h"
#import "RecipeDetailMaterialTableViewCell.h"
#import "RecipeDetailStepsTableViewCell.h"
#import "NetManager.h"
#import "DBHandler.h"
#import "RecipeDetailFooterView.h"
#import "RecipeCommentViewController.h"

@interface RecipeDetailController ()

@end

@implementation RecipeDetailController
@synthesize tableView,netOperation,recipeDataDic,cellContentArray,mPrevTitle;
@synthesize recipeCommentsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(NSInteger)recipeId withPrevTitle:(NSString*) prevName
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  
  mRecipeId = recipeId;
  mPrevTitle = [[NSString alloc]initWithString:prevName];
  recipeCommentsArray = [[NSMutableArray alloc] init];
  
  return self;
}

- (void)viewDidLoad
{
  CGRect viewframe = self.view.frame;
  viewframe.size.height = _screenHeight_NoStBar;
  [self.view setFrame:viewframe];
  
  CGRect tableframe = self.tableView.frame;
  tableframe.size.height = _screenHeight_NoStBar;
  [self.tableView setFrame:tableframe];

  [super viewDidLoad];
  
  [self setLeftButton];
  

  [self getRecipeDetailData:mRecipeId];
  [self getCommentsData];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.title = @"最热菜谱";
  
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
  return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RecipeDetailBaseTableViewCell* cell = [self GetTableCell:indexPath.row];
  [cell setData: recipeDataDic];
  [cell CalculateCellHeight];
  return [cell GetCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RecipeDetailBaseTableViewCell* cell = [self GetTableCell:indexPath.row];
  
  [cell setData: recipeDataDic];
  if (indexPath.row != kDetailStepsCell)
    [cell CalculateCellHeight];
  [cell ReformCell];

  return cell;
}

- (RecipeDetailBaseTableViewCell*)GetTableCell:(NSInteger)index
{
  NSString* CellIdentifier = NULL;
  if (index == kDetailHeaderCell)
    CellIdentifier = @"HeaderCell";
  else if (index == kDetailMaterialCell)
    CellIdentifier = @"MaterialCell";
  else if (index == kDetailStepsCell)
    CellIdentifier = @"StepCell";

  RecipeDetailBaseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell && [CellIdentifier isEqualToString:@"HeaderCell"]) {
    cell = [[RecipeDetailHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if ([[DBHandler sharedInstance] isInShoppingList:mRecipeId] ) {
      [((RecipeDetailHeaderTableViewCell*)cell).buyButton setTitle:@"已加入清单" forState:UIControlStateNormal];
;
    }
  }
  else if (!cell && [CellIdentifier isEqualToString:@"MaterialCell"]) {
    cell = [[RecipeDetailMaterialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  else if (!cell && [CellIdentifier isEqualToString:@"StepCell"]) {
    cell = [[RecipeDetailStepsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //[self.navigationController pushViewController:[[RecipeDetailController alloc]initWithNibName:@"RecipeDetailView" bundle:nil] animated:YES];
}


- (void)addToShoppingList
{
  if (!recipeDataDic[@"recipe_name"]) {
    return;
  }
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kDetailHeaderCell inSection:0];
  RecipeDetailHeaderTableViewCell* cell = (RecipeDetailHeaderTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
  if ([[cell.buyButton titleForState:UIControlStateNormal] isEqualToString:@"已加入清单"]) {
    if ([[DBHandler sharedInstance] isInShoppingList: mRecipeId]) {
      [[DBHandler sharedInstance] removeFromShoppingList:mRecipeId];
    }
    [cell.buyButton setTitle:@"+ 购买清单" forState:UIControlStateNormal];
    
  } else {
    if (![[DBHandler sharedInstance] isInShoppingList: mRecipeId]) {
      NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
      [dic setObject:[NSNumber numberWithInt:mRecipeId] forKey:@"recipeid"];
      [dic setObject:recipeDataDic[@"materials"] forKey:@"materials"];
      [dic setObject:recipeDataDic[@"recipe_name"] forKey:@"name"];
      [[DBHandler sharedInstance] addToShoppingList:dic];
      
      [cell.buyButton setTitle:@"已加入清单" forState:UIControlStateNormal];
    }
  }
}

- (void)setLeftButton
{
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 60, 30)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  UIImage *stretchedBackground = [[UIImage imageNamed:@"Images/recipeBack.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
  
  [leftBarButtonView setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:stretchedBackground forState:UIControlStateHighlighted];
  
  [leftBarButtonView setTitle:mPrevTitle forState:UIControlStateNormal];
  [leftBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  [leftBarButtonView.titleLabel setTextColor:[UIColor colorWithRed:234.0/255.0 green:232.0/255.0 blue:230.0/255.0 alpha:1.0]];
  
  
  CGSize titleLabelSize = [mPrevTitle sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(256, 20) lineBreakMode:NSLineBreakByWordWrapping];

  [leftBarButtonView setFrame:CGRectMake(20, 10, titleLabelSize.width + 20, 30)];
  //UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  //[self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
  [self.view addSubview:leftBarButtonView];
}

- (void)returnToPrev
{
  if ([netOperation isExecuting]) {
    [netOperation cancel];
  }
  
  if ([mPrevTitle isEqualToString:@"我的收藏"] || [mPrevTitle isEqualToString:@"购买清单"]) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
  else
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)isSupportAnimPushPop
{
  return YES;
}

- (void)tapComment
{
  RecipeCommentViewController *pController = [[RecipeCommentViewController alloc] initWithNibName:@"RecipeCommentView" bundle:nil withRecipeID:mRecipeId withData:recipeCommentsArray];
  [self.navigationController pushViewController:pController animated:YES];
}

- (void)collectRecipe:(UIButton*)btn
{
  NSString *title = [btn associativeObjectForKey:@"title"];
  if ([title isEqualToString:@"已收藏"])
  {
    [self delCollection];
  }
  else
  {
    [self addCollection];
  }
  
}

#pragma mark - Net

-(void)getRecipeDetailData:(NSInteger)recipeId
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getRecipeDetailData:recipeId
                       CompletionHandler:^(NSMutableDictionary *resultDic) {
                         [self getRecipeDetailCallBack:resultDic];}
                       errorHandler:^(NSError *error) {}];
}

- (void)getRecipeDetailCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0) {
    recipeDataDic = [[NSDictionary alloc]initWithDictionary:resultDic[@"result_recipe"]];
  }
  
  [self.tableView reloadData];
}

- (void)getCommentsData
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getCommentsWithRecipeID:mRecipeId
                       CompletionHandler:^(NSMutableDictionary *resultDic){
                         [self getCommentsDataCallBack:resultDic];
                       }
                       errorHandler:^(NSError *error){}];
}

- (void)getCommentsDataCallBack:(NSMutableDictionary*)resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    recipeCommentsArray = [NSMutableArray arrayWithArray:resultDic[@"result_recipe_comments"]];
    
    CGRect frame = self.tableView.tableFooterView.frame;
    frame.size.height = 50;
    frame.size.width = _screenWidth;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
    RecipeDetailFooterView *footerView = [[RecipeDetailFooterView alloc] initWithFrame:frame withCommentNum:[recipeCommentsArray count]];
    
    [self.tableView.tableFooterView addSubview:footerView];
  }
  else
  {
    CGRect frame = self.tableView.tableFooterView.frame;
    frame.size.height = 50;
    frame.size.width = _screenWidth;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
    RecipeDetailFooterView *footerView = [[RecipeDetailFooterView alloc] initWithFrame:frame withCommentNum:0];
    
    [self.tableView.tableFooterView addSubview:footerView];
  }
}

- (void)addCollection
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       addCollectionWithCollID:[recipeDataDic[@"recipe_id"] intValue]
                       completionHandler:^(NSMutableDictionary *resultDic){
                         [self addCollectionCallBack:resultDic];
                       }
                       errorHandler:^(NSError *error){}];
}

- (void)addCollectionCallBack:(NSMutableDictionary*)resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kDetailHeaderCell inSection:0];
    RecipeDetailHeaderTableViewCell* cell = (RecipeDetailHeaderTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.collectButton setTitle:@"已收藏" forState:UIControlStateNormal];
    [cell.collectButton setAssociativeObject:@"已收藏" forKey:@"title"];
  }
}

- (void)delCollection
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       delCollectionWithCollID:[recipeDataDic[@"recipe_id"] intValue]
                       completionHandler:^(NSMutableDictionary *resultDic){
                         [self delCollectionCallBack:resultDic];
                       }
                       errorHandler:^(NSError *error){}];
}

- (void)delCollectionCallBack:(NSMutableDictionary*)resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kDetailHeaderCell inSection:0];
    RecipeDetailHeaderTableViewCell* cell = (RecipeDetailHeaderTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.collectButton setTitle:@"未收藏" forState:UIControlStateNormal];
    [cell.collectButton setAssociativeObject:@"未收藏" forKey:@"title"];
  }
}

@end
