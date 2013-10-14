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
#import "RecipeDetailController.h"
#import "MaterialSearchBuyViewController.h"

@interface ShoppingListController ()

@end

@implementation ShoppingListController
@synthesize tableView, leftListButton, rightListButton, listCountLabel, cellContentArray, cellAllMaterialArray;

- (void)viewDidLoad
{
  isRecipeView = YES;
  
  [self setRightButton];
    
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Images/NavigationBarSide.png"] forBarMetrics:UIBarMetricsDefault];
    
  self.navigationController.navigationBar.clipsToBounds = NO;
  self.view.clipsToBounds = YES;
    
  self.navigationItem.title = @"购买清单";
  
  dataListArray = [[NSMutableArray alloc]init];
  cellContentArray = [[NSMutableArray alloc]init];
  cellAllMaterialArray = [[NSMutableArray alloc]init];
  
  [self resetTableHeader];
  
  CGRect viewFrame = self.view.frame;
  if (isIOS7) {
    viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  } else {
    viewFrame.size.height = _screenHeight_NoStBar_NoNavBar + 20;
  }
  
  //viewFrame.size.width = _sideWindowWidth;
  [self.view setFrame:viewFrame];
  [self.tableView setFrame:viewFrame];
    
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnSlashMaterialItem:) name:@"ShoppingListSlashMaterialItem" object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnUnSlashMaterialItem:) name:@"ShoppingListUnSlashMaterialItem" object:nil];

  [self.navigationController.view setFrame:CGRectMake(40, 0, _sideWindowWidth, _screenHeight_NoStBar)];

  if([self respondsToSelector:@selector(edgesForExtendedLayout)])
  {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  
  
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{

  if (isRecipeView == YES) {
    [self setDataList];
  } else {
    [self setDataList];
    [self setAllMaterialDataList];
  }
  
  [self.tableView reloadData];
  
  [self.navigationController.view setFrame:CGRectMake(40, 0, _sideWindowWidth, _screenHeight_NoStBar)];

  [super viewWillAppear:animated];  
}

- (void)OnSlashMaterialItem:(NSNotification*)notification
{
  if (isRecipeView) {
    int contentIndex = [notification.object intValue];
    NSUInteger dataIndex = (NSUInteger)[self getDataIndexByContentIndex:contentIndex];
    
    NSMutableArray* dbShoppingListArray = [[DBHandler sharedInstance] getShoppingList];
    NSString* slashString = [[NSString alloc]init];
    NSArray* materialsArray = dataListArray[dataIndex][@"materials"];
    NSUInteger mIndex = 0;
    for (NSUInteger i = 0; i < materialsArray.count; i++) {
      if ([materialsArray[i][@"select"] isEqualToString:@"slash"]) {
        if (mIndex == 0) {
          slashString = [slashString stringByAppendingFormat:@"%@", materialsArray[i][@"material"]];
        } else {
          slashString = [slashString stringByAppendingFormat:@"|%@", materialsArray[i][@"material"]];
        }
        mIndex++;
      }
    }
    
    dbShoppingListArray[dataIndex][@"slashitems"] = slashString;
    [[DBHandler sharedInstance] addToShoppingList:dbShoppingListArray[dataIndex]];
  } else {
    NSUInteger contentIndex = (NSUInteger)[notification.object intValue];
    
    NSString* materialString = cellAllMaterialArray[contentIndex][@"material"];
    
    NSMutableArray* dbShoppingListArray = [[DBHandler sharedInstance] getShoppingList];
    for (NSUInteger re_i = 0; re_i < dbShoppingListArray.count; re_i++) {
      NSString*slashItemsString = dbShoppingListArray[re_i][@"slashitems"];
      if (slashItemsString) {
        NSRange range = [slashItemsString rangeOfString:materialString];
        if (range.location == NSNotFound) {
          if ([slashItemsString isEqualToString:@""]) {
            slashItemsString = materialString;
          } else {
            slashItemsString = [NSString stringWithFormat:@"%@|%@", slashItemsString, materialString];
          }
          dbShoppingListArray[re_i][@"slashitems"] = slashItemsString;
          [[DBHandler sharedInstance] addToShoppingList:dbShoppingListArray[re_i]];
        }
      } else {
        dbShoppingListArray[re_i][@"slashitems"] = materialString;
        [[DBHandler sharedInstance] addToShoppingList:dbShoppingListArray[re_i]];
      }
    }
  }
}

-(void)OnUnSlashMaterialItem:(NSNotification*)notification
{
  if (isRecipeView) {
    int contentIndex = [notification.object intValue];
    
    NSUInteger dataIndex = (NSUInteger)[self getDataIndexByContentIndex:contentIndex];
    
    NSMutableArray* dbShoppingListArray = [[DBHandler sharedInstance] getShoppingList];
    NSString* slashString = [[NSString alloc]init];
    NSArray* materialsArray = dataListArray[dataIndex][@"materials"];
    int mindex = 0;
    for (NSUInteger i = 0; i < materialsArray.count; i++) {
      if ([materialsArray[i][@"select"] isEqualToString:@"slash"]) {
        if (mindex == 0) {
          slashString = [slashString stringByAppendingFormat:@"%@", materialsArray[i][@"material"]];
        } else {
          slashString = [slashString stringByAppendingFormat:@"|%@", materialsArray[i][@"material"]];
        }
        mindex ++;
      }
    }
    
    dbShoppingListArray[dataIndex][@"slashitems"] = slashString;
    [[DBHandler sharedInstance] addToShoppingList:dbShoppingListArray[dataIndex]];
  } else {
    NSUInteger contentIndex = (NSUInteger)[notification.object intValue];
    
    NSString* materialString = cellAllMaterialArray[contentIndex][@"material"];
    
    NSMutableArray* dbShoppingListArray = [[DBHandler sharedInstance] getShoppingList];
    for (NSUInteger re_i = 0; re_i < dbShoppingListArray.count; re_i++) {
      NSString*slashItemsString = dbShoppingListArray[re_i][@"slashitems"];
      NSString* tmpStr = [NSString stringWithFormat:@"|%@", materialString];
      slashItemsString = [slashItemsString stringByReplacingOccurrencesOfString:tmpStr withString:@""];
      tmpStr = [NSString stringWithFormat:@"%@|", materialString];
      slashItemsString = [slashItemsString stringByReplacingOccurrencesOfString:tmpStr withString:@""];
      tmpStr = [NSString stringWithFormat:@"%@", materialString];
      slashItemsString = [slashItemsString stringByReplacingOccurrencesOfString:tmpStr withString:@""];
      
      if (![dbShoppingListArray[re_i][@"slashitems"] isEqualToString:slashItemsString]) {
        dbShoppingListArray[re_i][@"slashitems"] = slashItemsString;
        [[DBHandler sharedInstance] addToShoppingList:dbShoppingListArray[re_i]];
      }
    }
  }

}

- (void)setDataList
{
  [dataListArray removeAllObjects];
  [cellContentArray removeAllObjects];
  
  NSMutableArray* dbShoppingListArray = [[DBHandler sharedInstance] getShoppingList];
  for (NSUInteger i = 0; i < dbShoppingListArray.count; i++) {
    
    NSMutableDictionary* contentDic = [[NSMutableDictionary alloc]init];//
    [contentDic setObject:dbShoppingListArray[i][@"name"] forKey:@"name"];
    [contentDic setObject:dbShoppingListArray[i][@"recipeid"] forKey:@"recipeid"];
    
    [cellContentArray addObject:contentDic];
    
    NSMutableArray* maArray = [[NSMutableArray alloc]init];//
    NSArray*totalMaterialArray = [dbShoppingListArray[i][@"materials"] componentsSeparatedByString:@"|"];
    for (NSUInteger j = 0; j < totalMaterialArray.count/2; j++) {
      NSMutableDictionary* subMaterialDic = [[NSMutableDictionary alloc]init];
      [subMaterialDic setObject:totalMaterialArray[j*2] forKey:@"material"];
      [subMaterialDic setObject:totalMaterialArray[j*2+1] forKey:@"weight"];
      
      subMaterialDic[@"select"] = @"unslash";
      NSArray* slashArray = [dbShoppingListArray[i][@"slashitems"] componentsSeparatedByString:@"|"];
      for (NSUInteger k = 0; k < slashArray.count; k++) {
        if ([subMaterialDic[@"material"] isEqualToString:slashArray[k]]) {
          subMaterialDic[@"select"] = @"slash";
          break;
        }
      }
      
      [maArray addObject:subMaterialDic];
      
      [cellContentArray addObject:subMaterialDic];

    }
    [contentDic setObject:maArray forKey:@"materials"];
    
    [dataListArray addObject:contentDic];
  }
}

- (void)setAllMaterialDataList
{
  [cellAllMaterialArray removeAllObjects];
  for (NSUInteger i = 0; i < cellContentArray.count; i++) {
    NSUInteger j = 0;
    for (; j < cellAllMaterialArray.count; j++) {
      NSMutableDictionary* materialDic = cellAllMaterialArray[j];
      if (cellContentArray[i][@"material"] && [cellContentArray[i][@"material"] isEqualToString: materialDic[@"material"]]) {
        if ([materialDic[@"select"] isEqualToString:@"slash"] && [cellContentArray[i][@"select"] isEqualToString:@"slash"]) {
          materialDic[@"select"] = @"slash";
        } else {
          materialDic[@"select"] = @"unslash";
        }
        
        if (cellContentArray[i][@"weight"] && ![cellContentArray[i][@"weight"] isEqualToString:@""]) {
          if ([materialDic[@"weight"] isEqualToString:@""]) {
            materialDic[@"weight"] = [NSString stringWithFormat:@"%@", cellContentArray[i][@"weight"]];
          } else {
            materialDic[@"weight"] = [NSString stringWithFormat:@"%@+%@", materialDic[@"weight"], cellContentArray[i][@"weight"]];
          }
        }
        break;
      }
    }
    if (j == cellAllMaterialArray.count) {
      if (cellContentArray[i][@"material"]) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        dic[@"material"] = cellContentArray[i][@"material"];
        dic[@"select"] = cellContentArray[i][@"select"];
        if (cellContentArray[i][@"weight"]) {
          dic[@"weight"] = cellContentArray[i][@"weight"];
        } else {
          dic[@"weight"] = @"";
        }
        [cellAllMaterialArray addObject:dic];
      }
    }
  }
}

