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
#import "MyRecipesMaterialController.h"
#import "CommonDef.h"

#define kTableCellHeader  48
#define kTableCellBody    45
#define kTableCellFooter  160
#define kTableCellSingle  50

@interface MyRecipesEditController ()

@end

@implementation MyRecipesEditController
@synthesize tableView, nameField, introTextView, uploadOperation;

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
  headImageView = [[MyRecipeEditAvatarView alloc]initWithFrame:CGRectMake(tableWidth /2-75, 30, 150, 150)];
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

    [headImageView.upImageView setImageWithURL:[NSURL URLWithString:[Common getUrl:pRecipeData.cover_img withType:Recipe526ImageUrl]]
                              placeholderImage:[UIImage imageNamed:@"Images/avatar.jpg"]];

    [headImageView.selectButton setTitle:@"替换" forState:UIControlStateNormal];
  }
  
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
    [textField setFrame:CGRectMake(30, 15, 200, 34)];
    [textField setPlaceholder:[dic objectForKey:@"placeHolder"]];
    [textField setBackgroundColor: [UIColor clearColor]];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [textField setFont:[UIFont systemFontOfSize:14]];
    textField.returnKeyType = UIReturnKeyDone;
    [textField setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
  } else if (textView) {
    textView.delegate = self;
    [textView setFrame:CGRectMake(20, 5, 300, 120)];
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
    [self uploadCoverTmpFile];
}

- (void) onSelectImageButton
{
  [self loadImagePicker];
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
  
  [headImageView setAssociativeObject:image forKey:@"cover_image_obj"];
  
  //Find the image url.
  //self.pickedImagePath = [(NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL] absoluteString];
  
  // Dismiss the camera
  [self dismissViewControllerAnimated:YES completion:nil];
  
  [headImageView.upImageView setImage:image];
  [headImageView.selectButton setTitle:@"上传" forState:UIControlStateNormal];
}


-(void)uploadCoverTmpFile
{
  if (![[headImageView.selectButton titleForState:UIControlStateNormal] isEqual: @"上传"]) {
    return;
  }
  
  NSString  *pngPath = @"";
  UIImage* uploadImage = headImageView.upImageView.image;
  
  if (uploadImage != headImageView.defaultImage) {
    pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/uploaCoverTmp.png"];
    uploadImage = [uploadImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(600, 600) interpolationQuality:kCGInterpolationHigh];
    uploadImage = [uploadImage cropToSize:CGSizeMake(600, 600) usingMode:NYXCropModeTopCenter];
    // Write image to PNG
    [UIImagePNGRepresentation(uploadImage) writeToFile:pngPath atomically:YES];
    
    self.uploadOperation = [[[NetManager sharedInstance] hellEngine]
                            uploadCoverTmpImage:pngPath
                            completionHandler:^(NSMutableDictionary *resultDic) {
                              [self UploadCallBack:resultDic];}
                            errorHandler:^(NSError *error) {}
                            ];
  }
}

-(void)UploadCallBack:(NSMutableDictionary*)resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success)
  {
    [headImageView setAssociativeObject:resultDic[@"avatar"] forKey:@"cover_img"];
    [headImageView.selectButton setTitle:@"替换" forState:UIControlStateNormal];
  }
  else if (result == GC_AuthAccountInvalid){
    //TODO:
  }
  
}


#pragma mark - Keyboard

- (void)keyboardSizeChanged:(CGSize)delta
{
  UIView* frView = [self.tableView findFirstResponder];
  if ([frView isKindOfClass:[UITextField class]] || [frView isKindOfClass:[SSTextView class]]) {
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
  
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
  
}

- (void)setRightButton
{
  UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 30)];
  [rightBarButtonView addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"]
                                forState:UIControlStateNormal];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/redNavigationButtonBackgroundHighlighted.png"]
                                forState:UIControlStateHighlighted];
  [rightBarButtonView setTitle:@"下一步" forState:UIControlStateNormal];
  [rightBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
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
  
  if ([headImageView associativeObjectForKey:@"cover_img"]
      && ![[headImageView associativeObjectForKey:@"cover_img"] isEqual:@""]) {
    pRecipeData.cover_img = [headImageView associativeObjectForKey:@"cover_img"];
  }
  
  MyRecipesMaterialController* pController = [[MyRecipesMaterialController alloc] initWithNibName:@"MyRecipesMatieralView" bundle:nil];
  [self.navigationController pushViewController:pController animated:YES];
}

@end
