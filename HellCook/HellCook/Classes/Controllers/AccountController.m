//
//  AccountController.cpp
//  HellCook
//
//  Created by panda on 2/22/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "AccountController.h"
#import "QuartzCore/QuartzCore.h"
#import "RegisterController.h"
#import "LoginController.h"
#import "UserAccount.h"
#import "AccountTableViewCell.h"
#import "AccountTableViewGridCell.h"
#import "User.h"
#import "DebugOptionController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Blurring.h"
#import "NetManager.h"
#import "MyCollectionController.h"
#import "AppDelegate.h"
#import "UIZoomNavigationController.h"
#import "MainController.h"
#import "HomePageController.h"

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
  UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 59, 27)];
  [titleImageView setImage:[UIImage imageNamed:@"Images/leftPageTitle.png"]];
  self.navigationItem.titleView = titleImageView;

  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Images/NavigationBarSide.png"] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.clipsToBounds = NO;

  self.view.clipsToBounds = YES;

  nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 70, 180, 30)];
  bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 120)];
  avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 65, 40, 40)];

  [self.view addSubview:bannerImageView];
  [self.view addSubview:avatarImageView];
  [self.view addSubview:nameLabel];

  [self hideLoginView];

  [self initCellContentArray];

  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];

  CGRect tableFrame = self.tableView.frame;
  tableFrame.size.height = _screenHeight_NoStBar_NoNavBar - 120;
  [self.tableView setFrame:tableFrame];

  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController.view setFrame:CGRectMake(0, 0, _sideWindowWidth, _screenHeight_NoStBar)];

  if ([[[User sharedInstance] account] isLogin] && [[[User sharedInstance] account] shouldResetLogin]) {
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

  [super viewWillAppear:animated];
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
  }
  return 64 * 3;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  BOOL isGridCell = NO;

  NSMutableDictionary *dic = [cellContentArray objectAtIndex:(NSUInteger) indexPath.row];
  if (![[dic allKeys] containsObject:@"image"]) {
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
    }
    else {
      cell = [[AccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
  }

  if (isGridCell) {
    AccountTableViewGridCell *aCell = (AccountTableViewGridCell *) cell;
    aCell.countLabel1.text = @"1";
    aCell.nameLabel1.text = [dic valueForKey:@"title1"];
    aCell.countLabel2.text = @"0";
    aCell.nameLabel2.text = [dic valueForKey:@"title2"];
    aCell.countLabel3.text = @"0";
    aCell.nameLabel3.text = [dic valueForKey:@"title3"];
    aCell.countLabel4.text = @"0";
    aCell.nameLabel4.text = [dic valueForKey:@"title4"];
    aCell.countLabel5.text = @"0";
    aCell.nameLabel5.text = [dic valueForKey:@"title5"];
    aCell.countLabel6.text = @"0";
    aCell.nameLabel6.text = [dic valueForKey:@"title6"];
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
  if (indexPath.row == cellContentArray.count - 1) {
    [self openDebugOption];
  }
  else if (indexPath.row == 2) {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
        initWithTitle:@"确定要退出吗?"
             delegate:self
     cancelButtonTitle:@"取消"
destructiveButtonTitle:@"确定"
     otherButtonTitles:nil];
    [actionSheet showInView:self.revealSideViewController.view];
  }
  else if (indexPath.row == 0) {
    MainController *mainController = [[MainController alloc] initWithNibName:@"MainView" bundle:nil];
    [ApplicationDelegate.centerNavController setViewControllers:@[mainController] animated:NO];
    [self.revealSideViewController popViewControllerAnimated:YES];
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
  [[self loginButton] setHidden:NO];
  [[self registerButton] setHidden:NO];
  [[self debugOptionButton] setHidden:NO];
}

- (void)hideLoginView {
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
  nameLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
  nameLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
  nameLabel.shadowColor = [UIColor colorWithRed:120.0 / 255.0 green:120.0 / 255.0 blue:120.0 / 255.0 alpha:0.8];
  nameLabel.backgroundColor = [UIColor clearColor];
  nameLabel.font = [UIFont boldSystemFontOfSize:20];

  [nameLabel setText:[[[User sharedInstance] account] username]];

  [self setAccountAvatar];
  [[[User sharedInstance] account] setShouldResetLogin:NO];

  nameLabel.userInteractionEnabled = YES;
  UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNameLabel:)];
  [nameLabel addGestureRecognizer:tapGestureTel];

}

- (IBAction)tapNameLabel:(id)sender {
  HomePageController *pHomePageController = [[HomePageController alloc] initWithNibName:@"HomePageView" bundle:nil withUserID:-1 from:ViewControllerCalledFromMyIndividual showIndex:0];

  // MyselfRootViewController *pViewController = [[MyselfRootViewController alloc] initWithNibName:@"MyselfRootView" bundle:nil];

  [ApplicationDelegate.centerNavController setViewControllers:@[pHomePageController] animated:NO];

  //[self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionRight withOffset:_offset animated:YES];

  [self.revealSideViewController popViewControllerAnimated:YES];
}


