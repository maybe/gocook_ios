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


@interface AccountController ()

@end

@implementation AccountController
@synthesize tableView;
@synthesize bannerImageView;
@synthesize loginButton;
@synthesize registerButton;


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
    
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.view setFrame:CGRectMake(0, 0, _sideWindowWidth, _screenHeight_NoStBar)];

    [self showLoginView];

    [super viewWillAppear:animated];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Main %d", indexPath.row];
    
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


- (void)openLoginWindow
{
    LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
    if (self.navigationController) {
        [self.navigationController presentViewController:m animated:YES completion:nil];
    }
//    AccountController* m = [[AccountController alloc] initWithNibName:@"AccountView" bundle:nil];
//    [self.navigationController pushViewController:m animated:YES];
}

- (void)openRegisterWindow
{
    RegisterController* m = [[RegisterController alloc]initWithNibName:@"RegisterView" bundle:nil];
    if (self.navigationController) {
        [self.navigationController presentViewController:m animated:YES completion:nil];
    }
}

@end


