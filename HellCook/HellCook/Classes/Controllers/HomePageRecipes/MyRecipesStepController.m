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
@synthesize tableView, uploadOperation;

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
  
//  CGRect frameHeader = self.tableView.tableHeaderView.frame;
//  frameHeader.size.height = 44;
//  self.tableView.tableHeaderView = [[MyRecipeMaterialTableViewHeader alloc]initWithFrame:frameHeader];
  
  CGRect frameFooter = self.tableView.tableFooterView.frame;
  frameFooter.size.height = 44;
  self.tableView.tableFooterView = [[MyRecipeStepTableViewFooter alloc]initWithFrame:frameFooter];
  
  //keyboard
  keyboard = [[KeyboardHandler alloc] init];
  
  CGRect viewframe = self.view.frame;
  viewframe.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewframe];
  [self.tableView setFrame:viewframe];
  
  cellContentList = [[NSMutableArray alloc]init];

  RecipeData* pRecipeData = nil;
  if ([[[User sharedInstance] recipe] getIsCreate]) {
    pRecipeData = [[[User sharedInstance] recipe] getCreateRecipeData];
  } else {
    pRecipeData = [[[User sharedInstance] recipe] getModifyRecipeData];
  }

  [cellContentList addObjectsFromArray: pRecipeData.recipe_steps];
  
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
  
  NSMutableArray* indexpathArray = [[NSMutableArray alloc]init];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellContentList.count-1 inSection:0];
  [indexpathArray addObject:indexPath];
  
  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:indexpathArray withRowAnimation:UITableViewRowAnimationNone];
  [self.tableView endUpdates];
}

#pragma mark - Image Picker + select button

-(void) onSelectButtonClick:(id)sender
{
  imagePickerButton = sender;
  if ([[imagePickerButton titleForState:UIControlStateNormal] isEqualToString:@"+图片"]) {
    [self loadImagePicker];
  } else if([[imagePickerButton titleForState:UIControlStateNormal] isEqualToString:@"上传"]) {
    [self uploadStepTmpFile];
  }
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
  
  MyRecipeStepTableViewCell* cell = (MyRecipeStepTableViewCell*)imagePickerButton.superview;
  //[cell.upImageView setImage:image];
  
  NSIndexPath *indexPath = [tableView indexPathForCell: cell];
  cellContentList[(NSUInteger)indexPath.row][@"pickRealImage"] = image;
  cellContentList[(NSUInteger)indexPath.row][@"pickImage"] = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
  cellContentList[(NSUInteger)indexPath.row][@"imageState"] = [NSString stringWithFormat:@"%d", RecipeImage_SELECTED];

  [cell setData:cellContentList[(NSUInteger)indexPath.row]];
}

-(void)uploadStepTmpFile
{
  NSString  *pngPath = @"";
  
  MyRecipeStepTableViewCell* cell = (MyRecipeStepTableViewCell*)imagePickerButton.superview;
  NSIndexPath *indexPath = [tableView indexPathForCell: cell];
  
  UIImage* uploadImage = cell.upImageView.image;
  
  if (uploadImage!=cell.defaultImage) {
    pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/uploaStepTmp.png"];
    uploadImage = [uploadImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(600, 600) interpolationQuality:kCGInterpolationHigh];
    uploadImage = [uploadImage cropToSize:CGSizeMake(600, 600) usingMode:NYXCropModeTopCenter];
    // Write image to PNG
    [UIImagePNGRepresentation(uploadImage) writeToFile:pngPath atomically:YES];
  }
  
  
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    MyRecipeStepTableViewCell* cell = (MyRecipeStepTableViewCell*)[tableView cellForRowAtIndexPath: indexPath];
    [cell setData:cellContentList[(NSUInteger)indexPath.row]];
  }
  else if (result == 1){
    //TODO:
  }
  
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
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundHighlighted.png"]
                               forState:UIControlStateHighlighted];
  [leftBarButtonView setTitle:@"上一步" forState:UIControlStateNormal];
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
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignMyRecipeStepTextView" object:nil];
  
  [self setDataToRecipe];
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNext
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignMyRecipeStepTextView" object:nil];
  
  [self setDataToRecipe];
  
  MyRecipesTipsController* pController = [[MyRecipesTipsController alloc]initWithNibName:@"MyRecipesTipsView" bundle:nil];
  [self.navigationController pushViewController:pController animated:YES];
}

#pragma mark - Set Data to Recipe
-(void)setDataToRecipe
{  
  RecipeData* pRecipeData = nil;
  if ([[[User sharedInstance] recipe] getIsCreate]) {
    pRecipeData = [[[User sharedInstance] recipe] getCreateRecipeData];
  } else {
    pRecipeData = [[[User sharedInstance] recipe] getModifyRecipeData];
  }

  [pRecipeData.recipe_steps removeAllObjects];
  
  for (int i = 0; i < cellContentList.count; i++) {
    NSString* stepStr = [cellContentList[(NSUInteger)i][@"step"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString* imageUrl = cellContentList[(NSUInteger)i][@"imageUrl"];
    
    if (![stepStr isEqualToString:@""]) {
      
      NSMutableDictionary* pDic = [[NSMutableDictionary alloc]init];
      
      pDic[@"step"] = [[NSString alloc]initWithString:stepStr];
      
      if (imageUrl && ![imageUrl isEqualToString:@""]) {
        pDic[@"imageUrl"] = [[NSString alloc]initWithString:imageUrl];
        pDic[@"imageState"] = [NSString stringWithFormat:@"%d", RecipeImage_UPLOADED];
      } else {
        pDic[@"imageState"] = [NSString stringWithFormat:@"%d", RecipeImage_UNSELECTED];
      }

      
      [pRecipeData.recipe_steps addObject:pDic];
    }
  }
}

- (void)changeInputData:(NSString *)data WithIndex:(NSInteger)index
{
  cellContentList[(NSUInteger)index][@"step"] = [[NSString alloc]initWithString:data];
}


@end
