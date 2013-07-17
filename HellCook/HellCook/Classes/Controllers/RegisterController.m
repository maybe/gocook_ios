//
//  RegisterController.m
//  HellCook
//
//  Created by panda on 3/27/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "RegisterController.h"
#import "DefaultGroupedTableCell.h"
#import "RegisterAvatarView.h"
#import "KeyboardHandler.h"
#import "UIView+FindFirstResponder.h"
#import "NetManager.h"
#import "User.h"
#import "UIImage+Resize.h"
#import "UIImage+Resizing.h"
#import "DBHandler.h"

#define kTableCellHeader  48
#define kTableCellBody    45
#define kTableCellFooter  49
#define kTableCellSingle  50

@interface RegisterController ()

@end

@implementation RegisterController
@synthesize navgationItem;
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [self setLeftButton];
  [self setRightButton];
  
  nickField = [[UITextField alloc]init];
  emailField = [[UITextField alloc]init];
  passwordField = [[UITextField alloc]init];
  repasswordField = [[UITextField alloc]init];

  cellContentList = [[NSMutableArray alloc]init];
  NSMutableDictionary *cellDic;
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys :
             @"cellNick",@"Identifier", @"昵称",@"placeHolder",
             nickField, @"textfield",@"text",@"type",nil];
  [cellContentList addObject:cellDic];
  
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys :
             @"cellEmail",@"Identifier", @"email",@"placeHolder",
             emailField, @"textfield",@"text",@"type",nil];
  [cellContentList addObject:cellDic];
  
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys :
             @"cellPass",@"Identifier", @"密码",@"placeHolder",
             passwordField, @"textfield",@"pass",@"type",nil];
  [cellContentList addObject:cellDic];
  
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys :
             @"cellRePass",@"Identifier", @"重复密码",@"placeHolder",
             repasswordField, @"textfield",@"pass",@"type",nil];
  [cellContentList addObject:cellDic];
  
  CGRect frame = self.tableView.tableHeaderView.frame;
  frame.size.height = 184;
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
  CGFloat tablewidth = self.tableView.frame.size.width;
  headImageView = [[RegisterAvatarView alloc]initWithFrame:CGRectMake(tablewidth/2-75, 30, 150, 150)];
  [self.tableView.tableHeaderView addSubview:headImageView];
  
  //keyboard
  keyboard = [[KeyboardHandler alloc] init];
  
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  keyboard.delegate = self;

  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  keyboard.delegate = nil;
  
  [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotate {
  
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
  
  return UIInterfaceOrientationMaskAll;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return cellContentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (cellContentList.count==1)
    return kTableCellSingle;
  
  if (indexPath.row==0) {
    return kTableCellHeader;
  }else if (indexPath.row == [cellContentList count]-1){
    return kTableCellFooter;
  }else
    return kTableCellBody;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  NSMutableDictionary* dic = [cellContentList objectAtIndex:indexPath.row];
  UITextField* textField = [dic objectForKey:@"textfield"];
  
  DefaultGroupedTableCell *cell = [aTableView dequeueReusableCellWithIdentifier:[dic objectForKey:@"Identifier"]];
  
  if (cell == nil) {
    cell = [[DefaultGroupedTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: [dic objectForKey:@"Identifier"]];
    [cell addSubview:textField];
  }
  [textField setDelegate:self];
  [textField setFrame:CGRectMake(30, 15, 200, 34)];
  [textField setPlaceholder:[dic objectForKey:@"placeHolder"]];
  [textField setBackgroundColor: [UIColor clearColor]];
  [textField setDelegate:self];
  textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  textField.keyboardType = UIKeyboardTypeDefault;
  textField.autocorrectionType = UITextAutocorrectionTypeNo;
  [textField setFont:[UIFont systemFontOfSize:14]];
  textField.returnKeyType = UIReturnKeyDone;
  if ([[dic objectForKey:@"type"] isEqual: @"pass"]) {
    [textField setSecureTextEntry:YES];
  }

  cell.tableCellBodyHeight = kTableCellBody;
  cell.tableCellHeaderHeight = kTableCellHeader;
  cell.accessoryType = UITableViewCellAccessoryNone;
  [cell setCellStyle:[cellContentList count] Index:indexPath.row];
  
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - Textreturn

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  
  return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)sender
{
  
}

#pragma mark - Avatar View
- (void)setHeaderView
{
  
}

-(void)ResetUploadImageView
{
  headImageView.upImageView.image = headImageView.defaultImage;
}


-(void) loadImagePicker
{
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]==YES) {
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  }
  picker.allowsEditing = NO;
  [self presentViewController:picker animated:YES completion:nil];
  
  
  
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  // Access the uncropped image from info dictionary
  UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
  
  //Find the image url.
  //self.pickedImagePath = [(NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL] absoluteString];
  
  // Dismiss the camera
  [self dismissViewControllerAnimated:YES completion:nil];
    
  [headImageView.upImageView setImage:image];
}

