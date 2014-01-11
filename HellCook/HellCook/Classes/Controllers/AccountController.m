//
//  AccountController.cpp
//  HellCook
//
//  Created by panda on 2/22/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "AccountController.h"
#import "LoginController.h"
#import "UserAccount.h"
#import "AccountTableViewCell.h"
#import "AccountTableViewGridCell.h"
#import "User.h"
#import "DebugOptionController.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"
#import "MyCollectionController.h"
#import "AppDelegate.h"
#import "MainController.h"
#import "HomePageController.h"
#import "HistoryDealViewController.h"
#import "HCNavigationController.h"
#import "NewCouponsViewController.h"

@interface AccountController ()

@end

@implementation AccountController
@synthesize tableView;
@synthesize bannerImageView;
@synthesize avatarImageView;
@synthesize loginButton;
@synthesize registerButton;
@synthesize cellContentArray;
@synthesize nameLabel;


- (void)viewDidLoad {
  UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 108, 19)];
  [titleImageView setImage:[UIImage imageNamed:@"Images/leftPageTitle.png"]];
  self.navigationItem.titleView = titleImageView;
  //self.title = @"M6分享厨房";

  nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 54, 180, 30)];
  nameLabel.backgroundColor = [UIColor clearColor];
  bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 138)];
  avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 46, 46)];

  loginTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 56, 280, 30)];
  loginTitleLabel.textAlignment = NSTextAlignmentCenter;
  loginTitleLabel.text = @"分享新鲜 分享美味 分享幸福";
  loginTitleLabel.backgroundColor = [UIColor clearColor];
  loginTitleLabel.textColor = [UIColor colorWithRed:128.0f / 255.0f green:128.0f / 255.0f blue:128.0f / 255.0f alpha:1];
  [loginTitleLabel setFont:[UIFont boldSystemFontOfSize:18]];

  [self.view addSubview:loginTitleLabel];

  [self hideLoginView];

  [self initCellContentArray];

  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];

  CGRect tableFrame = self.tableView.frame;
  tableFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.tableView setFrame:tableFrame];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnLoginSuccess:) name:@"EVT_OnLoginSuccess" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnUserInfoChange:) name:@"EVT_OnUserInfoChange" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnShouldRefreshKitchenInfo:) name:@"EVT_OnShouldRefreshKitchenInfo" object:nil];

  shouldRefreshKitchenInfo = NO;

  [self autoLayout];
  [super viewDidLoad];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {

  //[self.navigationController.view setFrame:CGRectMake(0, 0, _sideWindowWidth, _screenHeight)];

  if ([[[User sharedInstance] account] isLogin] && [[[User sharedInstance] account] shouldResetLogin]) {
    [self getKitchenInfo];
    [self resetAccountView];
  }

  if (shouldRefreshKitchenInfo) {
    [self getKitchenInfo];
    shouldRefreshKitchenInfo = NO;
  }

  if ([[[User sharedInstance] account] isLogin]) {
    [self hideLoginView];
    [self showAccountView];
  }
  else {
    [self hideAccountView];
    [self showLoginView];
  }

  [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];

  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  if ([[[[ApplicationDelegate centerNavController] viewControllers] objectAtIndex:0] isKindOfClass:[MainController class]]) {
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
  } else {
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
  }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
  return cellContentArray.count;

}


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
  NSMutableDictionary *dic = [cellContentArray objectAtIndex:(NSUInteger) indexPath.row];
  if ([[dic allKeys] containsObject:@"image"]) {
    return 64;
  } else if ([[dic allKeys] containsObject:@"banner"]) {
    return 120;
  }
  return 64 * 3;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  BOOL isGridCell = NO;
  BOOL isBannerCell = NO;

  NSMutableDictionary *dic = [cellContentArray objectAtIndex:(NSUInteger) indexPath.row];
  if ([[dic allKeys] containsObject:@"banner"]) {
    CellIdentifier = @"BannerCell";
    isBannerCell = YES;
  }
  else if (![[dic allKeys] containsObject:@"image"]) {
    CellIdentifier = @"GridCell";
    isGridCell = YES;
  }
  else {
    CellIdentifier = @"Cell";
  }

  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    if (isGridCell) {
      cell = [[AccountTableViewGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GridCell"];
    } else if (isBannerCell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BannerCell"];
      [cell setFrame:CGRectMake(0, 0, _sideWindowWidth, 120)];
      [cell addSubview:bannerImageView];
      [cell addSubview:avatarImageView];
      [cell addSubview:nameLabel];
    }
    else {
      cell = [[AccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
  }

  if (isGridCell) {
    KitchenInfo* kitchenInfo = [[User sharedInstance] kitchenInfo];

    AccountTableViewGridCell *aCell = (AccountTableViewGridCell *) cell;
    aCell.countLabel1.text = [NSString stringWithFormat:@"%d", kitchenInfo.following_count];
    aCell.nameLabel1.text = [dic valueForKey:@"title1"];
    aCell.countLabel2.text = [NSString stringWithFormat:@"%d", kitchenInfo.followed_count];
    aCell.nameLabel2.text = [dic valueForKey:@"title2"];
    aCell.countLabel3.text = [NSString stringWithFormat:@"%d", kitchenInfo.coll_count];
    aCell.nameLabel3.text = [dic valueForKey:@"title3"];
    aCell.countLabel4.text = [NSString stringWithFormat:@"%d", kitchenInfo.recipe_count];
    aCell.nameLabel4.text = [dic valueForKey:@"title4"];
    aCell.countLabel5.text = [NSString stringWithFormat:@"%d", kitchenInfo.order_count];
    aCell.nameLabel5.text = [dic valueForKey:@"title5"];
    aCell.countLabel6.text = @"";
    aCell.nameLabel6.text = @"";
  } else if (isBannerCell) {
  }
  else {
    AccountTableViewCell *aCell = (AccountTableViewCell *) cell;
    [aCell.imageView setImage:[UIImage imageNamed:[dic valueForKey:@"image"]]];
    [aCell.titleLabel setText:[dic valueForKey:@"title"]];
    if (indexPath.row == cellContentArray.count - 1) {
      aCell.bottomlineView.hidden = YES;
    }
    else
      aCell.bottomlineView.hidden = NO;
  }
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  if (indexPath.row == cellContentArray.count - 1) {
//    [self openDebugOption];
//  }
  if (indexPath.row == 3) {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
        initWithTitle:@"确定要退出吗?"
             delegate:self
     cancelButtonTitle:@"取消"
destructiveButtonTitle:@"确定"
     otherButtonTitles:nil];
    [actionSheet showInView:self.mm_drawerController.view];
  }
  else if (indexPath.row == 0) {
    NewCouponsViewController *pViewController = [[NewCouponsViewController alloc] initWithNibName:@"NewCouponsView" bundle:nil];
    [ApplicationDelegate.centerNavController setViewControllers:@[pViewController] animated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
  }
  else if (indexPath.row == 1) {
    MainController *mainController = [[MainController alloc] initWithNibName:@"MainView" bundle:nil];
    [ApplicationDelegate.centerNavController setViewControllers:@[mainController] animated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
  }
  else {
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    [self logout];
  } else if (buttonIndex == 1) {
  }
}

#pragma mark - Login view
- (void)showLoginView {
  [loginTitleLabel setHidden:NO];
  [[self loginButton] setHidden:NO];
  [[self registerButton] setHidden:NO];
  [[self debugOptionButton] setHidden:YES];
}

- (void)hideLoginView {
  [loginTitleLabel setHidden:YES];
  [[self loginButton] setHidden:YES];
  [[self registerButton] setHidden:YES];
  [[self debugOptionButton] setHidden:YES];

}

- (void)showAccountView {
  [tableView setHidden:NO];
  [bannerImageView setHidden:NO];
  [avatarImageView setHidden:NO];
  [nameLabel setHidden:NO];
}

- (void)hideAccountView {
  [tableView setHidden:YES];
  [bannerImageView setHidden:YES];
  [avatarImageView setHidden:YES];
  [nameLabel setHidden:YES];
}

- (void)resetAccountView {
  nameLabel.textColor = [UIColor colorWithRed:101.0 / 255.0 green:107.0 / 255.0 blue:55.0 / 255.0 alpha:0.8];
//  nameLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
//  nameLabel.shadowColor = [UIColor colorWithRed:101.0 / 255.0 green:107.0 / 255.0 blue:55.0 / 255.0 alpha:0.8];
//  nameLabel.backgroundColor = [UIColor clearColor];
  nameLabel.font = [UIFont boldSystemFontOfSize:22];

  [nameLabel setText:[[[User sharedInstance] account] username]];

  [self setAccountAvatar];
  [[[User sharedInstance] account] setShouldResetLogin:NO];

  nameLabel.userInteractionEnabled = YES;
  UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNameLabel:)];
  [nameLabel addGestureRecognizer:tapGestureTel];
  avatarImageView.userInteractionEnabled = YES;
  UITapGestureRecognizer *tapGestureAva = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNameLabel:)];
  [avatarImageView addGestureRecognizer:tapGestureAva];
}

- (IBAction)tapNameLabel:(id)sender {
  NSInteger user_id = [[[User sharedInstance] account] user_id];
  NSString* user_name = [[[User sharedInstance] account] username];
  HomePageController *pHomePageController = [[HomePageController alloc] initWithNibName:@"HomePageView" bundle:nil withUserID:user_id AndName:user_name showIndex:0];
  [ApplicationDelegate.centerNavController setViewControllers:@[pHomePageController] animated:NO];
  [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}


- (id)loginButton {
  if (!loginButton) {
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(280 / 2 - 171 / 2, 170, 171, 39)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/LoginButtonNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [loginButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];

    UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/LoginButtonHighLight.png"];
    UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [loginButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];

    [loginButton addTarget:self action:@selector(openLoginWindow) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:loginButton];
    [self.view bringSubviewToFront:loginButton];
  }

  return loginButton;
}

- (id)registerButton {
  if (!registerButton) {
    registerButton = [[UIButton alloc] initWithFrame:CGRectMake(280 / 2 - 171 / 2, 220, 171, 39)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/RegisterButtonNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [registerButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];

    UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/RegisterButtonHighLight.png"];
    UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [registerButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];

    [registerButton addTarget:self action:@selector(openRegisterWindow) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:registerButton];
    [self.view bringSubviewToFront:registerButton];
  }
  return registerButton;
}

- (id)debugOptionButton {
  if (!debugOptionButton) {
    debugOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 280, 120, 30)];
    [debugOptionButton setTitle:@"Debug Option" forState:UIControlStateNormal];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/grayStretchBackgroundNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [debugOptionButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];

    UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/grayStretchBackgroundHighlighted.png"];
    UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [debugOptionButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];

    [debugOptionButton addTarget:self action:@selector(openDebugOption) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:debugOptionButton];
    [self.view bringSubviewToFront:debugOptionButton];
  }
  return debugOptionButton;
}


- (void)initCellContentArray {
  cellContentArray = [[NSMutableArray alloc] init];
  NSMutableDictionary *cellDic;
  cellDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
      @"", @"banner", @"", @"title", nil];
  [cellContentArray addObject:cellDic];

  cellDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
      @"Images/leftPageHot.png", @"image", @"首页·热门菜谱", @"title", nil];
  [cellContentArray addObject:cellDic];

  cellDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
      @"Images/RollLittle.png", @"image", @"摇一摇·我的优惠券", @"title", nil];
  [cellContentArray addObject:cellDic];

  cellDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
      @"0", @"count1", @"关注", @"title1",
      @"0", @"count2", @"粉丝", @"title2",
      @"0", @"count3", @"收藏", @"title3",
      @"0", @"count4", @"菜谱", @"title4",
      @"0", @"count5", @"购买", @"title5", nil];
  [cellContentArray addObject:cellDic];

  cellDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
      @"Images/leftPageLogout.png", @"image", @"退出", @"title", nil];
  [cellContentArray addObject:cellDic];

