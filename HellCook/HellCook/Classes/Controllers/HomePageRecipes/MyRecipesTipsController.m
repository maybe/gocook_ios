//
//  MyRecipesEditController.m
//  HellCook
//
//  Created by panda on 8/5/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MyRecipesTipsController.h"
#import "KeyboardHandler.h"
#import "UIView+FindFirstResponder.h"
#import "NetManager.h"
#import "User.h"
#import "DBHandler.h"
#import "DefaultGroupedTableCell.h"

#define kTableCellHeader  48
#define kTableCellBody    45
#define kTableCellFooter  160
#define kTableCellSingle  200

@interface MyRecipesTipsController ()

@end

@implementation MyRecipesTipsController
@synthesize tableView, tipsTextView;

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
  
  tipsTextView = [[SSTextView alloc]init];
  
  CGRect frame = self.tableView.tableHeaderView.frame;
  frame.size.height = 44;
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
  
  //keyboard
  keyboard = [[KeyboardHandler alloc] init];
  
  CGRect viewframe = self.view.frame;
  viewframe.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewframe];
  [self.tableView setFrame:viewframe];
  
  RecipeData* pRecipeData = [[[User sharedInstance] recipe] getCreateRecipeData];
  if (pRecipeData.tips) {
    [tipsTextView setText:pRecipeData.tips];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellSingle;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  DefaultGroupedTableCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"TipsCell"];
  
  if (cell == nil) {
    cell = [[DefaultGroupedTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"TipsCell"];

    tipsTextView.delegate = self;
    [tipsTextView setFrame:CGRectMake(20, 5, 280, 185)];
    [tipsTextView setBackgroundColor: [UIColor clearColor]];
    [tipsTextView setPlaceholder: @"小贴士"];
    tipsTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tipsTextView.keyboardType = UIKeyboardTypeDefault;
    tipsTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [tipsTextView setFont:[UIFont systemFontOfSize:14]];
    tipsTextView.returnKeyType = UIReturnKeyDone;
    [tipsTextView setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
    
    cell.tableCellBodyHeight = kTableCellBody;
    cell.tableCellHeaderHeight = kTableCellHeader;
    cell.tableCellFooterHeight = kTableCellFooter;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setCellStyle:1 Index:indexPath.row];
    
    [cell addSubview:tipsTextView];
  }
  
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - Textreturn
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

#pragma mark - Keyboard

- (void)keyboardSizeChanged:(CGSize)delta
{
  UIView* frView = [self.tableView findFirstResponder];
  if ([frView isKindOfClass:[UITextField class]] || [frView isKindOfClass:[SSTextView class]]) {
    if (delta.height > 0) {
      CGPoint realOrigin = [frView convertPoint:frView.frame.origin toView:nil];
      if (realOrigin.y + frView.frame.size.height  > _screenHeight - delta.height) {
        CGFloat deltaHeight = realOrigin.y + frView.frame.size.height - ( _screenHeight - delta.height) -30;
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
  NSString *trimedDesc = @"";
  if (tipsTextView.text) {
    trimedDesc = [tipsTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  }
  
  RecipeData* pRecipeData = [[[User sharedInstance] recipe] getCreateRecipeData];
  pRecipeData.tips = [[NSString alloc]initWithString: trimedDesc];
  
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNext
{

  NSString *trimedDesc = @"";
  if (tipsTextView.text) {
    trimedDesc = [tipsTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  }
  
  RecipeData* pRecipeData = [[[User sharedInstance] recipe] getCreateRecipeData];
  pRecipeData.tips = [[NSString alloc]initWithString: trimedDesc];
//  
//  MyRecipesMaterialController* pController = [[MyRecipesMaterialController alloc] initWithNibName:@"MyRecipesMatieralView" bundle:nil];
//  [self.navigationController pushViewController:pController animated:YES];
}

@end