#pragma mark - Keyboard

- (void)keyboardSizeChanged:(CGSize)delta
{
  UIView* frView = [self.tableView findFirstResponder];
  if ([frView isKindOfClass:[UITextField class]]) {
    if (delta.height > 0) {
      CGPoint realOrigin = [frView convertPoint:frView.frame.origin toView:nil];
      if (realOrigin.y + frView.frame.size.height  > _screenHeight - delta.height) {
        CGFloat deltaHeight = realOrigin.y + frView.frame.size.height - ( _screenHeight - delta.height) + 10;
        CGRect frame = self.tableView.frame;
        frame.origin.y -= deltaHeight;
        self.tableView.frame = frame;
      }
    }
    else{
      CGRect frame = self.tableView.frame;
      frame.origin.y =  _navigationBarHeight;
      self.tableView.frame = frame;
    }
  }
}


#pragma mark - Navi Butons

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
  [leftBarButtonView setTitle:@"返回" forState:UIControlStateNormal];
  [leftBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  [self.navgationItem setLeftBarButtonItem:leftBarButtonItem];
  
}

- (void)setRightButton
{
  UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 30)];
  [rightBarButtonView addTarget:self action:@selector(onRegister) forControlEvents:UIControlEventTouchUpInside];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"]
                                forState:UIControlStateNormal];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/redNavigationButtonBackgroundHighlighted.png"]
                                forState:UIControlStateHighlighted];
  [rightBarButtonView setTitle:@"注册" forState:UIControlStateNormal];
  [rightBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
  
  [self.navgationItem setRightBarButtonItem:rightBarButtonItem];
}

-(void)returnToPrev
{
  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Net

-(void)onRegister
{
  NSString* email = emailField.text;
  NSString* nickname = nickField.text;
  NSString* password = passwordField.text;
  NSString* repassword = repasswordField.text;
  
  NSString  *pngPath = @"";

  UIImage* uploadImage = headImageView.upImageView.image;
  if (uploadImage!=headImageView.defaultImage) {
    pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/uploadtmp.png"];
    uploadImage = [uploadImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(100, 100) interpolationQuality:kCGInterpolationHigh];
    uploadImage = [uploadImage cropToSize:CGSizeMake(100, 100) usingMode:NYXCropModeTopCenter];
    // Write image to PNG
    [UIImagePNGRepresentation(uploadImage) writeToFile:pngPath atomically:YES];
  }
  
  self.registerOperation = [[[NetManager sharedInstance] hellEngine]
                            registerWithEmail:email AndNick:nickname
                            AndPass:password AndRePass:repassword AndAvatarPath:pngPath
                            completionHandler:^(NSMutableDictionary *resultDic) {
                              [self RegisterCallBack:resultDic];}
                            errorHandler:^(NSError *error) {}
                            ];
  
}

- (void)RegisterCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result != 0 || resultDic == nil)
  {
    [emailField resignFirstResponder];
    [nickField resignFirstResponder];
    [passwordField resignFirstResponder];
    [repasswordField resignFirstResponder];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
		
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.delegate = self;
    HUD.labelText = @"注册失败";
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
  }
  else {
    User* user = [User sharedInstance];
    user.account.username = resultDic[@"username"];
    user.account.isLogin = YES;
    user.account.avatar = resultDic[@"icon"];
    
    NSMutableDictionary* dic = nil;
    dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
           resultDic[@"username"], @"username",
           emailField.text, @"email",
           passwordField.text, @"password",
           resultDic[@"icon"], @"avatar", nil];
    
    DBHandler* dbHandler = [DBHandler sharedInstance];
    [dbHandler setAccount:dic];
    
    [[[User sharedInstance] account] setShouldResetLogin:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
  }
}


@end
