//
//  MyCollectionController.m
//  HellCook
//
//  Created by lxw on 13-7-28.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyCollectionController.h"
#import "NetManager.h"
#import "RecipeDetailController.h"
#import "MyCollectionTableViewCell.h"
#import "User.h"

@interface MyCollectionController ()

@end

@implementation MyCollectionController
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        curPage = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
  self.navigationItem.title = @"我的收藏";
  
  CGRect tableframe = self.tableView.frame;
  tableframe.size.height = _screenHeight_NoStBar_NoNavBar-44;
  [self.tableView setFrame:tableframe];
}

- (void) viewWillAppear:(BOOL)animated
{
  [self getMyCollectionData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (myCollectionArray.count == 0)
  {
    [self.tableView setHidden:YES];
  }
  else
  {
    [self.tableView setHidden:NO];
  }
  
  return myCollectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (myCollectionArray.count == 0)
  {
    return 0;
  }
  else
  {
    return 90;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"MyCollectionTableViewCell";
  
  MyCollectionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
  {
    cell = [[MyCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  [cell setData:myCollectionArray[indexPath.row]];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // [self.navigationController pushViewController:[[RegisterController alloc]initWithNibName:@"RegisterView" bundle:nil] animated:YES];
  NSString* recipeIdStr = myCollectionArray[indexPath.row][@"recipe_id"];
  NSInteger recipeId = [recipeIdStr intValue];

//  [self.navigationController pushViewController:[[RecipeDetailController alloc]initWithNibName:@"RecipeDetailView" bundle:nil withId:recipeId withPrevTitle:titile] animated:YES];
  [self.navigationController presentViewController:[[RecipeDetailController alloc]initWithNibName:@"RecipeDetailView" bundle:nil withId:recipeId withPrevTitle:@"我的收藏"] animated:YES completion:nil];
}



#pragma mark - Net

-(void)getMyCollectionData
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getMyCollectionDataByPage:curPage
                       CompletionHandler:^(NSMutableDictionary *resultDic) {
                         [self getMyCollectionDataCallBack:resultDic];}
                       errorHandler:^(NSError *error) {}
                       ];
  
}

- (void)getMyCollectionDataCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result != 1)
  {
    myCollectionArray = [[NSArray alloc] initWithArray:resultDic[@"result_recipes"]];
    [tableView reloadData];
//    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:valueArray[0]];
    
    [[[User sharedInstance] collection] SetMyCollectionArray:myCollectionArray];
  }
}

@end
