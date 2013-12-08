//
//  MyRecipesController.m
//  HellCook
//
//  Created by panda on 8/3/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MyRecipesController.h"
#import "MyRecipesTableViewCell.h"
#import "NetManager.h"
#import "LoginController.h"
#import "MyRecipesEditController.h"
#import "User.h"
#import "ODRefreshControl.h"
#import "MyRecipeDetailController.h"

@interface MyRecipesController ()

@end

@implementation MyRecipesController
@synthesize tableView;
@synthesize mMyRecipeArray;
@synthesize mLoadingActivity;
@synthesize mNetOperation;
@synthesize userId;
@synthesize titleName;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSInteger)userID AndName:(NSString *)userName
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    curPage = 0;
    firstLoad = YES;
    userId = userID;
    titleName = [[NSString alloc] initWithFormat:@"%@的菜谱", userName];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self autoLayout];

  if ([[[User sharedInstance] account] user_id] == userId) {
    [self resetTableHeader];
  }

  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar_NoTabBar;
  CGRect tableFrame = self.tableView.frame;
  tableFrame.size.height = _screenHeight_NoStBar_NoNavBar_NoTabBar;
  [self.view setFrame:viewFrame];
  self.view.autoresizesSubviews = NO;
  [self.tableView setFrame:tableFrame];

  refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
  [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
  refreshControl.tintColor = [UIColor colorWithRed:120.0 / 255.0 green:120.0 / 255.0 blue:120.0 / 255.0 alpha:1.0];

  mLoadingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  [mLoadingActivity setCenter:CGPointMake(160, 25)];
  [mLoadingActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  [mLoadingActivity stopAnimating];
  [self initLoadingView];

  mMyRecipeArray = [[NSMutableArray alloc] init];

  HUD = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:HUD];
  HUD.mode = MBProgressHUDModeCustomView;
  HUD.delegate = self;

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnLoginSuccess:) name:@"EVT_OnLoginSuccess" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnReloadRecipe:) name:@"EVT_ReloadRecipes" object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadRecipeData {
  curPage = 0;
  isPageEnd = NO;
  //[self.tableView reloadData];
  [self getRecipesData];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)aRefreshControl {
  [self initLoadingView];
  [self reloadRecipeData]; //下拉刷新的话就不显示loadingView的圈了
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if ([[[User sharedInstance] account] user_id] == userId) {
    self.tabBarController.navigationItem.title = @"我的菜谱";
  } else {
    self.tabBarController.navigationItem.title = titleName;
  }

  [self.tabBarController.navigationItem setRightBarButtonItem:nil];

  if (firstLoad) {
    [mMyRecipeArray removeAllObjects];
    [tableView reloadData];
    [self reloadRecipeData];
    [self showLoadingView];
    firstLoad = NO;
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
  return mMyRecipeArray.count;
}


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
  return 208;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *CellIdentifier = @"MyRecipesTableViewCell";

  MyRecipesTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[MyRecipesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }

  [cell setData:mMyRecipeArray[(NSUInteger)indexPath.row]];

  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString* recipeIdStr = mMyRecipeArray[(NSUInteger)indexPath.row][@"recipe_id"];
  NSInteger recipeId = [recipeIdStr intValue];

  if ([[[User sharedInstance] account] user_id] == userId) {
    [self.navigationController pushViewController:[[MyRecipeDetailController alloc]initWithNibName:@"RecipeDetailView" bundle:nil withId:recipeId] animated:YES];
  } else {
    [self.navigationController pushViewController:[[RecipeDetailController alloc]initWithNibName:@"RecipeDetailView" bundle:nil withId:recipeId] animated:YES];
  }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  // 下拉到最底部时显示更多数据
  if (scrollView.contentOffset.y + 40 >= ((scrollView.contentSize.height - scrollView.frame.size.height))) {
    if (![mNetOperation isExecuting] && !isPageEnd) {
      [self showLoadingView];
      [self getRecipesData];
    }
  }
}



#pragma mark - Net

