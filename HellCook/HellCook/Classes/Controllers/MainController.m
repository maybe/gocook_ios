#import "MainController.h"
#import "MainTopTableViewCell.h"
#import "MainCatTableViewCell.h"
#import "NetManager.h"
#import "TopListController.h"
#import "SearchController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"
#import "DBHandler.h"

@interface MainController ()

@end

@implementation MainController
@synthesize tableView, searchBarView, rightNumLabel;

- (void)viewDidLoad
{
  self.title = @"今日热门";
  
  [self setLeftButton];
  [self setRightButton];
  
  [self addSearchBar];
  
  //[self getIOSMainData];
  
  CGRect selfFrame = self.view.frame;
  selfFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:selfFrame];
  self.view.autoresizesSubviews = NO;
  
  CGRect viewFrame = self.tableView.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar - _navigationBarHeight;
  [self.tableView setFrame:viewFrame];

  NSString* home_dir =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  NSString* fileName = [home_dir  stringByAppendingPathComponent:@"main_data.plist"];
  NSFileManager* manager = [NSFileManager defaultManager];  //设置文件管理器
  if ([manager fileExistsAtPath:fileName]) {
    NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:fileName];
    iosMainDataDic = [[NSDictionary alloc] initWithDictionary:dic];
    catArray = [[NSMutableArray alloc] initWithArray:iosMainDataDic[@"recommend_items"]];
  }

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnRemoveFromShoppingListSuccess:) name:@"EVT_OnRemoveFromShoppingListSuccess" object:nil];

  [self autoLayout];
  [super viewDidLoad];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) showLeft:(id)sender
{
  [searchBarView hideMaskView];
  [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void) showRight:(id)sender
{
  [searchBarView hideMaskView];
  [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
  [ApplicationDelegate enableLeftDrawer];
  [ApplicationDelegate enableRightDrawer];

  NSInteger shoppingCount = [[DBHandler sharedInstance] getShoppingListCount];
  [rightNumLabel setText: [NSString stringWithFormat:@"%d", shoppingCount]];

  [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return catArray.count+1;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) {
    return 121;
  }
  return 64;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"CatCell";
  BOOL isTopCell = NO;
  
  if (indexPath.row == 0) {
    CellIdentifier = @"TopCell";
    isTopCell = YES;
  }
  else{
    CellIdentifier = @"CatCell";
  }
  
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    if (isTopCell) {
      cell = [[MainTopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else {
      cell = [[MainCatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  }
  
  if (isTopCell) {
    MainTopTableViewCell* aCell = (MainTopTableViewCell*)cell;
    [aCell setData:iosMainDataDic];
  }
  else{
    MainCatTableViewCell* aCell = (MainCatTableViewCell*)cell;
    [aCell setData:[catArray objectAtIndex:(NSUInteger)(indexPath.row-1)]];
  }

  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row != 0) {
    [self.navigationController pushViewController:[[SearchController alloc]initWithNibName:@"SearchView" bundle:nil keyword:catArray[(NSUInteger)(indexPath.row-1)][@"name"]] animated:YES];
  }
}

- (void)selectTopNewCell
{
  //[self.revealSideViewController setIsSwipeEnabled:NO];
  TopListController* topController = [[TopListController alloc]initWithNibName:@"TopListView" bundle:nil];
  topController.topListType = TLT_TopNew;
  [self.navigationController pushViewController:topController animated:YES];
}

- (void)selectTopHotCell
{
  //[self.revealSideViewController setIsSwipeEnabled:NO];
  TopListController* topController = [[TopListController alloc]initWithNibName:@"TopListView" bundle:nil];
  topController.topListType = TLT_TopHot;
  [self.navigationController pushViewController:topController animated:YES];
}

- (void)setLeftButton
{
    UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
    [leftBarButtonView addTarget:self action:@selector(showLeft:) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/leftPageButtonBackgroundNormal.png"]
                                 forState:UIControlStateNormal];
    
    [leftBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/leftPageButtonBackgroundHighlighted.png"]
                                 forState:UIControlStateHighlighted];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}


-(void)setRightButton
{
    UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
    [rightBarButtonView addTarget:self action:@selector(showRight:) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/rightPageButtonBackgroundNormal.png"]
                                  forState:UIControlStateNormal];
    
    [rightBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/rightPageButtonBackgroundHighlighted.png"]
                                  forState:UIControlStateHighlighted];
    
    rightNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 3, 27, 22)];
    [rightNumLabel setBackgroundColor:[UIColor clearColor]];
    [rightNumLabel setTextColor:[UIColor whiteColor]];
    [rightNumLabel setAdjustsFontSizeToFitWidth:YES];
    [rightNumLabel setTextAlignment:NSTextAlignmentCenter];
    [rightNumLabel setText:@"0"];
    [rightBarButtonView addSubview:rightNumLabel];
    
    UIImage* rightBLImage = [UIImage imageNamed:@"Images/buylistButtonImage.png"];
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 22, 19)];
    [rightImageView setImage:rightBLImage];
    [rightBarButtonView addSubview:rightImageView];
    
    [rightBarButtonView bringSubviewToFront:rightNumLabel];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)addSearchBar
{
  searchBarView = [[SearchBarView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
  [self.view addSubview:searchBarView];
}

- (void)goSearch
{
  if (![[searchBarView getSearchKeyword] isEqualToString:@""])
  {
    //[self.revealSideViewController setIsSwipeEnabled:NO];
    [self.navigationController pushViewController:[[SearchController alloc]initWithNibName:@"SearchView" bundle:nil keyword:[searchBarView getSearchKeyword]] animated:YES];
  }
}


- (void)OnRemoveFromShoppingListSuccess: (NSNotification *)notification
{
  NSInteger shoppingCount = [[DBHandler sharedInstance] getShoppingListCount];
  [rightNumLabel setText: [NSString stringWithFormat:@"%d", shoppingCount]];
}


#pragma mark - Net

-(void)getIOSMainData
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                        getIOSMainDataWithCompletionHandler:^(NSMutableDictionary *resultDic) {
                           [self getIOSMainCallBack:resultDic];}
                        errorHandler:^(NSError *error) {}
                        ];
  
}

- (void)getIOSMainCallBack:(NSMutableDictionary*) resultDic
{
  iosMainDataDic = [[NSDictionary alloc]initWithDictionary:resultDic];
  catArray = [[NSMutableArray alloc]initWithArray:resultDic[@"recommend_items"]];

  NSString* home_dir =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  NSString* recFileName = [home_dir  stringByAppendingPathComponent:@"main_data.plist"];
  [iosMainDataDic writeToFile:recFileName atomically:NO];

  [self.tableView reloadData];
}

@end
