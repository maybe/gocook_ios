//
//  TopHotController.h
//  HellCook
//
//  Created by panda on 2/22/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "AccountController.h"
#import "QuartzCore/QuartzCore.h"
#import "RegisterController.h"
#import "LoginController.h"
#import "UINavigationController+Autorotate.h"
#import "UserAccount.h"
#import "AccountTableViewCell.h"
#import "AccountTableViewGridCell.h"
#import "User.h"

@interface AccountController ()

@end

@implementation AccountController
@synthesize tableView;
@synthesize bannerImageView;
@synthesize loginButton;
@synthesize registerButton;
@synthesize cellContentArray;

- (void)viewDidLoad
{
  UIImageView* titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 59, 27)];
  [titleImageView setImage:[UIImage imageNamed:@"Images/leftPageTitle.png"]];
  self.navigationItem.titleView = titleImageView;
    
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Images/NavigationBarSide.png"] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.clipsToBounds = NO;

  self.view.clipsToBounds = YES;
  
  [self hideAccountView];
  [self hideLoginView];
  
  [self initCellContentArray];
  
  [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
  [self.navigationController.view setFrame:CGRectMake(0, 0, _sideWindowWidth, _screenHeight_NoStBar)];
  
  if ([[[User sharedInstance] account] isLogin]) {
    [self hideLoginView];
    [self showAccountView];
  }
  else{
    [self hideAccountView];
    [self showLoginView];
  }

  [super viewWillAppear:animated];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellContentArray.count;
}


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  NSMutableDictionary* dic = [cellContentArray objectAtIndex:indexPath.row];
  if ([[dic allKeys]containsObject:@"image"]) {
    return 63;
  }
  return 88;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  BOOL isGridCell = NO;
  
  NSMutableDictionary* dic = [cellContentArray objectAtIndex:indexPath.row];
  if (![[dic allKeys]containsObject:@"image"]) {
    CellIdentifier = @"GridCell";
    isGridCell = YES;
  }
  else{
    CellIdentifier = @"Cell";
  }
  
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    if (isGridCell) {
      cell = [[AccountTableViewGridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GridCell"];
    }
    else{
      cell = [[AccountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
  }
  
  if (isGridCell) {
    AccountTableViewGridCell* aCell = (AccountTableViewGridCell*)cell;
    aCell.countLabel1.text = @"0";
    aCell.nameLabel1.text = [dic valueForKey:@"title1"];
    aCell.countLabel2.text = @"0";
    aCell.nameLabel2.text = [dic valueForKey:@"title2"];
    aCell.countLabel3.text = @"0";
    aCell.nameLabel3.text = [dic valueForKey:@"title3"];
    aCell.countLabel4.text = @"0";
    aCell.nameLabel4.text = [dic valueForKey:@"title4"];
    aCell.countLabel5.text = @"0";
    aCell.nameLabel5.text = [dic valueForKey:@"title5"];
  }
  else
  {
    AccountTableViewCell* aCell = (AccountTableViewCell*)cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - Login view
- (void)showLoginView
{
    [[self loginButton] setHidden:NO];
    [[self registerButton] setHidden:NO];
}

- (void)hideLoginView
{
    [[self loginButton] setHidden:YES];
    [[self registerButton] setHidden:YES];
}

- (void)showAccountView
{
    [tableView setHidden:NO];
    [bannerImageView setHidden:NO];
}

- (void)hideAccountView
{
    [tableView setHidden:YES];
    [bannerImageView setHidden:YES];
}

- (id)loginButton
{
    if (!loginButton) {
        loginButton = [[UIButton alloc]initWithFrame:CGRectMake(90, 100, 120, 30)];
        [loginButton setTitle:@"用邮箱登录" forState:UIControlStateNormal];
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

- (id)registerButton
{
    if (!registerButton) {
        registerButton = [[UIButton alloc]initWithFrame:CGRectMake(90, 150, 120, 30)];
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

- (void)initCellContentArray
{
  cellContentArray = [[NSMutableArray alloc]init];
  NSMutableDictionary *cellDic;
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys :
             @"Images/leftPageHot.png",@"image", @"今日热门",@"title",nil];
  [cellContentArray addObject:cellDic];
  
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys :
             @"0",@"count1", @"关注",@"title1",
             @"0",@"count2", @"粉丝",@"title2",
             @"0",@"count3", @"收藏",@"title3",
             @"0",@"count4", @"作品",@"title4",
             @"0",@"count5", @"菜谱",@"title5",nil];
  [cellContentArray addObject:cellDic];
  
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys :
             @"Images/leftPageLogout.png",@"image", @"退出",@"title",nil];
  [cellContentArray addObject:cellDic];
  
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys :
             @"Images/leftPageScore.png",@"image", @"帮助我们评分",@"title",nil];
  [cellContentArray addObject:cellDic];
}


- (void)openLoginWindow
{
    LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
    if (self.navigationController) {
        [self.navigationController presentViewController:m animated:YES completion:nil];
    }
}

- (void)openRegisterWindow
{
    RegisterController* m = [[RegisterController alloc]initWithNibName:@"RegisterView" bundle:nil];
    if (self.navigationController) {
        [self.navigationController presentViewController:m animated:YES completion:nil];
    }
}

@end


