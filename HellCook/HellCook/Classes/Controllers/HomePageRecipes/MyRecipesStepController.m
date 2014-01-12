//
//  MyRecipesEditController.m
//  HellCook
//
//  Created by panda on 8/5/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MyRecipesStepController.h"
#import "KeyboardHandler.h"
#import "UIView+FindFirstResponder.h"
#import "User.h"
#import "UIImage+Resize.h"
#import "UIImage+Resizing.h"
#import "NetManager.h"
#import "MyRecipesTipsController.h"

@interface MyRecipesStepController ()

@end

@implementation MyRecipesStepController
@synthesize tableView, uploadOperation, recipeData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    isImagePickerDismiss = NO;
  }
  return self;
}

- (void)viewDidLoad
{
  [self setLeftButton];
  [self setRightButton];

  self.title = @"步骤";
  
//  CGRect frameHeader = self.tableView.tableHeaderView.frame;
//  frameHeader.size.height = 44;
//  self.tableView.tableHeaderView = [[MyRecipeMaterialTableViewHeader alloc]initWithFrame:frameHeader];
  
  CGRect frameFooter = self.tableView.tableFooterView.frame;
  frameFooter.size.height = 44;
  self.tableView.tableFooterView = [[MyRecipeStepTableViewFooter alloc]initWithFrame:frameFooter];
  
  //keyboard
  keyboard = [[KeyboardHandler alloc] init];
  
  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];
  [self.tableView setFrame:viewFrame];
  
  cellContentList = [[NSMutableArray alloc]init];

  if ([[[User sharedInstance] recipe] getIsCreate]) {
    recipeData = [[[User sharedInstance] recipe] getCreateRecipeData];
  } else {
    recipeData = [[[User sharedInstance] recipe] getModifyRecipeData];
  }

  HUD = [[MBProgressHUD alloc] initWithView: self.navigationController.view];
  [self.navigationController.view addSubview:HUD];
  HUD.mode = MBProgressHUDModeText;
  HUD.delegate = self;

  [self autoLayout];
  [super viewDidLoad];
}

