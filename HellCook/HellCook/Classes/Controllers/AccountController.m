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
#import "DebugOptionController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Blurring.h"
#import "NetManager.h"

@interface AccountController ()

@end

@implementation AccountController
@synthesize tableView;
@synthesize bannerImageView;
@synthesize avataImageVIew;
@synthesize loginButton;
@synthesize registerButton;
@synthesize cellContentArray;
@synthesize nameLabel;

- (void)viewDidLoad
{
  UIImageView* titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 59, 27)];
  [titleImageView setImage:[UIImage imageNamed:@"Images/leftPageTitle.png"]];
  self.navigationItem.titleView = titleImageView;
    
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Images/NavigationBarSide.png"] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.clipsToBounds = NO;

  self.view.clipsToBounds = YES;
  
  nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 70, 180, 30)];
  bannerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 120)];
  avataImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(15, 65, 40, 40)];
  
  [self.view addSubview:bannerImageView];
  [self.view addSubview:avataImageVIew];
  [self.view addSubview:nameLabel];
  
  [self hideLoginView];
  
  [self initCellContentArray];
  
  [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
  [self.navigationController.view setFrame:CGRectMake(0, 0, _sideWindowWidth, _screenHeight_NoStBar)];
  
  if ([[[User sharedInstance] account] isLogin] && [[[User sharedInstance] account] shouldResetLogin]) {
    [self resetAccountView];
  }
  
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
  if (indexPath.row == cellContentArray.count-1) {
    [self openDebugOption];
  }
  else if (indexPath.row == 2){
    [self logout];
  }
}


#pragma mark - Login view
- (void)showLoginView
{
    [[self loginButton] setHidden:NO];
    [[self registerButton] setHidden:NO];
  [[self debugOptonButton] setHidden:NO];
}

- (void)hideLoginView
{
    [[self loginButton] setHidden:YES];
    [[self registerButton] setHidden:YES];
  [[self debugOptonButton] setHidden:YES];

}

- (void)showAccountView
{
  [tableView setHidden:NO];
  [bannerImageView setHidden:NO];
  [avataImageVIew setHidden:NO];
  [nameLabel setHidden:NO];
}

- (void)hideAccountView
{
  [tableView setHidden:YES];
  [bannerImageView setHidden:YES];
  [avataImageVIew setHidden:YES];
  [nameLabel setHidden:YES];
}

- (void)resetAccountView
{
  nameLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
  nameLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  nameLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  nameLabel.backgroundColor = [UIColor clearColor];
  nameLabel.font = [UIFont boldSystemFontOfSize:20];
  
  [nameLabel setText: [[[User sharedInstance] account] username]];
  
  [self setAccountAvatar];
  [[[User sharedInstance] account] setShouldResetLogin:NO];
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

- (id)debugOptonButton
{
  if (!debugOptonButton) {
    debugOptonButton = [[UIButton alloc]initWithFrame:CGRectMake(90, 200, 120, 30)];
    [debugOptonButton setTitle:@"Debug Option" forState:UIControlStateNormal];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/grayStretchBackgroundNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [debugOptonButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
    
    UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/grayStretchBackgroundHighlighted.png"];
    UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [debugOptonButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
    
    [debugOptonButton addTarget:self action:@selector(openDebugOption) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:debugOptonButton];
    [self.view bringSubviewToFront:debugOptonButton];
  }
  return debugOptonButton;
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
  
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys :
             @"Images/leftPageScore.png",@"image", @"Debug Options",@"title",nil];
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

- (void)openDebugOption
{
  DebugOptionController* doController = [[DebugOptionController alloc]initWithNibName:@"DebugOption" bundle:nil];
  [self.navigationController presentViewController:doController animated:YES completion:nil];
}

- (void)logout
{
  [[[User sharedInstance] account] logout];
  [self showLoginView];
  [self hideAccountView];
}


- (void)setAccountAvatar
{
  UserAccount* account = [[User sharedInstance] account];
  if (account.avatar && ![account.avatar isEqual:@""]) {
    [avataImageVIew setContentMode:UIViewContentModeScaleAspectFill];
    [avataImageVIew setClipsToBounds:YES];
    
    NetManager* netManager = [NetManager sharedInstance];
    
    
    NSString* avatarUrl = [NSString stringWithFormat: @"http://%@/%@", netManager.host, account.avatar];
    
    [avataImageVIew setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:nil];
    avataImageVIew.layer.cornerRadius = 4.0;
    avataImageVIew.layer.masksToBounds = YES;
    avataImageVIew.layer.borderColor = [UIColor clearColor].CGColor;
    avataImageVIew.layer.borderWidth = 1.0;
    
    [bannerImageView setContentMode:UIViewContentModeScaleAspectFill];
    [bannerImageView setClipsToBounds:YES];
    [bannerImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:nil options:0  andGaussianBlurWithBias:20];
  }
  


}

@end


