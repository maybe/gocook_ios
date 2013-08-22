//
//  RecipeCommentViewController.m
//  HellCook
//
//  Created by lxw on 13-8-17.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "RecipeCommentViewController.h"
#import "RecipeCommentsTableViewCell.h"
#import "MyIntroductionViewController.h"
#import "RecipeSendCommentView.h"
#import "NetManager.h"
#import "KeyboardHandler.h"
#import "UIView+FindFirstResponder.h"
#import "MBProgressHUD.h"

@interface RecipeCommentViewController ()

@end

@implementation RecipeCommentViewController
@synthesize myTableView, cellForHeight, sendView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRecipeID:(NSInteger)recipeID withData:(NSMutableArray*)data
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    mRecipeID = recipeID;
    dataArray = [NSMutableArray arrayWithArray:data];
    cellForHeight = [[RecipeCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoUseJustForCaculateHeight"];
    sendView = [[RecipeSendCommentView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    keyboard = [[KeyboardHandler alloc] init];
  }
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.navigationItem.title = @"留言";
  [self setLeftButton];
  
  HUD = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:HUD];
  HUD.mode = MBProgressHUDModeText;
  HUD.delegate = self;
  
  CGRect viewframe = self.view.frame;
  viewframe.size.height = _screenHeight_NoStBar;
  [self.view setFrame:viewframe];
  
  CGRect tableframe = self.myTableView.frame;
  tableframe.size.height = _screenHeight_NoStBar_NoNavBar + _stateBarHeight +4 -40;
  [self.myTableView setFrame:tableframe];
  
  [self.view addSubview:sendView];
  sendView.contentTextView.delegate = self;
  CGRect sendViewFrame = sendView.frame;
  sendViewFrame.origin.y = _screenHeight_NoStBar_NoNavBar - 40;
  [sendView setFrame:sendViewFrame];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotate {
  
  return NO;
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

-(void)returnToPrev
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoOtherIntro:(UIButton*)btn
{
  NSInteger userid = [[btn associativeObjectForKey:@"userid"] integerValue];
  
  MyIntroductionViewController *pController = [[MyIntroductionViewController alloc] initWithNibName:@"MyIntroductionView" bundle:nil withUserID:userid from:ViewControllerCalledFromRecipeComment];
  [self.navigationController pushViewController:pController animated:YES];
}

- (void)tapSend
{
  if ([sendView.contentTextView.text length] > 0)
  {
    NSMutableDictionary *pCommentDict = [[NSMutableDictionary alloc] init];
    [pCommentDict setObject:[NSString stringWithFormat:@"%d",mRecipeID] forKey:@"recipe_id"];
    [pCommentDict setObject:sendView.contentTextView.text forKey:@"content"];
    
    self.netOperation = [[[NetManager sharedInstance] hellEngine]
                         commentWithDict:pCommentDict
                         completionHandler:^(NSMutableDictionary *resultDic) {
                           [self commentCallBack:resultDic];}
                         errorHandler:^(NSError *error){}];
  }
  else
  {
    HUD.labelText = @"评论内容不能为空！";
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
  }
}

- (void)commentCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    HUD.labelText = @"评论成功";
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSMutableDictionary *dataDict = [dataArray objectAtIndex:indexPath.row];
  if ([dataDict[@"content"] isEqual:@""] || dataDict[@"content"]==[NSNull null])
  {
    return 90;
  }
  else
  {
    NSString *strComment;
    if ([dataDict[@"name"] isEqual:@""] || dataDict[@"name"]==[NSNull null])
    {
      strComment = [NSString stringWithFormat:@"%@",dataDict[@"content"]];
    }
    else
    {
      strComment = [NSString stringWithFormat:@"%@: %@",dataDict[@"name"],dataDict[@"content"]];
    }
    
    [cellForHeight caculateCellHeight:strComment];
    return [cellForHeight getCellHeight];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"CommentsTableViewCell";
  
  RecipeCommentsTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
  {
    cell = [[RecipeCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  [cell setData:[dataArray objectAtIndex:indexPath.row]];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

#pragma mark - TextView delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  if ([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  return YES;
}



#pragma mark - Keyboard

- (void)keyboardSizeChanged:(CGSize)delta
{
    if (delta.height > 0)
    {
      CGRect sendViewFrame = sendView.frame;
      sendViewFrame.origin.y = _screenHeight_NoStBar_NoNavBar - delta.height - 40;
      [sendView setFrame:sendViewFrame];
      
    }
    else
    {
      CGRect sendViewFrame = sendView.frame;
      sendViewFrame.origin.y = _screenHeight_NoStBar_NoNavBar - sendViewFrame.size.height;
      [sendView setFrame:sendViewFrame];
    }
}

@end
