//
//  MyFollowViewController.m
//  HellCook
//
//  Created by lxw on 13-8-3.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyFollowViewController.h"
#import "NetManager.h"
#import "LoginController.h"

@interface MyFollowViewController ()

@end

@implementation MyFollowViewController
@synthesize netOperation;
@synthesize mLoadingActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      curPage = 0;
      myFollowsArray = [[NSMutableArray alloc] init];
      [self initLoadingView];
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  
  [self getMyFollowData];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
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

#pragma mark - Net

-(void)getMyFollowData
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getMyFollowDataByPage:(curPage+1)
                       CompletionHandler:^(NSMutableDictionary *resultDic) {
                         [self getMyFollowDataCallBack:resultDic];}
                       errorHandler:^(NSError *error) {}
                       ];
}

- (void)getMyFollowDataCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    int totalCount = [resultDic[@"total"] intValue];
    totalPage = totalCount/10 + (totalCount % 10 > 0 ? 1 : 0);
    int originsize = myFollowsArray.count;
    int addsize = [(NSArray*)resultDic[@"result_users"] count];
    if (addsize > 0)
    {
      curPage++;
      [myFollowsArray addObjectsFromArray:resultDic[@"result_users"]];
      
      if (originsize == 0)
      {
        [self.myTableView reloadData];
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
      mShouldRefresh = FALSE;
    if (!mShouldRefresh)
      [self deleteLoadingView];
  }
  else if (result == 1)
  {
    LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
    if (self.navigationController)
    {
      [self.navigationController presentViewController:m animated:YES completion:nil];
    }
  }
}


@end
