//
//  MyRecipesEditController.m
//  HellCook
//
//  Created by panda on 8/5/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MyRecipesEditController.h"
#import "MyRecipeEditAvatarView.h"
#import "KeyboardHandler.h"
#import "UIView+FindFirstResponder.h"
#import "NetManager.h"
#import "User.h"
#import "UIImage+Resize.h"
#import "UIImage+Resizing.h"
#import "UIImageView+WebCache.h"
#import "DefaultGroupedTableCell.h"
#import "RegexKitLite.h"

#define kTableCellHeader  52
#define kTableCellBody    52
#define kTableCellFooter  160
#define kTableCellSingle  52

@interface MyRecipesEditController ()

@end

@implementation MyRecipesEditController
@synthesize tableView, nameField, isCoverUploaded, introTextView, uploadOperation, tipsController, stepController, materialController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self autoLayout];

  self.title = @"封面";

  isCoverUploaded = NO;

  [self setLeftButton];
  [self setRightButton];
  
  nameField = [[UITextField alloc]init];
  introTextView = [[SSTextView alloc]init];
  
  cellContentList = [[NSMutableArray alloc]init];
  NSMutableDictionary *cellDic;
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys :
             @"cellName",@"Identifier", @"菜谱名称",@"placeHolder",
             nameField, @"textfield",@"text",@"type",nil];
  [cellContentList addObject:cellDic];
  
  cellDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys :
             @"cellIntro",@"Identifier", @"菜谱简介",@"placeHolder",
             introTextView, @"textview",@"text",@"type",nil];
  [cellContentList addObject:cellDic];
  
  CGRect frame = self.tableView.tableHeaderView.frame;
  frame.size.height = 184;
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
  CGFloat tableWidth = self.tableView.frame.size.width;
  headImageView = [[MyRecipeEditAvatarView alloc]initWithFrame:CGRectMake(tableWidth /2-75, 15, 150, 150)];
  [self.tableView.tableHeaderView addSubview:headImageView];
  
  //keyboard
  keyboard = [[KeyboardHandler alloc] init];
  
  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];
  [self.tableView setFrame:viewFrame];

  if (![[[User sharedInstance] recipe] getIsCreate]) {
    RecipeData* pRecipeData = [[[User sharedInstance] recipe] getModifyRecipeData];
    [self.nameField setText: pRecipeData.name];
    [self.introTextView setText:pRecipeData.description];
    isCoverUploaded = YES;

    [headImageView.upImageView setImageWithURL:[NSURL URLWithString:[Common getUrl:pRecipeData.cover_img withType:Recipe526ImageUrl]]
                              placeholderImage:[UIImage imageNamed:@"Images/defaultUpload.png"]];

    // [headImageView.selectButton setTitle:@"替换" forState:UIControlStateNormal];
  }

  materialController = [[MyRecipesMaterialController alloc] initWithNibName:@"MyRecipesMatieralView" bundle:nil];
  stepController = [[MyRecipesStepController alloc] initWithNibName:@"MyRecipesStepView" bundle:nil];
  tipsController = [[MyRecipesTipsController alloc]initWithNibName:@"MyRecipesTipsView" bundle:nil];

  HUD = [[MBProgressHUD alloc] initWithView: self.navigationController.view];
  [self.navigationController.view addSubview:HUD];
  HUD.mode = MBProgressHUDModeText;
  HUD.delegate = self;

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnPushStepController:) name:@"EVT_OnPushStepController" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnPushTipsController:) name:@"EVT_OnPushTipsController" object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [HUD removeFromSuperview];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
  return cellContentList.count;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
  
  NSMutableDictionary* dic = [cellContentList objectAtIndex:(NSUInteger)indexPath.row];
  UITextField* textField = [dic objectForKey:@"textfield"];
  SSTextView* textView = [dic objectForKey:@"textview"];
  
  DefaultGroupedTableCell *cell = [aTableView dequeueReusableCellWithIdentifier:[dic objectForKey:@"Identifier"]];
  
  if (cell == nil) {
    cell = [[DefaultGroupedTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: [dic objectForKey:@"Identifier"]];
    if (textField) {
      [cell addSubview:textField];
    }else {
      [cell addSubview:textView];
    }
  }
  
  if (textField) {
    [textField setDelegate:self];
    [textField setFrame:CGRectMake(30, 0, 260, kTableCellBody)];
    [textField setPlaceholder:[dic objectForKey:@"placeHolder"]];
    [textField setBackgroundColor: [UIColor clearColor]];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [textField setFont:[UIFont systemFontOfSize:14]];
    textField.returnKeyType = UIReturnKeyDone;
    [textField setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
  } else if (textView) {
    textView.delegate = self;
    [textView setFrame:CGRectMake(30, 5, 260, 120)];
    [textView setBackgroundColor: [UIColor clearColor]];
    [textView setPlaceholder: [dic objectForKey:@"placeHolder"]];
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    [textView setFont:[UIFont systemFontOfSize:14]];
    textView.returnKeyType = UIReturnKeyDone;
    [textView setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
  }
  
  cell.tableCellBodyHeight = kTableCellBody;
  cell.tableCellHeaderHeight = kTableCellHeader;
  cell.tableCellFooterHeight = kTableCellFooter;
  cell.accessoryType = UITableViewCellAccessoryNone;
  [cell setCellStyle:[cellContentList count] Index:indexPath.row];
  
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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


#pragma mark - Avatar View
- (void)setHeaderView
{
  
}

-(void)ResetUploadImageView
{
  headImageView.upImageView.image = headImageView.defaultImage;
}


-(void) onSelectButton:(id)sender
{
    [self selectCoverImage];
}

-(void) loadImagePicker
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  // Access the uncropped image from info dictionary
  UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

  // Dismiss the camera
  [self dismissViewControllerAnimated:YES completion:nil];
  
  [headImageView.upImageView setImage:image];
  [self uploadCover];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)selectCoverImage
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


-(void)uploadCover {
  NSString  *pngPath = nil;
  UIImage* uploadImage = headImageView.upImageView.image;

  if (uploadImage != headImageView.defaultImage) {
    pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/uploaCoverTmp.png"];
    uploadImage = [uploadImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(600, 600) interpolationQuality:kCGInterpolationHigh];
    uploadImage = [uploadImage cropToSize:CGSizeMake(600, 600) usingMode:NYXCropModeTopCenter];
    // Write image to PNG
    [UIImagePNGRepresentation(uploadImage) writeToFile:pngPath atomically:YES];

    HUD.labelText = @"上传封面中...";
    HUD.detailsLabelText = nil;
    [HUD show:YES];
    
    self.uploadOperation = [[[NetManager sharedInstance] hellEngine]
        uploadCoverTmpImage:pngPath
          completionHandler:^(NSMutableDictionary *resultDic) {
            [self UploadCallBack:resultDic];}
               errorHandler:^(NSError *error) {}
    ];
    isCoverUploaded = NO;
  }
}

-(void)UploadCallBack:(NSMutableDictionary*)resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success)
  {
    isCoverUploaded = YES;
    [headImageView setAssociativeObject:resultDic[@"avatar"] forKey:@"cover_img"];
    HUD.labelText = @"上传成功";
    HUD.detailsLabelText = nil;
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
  }
  else if (result == GC_AuthAccountInvalid){
    [HUD hide:YES];
  }
}

