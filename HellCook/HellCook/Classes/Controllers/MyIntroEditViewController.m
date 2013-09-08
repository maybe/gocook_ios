//
//  MyIntroEditViewController.m
//  HellCook
//
//  Created by lxw on 13-8-11.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyIntroEditViewController.h"
#import "KeyboardHandler.h"
#import "DefaultGroupedTableCell.h"
#import "UIView+FindFirstResponder.h"
#import "NetManager.h"
#import "UIImage+Resize.h"
#import "UIImage+Resizing.h"
#import "HomePageController.h"
#import "User.h"

#define kTableCellHeader  48
#define kTableCellBody    45
#define kTableCellFooter  160

@interface MyIntroEditViewController ()

@end

@implementation MyIntroEditViewController
@synthesize myTableView,nameField,careerField,ageField,maleBtn,femaleBtn,otherBtn,provinceField,cityField,introTextView;
@synthesize mLoadingActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary*)dict
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    isChanged = FALSE;
    waitCallBack = 0;
    data = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    nameField = [[UITextField alloc]init];
    careerField = [[UITextField alloc]init];
    provinceField = [[UITextField alloc]init];
    cityField = [[UITextField alloc]init];
    introTextView = [[SSTextView alloc]init];
    ageField = [[UITextField alloc] init];
    maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [maleBtn addTarget:self action:@selector(maleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [femaleBtn addTarget:self action:@selector(femaleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherBtn addTarget:self action:@selector(otherBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    cellContentList = [[NSMutableArray alloc]init];
  }
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  [self setLeftButton];
  [self setRightButton];
  
  [self initcellContentList];
  
  CGRect frame = self.myTableView.tableHeaderView.frame;
  frame.size.height = 150;
  self.myTableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
  headImageView = [[MyIntroAvatarView alloc]initWithFrame:CGRectMake(0, 0, 320, 150) withData:data];
  [self.myTableView.tableHeaderView addSubview:headImageView];
  //keyboard
  keyboard = [[KeyboardHandler alloc] init];
  
  HUD = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:HUD];  
  HUD.mode = MBProgressHUDModeText;
  HUD.delegate = self;
  
  CGRect viewframe = self.view.frame;
  viewframe.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewframe];
  [self.myTableView setFrame:viewframe];
  
  [self initLoadingView];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.title = @"编辑个人资料";
  
  keyboard.delegate = self;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initcellContentList
{
  NSMutableDictionary *cellDic;
  NSString *content;
  ///////////////姓名//////////////
  if (data[@"nickname"]!=[NSNull null] && ![data[@"nickname"] isEqual:@""])
  {
    content = [NSString stringWithString:data[@"nickname"]];
  }
  else
  {
    content = @"";
  }
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys:@"cellName",@"Identifier", @"姓名",@"placeHolder", nameField,@"textfield", @"text",@"type", content,@"content",nil];
  [cellContentList addObject:cellDic];
  ////////////////生日性别////////////
  NSString *gender;
  if (data[@"gender"]!=[NSNull null] && ![data[@"gender"] isEqual:@""])
  {
    gender = [NSString stringWithFormat:@"%d",[data[@"gender"] intValue]];
  }
  else
  {
    gender = @"";
  }
  if (data[@"age"]!=[NSNull null] && ![data[@"age"] isEqual:@""])
  {
    content = [NSString stringWithFormat:@"%d",[data[@"age"] intValue]];
  }
  else
  {
    content = @"";
  }
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys:@"cellBG",@"Identifier", @"",@"placeHolder", gender,@"gender", content,@"age",nil];
  [cellContentList addObject:cellDic];
  //////////////职业/////////////////
  if (data[@"career"]!=[NSNull null] && ![data[@"career"] isEqual:@""])
  {
    content = [NSString stringWithString:data[@"career"]];
  }
  else
  {
    content = @"";
  }
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys:@"cellCareer",@"Identifier", @"职业",@"placeHolder", careerField,@"textfield", @"text",@"type", content,@"content",nil];
  [cellContentList addObject:cellDic];
  //////////地点///////////////
  NSString *province;
  if (data[@"province"]!=[NSNull null] && ![data[@"province"] isEqual:@""])
  {
    province = [NSString stringWithString:data[@"province"]];
  }
  else
  {
    province = @"";
  }
  if (data[@"city"]!=[NSNull null] && ![data[@"city"] isEqual:@""])
  {
    content = [NSString stringWithString:data[@"city"]];
  }
  else
  {
    content = @"";
  }
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys:@"cellLocation",@"Identifier", @"地点",@"placeHolder", province,@"province", @"text",@"type", content,@"city",nil];
  [cellContentList addObject:cellDic];
  //////////////个人简介////////////////////
  if (data[@"intro"]!=[NSNull null] && ![data[@"intro"] isEqual:@""])
  {
    content = [NSString stringWithString:data[@"intro"]];
  }
  else
  {
    content = @"";
  }
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys:@"cellIntro",@"Identifier", @"个人简介",@"placeHolder", introTextView,@"textview", @"text",@"type", content,@"content",nil];
  [cellContentList addObject:cellDic];
}

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
  [rightBarButtonView addTarget:self action:@selector(Save) forControlEvents:UIControlEventTouchUpInside];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"]
                                forState:UIControlStateNormal];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/redNavigationButtonBackgroundHighlighted.png"]
                                forState:UIControlStateHighlighted];
  [rightBarButtonView setTitle:@"保存" forState:UIControlStateNormal];
  [rightBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
  
  [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

-(void)returnToPrev
{
  NSArray *viewControllers = [NSArray arrayWithArray:self.navigationController.viewControllers];
  HomePageController *prevController = [viewControllers objectAtIndex:[viewControllers count]-2];
  prevController.isMyInfoChanged = isChanged;
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)Save
{
  [mLoadingActivity startAnimating];
  
  [self uploadBasicInfo];
  [self uploadAvatar];
  
  if (waitCallBack<=0)
    [mLoadingActivity stopAnimating];
}



- (IBAction) maleBtnPressed
{
  [maleBtn setBackgroundImage:[UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"] forState:UIControlStateNormal];
  [femaleBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [otherBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [maleBtn setSelected:YES];
  [femaleBtn setSelected:NO];
  [otherBtn setSelected:NO];
}

- (IBAction) femaleBtnPressed
{
  [femaleBtn setBackgroundImage:[UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"] forState:UIControlStateNormal];
  [maleBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [otherBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [maleBtn setSelected:NO];
  [femaleBtn setSelected:YES];
  [otherBtn setSelected:NO];
}

- (IBAction) otherBtnPressed
{
  [otherBtn setBackgroundImage:[UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"] forState:UIControlStateNormal];
  [femaleBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [maleBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [maleBtn setSelected:NO];
  [femaleBtn setSelected:NO];
  [otherBtn setSelected:YES];
}


- (void)initLoadingView
{
  mLoadingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
  [mLoadingActivity setCenter:CGPointMake(_screenWidth/2, _screenHeight/2-50)];
  [mLoadingActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  [self.myTableView addSubview:mLoadingActivity];
  mLoadingActivity.hidesWhenStopped = YES;
  [mLoadingActivity stopAnimating];
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
  if (indexPath.row==0)
  {
    return kTableCellHeader;
  }else if (indexPath.row == [cellContentList count]-1)
  {
    return kTableCellFooter;
  }else
  {
    return kTableCellBody;
  }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  NSMutableDictionary* dic = [cellContentList objectAtIndex:indexPath.row];
  UITextField* textField = [dic objectForKey:@"textfield"];
  SSTextView* textView = [dic objectForKey:@"textview"];
  DefaultGroupedTableCell *cell = [aTableView dequeueReusableCellWithIdentifier:[dic objectForKey:@"Identifier"]];
  
  if (cell == nil)
  {
    cell = [[DefaultGroupedTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: [dic objectForKey:@"Identifier"]];
    if (textField)
    {
      [cell addSubview:textField];
    }
    else if(textView)
    {
      [cell addSubview:textView];
    }
    else
    {
      if (dic[@"city"])
      {
        [cell addSubview:provinceField];
        [cell addSubview:cityField];
      }
      else
      {
        [cell addSubview:ageField];
        [cell addSubview:maleBtn];
        [cell addSubview:femaleBtn];
        [cell addSubview:otherBtn];
      }
    }
  }
  
  if (textField)
  {
    [textField setDelegate:self];
    [textField setFrame:CGRectMake(30, 15, 200, 34)];
    [textField setPlaceholder:[dic objectForKey:@"placeHolder"]];
    if (![dic[@"content"] isEqual:@""])
    {
      [textField setText:[dic objectForKey:@"content"]];
    }
    [textField setBackgroundColor: [UIColor clearColor]];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [textField setFont:[UIFont systemFontOfSize:18]];
    textField.returnKeyType = UIReturnKeyDone;
    [textField setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
  }
  else if (textView)
  {
    textView.delegate = self;
    [textView setFrame:CGRectMake(15, 0, 290, 150)];
    [textView setBackgroundColor: [UIColor clearColor]];
    textView.placeholder = [dic objectForKey:@"placeHolder"];
    if (![dic[@"content"] isEqual:@""])
    {
      [textView setText:[dic objectForKey:@"content"]];
    }
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    [textView setFont:[UIFont systemFontOfSize:18]];
    textView.returnKeyType = UIReturnKeyDone;
    [textView setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
  }
  else
  {
    if (dic[@"city"])
    {
      [provinceField setDelegate:self];
      [provinceField setFrame:CGRectMake(30, 15, 100, 34)];
      [provinceField setPlaceholder:@"省份"];
      if (![dic[@"province"] isEqual:@""])
      {
        [provinceField setText:[dic objectForKey:@"province"]];
      }
      [provinceField setBackgroundColor: [UIColor clearColor]];
      provinceField.autocapitalizationType = UITextAutocapitalizationTypeNone;
      provinceField.keyboardType = UIKeyboardTypeDefault;
      provinceField.autocorrectionType = UITextAutocorrectionTypeNo;
      [provinceField setFont:[UIFont systemFontOfSize:18]];
      provinceField.returnKeyType = UIReturnKeyDone;
      [provinceField setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      
      [cityField setDelegate:self];
      [cityField setFrame:CGRectMake(140, 15, 100, 34)];
      [cityField setPlaceholder:@"城市"];
      if (![dic[@"city"] isEqual:@""])
      {
        [cityField setText:[dic objectForKey:@"city"]];
      }
      [cityField setBackgroundColor: [UIColor clearColor]];
      cityField.autocapitalizationType = UITextAutocapitalizationTypeNone;
      cityField.keyboardType = UIKeyboardTypeDefault;
      cityField.autocorrectionType = UITextAutocorrectionTypeNo;
      [cityField setFont:[UIFont systemFontOfSize:18]];
      cityField.returnKeyType = UIReturnKeyDone;
      [cityField setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
    }
    else//年龄性别
    {
      [ageField setFrame:CGRectMake(30, 13, 80, 30)];
      [ageField setPlaceholder:@"年龄"];
      if (![dic[@"age"] isEqual:@""])
      {
        [ageField setText:[dic objectForKey:@"age"]];
      }
      [ageField setDelegate:self];
      ageField.autocapitalizationType = UITextAutocapitalizationTypeNone;
      ageField.keyboardType = UIKeyboardTypeDefault;
      ageField.autocorrectionType = UITextAutocorrectionTypeNo;
      [ageField setFont:[UIFont systemFontOfSize:18]];
      ageField.returnKeyType = UIReturnKeyDone;
      [ageField setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      
      [maleBtn setFrame:CGRectMake(150, 10, 50, 30)];
      [maleBtn setBackgroundImage:[UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"] forState:UIControlStateSelected];
      [maleBtn setTitleColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
      [maleBtn setTitle:@"男" forState:UIControlStateNormal];
      maleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
      
      [femaleBtn setFrame:CGRectMake(200, 10, 50, 30)];
      [femaleBtn setBackgroundImage:[UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"] forState:UIControlStateSelected];
      [femaleBtn setTitleColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
      [femaleBtn setTitle:@"女" forState:UIControlStateNormal];
      femaleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
      
      [otherBtn setFrame:CGRectMake(250, 10, 50, 30)];
      [otherBtn setBackgroundImage:[UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"] forState:UIControlStateSelected];
      [otherBtn setTitleColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
      [otherBtn setTitle:@"其他" forState:UIControlStateNormal];
      otherBtn.titleLabel.font = [UIFont systemFontOfSize:18];
      
      if (![dic[@"gender"] isEqual:@""])
      {
        if ([dic[@"gender"] isEqual:@"0"])
        {
          [maleBtn setBackgroundImage:[UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"] forState:UIControlStateNormal];
          [maleBtn setSelected:YES];
        }
        else if ([dic[@"gender"] isEqual:@"1"])
        {
          [femaleBtn setBackgroundImage:[UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"] forState:UIControlStateNormal];
          [femaleBtn setSelected:YES];
        }
        else
        {
          [otherBtn setBackgroundImage:[UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"] forState:UIControlStateNormal];
          [otherBtn setSelected:YES];
        }
      }
    }    
  }
  
  cell.tableCellBodyHeight = kTableCellBody;
  cell.tableCellHeaderHeight = kTableCellHeader;
  cell.tableCellFooterHeight = kTableCellFooter;
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

-(void)textViewDidBeginEditing:(UITextView *)textView
{
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  if ([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  return YES;
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
  [self dismissViewControllerAnimated:YES completion:nil];
  
  [headImageView setNewImage:image];
}

#pragma mark - MBProgressHUD delegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
  if (isChanged)
  {
    [self returnToPrev];
  }
}

#pragma mark - Keyboard

- (void)keyboardSizeChanged:(CGSize)delta
{
  UIView* frView = [self.myTableView findFirstResponder];
  if ([frView isKindOfClass:[UITextField class]] || [frView isKindOfClass:[SSTextView class]]) {
    if (delta.height > 0) {
      CGPoint realOrigin = [frView convertPoint:frView.frame.origin toView:nil];
      if (realOrigin.y + frView.frame.size.height  > _screenHeight - delta.height) {
        CGFloat deltaHeight = realOrigin.y + frView.frame.size.height - ( _screenHeight - delta.height) + 10;
        CGRect frame = self.myTableView.frame;
        frame.origin.y -= deltaHeight;
        if (-frame.origin.y > delta.height) {
          frame.origin.y = - delta.height;
        }
        self.myTableView.frame = frame;
      }
    }
    else{
      CGRect frame = self.myTableView.frame;
      frame.origin.y =  0;
      self.myTableView.frame = frame;
    }
  }
}

- (void)uploadBasicInfo
{
  waitCallBack++;
  
  NSMutableDictionary *pBasicInfoDict = [[NSMutableDictionary alloc] init];
  //用户名
  if (nameField.text.length!=0 && ![data[@"nickname"] isEqual:nameField.text])
  {
    [pBasicInfoDict setObject:nameField.text forKey:@"nickname"];
  }
  //年龄
  if (ageField.text.length!=0 && [data[@"age"] intValue]!=[ageField.text intValue])
  {
    [pBasicInfoDict setObject:ageField.text forKey:@"age"];
  }
  //性别
  NSString *gender;
  if (maleBtn.selected)
  {
    gender = @"0";
  }
  else if (femaleBtn.selected)
  {
    gender = @"1";
  }
  else if (otherBtn.selected)
  {
    gender = @"2";
  }
  else
  {
    gender = @"";
  }
  if (![gender isEqual:@""] && [data[@"gender"] intValue]!=[gender intValue])
  {
    [pBasicInfoDict setObject:gender forKey:@"gender"];
  }
  //职业
  if (careerField.text.length!=0 && ![data[@"career"] isEqual:careerField.text])
  {
    [pBasicInfoDict setObject:careerField.text forKey:@"career"];
  }
  //省份
  if (provinceField.text.length!=0 && ![data[@"province"] isEqual:provinceField.text])
  {
    [pBasicInfoDict setObject:provinceField.text forKey:@"province"];
  }
  //城市
  if (cityField.text.length!=0 && ![data[@"city"] isEqual:cityField.text])
  {
    [pBasicInfoDict setObject:cityField.text forKey:@"city"];
  }
  //简介
  if (introTextView.text.length!=0 && ![data[@"intro"] isEqual:introTextView.text])
  {
    [pBasicInfoDict setObject:introTextView.text forKey:@"intro"];
  }
  
  if ([pBasicInfoDict count] > 0)
  {
    self.netOperation = [[[NetManager sharedInstance] hellEngine]
                         uploadBasicInfoWithDict:pBasicInfoDict
                         completionHandler:^(NSMutableDictionary *resultDic) {
                           [self changeBasicInfoCallBack:resultDic];}
                         errorHandler:^(NSError *error){}];
  }
  else
  {
    waitCallBack--;
    HUD.labelText = @"个人信息无改变，不需保存";
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
  }
}

- (void)changeBasicInfoCallBack:(NSMutableDictionary*) resultDic
{
  waitCallBack--;
  if (waitCallBack <= 0)
    [mLoadingActivity stopAnimating];
  
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    isChanged = TRUE;
    User* user = [User sharedInstance];
    user.account.username = nameField.text;
    
    HUD.labelText = @"个人基本信息上传成功";
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
  }
  else
  {
    if ([[resultDic valueForKey:@"errorcode"] intValue] == 2)
    {
      HUD.labelText = @"用户名已存在";
      [HUD show:YES];
      [HUD hide:YES afterDelay:2];
    }
    else
    {
      NSString *msg = [NSString stringWithFormat:@"errorcode:%d",[[resultDic valueForKey:@"errorcode"] intValue]];
      HUD.labelText = msg;
      [HUD show:YES];
      [HUD hide:YES afterDelay:2];
    }
  }
}

- (void)uploadAvatar
{
  waitCallBack++;
  NSString  *pngPath = @"";
  
  UIImage* uploadImage = headImageView.avataImageView.image;
  if (uploadImage != headImageView.defaultImage)
  {
    pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/uploadtmp.png"];
    newHeadImagePath = [NSString stringWithString:pngPath];
    uploadImage = [uploadImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(100, 100) interpolationQuality:kCGInterpolationHigh];
    uploadImage = [uploadImage cropToSize:CGSizeMake(100, 100) usingMode:NYXCropModeTopCenter];
    // Write image to PNG
    [UIImagePNGRepresentation(uploadImage) writeToFile:pngPath atomically:YES];
  
    self.netOperation = [[[NetManager sharedInstance] hellEngine]
        uploadAvatarByPath:pngPath
         completionHandler:^(NSMutableDictionary *resultDic) {
           [self uploadAvatarCallBack:resultDic];
         }
              errorHandler:^(NSError *error) {
              }];
  }
  else
    waitCallBack--;
  
}

- (void)uploadAvatarCallBack:(NSMutableDictionary*) resultDic
{
  waitCallBack--;
  if (waitCallBack <= 0)
    [mLoadingActivity stopAnimating];
  
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    isChanged = TRUE;
    User* user = [User sharedInstance];
    user.account.avatar = newHeadImagePath;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"头像上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
  }
  else
  {
    NSString *msg = [NSString stringWithFormat:@"errorcode:%d",[[resultDic valueForKey:@"errorcode"] intValue]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
  }
}

@end