//  cellDic = [NSMutableDictionary dictionaryWithObjectsAndKeys :
//      @"Images/leftPageScore.png", @"image", @"帮助我们评分", @"title", nil];
//  [cellContentArray addObject:cellDic];
//
//  cellDic = [NSMutableDictionary dictionaryWithObjectsAndKeys :
//      @"Images/leftPageScore.png", @"image", @"Debug Options", @"title", nil];
//  [cellContentArray addObject:cellDic];
}


- (void)openLoginWindow {
  LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
  m.callerClassName = NSStringFromClass([self class]);

  if (self.mm_drawerController) {
    [self.mm_drawerController.navigationController pushViewController:m animated:YES];
  } else {
    [self.navigationController pushViewController:m animated:YES];
  }
}

- (void)openRegisterWindow {
  [self openLoginWindow];
}

- (void)openDebugOption {
  DebugOptionController *doController = [[DebugOptionController alloc] initWithNibName:@"DebugOption" bundle:nil];
  [self.navigationController presentViewController:doController animated:YES completion:nil];
}

- (void)logout {
  [[[NetManager sharedInstance] hellEngine] removeCookie];
  [[[User sharedInstance] account] logout];
  [self showLoginView];
  [self hideAccountView];

  MainController *mainController = [[MainController alloc] initWithNibName:@"MainView" bundle:nil];
  [ApplicationDelegate.centerNavController setViewControllers:@[mainController] animated:NO];
}