- (id)loginButton {
  if (!loginButton) {
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 100, 120, 30)];
    [loginButton setTitle:@"用手机号登录" forState:UIControlStateNormal];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/grayStretchBackgroundNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [loginButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];

    UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/grayStretchBackgroundHighlighted.png"];
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
    registerButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 150, 120, 30)];
    [registerButton setTitle:@"注册新帐号" forState:UIControlStateNormal];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/grayStretchBackgroundNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [registerButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];

    UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/grayStretchBackgroundHighlighted.png"];
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
    debugOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 200, 120, 30)];
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
  cellDic = [NSMutableDictionary dictionaryWithObjectsAndKeys :
      @"Images/leftPageHot.png", @"image", @"今日热门", @"title", nil];
  [cellContentArray addObject:cellDic];

  cellDic = [NSMutableDictionary dictionaryWithObjectsAndKeys :
      @"0", @"count1", @"关注", @"title1",
      @"0", @"count2", @"粉丝", @"title2",
      @"0", @"count3", @"收藏", @"title3",
      @"0", @"count4", @"菜谱", @"title4",
      @"0", @"count5", @"购买", @"title5",
      @"0", @"count6", @"作品", @"title6", nil];
  [cellContentArray addObject:cellDic];

  cellDic = [NSMutableDictionary dictionaryWithObjectsAndKeys :
      @"Images/leftPageLogout.png", @"image", @"退出", @"title", nil];
  [cellContentArray addObject:cellDic];

  cellDic = [NSMutableDictionary dictionaryWithObjectsAndKeys :
      @"Images/leftPageScore.png", @"image", @"帮助我们评分", @"title", nil];
  [cellContentArray addObject:cellDic];

  cellDic = [NSMutableDictionary dictionaryWithObjectsAndKeys :
      @"Images/leftPageScore.png", @"image", @"Debug Options", @"title", nil];
  [cellContentArray addObject:cellDic];
}


- (void)openLoginWindow {
  LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
  m.callerClassName = NSStringFromClass([self class]);

  if (self.navigationController) {
    [self.navigationController presentViewController:m animated:YES completion:nil];
  }
}

- (void)openRegisterWindow {
  RegisterController *m = [[RegisterController alloc] initWithNibName:@"RegisterView" bundle:nil];
  if (self.navigationController) {
    [self.navigationController presentViewController:m animated:YES completion:nil];
  }
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
}


- (void)setAccountAvatar {
  UserAccount *account = [[User sharedInstance] account];
  NetManager *netManager = [NetManager sharedInstance];

  NSString *avatarUrl = nil;

  if (account.avatar && ![account.avatar isEqual:@""]) {
    avatarUrl = [NSString stringWithFormat:@"http://%@/%@", netManager.host, account.avatar];
  }

  [avatarImageView setContentMode:UIViewContentModeScaleAspectFill];
  [avatarImageView setClipsToBounds:YES];

  if (avatarUrl) {
    [avatarImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"Images/avatar.jpg"]];
  } else {
    [avatarImageView setImage:[UIImage imageNamed:@"Images/avatar.jpg"]];
  }
  avatarImageView.layer.cornerRadius = 4.0;
  avatarImageView.layer.masksToBounds = YES;
  avatarImageView.layer.borderColor = [UIColor clearColor].CGColor;
  avatarImageView.layer.borderWidth = 1.0;

  [bannerImageView setContentMode:UIViewContentModeScaleAspectFill];
  [bannerImageView setClipsToBounds:YES];
  if (avatarUrl) {
    [bannerImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"Images/avatar.jpg"] options:0 andGaussianBlurWithBias:20];
  } else {
    [bannerImageView setImage:[[UIImage imageNamed:@"Images/avatar.jpg"] gaussianBlurWithBias:20]];
  }

}

- (void)onClickCountGrid:(UIButton *)sender {
//  NSLog(@"%d",sender.tag);
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

    HomePageController *pHomePageController = [[HomePageController alloc] initWithNibName:@"HomePageView" bundle:nil withUserID:-1 from:ViewControllerCalledFromMyIndividual showIndex:index];

    [ApplicationDelegate.centerNavController setViewControllers:@[pHomePageController] animated:NO];

    [self.revealSideViewController popViewControllerAnimated:YES];
  }
  else if (sender.tag == 10003)//我的收藏
  {
    if (self.navigationController) {
      [self.navigationController pushViewController:[[MyCollectionController alloc] initWithNibName:@"MyRecipesView" bundle:nil] animated:YES];
    }
  }
}

@end


