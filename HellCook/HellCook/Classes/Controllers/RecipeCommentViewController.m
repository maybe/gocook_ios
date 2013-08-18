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

@interface RecipeCommentViewController ()

@end

@implementation RecipeCommentViewController
@synthesize myTableView, cellForHeight;
@synthesize navgationItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableArray*)data
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    dataArray = [NSMutableArray arrayWithArray:data];
    cellForHeight = [[RecipeCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoUseJustForCaculateHeight"];
  }
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  [self setLeftButton];
  
  CGRect viewframe = self.view.frame;
  viewframe.size.height = _screenHeight_NoStBar;
  [self.view setFrame:viewframe];
  
  CGRect tableframe = self.myTableView.frame;
  tableframe.size.height = _screenHeight_NoStBar_NoNavBar-100;
  [self.myTableView setFrame:tableframe];
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

-(void)returnToPrev
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoOtherIntro:(UIButton*)btn
{
  NSInteger userid = [[btn associativeObjectForKey:@"userid"] integerValue];
  
/*  MyIntroductionViewController *pController = [[MyIntroductionViewController alloc] initWithNibName:@"MyIntroductionView" bundle:nil isMyself:NO withUserID:userid fromMyFollow:NO];
  [self.navigationController pushViewController:pController animated:YES];*/
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

@end
