//
//  SearchGoodsViewController.m
//  HellCook
//
//  Created by lxw on 13-9-4.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "SearchGoodsViewController.h"
#import "NetManager.h"

@interface SearchGoodsViewController ()

@end

@implementation SearchGoodsViewController
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withKeyword:(NSString*)keyword
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  // Custom initialization
    myKeywords = [NSString stringWithString:keyword];
    curPage = 1;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [self getGoodsInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)getGoodsInfo
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getGoodsWithKeyword:myKeywords
                       withPage:curPage
                       completionHandler:^(NSMutableDictionary *resultDic){
                         [self getGoodsInfoCallBack:resultDic];}
                       errorHandler:^(NSError *error){}];
}

-(void)getGoodsInfoCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
  }
}





@end
