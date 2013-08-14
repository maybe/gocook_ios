//
//  TopHotController.h
//  HellCook
//
//  Created by panda on 2/22/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "ShoppingListController.h"
#import "ShoppingListRecipeTableViewCell.h"
#import "DBHandler.h"

@interface ShoppingListController ()

@end

@implementation ShoppingListController
@synthesize tableView, leftListButton, rightListButton, listCountLabel, cellContentArray;

- (void)viewDidLoad
{
  [self setRightButton];
    
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Images/NavigationBarSide.png"] forBarMetrics:UIBarMetricsDefault];
    
  self.navigationController.navigationBar.clipsToBounds = NO;
  self.view.clipsToBounds = YES;
    
  self.navigationItem.title = @"购买清单";
  
  dataListArray = [[NSMutableArray alloc]init];
  cellContentArray = [[NSMutableArray alloc]init];
  
  [self resetTableHeader];
  
  CGRect viewframe = self.view.frame;
  viewframe.size.height = _screenHeight_NoStBar_NoNavBar;
  //viewframe.size.width = _sideWindowWidth;
  [self.view setFrame:viewframe];
  [self.tableView setFrame:viewframe];
  
  [self setDataList];
    
  [super viewDidLoad];
}

- (void)setDataList
{
  [dataListArray removeAllObjects];
  [cellContentArray removeAllObjects];
  
  NSMutableArray* array = [[DBHandler sharedInstance] getShoppingList];
  for (int i = 0; i < array.count; i++) {
    
    NSMutableDictionary* contentDic = [[NSMutableDictionary alloc]init];//
    [contentDic setObject:array[i][@"name"] forKey:@"name"];
    [contentDic setObject:array[i][@"recipeid"] forKey:@"recipeid"];
    
    [cellContentArray addObject:[[NSMutableDictionary alloc] initWithDictionary:contentDic]];
    
    NSMutableArray* maArray = [[NSMutableArray alloc]init];//
    NSArray* totalmaterialArray = [array[i][@"materials"] componentsSeparatedByString:@"|"];
    for (int j = 0; j < totalmaterialArray.count/2; j++) {
      NSMutableDictionary* subMaterialDic = [[NSMutableDictionary alloc]init];
      [subMaterialDic setObject:totalmaterialArray[j*2] forKey:@"material"];
      [subMaterialDic setObject:totalmaterialArray[j*2+1] forKey:@"weight"];
      
      [maArray addObject:subMaterialDic];
      
      [cellContentArray addObject:[[NSMutableDictionary alloc] initWithDictionary:subMaterialDic]];

    }
    [contentDic setObject:maArray forKey:@"materials"];
    
    [dataListArray addObject:contentDic];
  }
}

- (void) viewWillAppear:(BOOL)animated
{
  [self.navigationController.view setFrame:CGRectMake(40, 0, _sideWindowWidth, _screenHeight_NoStBar)];
  
  [super viewWillAppear:animated];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Table Header
- (void)resetTableHeader
{
  CGRect frame = self.tableView.tableHeaderView.frame;
  frame.size.height = 50;
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
  
  leftListButton = [[UIButton alloc]initWithFrame:CGRectMake(280 - 74 - 5, 12, 37, 29)];
  [leftListButton addTarget:self action:@selector(onLeftListButton) forControlEvents:UIControlEventTouchDown];

  rightListButton = [[UIButton alloc]initWithFrame:CGRectMake(280 - 37 - 5, 12, 37, 29)];
  [rightListButton addTarget:self action:@selector(onRightListButton) forControlEvents:UIControlEventTouchDown];
  
  [self selectLeftListButton];
  
  [self.tableView.tableHeaderView addSubview:leftListButton];
  [self.tableView.tableHeaderView addSubview:rightListButton];
  
  listCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 15, 150, 20)];
  listCountLabel.text = @"";
  [listCountLabel setBackgroundColor: [UIColor clearColor]];
  [listCountLabel setTextColor:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]];
  
  [self.tableView.tableHeaderView addSubview:listCountLabel];
  
  UIImage* dotImage = [UIImage imageNamed:@"Images/homeHeaderSeperator.png"];
  UIImageView* dotImageView = [[UIImageView alloc]initWithImage:dotImage];
  [dotImageView setFrame:CGRectMake(0, 49, 280, 1)];
  
  [self.tableView.tableHeaderView addSubview:dotImageView];
}

-(void)onLeftListButton
{
  [self selectLeftListButton];
}

-(void)onRightListButton
{
  [self selectRightListButton];
}

-(void)selectLeftListButton
{
  UIImage *buttonBackgroundImageleft = [UIImage imageNamed:@"Images/buyListRecipeButtonSelected.png"];
  [leftListButton setBackgroundImage:buttonBackgroundImageleft forState:UIControlStateNormal];
  
  UIImage *buttonBackgroundImageright = [UIImage imageNamed:@"Images/buyListStatButtonNormal.png"];
  [rightListButton setBackgroundImage:buttonBackgroundImageright forState:UIControlStateNormal];

}

-(void)selectRightListButton
{
  UIImage *buttonBackgroundImageleft = [UIImage imageNamed:@"Images/buyListRecipeButtonNormal.png"];
  [leftListButton setBackgroundImage:buttonBackgroundImageleft forState:UIControlStateNormal];
  
  UIImage *buttonBackgroundImageright = [UIImage imageNamed:@"Images/buyListStatButtonSelected.png"];
  [rightListButton setBackgroundImage:buttonBackgroundImageright forState:UIControlStateNormal];

}

#pragma mark - Table view data source
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ShoppingListHideOptionButton" object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (cellContentArray[indexPath.row][@"name"]) {
    return 60;
  }
  return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return cellContentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *CellIdentifier = NULL;
  if (cellContentArray[indexPath.row][@"name"]) {
    CellIdentifier = @"NameCell";
  } else {
    CellIdentifier = @"MaterialCell";
  }
  
  UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    if ([CellIdentifier isEqualToString: @"NameCell"]) {
      cell = [[ShoppingListRecipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    } else {
      cell = [[ShoppingListMaterialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  }
  
  if ([CellIdentifier isEqualToString: @"NameCell"]) {
    [((ShoppingListRecipeTableViewCell*)cell) setData:cellContentArray[indexPath.row]];
  } else {
    [((ShoppingListMaterialTableViewCell*)cell) setData:cellContentArray[indexPath.row]];
  }
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (void) emptyShoppingList:(id)sender
{
}

- (void)setRightButton
{
    UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
    [rightBarButtonView addTarget:self action:@selector(emptyShoppingList:) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/rightPageButtonBackgroundNormal.png"]
                                  forState:UIControlStateNormal];
    
    [rightBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/rightPageButtonBackgroundHighlighted.png"]
                                  forState:UIControlStateHighlighted];
    
    UIImage* rightBLImage = [UIImage imageNamed:@"Images/buylistPageclear.png"];
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 15, 18)];
    [rightImageView setImage:rightBLImage];
    [rightBarButtonView addSubview:rightImageView];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
}

@end
