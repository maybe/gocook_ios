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
#import "ODRefreshControl.h"
#import "UIViewController+MMDrawerController.h"
#import "HCNavigationController.h"

@interface MyCollectionController ()

@end

@implementation MyCollectionController
@synthesize tableView;
@synthesize mLoadingActivity;
@synthesize netOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    curPage = 0;
    bShouldRefresh = TRUE;
    myCollectionArray = [[NSMutableArray alloc] init];
    [self initLoadingView];
  }
  return self;
}

- (void)viewDidLoad {
  self.navigationItem.title = @"我的收藏";

  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  viewFrame.size.width = _sideWindowWidth;
  [self.view setFrame:viewFrame];
  [self.tableView setFrame:viewFrame];

  [self setLeftButton];

  refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
  [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
  refreshControl.tintColor = [UIColor colorWithRed:120.0 / 255.0 green:120.0 / 255.0 blue:120.0 / 255.0 alpha:1.0];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnLoginSuccess:) name:@"EVT_OnLoginSuccess" object:nil];

  [self getMyCollectionData];

  [self autoLayout];
  [super viewDidLoad];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)aRefreshControl {
  [myCollectionArray removeAllObjects];
  curPage = 0;
  bShouldRefresh = YES;
  [self.tableView reloadData];
  [self getMyCollectionData];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)initLoadingView {
  CGRect frame = self.tableView.tableFooterView.frame;
  frame.size.height = 50;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
  mLoadingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  [mLoadingActivity setCenter:CGPointMake(160, 25)];
  [mLoadingActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  [self.tableView.tableFooterView addSubview:mLoadingActivity];
  [mLoadingActivity stopAnimating];
}

- (void)showLoadingView {
  CGRect frame = self.tableView.tableFooterView.frame;
  frame.size.height = 50;
  [self.tableView.tableFooterView setFrame:frame];
  [mLoadingActivity startAnimating];
}

- (void)deleteLoadingView {
  CGRect frame = self.tableView.tableFooterView.frame;
  frame.size.height = 3;
  [mLoadingActivity stopAnimating];
  [mLoadingActivity setHidden:YES];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
  return myCollectionArray.count;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 90;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"MyCollectionTableViewCell";

  MyCollectionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[MyCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }

  [cell setData:myCollectionArray[(NSUInteger) indexPath.row]];

  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *recipeIdStr = myCollectionArray[(NSUInteger) indexPath.row][@"recipe_id"];
  NSInteger recipeId = [recipeIdStr intValue];

//  [self.navigationController pushViewController:[[RecipeDetailController alloc]initWithNibName:@"RecipeDetailView" bundle:nil withId:recipeId withPrevTitle:titile] animated:YES];
  [self.mm_drawerController.navigationController pushViewController:[[RecipeDetailController alloc] initWithNibName:@"RecipeDetailView" bundle:nil withId:recipeId withPrevTitle:@"我的收藏"] animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  // 下拉到最底部时显示更多数据
  if (scrollView.contentOffset.y + 40 >= ((scrollView.contentSize.height - scrollView.frame.size.height))) {
    if (![self.netOperation isExecuting] && bShouldRefresh) {
      [self showLoadingView];
      [self getMyCollectionData];
    }
  }
}


#pragma mark - Return Button
- (void)setLeftButton {
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

- (void)returnToPrev {
  if ([self.netOperation isExecuting]) {
    [self.netOperation cancel];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Net

- (void)getMyCollectionData {
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
      getMyCollectionDataByPage:(curPage + 1)
              completionHandler:^(NSMutableDictionary *resultDic) {
                [self getMyCollectionDataCallBack:resultDic];
              }
              errorHandler:^(NSError *error) {
              }
  ];

}

- (void)getMyCollectionDataCallBack:(NSMutableDictionary *)resultDic {
  if ([refreshControl isRefreshing]) {
    [refreshControl endRefreshing];
  }

  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success) {
    int totalCount = [resultDic[@"total"] intValue];
    totalPage = totalCount / 10 + (totalCount % 10 > 0 ? 1 : 0);
    int originSize = myCollectionArray.count;
    int addsize = [(NSArray *) resultDic[@"result_recipes"] count];
    if (addsize > 0) {
      curPage++;
      [myCollectionArray addObjectsFromArray:resultDic[@"result_recipes"]];

      if (originSize == 0) {
        [self.tableView reloadData];
      }
      else {
        NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < addsize; i++) {
          NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i + originSize inSection:0];
          [indexPathArray addObject:indexPath];
        }

        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
      }
    }

    if (curPage >= totalPage)
      bShouldRefresh = FALSE;
    if (!bShouldRefresh)
      [self deleteLoadingView];

    [[[User sharedInstance] collection] SetMyCollectionArray:myCollectionArray];
  }
  else if (result == GC_Failed)
  {
    if ([refreshControl isRefreshing]) {
      [refreshControl endRefreshing];
    }

    [self deleteLoadingView];

    NSInteger errorCode = [[resultDic valueForKey:@"errorcode"] intValue];
    if (errorCode == GC_AuthAccountInvalid) {
      LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);

      if (self.navigationController) {
        [self.mm_drawerController.navigationController pushViewController:m animated:YES];

      }
    }
    // TODO: Other Error
  }

}

- (void)OnLoginSuccess:(NSNotification *)notification {
  NSString *className = (NSString *) notification.object;
  if ([className isEqualToString:NSStringFromClass([self class])]) {
    [myCollectionArray removeAllObjects];
    curPage = 0;
    bShouldRefresh = YES;
    [self.tableView reloadData];
    [self getMyCollectionData];
  }
}

@end
