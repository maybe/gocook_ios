//
//  RecipeDetailController.m
//  HellCook
//
//  Created by panda on 5/6/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "RecipeDetailController.h"
#import "RecipeDetailHeaderTableViewCell.h"
#import "NetManager.h"

@interface RecipeDetailController ()

@end

@implementation RecipeDetailController
@synthesize tableView,netOperation,recipeDataDic,cellContentArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(NSInteger)recipeId
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  
  mRecipeId = recipeId;
  
  return self;
}

- (void)viewDidLoad
{
  CGRect viewframe = self.view.frame;
  viewframe.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewframe];
  
  CGRect tableframe = self.tableView.frame;
  tableframe.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.tableView setFrame:tableframe];
    
  [super viewDidLoad];
  
  [self setLeftButton];
  
  [self.navigationController.navigationBar setHidden:YES];
  
  [self getRecipeDetailData:mRecipeId];

}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.navigationController.navigationBar setHidden:YES];
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
  return kTotalDetailCellNum;
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
  [cell CalculateCellHeight];
  [cell ReformCell];

  return cell;
}

- (RecipeDetailBaseTableViewCell*)GetTableCell:(NSInteger)index
{
  NSString* CellIdentifier = NULL;
  if (index == kDetailHeaderCell) {
    CellIdentifier = @"HeaderCell";
  }
  else
    CellIdentifier = @"NormalCell";
  
  RecipeDetailBaseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[RecipeDetailHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.navigationController pushViewController:[[RecipeDetailController alloc]initWithNibName:@"RecipeDetailView" bundle:nil] animated:YES];
}


- (void)setLeftButton
{
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 60, 30)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  UIImage *stretchedBackground = [[UIImage imageNamed:@"Images/recipeBack.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
  
  [leftBarButtonView setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:stretchedBackground forState:UIControlStateHighlighted];
  
  [leftBarButtonView setTitle:@"" forState:UIControlStateNormal];
  [leftBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  //UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  //[self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
  [self.view addSubview:leftBarButtonView];
}

- (void)returnToPrev
{
  if ([netOperation isExecuting]) {
    [netOperation cancel];
  }
  [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)isSupportAnimPushPop
{
  return YES;
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

@end