- (void)dealloc
{
  [HUD removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
  keyboard.delegate = self;

  if (!isImagePickerDismiss) {
    [cellContentList removeAllObjects];
    [cellContentList addObjectsFromArray: recipeData.recipe_steps];
    [tableView reloadData];

    if (recipeData.recipe_steps.count == 0) {
      [self addStepLine];
    }

  } else {
    isImagePickerDismiss = NO;
  }


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
  return 126;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  NSString* Identifier = @"StepCell";
  
  MyRecipeStepTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:Identifier];
  
  if (cell == nil) {
    cell = [[MyRecipeStepTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: Identifier];
  }
  
  [cell setDelegate: self];
  cell.indexInTable = indexPath.row;
  [cell setData: [cellContentList objectAtIndex: (NSUInteger)indexPath.row]];
  
  return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignMyRecipeStepTextView" object:nil];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Add line
- (void)addStepLine
{

  [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignMyRecipeStepTextView" object:nil];

  NSMutableDictionary* pStepLineDic = [[NSMutableDictionary alloc]init];
  [pStepLineDic setObject:@"" forKey:@"step"];
  [cellContentList addObject: pStepLineDic];
  
  NSMutableArray*indexPathArray = [[NSMutableArray alloc]init];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellContentList.count-1 inSection:0];
  [indexPathArray addObject:indexPath];
  
  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
  [self.tableView endUpdates];
}

#pragma mark - Image Picker + select button

-(void) onSelectButtonClick:(id)sender
{
  imagePickerButton = sender;

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
  UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
  selectStepImage = image;
  isImagePickerDismiss = YES;
  [self dismissViewControllerAnimated:YES completion:nil];

  [self uploadStepTmpFile];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  isImagePickerDismiss = YES;
  selectStepImage = nil;
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadStepTmpFile
{
  NSString  *pngPath = @"";
  
  MyRecipeStepTableViewCell* cell = (MyRecipeStepTableViewCell*)[self relatedCell:imagePickerButton];
  NSIndexPath *indexPath = [tableView indexPathForCell: cell];
  
  UIImage* uploadImage = selectStepImage;

  if (uploadImage != cell.defaultImage) {
    pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/uploaStepTmp.png"];
    uploadImage = [uploadImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(600, 600) interpolationQuality:kCGInterpolationHigh];
    uploadImage = [uploadImage cropToSize:CGSizeMake(600, 600) usingMode:NYXCropModeTopCenter];
    // Write image to PNG
    [UIImagePNGRepresentation(uploadImage) writeToFile:pngPath atomically:YES];
  }

  HUD.labelText = @"上传中...";
  [HUD show:YES];

  self.uploadOperation = [[[NetManager sharedInstance] hellEngine]
                            uploadStepTmpImage:pngPath
                            withIndex: indexPath.row
                            completionHandler:^(NSMutableDictionary *resultDic, NSInteger index) {
                              [self UploadCallBack:resultDic withIndex:index];}
                            errorHandler:^(NSError *error) {}
                            ];
}

-(void)UploadCallBack:(NSMutableDictionary*)resultDic withIndex:(NSInteger)index
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    cellContentList[(NSUInteger)index][@"imageUrl"] = resultDic[@"avatar"];
    cellContentList[(NSUInteger)index][@"tmpImageUrl"] = [NSString stringWithFormat: @"http://%@/images/tmp/%@", [[NetManager sharedInstance] host], resultDic[@"avatar"]];
    cellContentList[(NSUInteger)index][@"imageState"] = [NSString stringWithFormat:@"%d", RecipeImage_UPLOADED];
    cellContentList[(NSUInteger)index][@"pickRealImage"] = selectStepImage;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    MyRecipeStepTableViewCell* cell = (MyRecipeStepTableViewCell*)[tableView cellForRowAtIndexPath: indexPath];
    [cell setData:cellContentList[(NSUInteger)indexPath.row]];

    HUD.labelText = @"上传成功";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
  } else if (result == 1){
    HUD.labelText = @"上传失败";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
  }
}

#pragma mark - Delete One Step
-(void) onDeleteOneStep:(id)sender
{
  [self.view endEditing:YES];

  UITableViewCell* cell = [self relatedCell:sender];
  NSIndexPath *indexPath = [tableView indexPathForCell: cell];
  NSUInteger index = (NSUInteger)indexPath.row;
  [cellContentList removeObjectAtIndex:index];
  [tableView reloadData];
//  NSMutableArray* indexPathArray = [[NSMutableArray alloc]init];
//  [indexPathArray addObject:indexPath];
//  [self.tableView beginUpdates];
//  [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
//  [self.tableView endUpdates];
}

#pragma mark - Keyboard

- (void)keyboardSizeChanged:(CGSize)delta
{
  UIView* frView = [self.tableView findFirstResponder];
  if ([frView isKindOfClass:[UITextView class]]) {
    if (delta.height > 0) {
      CGPoint realOrigin = [frView convertPoint:frView.frame.origin toView:nil];
      if (realOrigin.y + frView.frame.size.height  > _screenHeight - delta.height) {
        CGFloat deltaHeight = realOrigin.y + frView.frame.size.height - ( _screenHeight - delta.height) + 10;
        CGRect frame = self.tableView.frame;
        frame.origin.y -= deltaHeight;
        if (-frame.origin.y > delta.height) {
          frame.origin.y = - delta.height;
        }
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


#pragma mark - Navi Butons

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
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignMyRecipeStepTextView" object:nil];
  BOOL result = [self setDataToRecipe];
  if (result) {
    [self.navigationController popViewControllerAnimated:YES];
  } else {
    HUD.labelText = @"请为图片输入步骤文字";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
  }
}

-(void)onNext
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignMyRecipeStepTextView" object:nil];

  BOOL result = [self setDataToRecipe];
  if (!result) {
    HUD.labelText = @"请为图片输入步骤文字";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
    return;
  }

  if (recipeData.recipe_steps.count > 0) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnPushTipsController" object:nil];
  } else {
    HUD.labelText = @"步骤不能为空";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
  }
}

#pragma mark - Set Data to Recipe
-(BOOL)setDataToRecipe
{

  [recipeData.recipe_steps removeAllObjects];
  
  for (int i = 0; i < cellContentList.count; i++) {
    NSString* stepStr = [cellContentList[(NSUInteger)i][@"step"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString* imageUrl = cellContentList[(NSUInteger)i][@"imageUrl"];
    NSString* tmpImageUrl = cellContentList[(NSUInteger)i][@"tmpImageUrl"];

    if (![stepStr isEqualToString:@""]) {
      
      NSMutableDictionary* pDic = [[NSMutableDictionary alloc]init];
      
      pDic[@"step"] = [[NSString alloc]initWithString:stepStr];
      
      if (imageUrl && ![imageUrl isEqualToString:@""]) {
        pDic[@"imageUrl"] = [[NSString alloc]initWithString:imageUrl];
        pDic[@"imageState"] = [NSString stringWithFormat:@"%d", RecipeImage_UPLOADED];
        if (tmpImageUrl && ![tmpImageUrl isEqualToString:@""]) {
          pDic[@"tmpImageUrl"] = [[NSString alloc]initWithString:tmpImageUrl];
        }
      } else {
        pDic[@"imageState"] = [NSString stringWithFormat:@"%d", RecipeImage_UNSELECTED];
      }

      
      [recipeData.recipe_steps addObject:pDic];
    } else {
      if (imageUrl && ![imageUrl isEqualToString:@""]) {
        return NO;
      }
    }
  }
  return YES;
}

- (void)changeInputData:(NSString *)data WithIndex:(NSInteger)index
{
  cellContentList[(NSUInteger)index][@"step"] = [[NSString alloc]initWithString:data];
}

- (UITableViewCell *)relatedCell:(UIView *)view
{
  if ([view.superview isKindOfClass:[UITableViewCell class]])
    return (UITableViewCell *)view.superview;
  else if ([view.superview.superview isKindOfClass:[UITableViewCell class]])
    return (UITableViewCell *)view.superview.superview;
  else
  {
    NSAssert(NO, @"UITableViewCell shall always be found.");
    return nil;
  }
}

@end
