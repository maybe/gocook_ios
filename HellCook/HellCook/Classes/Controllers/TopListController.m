//
//  TopListController.m
//  HellCook
//
//  Created by panda on 5/5/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "TopListController.h"
#import "TopListTableViewCell.h"
#import "NetManager.h"
#import "RecipeDetailController.h"

@interface TopListController ()

@end

@implementation TopListController
@synthesize tableView,netOperation,topArray,topListType,loadingActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    curPage = 0;
    isPageEnd = false;
  }
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
  
  topArray = [[NSMutableArray alloc]init];
  [self initLoadingView];
  [self showLoadingView];
  [self getTopListData];
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.navigationController.navigationBar setHidden:NO];
  
  [super viewWillAppear:animated];
  if (topListType == TLT_TopHot)
    self.title = @"最热菜谱";
  else
    self.title = @"最新菜谱";
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
  return topArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 210;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"TopListTableViewCell";
  
  TopListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
      cell = [[TopListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  [cell setData:topArray[indexPath.row]];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString* recipeIdStr = topArray[indexPath.row][@"recipe_id"];
  NSInteger recipeId = [recipeIdStr intValue];
  
  [self.navigationController pushViewController:[[RecipeDetailController alloc]initWithNibName:@"RecipeDetailView" bundle:nil withId:recipeId withPrevTitle:self.title] animated:YES];
}


//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//
//{  
//  // 下拉到最底部时显示更多数据
//  if(scrollView.contentOffset.y + 40 >= ((scrollView.contentSize.height - scrollView.frame.size.height)))
//  {
//    if (!isGettingData) {
//      [self showLoadingView];
//      [self getTopListData];
//    }
//  }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  // 下拉到最底部时显示更多数据
  if(scrollView.contentOffset.y + 20 >= ((scrollView.contentSize.height - scrollView.frame.size.height)))
  {
    if (![netOperation isExecuting] && curPage<5 && !isPageEnd) {
      [self showLoadingView];
      [self getTopListData];
    }
  }
}


#pragma mark - Net

-(void)getTopListData
{
  if (topListType == TLT_TopHot) {
    self.netOperation = [[[NetManager sharedInstance] hellEngine]
                         getTopHotDataWithPage:(curPage+1)
                         CompletionHandler:^(NSMutableDictionary *resultDic) {
                           [self getTopCallBack:resultDic];}
                         errorHandler:^(NSError *error) {
                         }
                         ];
  }
  else
  {
    self.netOperation = [[[NetManager sharedInstance] hellEngine]
                         getTopNewDataWithPage:(curPage+1)
                         CompletionHandler:^(NSMutableDictionary *resultDic) {
                           [self getTopCallBack:resultDic];}
                         errorHandler:^(NSError *error) {
                         }
                         ];
  }
}

- (void)getTopCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    curPage++;
    
    int originsize = topArray.count;
    int addsize = [(NSArray*)resultDic[@"result_recipes"] count];
   
    [topArray addObjectsFromArray:resultDic[@"result_recipes"]];
    
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
    
    if (curPage == 5 || addsize<10) {
      isPageEnd = YES;
    }
    
    if (isPageEnd) {
      [self deleteLoadingView];
    }
  }
}

- (void)initLoadingView
{
  CGRect frame = self.tableView.tableFooterView.frame;
  frame.size.height = 50;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
  //CGFloat tablewidth = self.tableView.frame.size.width;
  loadingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  [loadingActivity setCenter:CGPointMake(160, 25)];
  [loadingActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  [self.tableView.tableFooterView addSubview:loadingActivity];
  [loadingActivity stopAnimating];
}

- (void)showLoadingView
{
  CGRect frame = self.tableView.tableFooterView.frame;
  frame.size.height = 50;
  [self.tableView.tableFooterView setFrame:frame];
  [loadingActivity startAnimating];
}

- (void)deleteLoadingView
{
  CGRect frame = self.tableView.tableFooterView.frame;
  frame.size.height = 3;
  [loadingActivity stopAnimating];
  [loadingActivity setHidden:YES];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
}


- (void)setLeftButton
{
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundHighlighted.png"]
                               forState:UIControlStateHighlighted];
  [leftBarButtonView setTitle:@"返回" forState:UIControlStateNormal];
  [leftBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)returnToPrev
{
  if ([netOperation isExecuting]) {
    [netOperation cancel];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

@end