- (NSInteger)getDataIndexByContentIndex:(NSInteger)contentIndex
{
  int cur_count = 0;
  for (NSUInteger i = 0; i < dataListArray.count; i++) {
    cur_count += ((NSMutableArray*)dataListArray[i][@"materials"]).count;
    cur_count++;
    
    if (contentIndex < cur_count) {
      return i;
    }
  }
  return 0;
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
  isRecipeView = YES;

  [self selectLeftListButton];
  [self setDataList];
  
  [self.tableView reloadData];
}

-(void)onRightListButton
{
  isRecipeView = NO;

  [self selectRightListButton];
  [self setDataList];
  [self setAllMaterialDataList];

  [self.tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (isRecipeView) {
    if (cellContentArray[(NSUInteger)indexPath.row][@"name"]) {
      return 60;
    }
    return 44;
  } else {
    return 44;
  }
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
  if (isRecipeView) {
    return cellContentArray.count;
  } else {
    return cellAllMaterialArray.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSMutableArray* contentArray = NULL;
  if (isRecipeView) {
    contentArray = cellContentArray;
  } else {
    contentArray = cellAllMaterialArray;
  }
  
  NSString *CellIdentifier = NULL;
  if (contentArray[(NSUInteger)indexPath.row][@"name"]) {
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
    [((ShoppingListRecipeTableViewCell*)cell) setData:contentArray[(NSUInteger)indexPath.row]];
  } else {
    [((ShoppingListMaterialTableViewCell*)cell) setData:contentArray[(NSUInteger)indexPath.row]];
  }
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (cellContentArray[(NSUInteger)indexPath.row][@"recipeid"]) {
    
    int recipeid = [cellContentArray[(NSUInteger)indexPath.row][@"recipeid"] intValue];
    if (recipeid != 0) {
      [self.navigationController presentViewController:[[RecipeDetailController alloc]initWithNibName:@"RecipeDetailView" bundle:nil withId:recipeid withPrevTitle:@"购买清单"] animated:YES completion:nil];
    }
  }
}


- (void)emptyShoppingList:(id)sender
{
  UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"确认清空吗？"
                                                 message:@""
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"确定",nil];
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1) {
    [[DBHandler sharedInstance] emptyShoppingList];
    [self setDataList];
    [self setAllMaterialDataList];
    [self.tableView reloadData];
  }
}

- (void)delOneRecipeFromShoppingList:(id)sender
{
  UIView* button = sender;
  
  NSIndexPath *indexPath = [(UITableView *)button.superview.superview indexPathForCell: (UITableViewCell*)button.superview];
  
  [[DBHandler sharedInstance] removeFromShoppingList: [cellContentArray[(NSUInteger)indexPath.row][@"recipeid"] intValue]];
  
  [self setDataList];
  
  [self.tableView reloadData];
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

-(void)gotoMaterialSearchBuy
{
  if ([cellAllMaterialArray count] <= 0)
  {
    [self setAllMaterialDataList];
  }
  
  MaterialSearchBuyViewController *pController = [[MaterialSearchBuyViewController alloc] initWithNibName:@"MaterialSearchBuyView" bundle:nil withData:cellAllMaterialArray];
  [self.navigationController pushViewController:pController animated:YES];
}

@end
