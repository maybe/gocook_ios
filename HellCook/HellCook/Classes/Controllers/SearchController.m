//
//  SearchController.m
//  HellCook
//
//  Created by panda on 5/6/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "SearchController.h"
#import "AppDelegate.h"
#import "NetManager.h"
#import "SearchTableViewCell.h"

@interface SearchController ()

@end

@implementation SearchController
@synthesize tableView, searchBarView, searchKey, netOperation, loadingActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil keyword:(NSString*)key
{
  self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  curPage = 0;
  searchKey = [[NSString alloc]initWithString:key];
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  CGRect viewframe = self.view.frame;
  viewframe.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewframe];
  
  searchBarView = [[SearchBarView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
  [self.view addSubview:searchBarView];
  
  CGRect tableframe = self.tableView.frame;
  tableframe.size.height = _screenHeight_NoStBar_NoNavBar-44;
  [self.tableView setFrame:tableframe];
  
  [self setLeftButton];
  
  recipeArray = [[NSMutableArray alloc]init];
  [self initLoadingView];
  [self showLoadingView];
  [self getSearchData];
}

- (void)viewWillAppear:(BOOL)animated
{
  self.title = searchKey;
  [searchBarView setSearchKeyword:searchKey];
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
  return recipeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"SearchTableViewCell";
  
  SearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  [cell setData:recipeArray[indexPath.row]];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // [self.navigationController pushViewController:[[RegisterController alloc]initWithNibName:@"RegisterView" bundle:nil] animated:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  // 下拉到最底部时显示更多数据
  if(scrollView.contentOffset.y + 20 >= ((scrollView.contentSize.height - scrollView.frame.size.height)))
  {
    if (![netOperation isExecuting] && !isPageEnd) {
      [self showLoadingView];
      [self getSearchData];
    }
  }
}


#pragma mark - Net

-(void)getSearchData
{
    self.netOperation = [[[NetManager sharedInstance] cookEngine]
                         searchWithKey:searchKey AndPage:(curPage+1)
                         CompletionHandler:^(NSMutableDictionary *resultDic) {
                           [self getSearchResultCallBack:resultDic];}
                         errorHandler:^(NSError *error) {
                         }
                         ];
}

- (void)getSearchResultCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    curPage++;
    
    int originsize = recipeArray.count;
    int addsize = [(NSArray*)resultDic[@"result_recipes"] count];
    if (addsize>0) {
      [recipeArray addObjectsFromArray:resultDic[@"result_recipes"]];
      
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

    
    if (addsize<10) {
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


- (void)goSearch
{
  NSString* keyword =[searchBarView getSearchKeyword];
                      
  if (![keyword isEqualToString:@""])
    [self.navigationController pushViewController:[[SearchController alloc]initWithNibName:@"SearchView" bundle:nil keyword:keyword] animated:YES];
}

@end
