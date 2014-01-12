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
#import "GoodsDetailViewController.h"

@interface SearchGoodsViewController ()

@end

@implementation SearchGoodsViewController
@synthesize myTableView,mLoadingActivity,netOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withKeyword:(NSString*)keyword
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  // Custom initialization
    myKeywords = [NSString stringWithString:keyword];
    curPage = 0;
    goodsListArray = [[NSMutableArray alloc] init];
    bShouldRefresh = TRUE;
  }
  return self;
}

- (void)viewDidLoad
{
  self.navigationItem.title = @"搜索商品";
  
  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  viewFrame.size.width = _sideWindowWidth;
  [self.view setFrame:viewFrame];
  self.view.autoresizesSubviews = NO;
  [self.myTableView setFrame:viewFrame];
  
  [self setLeftButton];
  refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
  [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
  refreshControl.tintColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];

  [self initLoadingView];

  [self getGoodsInfo];

  emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2 - 20, _sideWindowWidth, 44)];
  emptyLabel.text = @"对不起，我们未提供您需要的商品，\n请选择其他商品";
  emptyLabel.numberOfLines = 0;
  [emptyLabel setBackgroundColor:[UIColor clearColor]];
  emptyLabel.textAlignment = NSTextAlignmentCenter;
  emptyLabel.font = [UIFont systemFontOfSize:15];
  [emptyLabel setTextColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
  emptyLabel.hidden = YES;
  [self.view addSubview:emptyLabel];

  [self autoLayout];
  [super viewDidLoad];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
  [goodsListArray removeAllObjects];
  curPage = 0;
  bShouldRefresh = YES;
  emptyLabel.hidden = YES;
  [self.myTableView reloadData];
  [self initLoadingView];
  [self getGoodsInfo];
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
  mLoadingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  [mLoadingActivity setCenter:CGPointMake(140, 25)];
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
  [mLoadingActivity setHidden:NO];
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
  GoodsDetailViewController *pController = [[GoodsDetailViewController alloc] initWithNibName:@"GoodsDetailView" bundle:nil withData:[goodsListArray objectAtIndex:indexPath.row]];
  [self.navigationController pushViewController:pController animated:YES];
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
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getGoodsWithKeyword:myKeywords
                       withPage:curPage + 1
                       completionHandler:^(NSMutableDictionary *resultDic){
                         [self getGoodsInfoCallBack:resultDic];}
                       errorHandler:^(NSError *error){
                       }];
}

-(void)getGoodsInfoCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    int totalCount = [resultDic[@"total_count"] intValue];

    if (totalCount == 0) {
      emptyLabel.hidden = NO;
      return;
    }

    emptyLabel.hidden = YES;

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
