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
#import "User.h"

#define kTableCellHeader  52
#define kTableCellBody    52
#define kTableCellFooter  120

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

  [self setLeftButton];
  [self setRightButton];
  
  [self initcellContentList];
  
  CGRect frame = self.myTableView.tableHeaderView.frame;
  frame.size.height = 140;
  self.myTableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
  headImageView = [[MyIntroAvatarView alloc]initWithFrame:CGRectMake(0, 0, 320, 140) withData:data];
  [self.myTableView.tableHeaderView addSubview:headImageView];
  //keyboard
  keyboard = [[KeyboardHandler alloc] init];
  
  HUD = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:HUD];  
  HUD.mode = MBProgressHUDModeText;
  HUD.delegate = self;
  
  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];
  self.view.autoresizesSubviews = NO;

  CGRect tableFrame = self.myTableView.frame;
  tableFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.myTableView setFrame:tableFrame];
  
  [self initLoadingView];

  [self autoLayout];
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
    gender = @"2";
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
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 29)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
      [UIImage imageNamed:@"Images/BackButtonNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
      [UIImage imageNamed:@"Images/BackButtonHighLight.png"]
                               forState:UIControlStateHighlighted];
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)setRightButton
{
  UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 29)];
  [rightBarButtonView addTarget:self action:@selector(Save) forControlEvents:UIControlEventTouchUpInside];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/SaveButtonNormal.png"]
                                forState:UIControlStateNormal];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/SaveButtonHighLight.png"]
                                forState:UIControlStateHighlighted];

  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
  
  [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

-(void)returnToPrev
{
  // NSArray *viewControllers = [NSArray arrayWithArray:self.navigationController.viewControllers];
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)Save
{
  [self.view endEditing:YES];

  [mLoadingActivity startAnimating];

  [self uploadAvatar];
  [self uploadBasicInfo];

  if (waitCallBack<=0)
    [mLoadingActivity stopAnimating];
}



- (IBAction) maleBtnPressed
{
  [maleBtn setBackgroundImage:[UIImage imageNamed:@"Images/GenderSelected.png"] forState:UIControlStateNormal];
  [femaleBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [otherBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [maleBtn setSelected:YES];
  [femaleBtn setSelected:NO];
  [otherBtn setSelected:NO];
}

- (IBAction) femaleBtnPressed
{
  [femaleBtn setBackgroundImage:[UIImage imageNamed:@"Images/GenderSelected.png"] forState:UIControlStateNormal];
  [maleBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [otherBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [maleBtn setSelected:NO];
  [femaleBtn setSelected:YES];
  [otherBtn setSelected:NO];
}

- (IBAction) otherBtnPressed
{
  [otherBtn setBackgroundImage:[UIImage imageNamed:@"Images/GenderSelected.png"] forState:UIControlStateNormal];
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
  }
  else if (indexPath.row == [cellContentList count]-1)
  {
    return kTableCellFooter;
  }
  else
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
    [textField setFrame:CGRectMake(30, 0, 200, kTableCellBody)];
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
    [textView setFrame:CGRectMake(30, 0, 260, kTableCellFooter)];
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
      [provinceField setFrame:CGRectMake(30, 0, 100, kTableCellBody)];
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
      [cityField setFrame:CGRectMake(140, 0, 100, kTableCellBody)];
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
      [ageField setFrame:CGRectMake(30, 0, 80, kTableCellBody)];
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
      
      [maleBtn setFrame:CGRectMake(150, kTableCellBody/2 -12, 40, 24)];
      [maleBtn setBackgroundImage:[UIImage imageNamed:@"Images/GenderSelected.png"] forState:UIControlStateSelected];
      [maleBtn setTitleColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
      [maleBtn setTitle:@"男" forState:UIControlStateNormal];
      maleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
      
      [femaleBtn setFrame:CGRectMake(200, kTableCellBody/2 -12, 40, 24)];
      [femaleBtn setBackgroundImage:[UIImage imageNamed:@"Images/GenderSelected.png"] forState:UIControlStateSelected];
      [femaleBtn setTitleColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
      [femaleBtn setTitle:@"女" forState:UIControlStateNormal];
      femaleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
      
      [otherBtn setFrame:CGRectMake(250, kTableCellBody/2 -12, 40, 24)];
      [otherBtn setBackgroundImage:[UIImage imageNamed:@"Images/GenderSelected.png"] forState:UIControlStateSelected];
      [otherBtn setTitleColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
      [otherBtn setTitle:@"其他" forState:UIControlStateNormal];
      otherBtn.titleLabel.font = [UIFont systemFontOfSize:16];
      
      if (![dic[@"gender"] isEqual:@""])
      {
        if ([dic[@"gender"] isEqual:@"0"])
        {
          [maleBtn setBackgroundImage:[UIImage imageNamed:@"Images/GenderSelected.png"] forState:UIControlStateNormal];
          [maleBtn setSelected:YES];
        }
        else if ([dic[@"gender"] isEqual:@"1"])
        {
          [femaleBtn setBackgroundImage:[UIImage imageNamed:@"Images/GenderSelected.png"] forState:UIControlStateNormal];
          [femaleBtn setSelected:YES];
        }
        else
        {
          [otherBtn setBackgroundImage:[UIImage imageNamed:@"Images/GenderSelected.png"] forState:UIControlStateNormal];
          [otherBtn setSelected:YES];
        }
      } else {
        [otherBtn setBackgroundImage:[UIImage imageNamed:@"Images/GenderSelected.png"] forState:UIControlStateNormal];
        [otherBtn setSelected:YES];
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


-(void)loadImagePicker
{
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  }
  picker.allowsEditing = NO;
  [self presentViewController:picker animated:YES completion:nil];
  
}

-(void)loadCameraPicker {

  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [picker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
    [picker setCameraDevice:UIImagePickerControllerCameraDeviceRear];
  }

  picker.allowsEditing = NO;
  [self presentViewController:picker animated:YES completion:nil];
}

-(void)selectAvatarImage
{
  UIActionSheet* actionSheet = [[UIActionSheet alloc]
      initWithTitle:@"请选择文件来源"
           delegate:self
     cancelButtonTitle:@"取消"
destructiveButtonTitle:nil
     otherButtonTitles:@"照相机",@"本地相簿",nil];
  [actionSheet setTag:1];
  [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (actionSheet.tag == 1) {
    if (buttonIndex == 0) {
      [self loadCameraPicker];
    } else if (buttonIndex == 1) {
      [self loadImagePicker];
    }
  }
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
  if (isChanged && waitCallBack == 0)
  {
    [self returnToPrev];
  }
}

#pragma mark - Keyboard

- (void)keyboardSizeChanged:(CGSize)delta
{
  UIView* frView = [self.myTableView findFirstResponder];
  if ([frView isKindOfClass:[UITextField class]] || [frView isKindOfClass:[SSTextView class]]) {
    if ([frView isKindOfClass:[SSTextView class]]) {
      frView = frView.superview;
    }
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
  else
  {
    if (nameField.text.length == 0)
    {
      [mLoadingActivity stopAnimating];
      HUD.labelText = @"用户名不能为空";
      HUD.detailsLabelText = nil;
      [HUD show:YES];
      [HUD hide:YES afterDelay:2];
      
      return;
    }
  }

  //年龄
  if (ageField.text.length!=0 && (data[@"age"] == [NSNull null] || [data[@"age"] intValue]!=[ageField.text intValue]))
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
  else
  {
    gender = @"2";
  }

  if (data[@"gender"] == [NSNull null] || [data[@"gender"] intValue]!=[gender intValue])
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
  if (introTextView.text.length!=0 || ![data[@"intro"] isEqual:introTextView.text])
  {
    [pBasicInfoDict setObject:introTextView.text forKey:@"intro"];
  }
  
  if ([pBasicInfoDict count] > 0)
  {

    HUD.labelText = @"修改中";
    HUD.detailsLabelText = nil;
    [HUD show:YES];

    self.netOperation = [[[NetManager sharedInstance] hellEngine]
                         uploadBasicInfoWithDict:pBasicInfoDict
                         completionHandler:^(NSMutableDictionary *resultDic) {
                           [self changeBasicInfoCallBack:resultDic];}
                         errorHandler:^(NSError *error){
                           HUD.labelText = @"提交超时，请检查网络";
                           HUD.detailsLabelText = nil;
                           [HUD show:YES];
                           [HUD hide:YES afterDelay:2];
                         }];
  }
  else
  {
    waitCallBack--;
    [mLoadingActivity stopAnimating];
    if (waitCallBack == 0) {
      HUD.labelText = @"个人信息无改变，不需保存";
      HUD.detailsLabelText = nil;
      [HUD show:YES];
      [HUD hide:YES afterDelay:2];
    }
  }
}

- (void)changeBasicInfoCallBack:(NSMutableDictionary*) resultDic
{
  waitCallBack--;
  if (waitCallBack <= 0)
    [mLoadingActivity stopAnimating];
  
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success)
  {
    isChanged = TRUE;
    User* user = [User sharedInstance];
    user.account.username = nameField.text;
    
    HUD.labelText = @"个人基本信息上传成功";
    HUD.detailsLabelText = nil;
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];

    // notify
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
    else
    {
      gender = @"2";
    }

    NSDictionary * dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
        nameField.text, @"nickname",
        introTextView.text, @"intro",
        ageField.text, @"age",
        gender, @"gender",
        careerField.text, @"career",
        provinceField.text, @"province",
        cityField.text, @"city", nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnUserInfoChange" object:dictionary];
  }
  else
  {
    NSInteger error_code = [[resultDic valueForKey:@"errorcode"] intValue];
    if (error_code == GC_NickNameExist)
    {
      HUD.labelText = @"用户名已存在";
      HUD.detailsLabelText = nil;
      [HUD show:YES];
      [HUD hide:YES afterDelay:2];
    }
    else if (error_code == GC_NickNameInvalid)
    {
      HUD.labelText = nil;
      HUD.detailsLabelText = @"用户名必须大于两个字并且只能包含数字、字母、汉字和下划线";
      [HUD show:YES];
      [HUD hide:YES afterDelay:2];
    }
  }
}

- (void)uploadAvatar
{
  waitCallBack++;
  NSString  *pngPath;
  
  UIImage* uploadImage = headImageView.avataImageView.image;
  if (uploadImage != headImageView.defaultImage)
  {
    pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/uploadtmp.png"];
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
    user.account.avatar = [resultDic valueForKey:@"avatar"];

    HUD.labelText = @"头像上传成功";
    HUD.detailsLabelText = nil;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];

    // notify
    UIImage* uploadImage = headImageView.avataImageView.image;
    NSDictionary * dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:uploadImage, @"avatar", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnUserInfoChange" object:dictionary];
  }
  else
  {
    HUD.labelText = @"头像上传失败";
    HUD.detailsLabelText = nil;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
  }
}

@end
