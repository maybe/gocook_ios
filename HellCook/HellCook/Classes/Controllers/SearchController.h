//
//  SearchController.h
//  HellCook
//
//  Created by panda on 5/6/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchBarView.h"


@interface SearchController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
  UITableView* tableView;
  SearchBarView* searchBarView;
  
  NSMutableArray* recipeArray;
  
  NSString* searchKey;
  
  MKNetworkOperation *netOperation;
  
  bool isPageEnd;//是否全部加载完毕
  NSInteger curPage;
  UIActivityIndicatorView* loadingActivity;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain)SearchBarView* searchBarView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) UIActivityIndicatorView* loadingActivity;

@property (retain, nonatomic) NSString* searchKey;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil keyword:(NSString*)key;


@end
