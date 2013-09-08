//
//  LoginController.m
//  HellCook
//
//  Created by panda on 3/28/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "LoginController.h"
#import "DefaultGroupedTableCell.h"
#import "NetManager.h"

#define kTableCellHeader  48
#define kTableCellBody    45
#define kTableCellFooter  49
#define kTableCellSingle  50

@interface LoginController ()

@end

@implementation LoginController
@synthesize tableView;
@synthesize navigationItem;
@synthesize callerClassName;


- (void)viewDidLoad
{
  cellList = [[NSMutableArray alloc]initWithObjects:@"手机号",@"密码",nil];
  [usernameField setDelegate:self];
  [passwordField setDelegate:self];
  
  [self.tableView setScrollEnabled:NO];
  CGRect frame = self.tableView.tableHeaderView.frame;
  frame.size.height = 24;
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
  
  self.navigationItem.title = @"登录";
  
  [self setLeftButton];
  [self setRightButton];

  // callerClassName = @"";
  
  [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [usernameField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
  if (self.loginOperation) {
    [self.loginOperation cancel];
  }
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
  return cellList.count;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cellList.count==1)
        return kTableCellSingle;
    
    if (indexPath.row==0) {
        return kTableCellHeader;
    }else if (indexPath.row == [cellList count]-1){
        return kTableCellFooter;
    }else
        return kTableCellBody;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier;
  if (indexPath.row == 0) {
    CellIdentifier = @"LoginUserCell";
  }
  if (indexPath.row == 1) {
    CellIdentifier = @"LoginPassCell";
  }
  
  DefaultGroupedTableCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
  if (cell == nil) {
    cell = [[DefaultGroupedTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    if (indexPath.row == 0) {
      usernameField = [[UITextField alloc]init];
      [cell addSubview:usernameField];
    }
    if (indexPath.row == 1) {
      passwordField = [[UITextField alloc]init];
      [cell addSubview:passwordField];
    }
  }
  
  if (indexPath.row == 0) {
    [usernameField setFrame:CGRectMake(30, 15, 200, 34)];
    [usernameField setPlaceholder:@"手机号"];
    [usernameField setBackgroundColor: [UIColor clearColor]];
    [usernameField setDelegate:self];
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameField.keyboardType = UIKeyboardTypeNumberPad;
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    [usernameField setFont:[UIFont systemFontOfSize:14]];
    usernameField.returnKeyType = UIReturnKeyDone;
  }
  else if(indexPath.row == 1)
  {
    [passwordField setFrame:CGRectMake(30, 13, 200, 34)];
    [passwordField setPlaceholder:@"密码"];
    [passwordField setBackgroundColor: [UIColor clearColor]];
    [passwordField setDelegate:self];
    [passwordField setSecureTextEntry:YES];
    passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordField.keyboardType = UIKeyboardTypeDefault;
    [passwordField setFont:[UIFont systemFontOfSize:14]];
    passwordField.returnKeyType = UIReturnKeyDone;
  }
  cell.tableCellBodyHeight = kTableCellBody;
  cell.tableCellHeaderHeight = kTableCellHeader;
  cell.accessoryType = UITableViewCellAccessoryNone;
  [cell setCellStyle:[cellList count] Index:indexPath.row];

  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - Text Return

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  
  return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)sender
{
  
}

#pragma mark - Navi Button

- (void)setLeftButton
{
    UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/commonBackBackgroundNormal.png"]
                                 forState:UIControlStateNormal];
    [leftBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/commonBackBackgroundHighlighted.png"]
                                 forState:UIControlStateHighlighted];
    [leftBarButtonView setTitle:@"  返回 " forState:UIControlStateNormal];
    [leftBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
    
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)setRightButton
{
  UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 30)];
  [rightBarButtonView addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"]
                               forState:UIControlStateNormal];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/redNavigationButtonBackgroundHighlighted.png"]
                               forState:UIControlStateHighlighted];
  [rightBarButtonView setTitle:@"登陆" forState:UIControlStateNormal];
  [rightBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
  
  [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

-(void)returnToPrev
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Net

-(void)onLogin
{
  HUD = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:HUD];
  
  HUD.mode = MBProgressHUDModeText;
  
  HUD.delegate = self;
  HUD.labelText = @"登录中";
  
  [HUD show:YES];
  
  [usernameField resignFirstResponder];
  [passwordField resignFirstResponder];
  
  NSString* username = usernameField.text;
  NSString* password = passwordField.text;
  
  self.loginOperation = [[[NetManager sharedInstance] hellEngine]
                          loginWithUser:username AndPass:password
                          completionHandler:^(NSMutableDictionary *resultDic) {
                            [self LoginCallBack:resultDic];}
                          errorHandler:^(NSError *error) {}
                         ];
  
}

- (void)LoginCallBack:(NSMutableDictionary*) resultDic
{
  [HUD hide:NO];
  
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0) {
    [self dismissViewControllerAnimated:YES completion:nil];
    // 广播登陆成功的消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnLoginSuccess" object:callerClassName];
  }
  else
  {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
		
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.delegate = self;
    HUD.labelText = @"登录失败";
        
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
  }
}

@end