- (void)getRecipesData {
  self.mNetOperation = [[[NetManager sharedInstance] hellEngine]
      getUserRecipesDataByPage:(curPage + 1)
            WithUserID:userId
             completionHandler:^(NSMutableDictionary *resultDic) {
               [self getRecipesResultCallBack:resultDic];
             }
                  errorHandler:^(NSError *error) {
                  }
  ];
}

- (void)getRecipesResultCallBack:(NSMutableDictionary *)resultDic {
  if ([refreshControl isRefreshing]) {
    [mMyRecipeArray removeAllObjects];
    [refreshControl endRefreshing];
  }

  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success) {
    int totalCount = [resultDic[@"totalrecipecount"] intValue];
    totalPage = totalCount / 10 + (totalCount % 10 > 0 ? 1 : 0);

    curPage++;

    int originSize = mMyRecipeArray.count;
    int addSize = [(NSArray *) resultDic[@"result_recipes"] count];
    if (addSize > 0) {
      [mMyRecipeArray addObjectsFromArray:resultDic[@"result_recipes"]];

      NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];

      for (int i = 0; i < addSize; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i + originSize inSection:0];
        [indexPathArray addObject:indexPath];
      }

      if (originSize == 0) {
        [self.tableView reloadData];
      }
      else {
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
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
  else {
    NSInteger errorCode = [[resultDic valueForKey:@"errorcode"] intValue];
    if (errorCode == GC_AuthAccountInvalid) {
      LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);

      if (self.mm_drawerController) {
        [self.mm_drawerController.navigationController pushViewController:m animated:YES];
      } else {
        [self.navigationController pushViewController:m animated:YES];
      }
    }
  }
}


- (void)initLoadingView {
  CGRect frame = self.tableView.tableFooterView.frame;
  frame.size.height = 50;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
  [self.tableView.tableFooterView addSubview:mLoadingActivity];
  [mLoadingActivity stopAnimating];
}

- (void)showLoadingView {
  CGRect frame = self.tableView.tableFooterView.frame;
  frame.size.height = 50;
  [self.tableView.tableFooterView setFrame:frame];
  [mLoadingActivity startAnimating];
  [mLoadingActivity setHidden:NO];
}

- (void)deleteLoadingView {
  CGRect frame = self.tableView.tableFooterView.frame;
  frame.size.height = 3;
  [mLoadingActivity stopAnimating];
  [mLoadingActivity setHidden:YES];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
}


#pragma mark - TableHeader

- (void)resetTableHeader {
  CGRect frame = self.tableView.tableHeaderView.frame;
  frame.size.height = 44;
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
  CGFloat tableWidth = self.tableView.frame.size.width;

  UIButton *uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(tableWidth / 2 - 106, 8, 212, 28)];
  UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/UploadRecipeNormal.png"];
  UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  [uploadButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];

  UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/UploadRecipeHighLight.png"];
  UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  [uploadButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];

  [uploadButton addTarget:self action:@selector(onCreateRecipe) forControlEvents:UIControlEventTouchUpInside];

  [self.tableView.tableHeaderView addSubview:uploadButton];

  UIImage *dotImage = [UIImage imageNamed:@"Images/homeHeaderSeperator.png"];
  UIImageView *dotImageView = [[UIImageView alloc] initWithImage:dotImage];
  [dotImageView setFrame:CGRectMake(0, 43, 320, 1)];

  [self.tableView.tableHeaderView addSubview:dotImageView];
}

- (void)onCreateRecipe {
  //初始化创建数据
  [[[User sharedInstance] recipe] resetCreateRecipeData];
  [[[User sharedInstance] recipe] setIsCreate:YES];

  MyRecipesEditController *pEditController = [[MyRecipesEditController alloc] initWithNibName:@"MyRecipesEditView" bundle:nil];
  [self.tabBarController.navigationController pushViewController:pEditController animated:YES];
}

- (void)OnLoginSuccess:(NSNotification *)notification {
  NSString *className = (NSString *) notification.object;
  if ([className isEqualToString:NSStringFromClass([self class])]) {
    [self reloadRecipeData];
    [self showLoadingView];
  }
}

- (void)OnReloadRecipe:(NSNotification *)notification {
  firstLoad = YES;
}

@end
