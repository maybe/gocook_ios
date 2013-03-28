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
    
    [self initAccountView];
    
    [super viewDidLoad];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self hideAccountView];
    [self showLoginView];

    [self.navigationController.view setFrame:CGRectMake(0, 0, 280, 480)];

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
        loginButton = [[UIButton alloc]initWithFrame:CGRectMake(90, 200, 120, 30)];
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
        registerButton = [[UIButton alloc]initWithFrame:CGRectMake(90, 250, 120, 30)];
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

- (void)initAccountView
{
    [bannerImageView setImage: [UIImage imageNamed:@"Images/recipeGroup7.png"]];
}

- (void)openLoginWindow
{
    NSLog(@"111");
    AccountController* m = [[AccountController alloc] initWithNibName:@"AccountView" bundle:nil];    
    [self.navigationController pushViewController:m animated:YES];
}

- (void)openRegisterWindow
{
    NSLog(@"222");
//    RegisterController* m = [[RegisterController alloc]init];
////    if (self.parentViewController) {
////        [self.parentViewController presentViewController:m animated:YES completion:nil];
////
////    }
//    if (self.navigationController) {
//        [self.navigationController presentViewController:m animated:YES completion:nil];
//
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end


