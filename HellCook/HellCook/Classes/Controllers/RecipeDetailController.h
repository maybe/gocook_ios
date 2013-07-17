//
//  RecipeDetailController.h
//  HellCook
//
//  Created by panda on 5/6/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
  kDetailHeaderCell = 0,
  kDetailMaterialCell,
  kDetailStepsCell,
  kDetailFooterCell,
  kTotalDetailCellNum
} DetailCellType;

@class RecipeDetailBaseTableViewCell;
@interface RecipeDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
  UITableView* tableView;
  NSDictionary* recipeDataDic;
  NSMutableArray* cellContentArray;
  
  NSInteger mRecipeId;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) NSDictionary* recipeDataDic;
@property (nonatomic, retain) NSMutableArray* cellContentArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(NSInteger)recipeId;

- (RecipeDetailBaseTableViewCell*)GetTableCell:(NSInteger)index;

@end