- (void)setAccountAvatar {
  UserAccount *account = [[User sharedInstance] account];
  NetManager *netManager = [NetManager sharedInstance];

  NSString *avatarUrl = nil;

  if (account.avatar && ![account.avatar isEqual:@""]) {
    if ([[account.avatar substringToIndex:15] isEqualToString:@"images/avatars/"]) {
      avatarUrl = [NSString stringWithFormat:@"http://%@/%@", netManager.host, account.avatar];
    } else {
      avatarUrl = [NSString stringWithFormat:@"http://%@/images/avatars/%@", netManager.host, account.avatar];
    }
  }

  [avatarImageView setContentMode:UIViewContentModeScaleAspectFill];
  [avatarImageView setClipsToBounds:YES];

  if (avatarUrl) {
    [avatarImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"Images/avatar.jpg"]];
  } else {
    [avatarImageView setImage:[UIImage imageNamed:@"Images/avatar.jpg"]];
  }
  //avatarImageView.layer.cornerRadius = 4.0;
  avatarImageView.layer.masksToBounds = YES;
  avatarImageView.layer.borderColor = [UIColor clearColor].CGColor;
  avatarImageView.layer.borderWidth = 1.0;

  [bannerImageView setContentMode:UIViewContentModeScaleAspectFill];
  [bannerImageView setClipsToBounds:YES];
  [bannerImageView setImage:[UIImage imageNamed:@"Images/AvatarBackground.png"]];
}

