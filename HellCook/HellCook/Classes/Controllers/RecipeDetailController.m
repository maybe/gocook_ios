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
#import "RecipeDetailTipsTableViewCell.h"
#import "NetManager.h"
#import "DBHandler.h"
#import "RecipeDetailFooterView.h"
#import "RecipeCommentViewController.h"

@interface RecipeDetailController ()

@end

@implementation RecipeDetailController
@synthesize tableView,netOperation,recipeDataDic,cellContentArray;
@synthesize recipeCommentsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(NSInteger)recipeId
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  
  mRecipeId = recipeId;
  recipeCommentsArray = [[NSMutableArray alloc] init];

  return self;
}

- (void)viewDidLoad
{
  CGRect viewFrame = self.view.frame;
  if (HCSystemVersionGreaterOrEqualThan(7.0)) {
    viewFrame.origin.y = -_stateBarHeight;
    viewFrame.size.height = _screenHeight + _stateBarHeight;
  } else {
    viewFrame.size.height = _screenHeight_NoStBar;
  }
  [self.view setFrame:viewFrame];
  self.view.autoresizesSubviews = NO;

  CGRect tableFrame = self.tableView.frame;
  if (HCSystemVersionGreaterOrEqualThan(7.0)) {
    tableFrame.origin.y = -_stateBarHeight;
    tableFrame.size.height = _screenHeight + _stateBarHeight;
  } else {
    tableFrame.size.height = _screenHeight_NoStBar;
  }
  [self.tableView setFrame:tableFrame];

  UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, _screenHeight)];
  UIImageView *backImageView = NULL;
  if (HCSystemVersionGreaterOrEqualThan(7.0)) {
    backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, _screenWidth, _screenHeight)];
  } else {
    backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, _screenHeight)];
  }

  [backImageView setImage:[UIImage imageNamed:@"Images/RecipeDetailBackground.png"]];
  [backImageView setContentMode:UIViewContentModeTop];
  [backView addSubview:backImageView];
  [self.tableView setBackgroundView:backView];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationController.view.backgroundColor = [UIColor whiteColor];

  [self setLeftButton];
  [self initLoadingView];

  [self getRecipeDetailData:mRecipeId];
  [self getCommentsData];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnCommentSuccess:) name:@"EVT_OnCommentSuccess" object:nil];

  [super viewDidLoad];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
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
  if (recipeDataDic)
    return kTotalDetailCellNum;
  else
    return 0;
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
  else if (index == kDetailTipsCell)
    CellIdentifier = @"TipsCell";

  RecipeDetailBaseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell && [CellIdentifier isEqualToString:@"HeaderCell"]) {
    cell = [[RecipeDetailHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if ([[DBHandler sharedInstance] isInShoppingList:mRecipeId] ) {
      [((RecipeDetailHeaderTableViewCell*)cell).buyButton setTitle:@"已加入清单" forState:UIControlStateNormal];
      UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/CollectedButton.png"];
      UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
      [((RecipeDetailHeaderTableViewCell*)cell).buyButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
;
    }
  }
  else if (!cell && [CellIdentifier isEqualToString:@"MaterialCell"]) {
    cell = [[RecipeDetailMaterialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  else if (!cell && [CellIdentifier isEqualToString:@"StepCell"]) {
    cell = [[RecipeDetailStepsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  else if (!cell && [CellIdentifier isEqualToString:@"TipsCell"]) {
    cell = [[RecipeDetailTipsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/BuyButton.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [cell.buyButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];

    [cell.buyButton setTitle:@"+ 购买清单" forState:UIControlStateNormal];
    
  } else {
    if (![[DBHandler sharedInstance] isInShoppingList: mRecipeId]) {
      NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
      [dic setObject:[NSNumber numberWithInt:mRecipeId] forKey:@"recipeid"];
      [dic setObject:recipeDataDic[@"materials"] forKey:@"materials"];
      [dic setObject:recipeDataDic[@"recipe_name"] forKey:@"name"];
      [[DBHandler sharedInstance] addToShoppingList:dic];

      UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/CollectedButton.png"];
      UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
      [cell.buyButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];

      [cell.buyButton setTitle:@"已加入清单" forState:UIControlStateNormal];
    }
  }
}

- (void)setLeftButton
{
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 49, 29)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  UIImage *background = [UIImage imageNamed:@"Images/RecipeDetailReturn.png"];
  
  [leftBarButtonView setBackgroundImage:background forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:background forState:UIControlStateHighlighted];

  [self.view addSubview:leftBarButtonView];
}

- (void)returnToPrev
{
  if ([netOperation isExecuting]) {
    [netOperation cancel];
  }

  [self.navigationController popViewControllerAnimated:YES];
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
  [mLoadingActivity startAnimating];

  self.netOperation = [[[NetManager sharedInstance] hellEngine]
      getRecipeDetailData:recipeId
        completionHandler:^(NSMutableDictionary *resultDic) {
          [self getRecipeDetailCallBack:resultDic];
        }
             errorHandler:^(NSError *error) {
             }];
}

- (void)getRecipeDetailCallBack:(NSMutableDictionary*) resultDic
{
  [mLoadingActivity stopAnimating];

  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0) {
    recipeDataDic = [[NSMutableDictionary alloc]initWithDictionary:resultDic[@"result_recipe"]];
  }

  [self.tableView reloadData];

  self.tableView.tableFooterView.hidden = NO;
}

- (void)getCommentsData
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
      getCommentsWithRecipeID:mRecipeId
            completionHandler:^(NSMutableDictionary *resultDic) {
              [self getCommentsDataCallBack:resultDic];
            }
                 errorHandler:^(NSError *error) {
                 }];
}

- (void)getCommentsDataCallBack:(NSMutableDictionary*)resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    recipeCommentsArray = [NSMutableArray arrayWithArray:resultDic[@"result_recipe_comments"]];
    [self ResetCommentView];
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

  if (!recipeDataDic) {
    self.tableView.tableFooterView.hidden = YES;
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

    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/CollectedButton.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [cell.collectButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];

    [cell.collectButton setAssociativeObject:@"已收藏" forKey:@"title"];

    recipeDataDic[@"collect"] = @"0";
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

    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/CollectButton.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [cell.collectButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];

    recipeDataDic[@"collect"] = @"1";
  }
}

- (void)initLoadingView {
  mLoadingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  [mLoadingActivity setCenter:CGPointMake(160, 64)];
  [mLoadingActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
  [self.view addSubview:mLoadingActivity];
  [self.view bringSubviewToFront:mLoadingActivity];
  [mLoadingActivity stopAnimating];
}

- (void)OnCommentSuccess: (NSNotification *)notification
{
  NSMutableDictionary *dict = (NSMutableDictionary*)notification.object;
  NSDictionary *tmpDic = [[NSDictionary alloc] initWithDictionary:dict];
  [recipeCommentsArray insertObject:tmpDic atIndex:0];

  [self ResetCommentView];
}

-(void)ResetCommentView
{
  CGRect frame = self.tableView.tableFooterView.bounds;
  frame.size.height = 50;
  frame.size.width = _screenWidth;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
  RecipeDetailFooterView *footerView = [[RecipeDetailFooterView alloc] initWithFrame:frame withCommentNum:[recipeCommentsArray count]];

  [self.tableView.tableFooterView addSubview:footerView];
}
@end