#pragma mark - Keyboard

- (void)keyboardSizeChanged:(CGSize)delta
{
  UIView* frView = [self.tableView findFirstResponder];
  if ([frView isKindOfClass:[UITextField class]] || [frView isKindOfClass:[SSTextView class]]) {
    if ([frView isKindOfClass:[SSTextView class]]) {
      frView = frView.superview;
    }
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
      frame.origin.y =  0;
      self.tableView.frame = frame;
    }
  }
}


#pragma mark - Navigation Buttons

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
  [rightBarButtonView addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/NextStepNormal.png"]
                                forState:UIControlStateNormal];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/NextStepHighLight.png"]
                                forState:UIControlStateHighlighted];

  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
  
  [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

-(void)returnToPrev
{
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNext
{
  NSString *trimedName = @"";
  if (nameField.text) {
    trimedName = [nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  }

  NSString *trimedDesc = @"";
  if (introTextView.text) {
    trimedDesc = [introTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  }
  
  if ([trimedName isEqualToString:@""]) {
    HUD.labelText = @"菜谱名不能为空";
    HUD.detailsLabelText = nil;
    [HUD show:YES];
    [HUD hide:YES afterDelay:2.0];
    return;
  }

  BOOL name_result = [trimedName isMatchedByRegex:@"^[0-9a-zA-Z_\\-\\x{4e00}-\\x{9fa5}\\x{ff01}-\\x{ff5e}\\x{2014}\\x{2013}]{2,30}$"];
  if (!name_result) {
    HUD.labelText = nil;
    HUD.detailsLabelText = @"菜谱名必须包含2个及以上英文字母或者汉字，不能有空格";
    [HUD show:YES];
    [HUD hide:YES afterDelay:2.0];
    return;
  }

  RecipeData* pRecipeData = nil;
  if ([[[User sharedInstance] recipe] getIsCreate]) {
    pRecipeData = [[[User sharedInstance] recipe] getCreateRecipeData];
  } else {
    pRecipeData = [[[User sharedInstance] recipe] getModifyRecipeData];
  }


  pRecipeData.name = [[NSString alloc]initWithString: trimedName];
  
  if (![trimedDesc isEqualToString:@""]) {
    pRecipeData.description = [[NSString alloc]initWithString: trimedDesc];
  }

  if (!isCoverUploaded) {
    HUD.labelText = @"必须先上传菜谱封面";
    HUD.detailsLabelText = nil;
    [HUD show:YES];
    [HUD hide:YES afterDelay:2.0];
    return;
  }

  if ([headImageView associativeObjectForKey:@"cover_img"]
      && ![[headImageView associativeObjectForKey:@"cover_img"] isEqual:@""]) {
    pRecipeData.cover_img = [headImageView associativeObjectForKey:@"cover_img"];
  }

  [self.view endEditing:YES];
  [self.navigationController pushViewController:materialController animated:YES];
}

- (void)OnPushStepController:(NSNotification *)notification {
  [self.navigationController pushViewController:stepController animated:YES];
}

- (void)OnPushTipsController:(NSNotification *)notification {
  [self.navigationController pushViewController:tipsController animated:YES];
}

@end