- (void)onClickCountGrid:(UIButton *)sender {
  if (sender.tag == 10001 || sender.tag == 10002 || sender.tag == 10004) {
    NSInteger index = 0;
    switch (sender.tag) {
      case 10001://我的关注
        index = 1;
        break;
      case 10002://我的粉丝
        index = 2;
        break;
      case 10004://我的菜谱
        index = 3;
        break;
      default:
        break;
    }

    NSInteger user_id = [[[User sharedInstance] account] user_id];
    NSString* user_name = [[[User sharedInstance] account] username];
    HomePageController *pHomePageController = [[HomePageController alloc] initWithNibName:@"HomePageView" bundle:nil withUserID:user_id AndName:user_name showIndex:index];
    [ApplicationDelegate.centerNavController setViewControllers:@[pHomePageController] animated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
  }
  else if (sender.tag == 10003)//我的收藏
  {
    if (self.navigationController) {
      [self.navigationController pushViewController:[[MyCollectionController alloc] initWithNibName:@"MyRecipesView" bundle:nil] animated:YES];
    }
  }
  else if (sender.tag == 10005)//我的购买
  {
    if (self.navigationController) {
      [self.navigationController pushViewController:[[HistoryDealViewController alloc] initWithNibName:@"HistoryDealView" bundle:nil] animated:YES];
    }
  }
}


- (void)OnLoginSuccess:(NSNotification *)notification {
  // NSString *className = (NSString *) notification.object;
  // if ([className isEqualToString:NSStringFromClass([self class])]) {
  // }
  if ([[[User sharedInstance] account] isLogin] && [[[User sharedInstance] account] shouldResetLogin]) {
    [self getKitchenInfo];
    [self resetAccountView];
  }

  if ([[[User sharedInstance] account] isLogin]) {
    [self hideLoginView];
    [self showAccountView];
  }
  else {
    [self hideAccountView];
    [self showLoginView];
  }
}

- (void)OnShouldRefreshKitchenInfo:(NSNotification *)notification{
  shouldRefreshKitchenInfo = YES;
}

-(void)OnUserInfoChange:(NSNotification *)notification
{
  NSDictionary * dictionary = (NSDictionary*)notification.object;
  if ([[dictionary allKeys] containsObject:@"avatar"]) {
    UIImage *uploadImage = dictionary[@"avatar"];
    UserAccount *account = [[User sharedInstance] account];
    [avatarImageView setImageWithURL:[NSURL URLWithString:account.avatar] placeholderImage:uploadImage];
  }
  if ([[dictionary allKeys] containsObject:@"nickname"]) {
    nameLabel.text = dictionary[@"nickname"];
  }
}
#pragma get kitchen info

-(void)getKitchenInfo
{
  NSString* user_id = [NSString stringWithFormat:@"%d",[[User sharedInstance] account].user_id];
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
               getKitchenInfoById:user_id
               completionHandler:^(NSMutableDictionary *resultDic) {
                 [self getKitchenInfoCallBack:resultDic];
               }
               errorHandler:^(NSError *error) {
               }
  ];
}

- (void)getKitchenInfoCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success)
  {
    KitchenInfo* kitchenInfo = [[User sharedInstance] kitchenInfo];
    kitchenInfo.recipe_count = [resultDic[@"recipe_count"] intValue];
    kitchenInfo.coll_count = [resultDic[@"collect_count"] intValue];
    kitchenInfo.followed_count = [resultDic[@"followed_count"] intValue];
    kitchenInfo.following_count = [resultDic[@"following_count"] intValue];
    kitchenInfo.order_count = [resultDic[@"order_count"] intValue];

    [tableView reloadData];
  }
  else if (result == GC_Failed)
  {
  }
}

@end


