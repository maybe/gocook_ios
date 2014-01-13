//
//  RecipeDetailController.h
//  HellCook
//
//  Created by panda on 5/6/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

typedef enum{
  kDetailHeaderCell = 0,
  kDetailMaterialCell,
  kDetailStepsCell,
  kDetailTipsCell,
  kTotalDetailCellNum
} DetailCellType;

@class RecipeDetailBaseTableViewCell;
@interface RecipeDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
  UITableView* tableView;
  NSMutableDictionary* recipeDataDic;
  NSMutableArray* cellContentArray;
  
  NSInteger mRecipeId;

  NSMutableArray *recipeCommentsArray;

  UIActivityIndicatorView* mLoadingActivity;

  MBProgressHUD *HUD;

  UIImageView* coverImageView; //不添加到view上，只用来作为分享的图片
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) NSMutableDictionary* recipeDataDic;
@property (nonatomic, retain) NSMutableArray* cellContentArray;
@property (nonatomic, retain) NSMutableArray *recipeCommentsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(NSInteger)recipeId;

- (RecipeDetailBaseTableViewCell*)GetTableCell:(NSInteger)index;
- (void)returnToPrev;

@end
