//
//  MyCollectionController.m
//  HellCook
//
//  Created by lxw on 13-7-28.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyCollectionController.h"
#import "NetManager.h"
#import "RecipeDetailController.h"
#import "MyCollectionTableViewCell.h"
#import "User.h"
#import "LoginController.h"

@interface MyCollectionController ()

@end

@implementation MyCollectionController
@synthesize tableView;
@synthesize mLoadingActivity;
@synthesize netOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      curPage = 0;
      bShouldRefresh = TRUE;
      bSessionInvalid = FALSE;
      myCollectionArray = [[NSMutableArray alloc] init];
      [self initLoadingView];
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib
  self.navigationItem.title = @"我的收藏";
  
  CGRect viewframe = self.view.frame;
  viewframe.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewframe];
  [self.tableView setFrame:viewframe];
  
  [self setLeftButton];
}

- (void) viewWillAppear:(BOOL)animated
{
  [self getMyCollectionData];
  
  if (bSessionInvalid)
  {
    bSessionInvalid = FALSE;
    [self getMyCollectionData];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return myCollectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"MyCollectionTableViewCell";
  
  MyCollectionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
  {
    cell = [[MyCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  [cell setData:myCollectionArray[indexPath.row]];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // [self.navigationController pushViewController:[[RegisterController alloc]initWithNibName:@"RegisterView" bundle:nil] animated:YES];
  NSString* recipeIdStr = myCollectionArray[indexPath.row][@"recipe_id"];
  NSInteger recipeId = [recipeIdStr intValue];

//  [self.navigationController pushViewController:[[RecipeDetailController alloc]initWithNibName:@"RecipeDetailView" bundle:nil withId:recipeId withPrevTitle:titile] animated:YES];
  [self.navigationController presentViewController:[[RecipeDetailController alloc]initWithNibName:@"RecipeDetailView" bundle:nil withId:recipeId withPrevTitle:@"我的收藏"] animated:YES completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  // 下拉到最底部时显示更多数据
  if(scrollView.contentOffset.y + 20 >= ((scrollView.contentSize.height - scrollView.frame.size.height)))
  {
    if (![self.netOperation isExecuting] && bShouldRefresh) {
      [self showLoadingView];
      [self getMyCollectionData];
    }
  }
}


#pragma mark - Return Button
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
  if ([self.netOperation isExecuting]) {
    [self.netOperation cancel];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Net

-(void)getMyCollectionData
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getMyCollectionDataByPage:(curPage+1)
                       CompletionHandler:^(NSMutableDictionary *resultDic) {
                         [self getMyCollectionDataCallBack:resultDic];}
                       errorHandler:^(NSError *error) {}
                       ];
  
}

- (void)getMyCollectionDataCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    int totalCount = [resultDic[@"total"] intValue];
    totalPage = totalCount/10 + (totalCount % 10 > 0 ? 1 : 0);
    int originsize = myCollectionArray.count;
    int addsize = [(NSArray*)resultDic[@"result_recipes"] count];
    if (addsize > 0)
    {
      curPage++;
      [myCollectionArray addObjectsFromArray:resultDic[@"result_recipes"]];
      
      if (originsize == 0)
      {
        [self.tableView reloadData];
      }
      else
      {
        NSMutableArray* indexpathArray = [[NSMutableArray alloc]init];
        for (int i = 0; i<addsize; i++)
        {
          NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+originsize inSection:0];
          [indexpathArray addObject:indexPath];
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexpathArray withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
      }
    }
    
    if (curPage >= totalPage)
      bShouldRefresh = FALSE;
    if (!bShouldRefresh)
      [self deleteLoadingView];
    
    [[[User sharedInstance] collection] SetMyCollectionArray:myCollectionArray];
  }
  else if (result == 1)
  {
    LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
    if (self.navigationController)
    {
      [self.navigationController presentViewController:m animated:YES completion:nil];
    }
  }
}

@end
