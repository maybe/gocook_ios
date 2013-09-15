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
#import "CommonDef.h"

@interface MyRecipesController ()

@end

@implementation MyRecipesController
@synthesize tableView;
@synthesize mMyRecipeArray;
@synthesize mLoadingActivity;
@synthesize mNetOperation;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    curPage = 0;
    firstLoad = YES;
    deleteRecipeId = 0;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self resetTableHeader];

  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar_NoTabBar;
  [self.view setFrame:viewFrame];
  [self.tableView setFrame:viewFrame];

  refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
  [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
  refreshControl.tintColor = [UIColor colorWithRed:120.0 / 255.0 green:120.0 / 255.0 blue:120.0 / 255.0 alpha:1.0];

  [self initLoadingView];

  mMyRecipeArray = [[NSMutableArray alloc] init];

  HUD = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:HUD];
  HUD.mode = MBProgressHUDModeCustomView;
  HUD.delegate = self;

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnLoginSuccess:) name:@"EVT_OnLoginSuccess" object:nil];

}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadRecipeData {
  [mMyRecipeArray removeAllObjects];
  curPage = 0;
  //[self.tableView reloadData];
  [self getRecipesData];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)aRefreshControl {
  [self reloadRecipeData]; //下拉刷新的话就不显示loadingView的圈了
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (firstLoad) {
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
  return 90;
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
  // [self.navigationController pushViewController:[[RegisterController alloc]initWithNibName:@"RegisterView" bundle:nil] animated:YES];
  // NSString* recipeIdStr = mMyRecipeArray[indexPath.row][@"recipe_id"];
  // NSInteger recipeId = [recipeIdStr intValue];

//  [self.navigationController pushViewController:[[RecipeDetailController alloc]initWithNibName:@"RecipeDetailView" bundle:nil withId:recipeId withPrevTitle:self.title] animated:YES];
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

#pragma  mark - Recipe Operation
- (void)modifyOneMyRecipe:(id)sender {
  MyRecipesTableViewCell* cell = (MyRecipesTableViewCell*)(((UIButton*)sender).superview);
  NSIndexPath *indexPath = [tableView indexPathForCell: cell];
  if (mMyRecipeArray.count > indexPath.row) {
    modifyRecipeId = [mMyRecipeArray[(NSUInteger) indexPath.row][@"recipe_id"] intValue];
    [self getOneRecipeDetailData:modifyRecipeId];
  }
}

- (void)deleteOneMyRecipe:(id)sender {
  MyRecipesTableViewCell* cell = (MyRecipesTableViewCell*)(((UIButton*)sender).superview);
  NSIndexPath *indexPath = [tableView indexPathForCell: cell];
  if (mMyRecipeArray.count > indexPath.row) {
    deleteRecipeId = [mMyRecipeArray[(NSUInteger) indexPath.row][@"recipe_id"] intValue];
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"确认删除吗？"
                                                       message:@""
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定",nil];
    [alert show];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1) {
    [self deleteRecipeData:deleteRecipeId];
    [self.tableView reloadData];
  }
}


#pragma mark - Net

- (void)getRecipesData {
  self.mNetOperation = [[[NetManager sharedInstance] hellEngine]
      getMyRecipesDataByPage:(curPage + 1)
           completionHandler:^(NSMutableDictionary *resultDic) {
             [self getRecipesResultCallBack:resultDic];
           }
                errorHandler:^(NSError *error) {
                }
  ];
}

- (void)getRecipesResultCallBack:(NSMutableDictionary *)resultDic {
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success) {
    int totalCount = [resultDic[@"total"] intValue];
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
        if ([refreshControl isRefreshing]) {
          [refreshControl endRefreshing];
        }
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
    NSInteger $errorCode = [[resultDic valueForKey:@"errorcode"] intValue];
    if ($errorCode == GC_AuthAccountInvalid) {
      LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);
      if (self.tabBarController) {
        [self.tabBarController presentViewController:m animated:YES completion:nil];
      }
    }
  }
}

- (void)deleteRecipeData:(NSInteger)recipeId {

  HUD.labelText = @"正在删除...";
  [HUD show:YES];

  self.mNetOperation = [[[NetManager sharedInstance] hellEngine]
           deleteRecipe:recipeId
           completionHandler:^(NSMutableDictionary *resultDic) {
             [self deleteRecipeResultCallBack:resultDic];
           }
           errorHandler:^(NSError *error) {
           }
  ];
}

