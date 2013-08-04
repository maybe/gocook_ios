//
//  MyRecipesContorller.m
//  HellCook
//
//  Created by panda on 8/3/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MyRecipesController.h"
#import "MyRecipesTableViewCell.h"
#import "NetManager.h"
#import "LoginController.h"

@interface MyRecipesController ()

@end

@implementation MyRecipesController
@synthesize tableView;
@synthesize mMyRecipeArray;
@synthesize mLoadingActivity;
@synthesize mNetOperation;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    curPage = 0;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self resetTableHeader];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  curPage = 0;
  [mMyRecipeArray removeAllObjects];
  [self getRecipesData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return mMyRecipeArray.count;
}


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  return 90;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  static NSString *CellIdentifier = @"MyRecipesTableViewCell";
  
  MyRecipesTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[MyRecipesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  [cell setData:mMyRecipeArray[indexPath.row]];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // [self.navigationController pushViewController:[[RegisterController alloc]initWithNibName:@"RegisterView" bundle:nil] animated:YES];
 // NSString* recipeIdStr = mMyRecipeArray[indexPath.row][@"recipe_id"];
 // NSInteger recipeId = [recipeIdStr intValue];
  
//  [self.navigationController pushViewController:[[RecipeDetailController alloc]initWithNibName:@"RecipeDetailView" bundle:nil withId:recipeId withPrevTitle:self.title] animated:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  // 下拉到最底部时显示更多数据
  if(scrollView.contentOffset.y + 20 >= ((scrollView.contentSize.height - scrollView.frame.size.height)))
  {
    if (![mNetOperation isExecuting] && !isPageEnd) {
      [self showLoadingView];
      [self getRecipesData];
    }
  }
}


#pragma mark - Net

-(void)getRecipesData
{
  self.mNetOperation = [[[NetManager sharedInstance] hellEngine]
                       getMyRecipesDataByPage: (curPage+1)
                       CompletionHandler:^(NSMutableDictionary *resultDic) {
                         [self getRecipesResultCallBack:resultDic];}
                       errorHandler:^(NSError *error) {
                       }
                       ];
}

- (void)getRecipesResultCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    int totalCount = [resultDic[@"total"] intValue];
    totalPage = totalCount/10 + (totalCount % 10 > 0 ? 1 : 0);
    
    curPage++;
    
    int originsize = mMyRecipeArray.count;
    int addsize = [(NSArray*)resultDic[@"result_recipes"] count];
    if (addsize > 0) {
      [mMyRecipeArray addObjectsFromArray:resultDic[@"result_recipes"]];
      
      NSMutableArray* indexpathArray = [[NSMutableArray alloc]init];
      
      for (int i = 0; i<addsize; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+originsize inSection:0];
        [indexpathArray addObject:indexPath];
      }
      
      if (originsize == 0) {
        [self.tableView reloadData];
      }
      else
      {
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexpathArray withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
      }
    }
    
    if (curPage >= totalPage) {
      isPageEnd = YES;
    }
    
    if (isPageEnd) {
      [self deleteLoadingView];
    }
  }
  else if (result == 1){
    LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
    if (self.navigationController) {
      [self.navigationController presentViewController:m animated:YES completion:nil];
    }
  }
}

- (void)initLoadingView
{
  CGRect frame = self.tableView.tableFooterView.frame;
  frame.size.height = 50;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
  //CGFloat tablewidth = self.tableView.frame.size.width;
  mLoadingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  [mLoadingActivity setCenter:CGPointMake(160, 25)];
  [mLoadingActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  [self.tableView.tableFooterView addSubview:mLoadingActivity];
  [mLoadingActivity stopAnimating];
}

- (void)showLoadingView
{
  CGRect frame = self.tableView.tableFooterView.frame;
  frame.size.height = 50;
  [self.tableView.tableFooterView setFrame:frame];
  [mLoadingActivity startAnimating];
}

- (void)deleteLoadingView
{
  CGRect frame = self.tableView.tableFooterView.frame;
  frame.size.height = 3;
  [mLoadingActivity stopAnimating];
  [mLoadingActivity setHidden:YES];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
}




#pragma mark - TableHeader

- (void)resetTableHeader
{
  CGRect frame = self.tableView.tableHeaderView.frame;
  frame.size.height = 72;
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
  CGFloat tablewidth = self.tableView.frame.size.width;
  
  UIButton* uploadButton = [[UIButton alloc]initWithFrame:CGRectMake(tablewidth/2 - 60, 20, 120, 30)];
  [uploadButton setTitle:@"上传菜谱" forState:UIControlStateNormal];
  UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/grayStretchBackgroundNormal.png"];
  UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  [uploadButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
  
  UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/grayStretchBackgroundHighlighted.png"];
  UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  [uploadButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
  
  [uploadButton addTarget:self action:@selector(openLoginWindow) forControlEvents:UIControlEventTouchUpInside];
    
  [self.tableView.tableHeaderView addSubview:uploadButton];
}


@end
