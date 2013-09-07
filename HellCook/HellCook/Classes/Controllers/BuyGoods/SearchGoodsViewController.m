//
//  SearchGoodsViewController.m
//  HellCook
//
//  Created by lxw on 13-9-4.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "SearchGoodsViewController.h"
#import "NetManager.h"
#import "ODRefreshControl.h"
#import "SearchGoodsTableViewCell.h"

@interface SearchGoodsViewController ()

@end

@implementation SearchGoodsViewController
@synthesize myTableView,mLoadingActivity,netOperation,mWaitingActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withKeyword:(NSString*)keyword
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  // Custom initialization
    myKeywords = [NSString stringWithString:keyword];
    curPage = 1;
    goodsListArray = [[NSMutableArray alloc] init];
    bShouldRefresh = TRUE;
    [self initLoadingView];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.navigationItem.title = @"搜索商品";
  
/*  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];
  [self.myTableView setFrame:viewFrame];*/
  
  [self setLeftButton];
  refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
  [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
  refreshControl.tintColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
  
  [self getGoodsInfo];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
  [goodsListArray removeAllObjects];
  curPage = 0;
  bShouldRefresh = YES;
  [self.myTableView reloadData];
  [self getGoodsInfo];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initLoadingView
{
  CGRect frame = self.myTableView.tableFooterView.frame;
  frame.size.height = 50;
  self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
  //CGFloat tablewidth = self.tableView.frame.size.width;
  mLoadingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  [mLoadingActivity setCenter:CGPointMake(160, 25)];
  [mLoadingActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  [self.myTableView.tableFooterView addSubview:mLoadingActivity];
  [mLoadingActivity stopAnimating];
}

- (void)showLoadingView
{
  CGRect frame = self.myTableView.tableFooterView.frame;
  frame.size.height = 50;
  [self.myTableView.tableFooterView setFrame:frame];
  [mLoadingActivity startAnimating];
}

- (void)deleteLoadingView
{
  CGRect frame = self.myTableView.tableFooterView.frame;
  frame.size.height = 3;
  [mLoadingActivity stopAnimating];
  [mLoadingActivity setHidden:YES];
  self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return goodsListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 97;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"SearchGoodsTableViewCell";
  
  SearchGoodsTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
  {
    cell = [[SearchGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  [cell setData:goodsListArray[indexPath.row]];
  
    
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  // 下拉到最底部时显示更多数据
  if(scrollView.contentOffset.y + 40 >= ((scrollView.contentSize.height - scrollView.frame.size.height)))
  {
    if (![self.netOperation isExecuting] && bShouldRefresh) {
      [self showLoadingView];
      [self getGoodsInfo];
    }
  }
}










-(void)getGoodsInfo
{
  [mWaitingActivity startAnimating];
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getGoodsWithKeyword:myKeywords
                       withPage:curPage
                       completionHandler:^(NSMutableDictionary *resultDic){
                         [self getGoodsInfoCallBack:resultDic];}
                       errorHandler:^(NSError *error){}];
}

-(void)getGoodsInfoCallBack:(NSMutableDictionary*) resultDic
{
  [mWaitingActivity stopAnimating];
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
/*    goodsListArray = [NSMutableArray arrayWithArray:resultDic[@"wares"]];
    for (int i=0; i<[goodsListArray count]; i++) {
      NSMutableDictionary *tmpDict = [goodsListArray objectAtIndex:i];
    }*/
    
    
    
    int totalCount = [resultDic[@"total_count"] intValue];
    totalPage = totalCount/10 + (totalCount % 10 > 0 ? 1 : 0);
    int originsize = goodsListArray.count;
    int addsize = [(NSArray*)resultDic[@"wares"] count];
    if (addsize > 0)
    {
      curPage++;
      [goodsListArray addObjectsFromArray:resultDic[@"wares"]];
      
      if (originsize == 0)
      {
        [self.myTableView reloadData];
        if ([refreshControl isRefreshing]){
          [refreshControl endRefreshing];
        }
      }
      else
      {
        NSMutableArray* indexpathArray = [[NSMutableArray alloc]init];
        for (int i = 0; i<addsize; i++)
        {
          NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+originsize inSection:0];
          [indexpathArray addObject:indexPath];
        }
        
        [self.myTableView beginUpdates];
        [self.myTableView insertRowsAtIndexPaths:indexpathArray withRowAnimation:UITableViewRowAnimationNone];
        [self.myTableView endUpdates];
      }
    }
    
    if (curPage >= totalPage)
      bShouldRefresh = FALSE;
    if (!bShouldRefresh)
      [self deleteLoadingView];
  }
}





@end