- (void)deleteRecipeResultCallBack:(NSMutableDictionary *)resultDic {

  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success) {
    HUD.labelText = @"删除成功";
    [HUD hide:YES afterDelay:1.0];

    [self reloadRecipeData];
    [self showLoadingView];
  }
  else {
    [HUD hide:YES];
    NSInteger $errorCode = [[resultDic valueForKey:@"errorcode"] intValue];
    if ($errorCode == GC_AuthAccountInvalid) {
      LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);
      if (self.tabBarController) {
        [self.tabBarController presentViewController:m animated:YES completion:nil];
      }
    }
  }
}


-(void)getOneRecipeDetailData:(NSInteger)recipeId
{
  self.mNetOperation = [[[NetManager sharedInstance] hellEngine]
      getRecipeDetailData:recipeId
             completionHandler:^(NSMutableDictionary *resultDic) {
               [self getOneRecipeDetailCallBack:resultDic];
             }
             errorHandler:^(NSError *error) {
             }];
}

- (void)getOneRecipeDetailCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success) {
    NSDictionary* recipeDic = [[NSDictionary alloc]initWithDictionary:resultDic[@"result_recipe"]];
    //初始化修改数据
    [[[User sharedInstance] recipe] resetModifyRecipeData];
    [[[User sharedInstance] recipe] setIsCreate:NO];
    RecipeData* recipeData = [[[User sharedInstance] recipe] getModifyRecipeData];
    recipeData.recipe_id = [recipeDic[@"recipe_id"] intValue];
    recipeData.user_id = [recipeDic[@"author_id"] intValue];
    recipeData.name = recipeDic[@"recipe_name"];
    recipeData.description = recipeDic[@"intro"];
    recipeData.cover_img = recipeDic[@"cover_image"];
    recipeData.cover_img_status = RecipeImage_UPLOADED;
    recipeData.tips = recipeDic[@"tips"];

    NSArray* materialArray = [recipeDic[@"materials"] componentsSeparatedByString:@"|"];
    for (int i = 0; i < materialArray.count/2; i++) {
      NSMutableDictionary* pDic = [[NSMutableDictionary alloc]init];
      pDic[@"material"] = [[NSString alloc]initWithString:[materialArray objectAtIndex:(NSUInteger)i*2]];
      pDic[@"weight"] = [[NSString alloc]initWithString:[materialArray objectAtIndex:(NSUInteger)i*2+1]];

      [recipeData.materials addObject:pDic];
    }

    NSArray* stepArray = (NSArray*)recipeDic[@"steps"];
    for (NSUInteger j = 0; j < stepArray.count; j++) {
      NSMutableDictionary* pDic = [[NSMutableDictionary alloc]init];

      pDic[@"step"] = [[NSString alloc]initWithString:stepArray[j][@"content"]];
      pDic[@"imageUrl"] = [[NSString alloc]initWithString:stepArray[j][@"img"]];
      if ([pDic[@"imageUrl"] isEqual:@""]) {
        pDic[@"imageState"] = [NSString stringWithFormat:@"%d", RecipeImage_UNSELECTED];

      } else {
        pDic[@"imageState"] = [NSString stringWithFormat:@"%d", RecipeImage_UPLOADED];
      }

      [recipeData.recipe_steps addObject:pDic];
    }

    MyRecipesEditController *pEditController = [[MyRecipesEditController alloc] initWithNibName:@"MyRecipesEditView" bundle:nil];
    [self.tabBarController.navigationController pushViewController:pEditController animated:YES];
  }
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


#pragma mark - TableHeader

- (void)resetTableHeader {
  CGRect frame = self.tableView.tableHeaderView.frame;
  frame.size.height = 72;
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
  CGFloat tableWidth = self.tableView.frame.size.width;

  UIButton *uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(tableWidth / 2 - 60, 20, 120, 30)];
  [uploadButton setTitle:@"上传菜谱" forState:UIControlStateNormal];
  UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/grayStretchBackgroundNormal.png"];
  UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  [uploadButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];

  UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/grayStretchBackgroundHighlighted.png"];
  UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  [uploadButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];

  [uploadButton addTarget:self action:@selector(onCreateRecipe) forControlEvents:UIControlEventTouchUpInside];

  [self.tableView.tableHeaderView addSubview:uploadButton];

  UIImage *dotImage = [UIImage imageNamed:@"Images/homeHeaderSeperator.png"];
  UIImageView *dotImageView = [[UIImageView alloc] initWithImage:dotImage];
  [dotImageView setFrame:CGRectMake(0, 71, 320, 1)];

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

@end
